---
layout: blog
title:  "Teiid Results Caching Comparison Example"
date:   2015-05-19 21:20:00
categories: teiid
permalink: /teiid-rs-cache
author: Kylin Soong
duoshuoid: ksoong2015051901
excerpt: A comparison example(native query, query without cache, query with cache) show how Results Caching improve thousands of performance
---

## Teiid Results Caching Comparison Example

There are 3 sections in Results Caching Comparison Example:

* Overview
* Run
* Conclusion

### Overview

Teiid Results Caching Comparison Example is a Performance conparison example, **PERFTEST** table exist in RDBMS, which contains 100 MB data in RDBMS. **PERFTESTVIEW** is a View which mapped to **PERFTEST** table, it be defined in a Teiid VDB. There are 3 different query:

* Native Query(SELECT * FROM PERFTEST) - Connection be created by RDBMS JDBC Driver, Repeated query 10 times, record query time 
* Query Without Results Caching(SELECT * FROM PERFTESTVIEW) - Connection be created by Teiid JDBC Driver, Repeated query 10 times, record query time
* Query With Results Caching(/*+ cache */ SELECT * FROM PERFTESTVIEW) - Connection be created by Teiid JDBC Driver, Repeated query 10 times, record query time

The Comparison result will show how Results Caching are critical for query performance.

More details about Results Caching: [https://docs.jboss.org/author/display/TEIID/Results+Caching](https://docs.jboss.org/author/display/TEIID/Results+Caching).

[Results Caching Example Source Code](https://github.com/teiid/teiid-embedded-examples/blob/master/embedded-caching/src/main/java/org/teiid/example/ResultsCachingExample.java).

### Run  

With the following steps to run the performance comparison example:

* **Step.1 Add test data to Mysql**

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

* **Step.3 Run example**

Run each queries('SELECT * FROM PERFTEST', 'SELECT * FROM PERFTESTVIEW', '/*+ cache */ SELECT * FROM PERFTESTVIEW') 10 times, record query time, it should looks

~~~
+------------------------+----------------------------+-----------------------------------------+
| SELECT * FROM PERFTEST | SELECT * FROM PERFTESTVIEW | /*+ cache */ SELECT * FROM PERFTESTVIEW |
+------------------------+----------------------------+-----------------------------------------+
|          1869          |            1553            |                   1448                  |
|          1379          |            1347            |                    1                    |
|          1333          |            1359            |                    0                    |
|          1342          |            1363            |                    1                    |
|          1370          |            1326            |                    0                    |
|          1351          |            1392            |                    1                    |
|          1539          |            1348            |                    1                    |
|          1346          |            1350            |                    0                    |
|          1358          |            1326            |                    1                    |
|          1375          |            1381            |                    1                    |
+------------------------+----------------------------+-----------------------------------------+
~~~

### Conclusion

Converting above step.3 result to a performance comparison diagram

![Teiid rs cache]({{ site.baseurl }}/assets/blog/teiid-perf-resultset.png)

From top to bottom

* The top histogram show Query With Results Caching, it spent 1 millisecond if result be cached
* The middle histogram show Query Without Results Caching, it spend 1300 milliseconds each time
* The bottom histogram show Native query, it spend 1300 milliseconds each time

We can get the conclusion: **enable Results Caching is 1000 times fast than disable caching**.

## How it work

In this section we discuss why 1000 times performance take place. As below sequence diagram, RequestWorkItem process first will get result from RssultSetCache, if result exist, get result from cache and return, this is the reson why 1000 times performance take place.

![Result From Cache]({{ site.baseurl }}/assets/blog/teiid-cache.png)

> Note that: more detailed logic about RequestWorkItem get results from cache please look at processNew() method in [RequestWorkItem.java](https://github.com/teiid/teiid/blob/master/engine/src/main/java/org/teiid/dqp/internal/process/RequestWorkItem.java) 

## Cached Virtual Procedure

Cached virtual procedure results are used automatically when a matching set of parameter values is detected for the same procedure execution. Use the Cache Hints can enable cache virtual procedure results, below as an example:

~~~
CoREATE VIRTUAL PROCEDURE PERFTPROCE2()
AS
/*+ cache */
BEGIN 
	SELECT A.id, A.col_a, A.col_b, A.col_c FROM Accounts.PERFTEST AS A;
END
~~~

In my test there also is a `PERFTPROCE1()` which cache is diabaled, the test results show there also have thousands of times performance improve, the comparison result as below:

~~~
+--------------------+--------------------+
| call PERFTPROCE1() | call PERFTPROCE2() |
+--------------------+--------------------+
|        3622        |        3355        |
|        3236        |          1         |
|        3219        |          1         |
|        3233        |          1         |
|        3207        |          1         |
|        3207        |          1         |
|        3596        |          1         |
|        3192        |          1         |
|        3198        |          1         |
|        3180        |          1         |
+--------------------+--------------------+
~~~
