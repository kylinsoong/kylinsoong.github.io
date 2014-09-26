---
layout: blog
title:  "JavaEE Profiling concepts"
date:   2014-09-10 16:05:00
categories: javaee
permalink: /jee-profiling
author: Kylin Soong
duoshuoid: ksoong2014092501
---

This Blog article contains some JavaEE profiling/performance concepts.

## CPU time Vs Wall time

* **CPU time** (or **process time**) is the amount of time for which a central processing unit (CPU) was used for processing / executing method code.

* **Wall time** (or **wall-clock time**) is the human perception of the passage of time from the start to the completion of a task.

Wall time can also mean the actual time taken by a computer to complete a task. It is the sum of three terms: CPU time, I/O time, and the communication channel delay (e.g. if data are scattered on multiple machines).

## CPU, Core and Processors

* 物理CPU个数：

~~~
[root@localhost ~]# cat /proc/cpuinfo | grep "physical id" | sort | uniq
physical id : 0
physical id : 1
~~~

可以看到物理CPU个数为2，物理CPU也就是机器外面就能看到的一个个CPU，每个物理CPU还带有单独的风扇。

* 每个物理CPU的逻辑核数：

~~~
[root@localhost ~]# cat /proc/cpuinfo | grep "cores" | uniq
cpu cores   : 6
~~~

* 系统整个cpu线程数：

~~~
[root@localhost ~]# cat /proc/cpuinfo | grep "processor" | wc -l
24
~~~

cpu线程数=物理CPU个数*每个物理CPU的逻辑核数*2，因为每个逻辑核跑了2个cpu线程。所以，上面的24=2*6*2
