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
