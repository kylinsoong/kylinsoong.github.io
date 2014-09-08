---
layout: blog
title:  "Teiid embedded samples MongoDB"
date:   2014-09-08 18:30:00
categories: teiid
permalink: /teiid-mongodb
author: Kylin Soong
duoshuoid: ksoong2014090803
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use MongoDB as data source, the architecture as below:

![teiid-embed-mongo]({{ site.baseurl }}/assets/blog/teiid-embed-mongodb.png)

## MongoDB

MongoDB run remotely, in this example, MongoDB run on 10.66.218.46, with database `mydb`.

## nothwind VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, nothwind VDB has Model `northwind` point to MongoDB database `mydb`. 

[The completed content of northwind VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/mongodb-vdb.xml)

## JVM

Java Application run on JVM, load the `northwind VDB` and query via JDBC. The mainly Code Snippets:

~~~
init("translator-mongodb", new MongoDBExecutionFactory());
		
MongoDBManagedConnectionFactory managedconnectionFactory = new MongoDBManagedConnectionFactory();
managedconnectionFactory.setRemoteServerList(SERVERLIST);
managedconnectionFactory.setDatabase(DBNAME);
server.addConnectionFactory("java:/mongoDS", managedconnectionFactory.createConnectionFactory());
		
start(false);
server.deployVDB(new FileInputStream(new File("vdb/mongodb-vdb.xml")));
conn = server.getDriver().connect("jdbc:teiid:nothwind", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/mongodb/TestMongoDBDataSource.java)

