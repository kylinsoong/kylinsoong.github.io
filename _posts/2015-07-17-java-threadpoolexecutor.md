---
layout: blog
title:  "Java ThreadPoolExecutor"
date:   2015-07-17 15:30:00
categories: java
permalink: /java-threadpoolexecutor
author: Kylin Soong
duoshuoid: ksoong2015071701
---

ThreadPoolExecutor 且使用如下构造方法：

~~~
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler)
~~~

如上使用一些初始化参数构建 ThreadPoolExecutor：

* corePoolSize - 线程池中保存的线程数，线程池不会 prefill 线程，不管线程池中是否有空闲线程，当线程数大小小于 corePoolSize 就新建线程
* maximumPoolSize - 线程池允许的最大线程数
* keepAliveTime - 当线程池中线程数大于 corePoolSize 时，多余的线程在等待空闲时间 keepAliveTime 后终止
* unit - keepAliveTime 的时间单位
* workQueue - Task 被执行之前首先至于此 workQueue，当然 workQueue 只保存实现 Runnable 的 Task，通常被 execute 方法提交
* threadFactory - 用来创建创建新线程
* handler - 当队列里累积的 Task 多于 workQueue 最大容量时用来处理新来的 Task

> NOTE: 线程池并不会 prefill 线程，当 `corePoolSize` > 0 时，线程池不会自动关闭

## 示例

使用如下代码初始化一个 ThreadPoolExecutor:

~~~
ThreadPoolExecutor executor = new ThreadPoolExecutor(8, 8, 30, TimeUnit.SECONDS, new LinkedBlockingQueue<Runnable>(), new ThreadFactory(){
	private final int id = executorSeq.getAndIncrement();
        private final AtomicInteger threadSeq = new AtomicInteger(1);
            
	public Thread newThread(Runnable r) {
		return doPrivileged(new ThreadAction(r, id, threadSeq));
	}}, POLICY);
~~~

[详细初始化代码](https://raw.githubusercontent.com/kylinsoong/wildfly-samples/master/wildfly-core-debug/src/main/java/org/wildfly/example/threads/MSCThreadPoolExecutor.java)

### 示例.1 执行 PrintTask 

执行 10 个 PrintTask:

~~~
for(int i = 0 ; i < 10 ; i ++) {
	executor.execute(new PrintTask());
}
~~~

执行完成之后，ThreadPool 的状态: [Running, pool size = 8, active threads = 0, queued tasks = 0, completed tasks = 10]

ThreadPool 中所有线程处于 waiting on condition 状态:

~~~
"MSC service thread 1-8" #16 prio=5 os_prio=0 tid=0x00007f20c40ec800 nid=0x2780 waiting on condition [0x00007f209dce3000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000000d7f80410> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2039)
        at java.util.concurrent.LinkedBlockingQueue.take(LinkedBlockingQueue.java:442)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1067)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1127)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
        - None
~~~

> NOTE: 线程处于 waiting on condition 状态是因为 LinkedBlockingQueue 中没有 Runnable Task。

### 示例.2 执行 WaitTask

执行 10 个 WaitTask:

~~~
for(int i = 0 ; i < 10 ; i ++) {
        executor.execute(new WaitTask());
}
~~~

执行完成之后，ThreadPool 的状态: [Running, pool size = 8, active threads = 8, queued tasks = 2, completed tasks = 0]

> NOTE: queued tasks is 2, that's due to ThreadPool's maximumPoolSize is 8 and previous 8 threads are in wait.

ThreadPool 中所有线程处于 Object.wait() 状态:

~~~
"MSC service thread 1-8" #16 prio=5 os_prio=0 tid=0x00007f8f180f5000 nid=0x2823 in Object.wait() [0x00007f8ee56d1000]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        - waiting on <0x00000000d7f8fae8> (a org.wildfly.example.threads.MSCThreadPoolExecutor$WaitTask)
        at java.lang.Object.wait(Object.java:502)
        at org.wildfly.example.threads.MSCThreadPoolExecutor$WaitTask.run(MSCThreadPoolExecutor.java:55)
        - locked <0x00000000d7f8fae8> (a org.wildfly.example.threads.MSCThreadPoolExecutor$WaitTask)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)

   Locked ownable synchronizers:
        - <0x00000000d7f8faf8> (a java.util.concurrent.ThreadPoolExecutor$Worker)
~~~
