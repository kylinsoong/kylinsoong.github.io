---
layout: blog
title:  "Teiid embedded samples Files"
date:   2014-08-27 18:10:00
categories: teiid
permalink: /teiid-embedded-file
author: Kylin Soong
duoshuoid: ksoong2014082701
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Files(flat/xml file) as data source, and query files data via Teiid Driver with JDBC, the architecture as below:

![teiid-embed-file]({{ site.baseurl }}/assets/blog/teiid-embed-file.png)

## Files

Two files be used in this example:

* [marketdata.csv](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/marketdata.csv) 
* [books.xml](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/books.xml)

## FilesVDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, FilesVDB has `Stocks` point to [marketdata.csv](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/marketdata.csv), and `Books` for [books.xml](https://github.com/jbosschina/teiid-embedded-samples/blob/master/metadata/books.xml)

[The completed content of FilesVDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/files-vdb.xml)

## JVM

Java Application run on JVM, load the `FilesVDB` and query via JDBC. The mainly Code Snippets:

~~~
		init("file", new FileExecutionFactory());
		
		FileManagedConnectionFactory managedconnectionFactory = new FileManagedConnectionFactory();
		managedconnectionFactory.setParentDirectory("metadata");
		server.addConnectionFactory("java:/marketdata-file", managedconnectionFactory.createConnectionFactory());
		
		start(false);
		
		server.deployVDB(new FileInputStream(new File("vdb/files-vdb.xml")));
		
		conn = server.getDriver().connect("jdbc:teiid:FilesVDB", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/file/TestFileDataSource.java)

