---
layout: blog
title:  "Teiid embedded samples Mysql"
date:   2014-08-27 18:30:00
categories: teiid
permalink: /teiid-embedded-mysql
author: Kylin Soong
duoshuoid: ksoong2014082702
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Mysql Database as data source, the architecture as below:

![teiid-embed-mysql]({{ site.baseurl }}/assets/blog/teiid-embed-mysql.png)

## Mysql

Mysql database be used in this example, note that `customer` are mysql database name, it contain the [customer-schema.sql](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/customer-schema.sql) tables.

For how to import sql file to mysql database, alos database creation please refer to [mysql usage commands]({{ site.baseurl }}/mysql-usage-commands)


## MysqlVDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, MysqlVDB has Model `Product` point to Mysql database `customer` 

[The completed content of MysqlVDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/myql-vdb.xml)

## JVM

Java Application run on JVM, load the `MysqlVDB` and query via JDBC. The mainly Code Snippets:

~~~
	setupDataSource();	
	init("translator-mysql", new MySQL5ExecutionFactory());	
	start(false);	
	server.deployVDB(new FileInputStream(new File("vdb/mysql-vdb.xml")));	
	conn = server.getDriver().connect("jdbc:teiid:MysqlVDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/mysql/TestMysqDataSource.java)

