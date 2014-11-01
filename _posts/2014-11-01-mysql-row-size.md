---
layout: blog
title:  "Mysql rows and size counting example"
date:   2014-11-01 20:50:12
categories: database
author: Kylin Soong
duoshuoid: ksoong2014110101
---

This article give a example for counting how many rows and total data size in mysql table.

* Assuming table `SERIALTEST` exist in mysql 

~~~
CREATE TABLE SERIALTEST(id BIGINT, col_a CHAR(8), col_b CHAR(12), col_c CHAR(12));
~~~ 

* How many rows in table `SERIALTEST`

~~~
mysql> SELECT sum(table_rows) from information_schema.TABLES WHERE table_name = 'SERIALTEST';
+-----------------+
| sum(table_rows) |
+-----------------+
|         6763808 |
+-----------------+
~~~

* How much size in byte in table `SERIALTEST`

~~~
mysql> SELECT sum(data_length) from information_schema.TABLES WHERE table_name = 'SERIALTEST';
+------------------+
| sum(data_length) |
+------------------+
|        286392052 |
+------------------+
~~~
