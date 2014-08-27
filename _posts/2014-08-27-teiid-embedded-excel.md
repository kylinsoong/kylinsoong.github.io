---
layout: blog
title:  "Teiid embedded samples Excel"
date:   2014-08-27 20:05:00
categories: teiid
permalink: /teiid-embedded-excel
author: Kylin Soong
duoshuoid: ksoong2014082703
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Microsoft Excel as data source, the architecture as below:

![teiid-embed-excel]({{ site.baseurl }}/assets/blog/teiid-embed-excel.png)

## Excel

One Microsoft Excel be used int this example:

* [otherholdings.xls](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/otherholdings.xls)


## ExcelVDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, ExcelVDB has Model `PersonalHoldings` point to excel [otherholdings.xls](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/otherholdings.xls)

[The completed content of ExcelVDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/excel-vdb.xml)

## JVM

Java Application run on JVM, load the `ExcelVDB` and query via JDBC. The mainly Code Snippets:

~~~
		init("excel", new ExcelExecutionFactory());
		
		FileManagedConnectionFactory managedconnectionFactory = new FileManagedConnectionFactory();
		managedconnectionFactory.setParentDirectory("metadata");
		server.addConnectionFactory("java:/excel-file", managedconnectionFactory.createConnectionFactory());
		
		start(false);
		
		server.deployVDB(new FileInputStream(new File("vdb/excel-vdb.xml")));
		
		conn = server.getDriver().connect("jdbc:teiid:ExcelVDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/excel/TestExcelDataSource.java)

