---
layout: blog
title:  "Java 多线程 - jGroups 中多线程的使用"
date:   2015-11-19 18:05:00
categories: java
author: Kylin Soong
duoshuoid: ksoong2015111901
---

[JGroups](http://jgroups.org) 是 JBoss/WildFly, JBoss Cache/Infinispan 等的底层框架，它的协议栈（Protocol Stack）中大量使用多线程，本文抽取出一些示例代码来进行分析。

### Timer thread pool

JGroups 传输层TP(UDP, TCP, TCP_NIO)中的 TimeScheduler 设计用来执行 Runnable Task, JGroups 3.x 版本对应的实现类为 `org.jgroups.util.TimeScheduler3`。它的简单架构如下图

![JGroups TimeScheduler]({{ site.baseurl }}/assets/blog/jgroups-tp-timerschedule.png)

TimeScheduler 架构分三个部分: 阻塞队列，Timer runner 监听线程（监听于阻塞队列），线程池（执行 Task）。Runnable Task 可以通过两种途径被线程池运行：

* Task 被添加到阻塞队列，监听线程获取 Task 并将 Task 提交给线程池，线程池执行 Task
* Task 直接提交到线程池执行

阻塞队列的实现使用 java.util.concurrent.DelayQueue

~~~
protected final BlockingQueue<Task> queue = new DelayQueue<>();
~~~

线程池的实现使用 ThreadPoolExecutor

~~~
ThreadPoolExecutor pool = new ThreadPoolExecutor(timer_min_threads, 
						 timer_max_threads, 
						 timer_keep_alive_time,
						 TimeUnit.MICROSECONDS,
						 new LinkedBlockingQueue<Runnable>(timer_queue_max_size),
						 timer_thread_factory,
						 new ThreadPoolExecutor.AbortPolicy());
~~~

如上 ThreadPoolExecutor 实例化参数来自 JGroups 协议栈的配置:

~~~
timer_type="new3"
timer.min_threads="2"
timer.max_threads="4"
timer.keep_alive_time="3000"
imer.queue_max_size="500"
~~~

## OOB thread pool

OOB 线程池的实现使用 ThreadPoolExecutor

~~~
BlockingQueue<Runnable> oob_thread_pool_queue = new SynchronousQueue<>();
int oob_thread_pool_min_threads = 1;
int oob_thread_pool_max_threads = 8;
long oob_thread_pool_keep_alive_time = 5000;
ThreadFactory oob_thread_factory = new DefaultThreadFactory("OOB", false, true);
ThreadPoolExecutor pool = new ThreadPoolExecutor(oob_thread_pool_min_threads, oob_thread_pool_max_threads, oob_thread_pool_keep_alive_time, TimeUnit.MILLISECONDS, oob_thread_pool_queue);
pool.setThreadFactory(oob_thread_factory);
RejectedExecutionHandler handler = new ThreadPoolExecutor.DiscardPolicy();
pool.setRejectedExecutionHandler(handler);
~~~

如上 ThreadPoolExecutor 实例化参数来自 JGroups 协议栈的配置:

~~~
oob_thread_pool.enabled="true"
oob_thread_pool.min_threads="1"
oob_thread_pool.max_threads="8"
oob_thread_pool.keep_alive_time="5000"
oob_thread_pool.queue_enabled="false"
oob_thread_pool.queue_max_size="100"
oob_thread_pool.rejection_policy="discard"
~~~

## Regular thread pool

Regular 线程池的实现使用 ThreadPoolExecutor

~~~
int thread_pool_queue_max_size=10000;
BlockingQueue<Runnable> thread_pool_queue = new LinkedBlockingQueue<>(thread_pool_queue_max_size);
int thread_pool_min_threads = 2;
int thread_pool_max_threads = 8;
long thread_pool_keep_alive_time = 5000;
ThreadFactory default_thread_factory = new DefaultThreadFactory("Incoming", false, true);
ThreadPoolExecutor pool = new ThreadPoolExecutor(thread_pool_min_threads, thread_pool_max_threads, thread_pool_keep_alive_time, TimeUnit.MILLISECONDS, thread_pool_queue);
pool.setThreadFactory(default_thread_factory);
RejectedExecutionHandler handler = new ThreadPoolExecutor.DiscardPolicy();
pool.setRejectedExecutionHandler(handler);
~~~

如上 ThreadPoolExecutor 实例化参数来自 JGroups 协议栈的配置:

~~~
thread_pool.enabled="true"
thread_pool.min_threads="2"
thread_pool.max_threads="8"
thread_pool.keep_alive_time="5000"
thread_pool.queue_enabled="true"
thread_pool.queue_max_size="10000"
thread_pool.rejection_policy="discard"
~~~

## Internal thread pool

Internal 线程池的实现使用 ThreadPoolExecutor

~~~
int internal_thread_pool_queue_max_size = 500;
BlockingQueue<Runnable> internal_thread_pool_queue = new LinkedBlockingQueue<>(internal_thread_pool_queue_max_size);
int internal_thread_pool_min_threads = 2;
int internal_thread_pool_max_threads = 4;
long internal_thread_pool_keep_alive_time = 30000;
ThreadFactory internal_thread_factory = new DefaultThreadFactory("INT", false, true);
ThreadPoolExecutor pool = new ThreadPoolExecutor(internal_thread_pool_min_threads, internal_thread_pool_max_threads, internal_thread_pool_keep_alive_time, TimeUnit.MILLISECONDS, internal_thread_pool_queue);
pool.setThreadFactory(internal_thread_factory);
RejectedExecutionHandler handler = new ThreadPoolExecutor.DiscardPolicy();
pool.setRejectedExecutionHandler(handler);
~~~
