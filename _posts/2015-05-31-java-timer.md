---
layout: blog
title:  "Java 执行 scheduled task"
date:   2015-05-31 22:00:00
categories: java
permalink: /java-timer
author: Kylin Soong
duoshuoid: ksoong2015053101
excerpt: Java Timer and ScheduledExecutorService
---

## Java Timer

[JavaSE 8 api doc](https://docs.oracle.com/javase/8/docs/api/java/util/Timer.html)

Timer 用于执行一个 scheduled task，它提供了如下 schedule 方法:

~~~
public void schedule(TimerTask task, long delay);
public void schedule(TimerTask task, Date time);
public void schedule(TimerTask task, long delay, long period);
public void schedule(TimerTask task, Date firstTime, long period);
public void scheduleAtFixedRate(TimerTask task, long delay, long period);
public void scheduleAtFixedRate(TimerTask task, Date firstTime, long period);
~~~

如上方法中:

* TimerTask 实现 Runnable 接口可被 schedule 执行一次或多次
* delay 定义 task 被 schedule 到执行所延迟的时间，time 定义 task 执行的时间
* period 指周期行执行 task 的时间间隔

### 使用示例

TimerTask 的实现如下，它的任务是输出当前时间戳:

~~~
public class TestTimerTask extends TimerTask {

	public void run() {
		System.out.println(System.currentTimeMillis());
	}
}
~~~

如下代码演示周期性的运行 TimerTask:

~~~
Timer timer = new Timer("Test Timer", true);
TimerTask task = new TestTimerTask();
timer.schedule(task, 5000, 2000);
Thread.currentThread().sleep(Long.MAX_VALUE);
~~~

Timer 将会在 5000 毫秒后运行 TimerTask，且循环的运行 TimerTask，两次运行的时间间隔为 2000 毫秒。TimerTask 在没有执行的时候处于 wait 状态，它的线程 dump 如下:

~~~
"Test Timer" #9 daemon prio=5 os_prio=0 tid=0x00007f7da80db800 nid=0x19e4 in Object.wait() [0x00007f7d8befd000]
   java.lang.Thread.State: TIMED_WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        - waiting on <0x00000000d7f7c0a8> (a java.util.TaskQueue)
        at java.util.TimerThread.mainLoop(Timer.java:552)
        - locked <0x00000000d7f7c0a8> (a java.util.TaskQueue)
        at java.util.TimerThread.run(Timer.java:505)

   Locked ownable synchronizers:
        - None
~~~


## Java ScheduledExecutorService

[JavaSE 8 api doc](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledExecutorService.html)

ScheduledExecutorService 实现 ExecutorService 接口，它提供了如下 schedule 方法:

~~~
public ScheduledFuture<?> schedule(Runnable command, long delay, TimeUnit unit);
public <V> ScheduledFuture<V> schedule(Callable<V> callable, long delay, TimeUnit unit);
public ScheduledFuture<?> scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit);
public ScheduledFuture<?> scheduleWithFixedDelay(Runnable command, long initialDelay, long delay, TimeUnit unit);
~~~

如上方法中:

* command 是一个 Runnable Task，可以被执行一次或多次
* delay 定义 task 被 schedule 到执行所延迟的时间
* period 定义多次执行 task 的时间间隔

### 使用示例

如下代码演示使用 ScheduledExecutorService 周期性的执行 4 个 Runnable Task，每个 Task 的任务是输出 线程的名称和当前系统时间戳:

~~~
final ThreadGroup threadGroup = new ThreadGroup("TestService ThreadGroup");
final String namePattern = "TestService Thread Pool -- %t";
final ThreadFactory threadFactory = new JBossThreadFactory(threadGroup, Boolean.FALSE, null, namePattern, null, null, doPrivileged(GetAccessControlContextAction.getInstance()));       
ScheduledThreadPoolExecutor scheduledExecutorService = new ScheduledThreadPoolExecutor(4 , threadFactory);
scheduledExecutorService.setExecuteExistingDelayedTasksAfterShutdownPolicy(false);
for(int i = 0 ; i < 4 ; i ++) {
	scheduledExecutorService.scheduleAtFixedRate(new Runnable(){

		public void run() {
			System.out.println(Thread.currentThread().getName() + ": " + System.currentTimeMillis());
		}}, 5, 2, TimeUnit.SECONDS);
}
~~~

ScheduledExecutorService 将会在 5 秒钟之后周期性的执行  4 个 Runnable Task，且每两个 Task 之间的时间间隔为 2 秒钟，Runnable Task 没有被执行时状态如下:

~~~
"TestService Thread Pool -- 1" #10 prio=5 os_prio=0 tid=0x00007f1cc030a000 nid=0x1faf waiting on condition [0x00007f1c8955c000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000000d8232688> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.await(AbstractQueuedSynchronizer.java:2039)
        at java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:1088)
        at java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:809)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1067)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1127)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)
        at org.jboss.threads.JBossThread.run(JBossThread.java:320)

   Locked ownable synchronizers:
        - None
~~~
