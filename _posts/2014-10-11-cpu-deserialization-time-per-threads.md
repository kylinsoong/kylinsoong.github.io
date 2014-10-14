---
layout: blog
title:  "CPU deserialization capability per hardware threads"
date:   2014-10-11 16:05:00
categories: performance
permalink: /cpu-deserialize
author: Kylin Soong
duoshuoid: ksoong2014101101
---

Usually, the total hardware threads represents a server's compute capability, the following formula can count out a total hardware threads:

**total_hardware_threads = socket * cores * 2**

For example, assume a linux server have 2 sockets(2 physical cpu), each socket have 6 cores, then the server's total_hardware_threads = 2 * 6 * 2, it's 24, it hints this server can concurrent run 24 threads in a time point.

This article will give a trial which get a comparision between hardware threads and CPU deserialization capability. Simply, the trial quiet easy, a simple java code query mysql database, thing we need to calculate is how much time taken from first time we we receive the row of result to, how mach time taken to read all the rows, this gives us deserialization time roughly, grab results for 100, 1000, 1k, 10k, 50k, 100K, 500k see the numbers as to how much time it took more with number of results, like on a graph, it should linearly go up, based on that we can come with a number to multiply by. Where look at schema and see how much size that is.

## Environment

* Oracle JDK 1.7.0_60

* Mysql 5.1.73 with reference Driver jar

* [Intel® Core™ i5-2520M Processor](http://ark.intel.com/products/52229/Intel-Core-i5-2520M-Processor-3M-Cache-up-to-3_20-GHz)

## perftest table

perftest table schema like:

~~~
CREATE TABLE PERFTEST(id INTEGER, col_a CHAR(16), col_b CHAR(40), col_c CHAR(40));
~~~

According to Mysql Data Type, `int` type should be 4 bytes, char(16) should be 16 bytes, char(40) should be 40 bytes, so totally 1 row should be 100 bytes.

Execute the floowing sql can check total rows and total size in bytes:

~~~
SELECT sum(table_rows) from information_schema.TABLES WHERE table_name = 'PERFTEST';
SELECT sum(data_length) from information_schema.TABLES WHERE table_name = 'PERFTEST';
~~~

## Deserialize log

~~~
Deserialize 100000000 bytes spend time: 530 ms
Deserialize 90000000 bytes spend time: 490 ms
Deserialize 90000000 bytes spend time: 489 ms
Deserialize 90000000 bytes spend time: 485 ms
Deserialize 80000000 bytes spend time: 443 ms
Deserialize 80000000 bytes spend time: 446 ms
Deserialize 80000000 bytes spend time: 454 ms
Deserialize 70000000 bytes spend time: 416 ms
Deserialize 70000000 bytes spend time: 407 ms
Deserialize 70000000 bytes spend time: 403 ms
Deserialize 60000000 bytes spend time: 361 ms
Deserialize 60000000 bytes spend time: 358 ms
Deserialize 60000000 bytes spend time: 355 ms
Deserialize 50000000 bytes spend time: 317 ms
Deserialize 50000000 bytes spend time: 317 ms
Deserialize 50000000 bytes spend time: 312 ms
Deserialize 40000000 bytes spend time: 271 ms
Deserialize 40000000 bytes spend time: 275 ms
Deserialize 40000000 bytes spend time: 269 ms
Deserialize 30000000 bytes spend time: 237 ms
Deserialize 30000000 bytes spend time: 237 ms
Deserialize 30000000 bytes spend time: 234 ms
Deserialize 20000000 bytes spend time: 186 ms
Deserialize 20000000 bytes spend time: 192 ms
Deserialize 20000000 bytes spend time: 192 ms
Deserialize 10000000 bytes spend time: 149 ms
Deserialize 10000000 bytes spend time: 149 ms
Deserialize 10000000 bytes spend time: 149 ms
Deserialize 9000000 bytes spend time: 141 ms
Deserialize 9000000 bytes spend time: 160 ms
Deserialize 9000000 bytes spend time: 140 ms
Deserialize 9000000 bytes spend time: 144 ms
Deserialize 8000000 bytes spend time: 147 ms
Deserialize 8000000 bytes spend time: 140 ms
Deserialize 8000000 bytes spend time: 150 ms
Deserialize 8000000 bytes spend time: 147 ms
Deserialize 8000000 bytes spend time: 138 ms
Deserialize 8000000 bytes spend time: 139 ms
Deserialize 6000000 bytes spend time: 145 ms
Deserialize 6000000 bytes spend time: 129 ms
Deserialize 6000000 bytes spend time: 129 ms
Deserialize 6000000 bytes spend time: 135 ms
Deserialize 4000000 bytes spend time: 131 ms
Deserialize 4000000 bytes spend time: 128 ms
Deserialize 4000000 bytes spend time: 120 ms
Deserialize 2000000 bytes spend time: 108 ms
Deserialize 2000000 bytes spend time: 105 ms
Deserialize 2000000 bytes spend time: 111 ms
Deserialize 1000000 bytes spend time: 91 ms
Deserialize 1000000 bytes spend time: 91 ms
Deserialize 1000000 bytes spend time: 93 ms
Deserialize 900000 bytes spend time: 90 ms
Deserialize 900000 bytes spend time: 87 ms
Deserialize 900000 bytes spend time: 88 ms
Deserialize 700000 bytes spend time: 77 ms
Deserialize 700000 bytes spend time: 86 ms
Deserialize 700000 bytes spend time: 88 ms
Deserialize 500000 bytes spend time: 69 ms
Deserialize 500000 bytes spend time: 76 ms
Deserialize 500000 bytes spend time: 73 ms
Deserialize 300000 bytes spend time: 57 ms
Deserialize 300000 bytes spend time: 59 ms
Deserialize 300000 bytes spend time: 49 ms
Deserialize 100000 bytes spend time: 25 ms
Deserialize 100000 bytes spend time: 23 ms
Deserialize 100000 bytes spend time: 24 ms
Deserialize 90000 bytes spend time: 24 ms
Deserialize 90000 bytes spend time: 20 ms
~~~

## Conclusion

![perf-mysql-conclusion]({{ site.baseurl }}/assets/blog/perf-mysql-conclusion.png)

For example if deserialize 900 MB(900000 KB), 900000 = 9 * Math.pow(10, 5), so

* per = 0.9
* n = 5

deserialize_time = Math.pow(4, 5) * 3.5 * (1 + 3 * 0.9) = 13260 ms, in other words, one hardware thread deserialize 1 GB size need around 14 secs.

If we have wall time is 1 secs, so deserialize 1 GB size's cpu cores can be caculate via below formula:

wall_time = 14 /(cores * 2), we can count cores is 7, so we need at least 7 cores cpu.
