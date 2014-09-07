---
layout: blog
title:  "Teiid embedded samples H2"
date:   2014-09-07 10:50:00
categories: teiid
permalink: /teiid-embedded-h2
author: Kylin Soong
duoshuoid: ksoong2014090701
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use H2 Database as data source, the architecture as below:

![teiid-embed-h2]({{ site.baseurl }}/assets/blog/teiid-embed-h2.png)

## H2

Mysql database be used in this example, note that `test` are mysql database name, it contain the [customer-schema-h2.sql](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/customer-schema-h2.sql) tables.

The [customer-schema-h2.sql](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/customer-schema-h2.sql) be executed automatically in runtime.


## H2VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, H2VDB has Model `Product` point to H2 database `test` 

[The completed content of H2VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/h2-vdb.xml)

## JVM

Java Application run on JVM, load the `H2VDB` and query via JDBC. The mainly Code Snippets:

~~~
startServer();
setupDataSource();
initTestData();
		
init("translator-h2", new H2ExecutionFactory());
start(false);
server.deployVDB(new FileInputStream(new File("vdb/h2-vdb.xml")));
conn = server.getDriver().connect("jdbc:teiid:H2VDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/h2/TestH2DataSource.java)

