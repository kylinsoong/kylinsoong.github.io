---
layout: blog
title:  "Teiid embedded samples WebService"
date:   2014-09-17 11:06:00
categories: teiid
permalink: /teiid-ws
author: Kylin Soong
duoshuoid: ksoong2014091701
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver and an embed Query Engine. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Web Service as data source, the architecture as below:

![teiid-embbed-ws]({{ site.baseurl }}/assets/blog/teiid-embbed-ws.png)

## JVM

JBoss EAP 6.3 hold the `StateService.jar` run on JVM, it supply State WebService for users to extract all states information, or extract only one state information via stateCode(for example, state code `CA` will get California information). 

> Note that: In this example, JBoss EAP 6.3 run on localhost. [ Web Service StateService Example]({{ site.baseurl }}/jaxws-stateservice) have detailed steps for deploy `StateService.jar` and StateService.

## StateServiceVDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, StateService VDB has Model `StateService` point to Web Service run on JBoss Server. 

[The completed content of webservice VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/webservice-vdb.xml)

## JVM

Java Application run on JVM, load the `StateServiceVDB` and invoke Web Service via JDBC. The mainly Code Snippets:

~~~
init("translator-ws", new WSExecutionFactory());
		
WSManagedConnectionFactory managedconnectionFactory = new WSManagedConnectionFactory();
server.addConnectionFactory("java:/StateServiceWebSvcSource", managedconnectionFactory.createConnectionFactory());
		
start(false);
server.deployVDB(new FileInputStream(new File("vdb/webservice-vdb.xml")));
conn = server.getDriver().connect("jdbc:teiid:StateServiceVDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/ws/TestWebServiceDataSource.java)

