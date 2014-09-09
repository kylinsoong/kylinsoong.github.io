---
layout: blog
title:  "Teiid embedded samples Rest WebService"
date:   2014-09-09 12:15:00
categories: teiid
permalink: /teiid-restws
author: Kylin Soong
duoshuoid: ksoong2014090901
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Rest Web Service as data source, the architecture as below:

![teiid-embed-restws]({{ site.baseurl }}/assets/blog/teiid-embed-restws.png)

## JVM

JBoss EAP 6.3 hold the `CustomerRESTWebSvc.war` run on JVM, it supply REST WebService http://localhost:8080/CustomerRESTWebSvc/MyRESTApplication/customerList for list all exist customers.

> Note that: In this exanple, JBoss EAP 6.3 run on localhost. [Click this doc](https://github.com/kylinsoong/jaxrs/tree/master/customer) for how build and deploy `CustomerRESTWebSvc.war`.

## restwebservice VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, restwebservice VDB has Model `Customers` point to Rest Web Service run on JBoss Server. 

[The completed content of restwebservice VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/restwebservice-vdb.xml)

## JVM

Java Application run on JVM, load the `restwebservice VDB` and query via JDBC. The mainly Code Snippets:

~~~
init("translator-rest", new WSExecutionFactory());
		
WSManagedConnectionFactory managedconnectionFactory = new WSManagedConnectionFactory();
managedconnectionFactory.setEndPoint(ENDPOINT);
server.addConnectionFactory("java:/CustomerRESTWebSvcSource", managedconnectionFactory.createConnectionFactory());
		
start(false);
server.deployVDB(new FileInputStream(new File("vdb/restwebservice-vdb.xml")));
conn = server.getDriver().connect("jdbc:teiid:restwebservice", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/ws/TestRESTWebServiceDataSource.java)

