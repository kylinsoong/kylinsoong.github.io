---
layout: blog
title:  "java.lang.OutOfMemoryError: GC overhead limit exceeded"
date:   2014-10-12 20:55:00
categories: java
permalink: /gc-over-exceed
author: Kylin Soong
duoshuoid: ksoong20141012
---

Mysql JDBC driver throw `java.lang.OutOfMemoryError: GC overhead limit exceeded` while querying databases, the stacktrace likes:

~~~
Exception in thread "main" java.lang.OutOfMemoryError: GC overhead limit exceeded
	at com.mysql.jdbc.MysqlIO.nextRowFast(MysqlIO.java:2267)
	at com.mysql.jdbc.MysqlIO.nextRow(MysqlIO.java:2044)
	at com.mysql.jdbc.MysqlIO.readSingleRowSet(MysqlIO.java:3549)
	at com.mysql.jdbc.MysqlIO.getResultSet(MysqlIO.java:489)
	at com.mysql.jdbc.MysqlIO.readResultsForQueryOrUpdate(MysqlIO.java:3240)
	at com.mysql.jdbc.MysqlIO.readAllResults(MysqlIO.java:2411)
	at com.mysql.jdbc.MysqlIO.sqlQueryDirect(MysqlIO.java:2834)
	at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2832)
	at com.mysql.jdbc.ConnectionImpl.execSQL(ConnectionImpl.java:2781)
	at com.mysql.jdbc.StatementImpl.executeQuery(StatementImpl.java:1569)
~~~

This documents will dive into the underlying find out why java.lang.OutOfMemoryError: GC overhead limit exceeded throw.

## Collect GC log

From GC log we can find the following:

~~~
433.249: [Full GC [PSYoungGen: 233472K->58879K(466432K)] [ParOldGen: 1247673K->1398227K(1398272K)] 1481145K->1457106K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 5.0595010 secs] [Times: user=18.83 sys=0.08, real=5.06 secs]
438.570: [Full GC [PSYoungGen: 233472K->233470K(466432K)] [ParOldGen: 1398227K->1398227K(1398272K)] 1631699K->1631697K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 4.2411710 secs] [Times: user=16.32 sys=0.05, real=4.24 secs]
442.812: [Full GC [PSYoungGen: 233472K->233471K(466432K)] [ParOldGen: 1398227K->1398227K(1398272K)] 1631699K->1631699K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 4.1849020 secs] [Times: user=16.18 sys=0.04, real=4.19 secs]
446.997: [Full GC [PSYoungGen: 233471K->233471K(466432K)] [ParOldGen: 1398229K->1398229K(1398272K)] 1631701K->1631701K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 4.2677620 secs] [Times: user=15.34 sys=0.05, real=4.27 secs]
451.265: [Full GC [PSYoungGen: 233471K->233471K(466432K)] [ParOldGen: 1398231K->1398231K(1398272K)] 1631703K->1631703K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 4.2274540 secs] [Times: user=15.62 sys=0.05, real=4.22 secs]
455.493: [Full GC [PSYoungGen: 233471K->233471K(466432K)] [ParOldGen: 1398234K->1398126K(1398272K)] 1631706K->1631598K(1864704K) [PSPermGen: 6322K->6322K(21504K)], 5.4616650 secs] [Times: user=18.96 sys=0.07, real=5.46 secs]
~~~

Note that, GC can not release the heap and occurred very frequently.

## Conclusion

This error is thrown by the throughput old collector (serial or parallel) if more than 98% of the total time is spent doing garbage collection and less than 2% of the heap is recovered. It is intended to prevent applications from running for an extended period of time while making little or no progress reclaiming objects (e.g. when the heap is too small, there is a memory leak, or the old generation is disproportionately small compared to the new generation). It is a throttle to prevent the JVM from swamping the environment it is running in. This feature can be disabled with the -XX:-UseGCOverheadLimit JVM option.

## Resolution

* If the new generation size is explicitly defined with JVM options, decrease the size or remove the relevant JVM options entirely to unconstrain the JVM and provide more space in the old generation for long lived objects. 

* If there is unintended object retention, typically code and/or configuration changes are needed.

* If the retention looks normal, and it is a load issue, the heap size would need to be increased.
