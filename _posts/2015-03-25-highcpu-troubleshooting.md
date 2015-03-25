---
layout: blog
title:  "JVM High CPU 问题分析步骤"
date:   2015-03-25 21:30:00
categories: performance
permalink: /jvmhighcpu
author: Kylin Soong
duoshuoid: ksoong2015032501
---

本文结合一个例子给出分析 JVM High CPU 问题的步骤。使用 Maven 编译 [cpu-identify](https://github.com/kylinsoong/JVM/tree/master/jvm/cpu/identify) 生成 `jvm-highcpu-identify.jar`，通过命令运行此 jar：

~~~
java -jar jvm-highcpu-identify.jar
~~~

这样会启动 JVM High CPU 示例。JVM High CPU 问题分析步骤如下:

### 步骤一: 找出 JVM 进程号 PID

使用 JDK jps 命令

~~~
jps -l
~~~

或使用操系统的命令，如 Linux 下使用

~~~
ps -aux | grep java
~~~

### 步骤二: 找出 High CPU 线程 ID

Linux 操作系统下，top 命令可以查看进程中每个线程所占用的 CPU:

~~~
top -H -p <PID>
~~~

NOTE: -H: Threads toggle. Starts top with the last remembered H state reversed. When this toggle is On, all individual threads will be displayed. Otherwise, top displays a summation of all threads in a process. 

下图为上面示例中top命令的结果输出:

![Top High CPU output]({{ site.baseurl }}/assets/blog/jvm-cpu-1.PNG)

**5019** 为 High CPU 线程 ID

### 步骤三: 转化 Decimal 线程 ID 到 Hexadecimal

使用 Decimal 转化 Hexadecimal 工具，例如:

~~~
5019 → 139b
5008 → 1390
5007 → 138f
5009 → 1391
5011 → 1393
5020 → 139c
5023 → 139f
5010 → 1392
5018 → 139a
5021 → 139d
5022 → 139e
~~~

**139b** 为 Hexadecimal High CPU 线程 ID

### 步骤四: 收集 JVM 线程 Dump 找出 High CPU 线程

收集 JVM 线程 Dump（JVM 的 `jstack -l <PID>` 命令可以收集线程 Dump），在线程 Dump 中查找 Hexadecimal High CPU 线程 ID，如下为 High CPU 线程:

~~~
"lab-cpu-heavyThread" prio=10 tid=0xb6aeac00 nid=0x139b runnable [0x6eb5c000]
   java.lang.Thread.State: RUNNABLE
        at java.lang.StringBuilder.append(StringBuilder.java:119)
        at com.kylin.jvm.highcpu.HeavyThread.run(HeavyThread.java:25)
        at java.lang.Thread.run(Thread.java:662)

   Locked ownable synchronizers:
        - None
~~~

**lab-cpu-heavyThread** 为 High CPU 线程.
