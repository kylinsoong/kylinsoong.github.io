---
layout: blog
title:  "MariaDB 事物隔离实验"
date:   2017-10-25 19:00:00
categories: database
author: Kylin Soong
---

本实验的目的是测试MariaDB 事物隔离级别 READ_UNCOMMITTED, READ_COMMITTED, REPEATABLE_READ。本实验有两个数据库连接，基于两个连接进行不同的操作，操作的编号为 A - G 如下

![MariaDB TX ISOLATION]({{ site.baseurl }}/assets/blog/2017/mysql-tx-isolation.png)

* A - 连接 1 创建测试表，初始化测试数据

~~~
CREATE TABLE IF NOT EXISTS TEST(a INT PRIMARY KEY, b INT);
INSERT INTO TEST VALUES(1, 1);
INSERT INTO TEST VALUES(2, 2);
~~~

* B - 连接 1 设置事物隔离级别，并查看设置结果

~~~
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
select @@TX_ISOLATION;
~~~

> 注意: READ-COMMITTED 为设置的事物隔离级别。

* C - 连接 2 查看事物隔离级别

~~~
select @@TX_ISOLATION;
~~~

> 注意: REPEATABLE-READ 是 MariaDB/Mysql 默认的事物隔离级别。

* D - 连接 2 开始事务，修改测试数据，并查看修改结果

~~~
START TRANSACTION;
UPDATE TEST SET b = 200 WHERE a = 2;
SELECT * FROM TEST;
~~~

> 注意，查看修改结果显示连接 2 可以看到相关修改。

* E - 连接 1 查询数据

~~~
SELECT * FROM TEST;
~~~

> 注意: 查询结果看不到修改数据，这是由于事物隔离的级别为 READ-COMMITTED。如果将事物隔离的级别设置为 READ UNCOMMITTED，则连接 1 能够看到修改数据。

* F - 连接 2 提交事物并查询数据

~~~
COMMIT;
SELECT * FROM TEST;
~~~

> 注意: 查询结果显示事物提交成功。

* G - 连接 1 查询数据

~~~
SELECT * FROM TEST;
~~~

> 注意: 查询结果显示可以读取到连接 2 修改的数据，注意在同一个连接两次读取同一行数据结果显示两次读取的结果不一致。

