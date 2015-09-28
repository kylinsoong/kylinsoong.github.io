---
layout: blog
title:  "java.lang.OutOfMemoryError: unable to create new native thread"
date:   2015-09-25 20:55:00
categories: java
permalink: /oom-native-threads
author: Kylin Soong
duoshuoid: ksoong2015092502
---

Today I have encountered the 'java.lang.OutOfMemoryError: unable to create new native thread' when using the JMeter in a Performance Benchmark Test, the detailed stack strace:

~~~
java.lang.OutOfMemoryError: unable to create new native thread
        at java.lang.Thread.start0(Native Method)
        at java.lang.Thread.start(Thread.java:714)
~~~

This article will give a Resolution how to fix this issue.

Java version used in my test:

~~~
$ java -version
java version "1.8.0_25"
Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
~~~

OS used in my test:

~~~
$ uname -a
Linux ksoong.redhat.com 3.11.10-301.fc20.x86_64 #1 SMP Thu Dec 5 14:01:17 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
~~~

## Why Error Throw

* Native virtual memory (address space) exhaustion and/or fragmentation.
* The open file limit imposed by the OS has been reached. In Java, every socket is a file.
* The maximum number of processes per user (ulimit -u) limits the number of threads.
* The number of sockets exceeds the open file limit (ulimit -n).
* The JVM process size is hitting the configured max memory size limit (ulimit -m).

## How to Resolve
