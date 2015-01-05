---
layout: blog
title:  "Teiid embedded Client"
date:   2015-01-04 18:10:00
categories: teiid
permalink: /teiid-embedded-client
author: Kylin Soong
duoshuoid: ksoong20150104
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. This article will deive into the teidd embedded client.

## Debug Driver Get Connection

~~~
EmbeddedServer server;
...
Driver driver = server.getDriver();
Connection conn = driver.connect("jdbc:teiid:hbasevdb", null);
~~~

![teiid embedded get connection]({{ site.baseurl }}/assets/blog/DriverGetConnection.png)

## Debug Statement execute Query

~~~
ResultSet rs = stmt.executeQuery("SELECT * FROM Customer");
~~~

![teiid embedded statement get resultset]({{ site.baseurl }}/assets/blog/StatementExecuteQuery.png)

The Log outputed while Statement execute query:

~~~
Jan 05,2015 17:44 FINER [org.teiid.jdbc] (main) Executing: requestID -1 commands: [SELECT * FROM Customer] expecting: RESULTSET
Jan 05,2015 17:44 FINER [org.teiid.COMMAND_LOG] (main)  START USER COMMAND:     startTime=2015-01-05 17:44:01.458       requestID=3Bx8notQEs/u.0        txID=null       sessionID=3Bx8notQEs/u  applicationName=JDBC    principal=anonymous@teiid-security      vdbName=hbasevdb        vdbVersion=1    sql=SELECT * FROM Customer
Jan 05,2015 17:44 FINER [org.teiid.PROCESSOR] (main) Request Thread 3Bx8notQEs/u.0 with state NEW
Jan 05,2015 17:44 FINER [org.teiid.PROCESSOR] (main) 3Bx8notQEs/u.0 Command has no cache hint and result set cache mode is not on.
Jan 05,2015 17:44 FINER [org.teiid.PROCESSOR] (main) 3Bx8notQEs/u.0 executing  SELECT * FROM Customer
Jan 05,2015 17:44 FINER [org.teiid.PROCESSOR] (main) ProcessTree for 3Bx8notQEs/u.0 AccessNode(0) output=[Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product] SELECT Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product FROM Customer.Customer

Jan 05,2015 17:44 FINER [org.teiid.BUFFER_MGR] (main) Creating TupleBuffer: 0 [Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product] [class java.lang.String, class java.lang.String, class java.lang.String, class java.lang.String, class java.lang.String] batch size 256 of type PROCESSOR
Jan 05,2015 17:44 FINER [org.teiid.CONNECTOR] (main) 3Bx8notQEs/u.0.0.0 Create State
Jan 05,2015 19:28 FINER [org.teiid.PROCESSOR] (Worker0_QueryProcessorQueue0) Running task for parent thread main
Jan 05,2015 19:54 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Processing NEW request: SELECT Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product FROM Customer.Customer
Jan 05,2015 20:08 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) Source-specific command: SELECT Customer."ROW_ID", Customer."city", Customer."name", Customer."amount", Customer."product" FROM "Customer" AS Customer
Jan 05,2015 20:13 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Obtained execution
Jan 05,2015 20:14 FINER [org.teiid.COMMAND_LOG] (Worker0_QueryProcessorQueue0)  START DATA SRC COMMAND: startTime=2015-01-05 20:14:03.419       requestID=3Bx8notQEs/u.0        sourceCommandID=0       executionID=0   txID=null       modelName=Customer      translatorName=translator-hbase sessionID=3Bx8notQEs/u  principal=anonymous@teiid-security      sql=SELECT Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product FROM Customer.Customer
Jan 05,2015 20:15 FINE [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) SELECT Customer.PK, Customer.city, Customer.name, Customer.amount, Customer.product FROM Customer
Jan 05,2015 20:16 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Executed command
Jan 05,2015 20:23 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Processing MORE request
Jan 05,2015 20:24 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Getting results from connector
Jan 05,2015 20:29 FINER [org.teiid.CONNECTOR] (Worker0_QueryProcessorQueue0) 3Bx8notQEs/u.0.0.0 Obtained last batch, total row count: 9
Jan 05,2015 20:36 FINER [org.teiid.PROCESSOR] (main) Request Thread 3Bx8notQEs/u.0 - processor blocked
Jan 05,2015 20:37 FINER [org.teiid.PROCESSOR] (main) Request Thread 3Bx8notQEs/u.0 with state PROCESSING
Jan 05,2015 20:37 FINER [org.teiid.CONNECTOR] (main) 3Bx8notQEs/u.0.0.0 Remove State
Jan 05,2015 20:37 FINER [org.teiid.CONNECTOR] (main) 3Bx8notQEs/u.0.0.0 Processing Close : SELECT Customer.Customer.PK, Customer.Customer.city, Customer.Customer.name, Customer.Customer.amount, Customer.Customer.product FROM Customer.Customer
Jan 05,2015 20:37 FINER [org.teiid.COMMAND_LOG] (main)  END SRC COMMAND:        endTime=2015-01-05 20:37:05.574 requestID=3Bx8notQEs/u.0        sourceCommandID=0       executionID=0   txID=null       modelName=Customer      translatorName=translator-hbase sessionID=3Bx8notQEs/u  principal=anonymous@teiid-security      finalRowCount=9
Jan 05,2015 20:37 FINER [org.teiid.CONNECTOR] (main) 3Bx8notQEs/u.0.0.0 Closed execution
Jan 05,2015 20:37 FINER [org.teiid.CONNECTOR] (main) 3Bx8notQEs/u.0.0.0 Closed connection
Jan 05,2015 20:37 FINER [org.teiid.PROCESSOR] (main) QueryProcessor: closing processor
Jan 05,2015 20:37 FINER [org.teiid.PROCESSOR] (main) [RequestWorkItem.sendResultsIfNeeded] requestID: 3Bx8notQEs/u.0 resultsID: 0 done: true
Jan 05,2015 20:37 FINER [org.teiid.BUFFER_MGR] (main) 3Bx8notQEs/u.0 Blocking to allow asynch processing
Jan 05,2015 20:37 FINER [org.teiid.PROCESSOR] (main) Request Thread 3Bx8notQEs/u.0 - processor blocked
Jan 05,2015 20:37 FINER [org.teiid.jdbc] (main) Creating ResultSet requestID: 0 beginRow: 1 resultsColumns: 5 parameters: 0
Jan 05,2015 20:37 FINE [org.teiid.jdbc] (main) Successfully executed a query SELECT * FROM Customer and obtained results
~~~
