---
layout: blog
title:  "JavaEE Profiling concepts"
date:   2014-09-25 16:05:00
categories: performance
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

如下命令分别用来在 Linux 操作系统下统计物理CPU个数（socket 个数)，每个物理CPU 的逻辑核数，以及系统整个cpu线程数。

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

假设，物理CPU个数（socket 个数) 为 socket, 每个物理CPU的逻辑核数为 cores, 系统整个cpu线程数(硬件线程数)为 total_hardware_threads, 则我们有如下公式：

**total_hardware_threads = socket * cores * 2**

> 每个逻辑核跑了2个cpu线程，上面例子中服务器共有两个物理CPU，即 socket = 2，每个物理CPU的逻辑核数为6，即 cores = 6，所以，上面的cpu线程数 24 = 2 * 6 * 2


## Intel Hardware List

* [http://ark.intel.com/products/75128/Intel-Core-i7-4800MQ-Processor-6M-Cache-up-to-3_70-GHz](http://ark.intel.com/products/75128/Intel-Core-i7-4800MQ-Processor-6M-Cache-up-to-3_70-GHz)

4 cores, 8 processors

* [http://ark.intel.com/products/52229/Intel-Core-i5-2520M-Processor-3M-Cache-up-to-3_20-GHz](http://ark.intel.com/products/52229/Intel-Core-i5-2520M-Processor-3M-Cache-up-to-3_20-GHz)

2 cores, 4 processors

* [http://ark.intel.com/products/81059/Intel-Xeon-Processor-E5-2697-v3-35M-Cache-2_60-GHz](http://ark.intel.com/products/81059/Intel-Xeon-Processor-E5-2697-v3-35M-Cache-2_60-GHz)

14 cores, 28 processors

* [http://ark.intel.com/products/81713/Intel-Xeon-Processor-E5-2690-v3-30M-Cache-2_60-GHz](http://ark.intel.com/products/81713/Intel-Xeon-Processor-E5-2690-v3-30M-Cache-2_60-GHz)

12 cores, 24 processors

* [http://ark.intel.com/products/81709/Intel-Xeon-Processor-E5-2670-v3-30M-Cache-2_30-GHz](http://ark.intel.com/products/81709/Intel-Xeon-Processor-E5-2670-v3-30M-Cache-2_30-GHz)

12 cores, 24 processors

* [http://ark.intel.com/products/75275/Intel-Xeon-Processor-E5-2670-v2-25M-Cache-2_50-GHz](http://ark.intel.com/products/75275/Intel-Xeon-Processor-E5-2670-v2-25M-Cache-2_50-GHz)

10 cores, 20 processors

* [http://ark.intel.com/products/64583/Intel-Xeon-Processor-E5-2680-%2820M-Cache-2_70-GHz-8_00-GTs-Intel-QPI%29](http://ark.intel.com/products/64583/Intel-Xeon-Processor-E5-2680-%2820M-Cache-2_70-GHz-8_00-GTs-Intel-QPI%29)

8 cores, 16 processors

* [http://ark.intel.com/products/63697/Intel-Core-i7-3930K-Processor-12M-Cache-up-to-3_80-GHz](http://ark.intel.com/products/63697/Intel-Core-i7-3930K-Processor-12M-Cache-up-to-3_80-GHz)

6 cores, 12 processors

* [http://ark.intel.com/products/75123/Intel-Core-i7-4770K-Processor-8M-Cache-up-to-3_90-GHz](http://ark.intel.com/products/75123/Intel-Core-i7-4770K-Processor-8M-Cache-up-to-3_90-GHz)

4 cores, 8 processors
