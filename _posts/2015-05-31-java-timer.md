---
layout: blog
title:  "Java Timer"
date:   2015-05-31 22:00:00
categories: java
permalink: /java-timer
author: Kylin Soong
duoshuoid: ksoong2015053101
excerpt: What and When Java Timer
---

## 什么是 Java ThreadLocal

From Oracle [JavaSE 8 api doc](https://docs.oracle.com/javase/8/docs/api/java/util/Timer.html):

**java.util.Timer** is a facility for threads to schedule tasks for future execution in a background thread.  Tasks may be scheduled for one-time execution, or for repeated execution at regular intervals.

Corresponding to each 'Timer' object is a single background thread that is used to execute all of the timer's tasks, sequentially. Timer tasks should complete quickly.  If a timer task takes excessive time to complete, it "hogs" the timer's task execution thread. This can, in turn, delay the execution of subsequent tasks, which may "bunch up" and execute in rapid succession when (and if) the offending task finally completes.

After the last live reference to a 'Timer' object goes away and all outstanding tasks have completed execution, the timer's task execution thread terminates gracefully (and becomes subject to garbage collection).  However, this can take arbitrarily long to occur.  By default, the task execution thread does not run as a daemon thread, so it is capable of keeping an application from terminating.  If a caller wants to terminate a timer's task execution thread rapidly, the caller should invoke the timer's `cancel` method.

If the timer's task execution thread terminates unexpectedly, for example, because its `stop` method is invoked, any further attempt to schedule a task on the timer will result in an `IllegalStateException` as if the timer's `cancel` method had been invoked.

This class is thread-safe: multiple threads can share a single 'Time' object without the need for external synchronization.

This class does not offer real-time guarantees: it schedules tasks using the Object.wait(long) method.

'java.util.concurrent.ScheduledThreadPoolExecutor' which is a thread pool for repeatedly executing tasks at a given rate or delay.  It is effectively a more versatile replacement for the Time/TimerTask combination.

## 使用示例

~~~
        Timer timer = new Timer("Test Timer", true);
        TimerTask task = new TestTimerTask();
        timer.schedule(task, 2000);
~~~

该 Timer 将会在 2000 毫秒后运行 TimerTask.
