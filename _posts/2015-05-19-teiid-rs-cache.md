---
layout: blog
title:  "Teiid Results Caching Usage Example"
date:   2015-05-19 21:20:00
categories: teiid
permalink: /teiid-rs-cache
author: Kylin Soong
duoshuoid: ksoong2015051901
excerpt: Teiid Results Caching Example
---

Let's start from an eample, there are 100 MB size data exist in Mysql Data Base, then we create View in Teiid VDB query against these data, the result as figure: 

![Teiid rs cache]({{ site.baseurl }}/assets/blog/teiid-perf-resultset.png)

In the Figure, the left histogram is query without cache, the right histogram is with cache, we can get the conclusion: **enable Results Caching is 1000 times fast than without caching**.

More details about Results Caching refer to [https://docs.jboss.org/author/display/TEIID/Results+Caching](https://docs.jboss.org/author/display/TEIID/Results+Caching).

## How to run 

Follow the following steps to run the examples:

* **Step.1 Add test data to MySQL**

In my test I have insert 100 MB size data in Mysql `PERFTEST` table(CREATE TABLE PERFTEST(id INTEGER, col_a CHAR(16), col_b CHAR(40), col_c CHAR(40))).

> NOTE: int type is 4 bytes, char(n) is n bytes, so each row's size = 4 + 16 + 40 + 40, in other words, each rows size is 100 bytes.

So for insert 100 MB into Mysql, we need inser 1<<20(MB) rows. Query from Mysql Comman Line, the result:

~~~
> SELECT sum(table_rows), sum(data_length) from information_schema.TABLES WHERE table_name = 'PERFTEST';
+-----------------+------------------+
| sum(table_rows) | sum(data_length) |
+-----------------+------------------+
|         1048716 |        142262272 |
+-----------------+------------------+
~~~ 

* **Step.2 Create View in VDB map to Mysql Table**

The View in my test like:

~~~
<model name="Test" type="VIRTUAL">
	<metadata type="DDL"><![CDATA[
	CREATE VIEW PERFTESTVIEW (
	id long,
	col_a varchar,
	col_b varchar,
	col_c varchar
	)
	AS
	SELECT A.id, A.col_a, A.col_b, A.col_c FROM Accounts.PERFTEST AS A;
	]]>
	</metadata>
</model>
~~~

* **Query against PERFTESTVIEW**

Implement select all query 10 times with enable and disable User Query Cache.

Enable User Query Cache Result:

~~~
+-----------------------------------------+
| /*+ cache */ SELECT * FROM PERFTESTVIEW |
+-----------------------------------------+
|                                    1077 |
|                                      11 |
|                                       1 |
|                                       1 |
|                                       1 |
|                                       2 |
|                                       1 |
|                                       0 |
|                                       1 |
|                                       0 |
+-----------------------------------------+
~~~

Disable User Query Cache Result:

~~~
+-----------------------------------------+
|         SELECT * FROM PERFTESTVIEW      |
+-----------------------------------------+
|                                    1252 |
|                                    1226 |
|                                    1005 |
|                                     995 |
|                                    1005 |
|                                     983 |
|                                    1042 |
|                                    1089 |
|                                    1025 |
|                                    1047 |
+-----------------------------------------+
~~~

## How it work
