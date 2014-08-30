---
layout: blog
title:  "Teiid JDBC Client"
date:   2014-08-30 22:10:00
categories: teiid
permalink: /teiid-jdbc-client
author: Kylin Soong
duoshuoid: ksoong20140830
---

The Teiid JDBC API provides Java Database Connectivity (JDBC) access to any Virtual Database (VDB) deployed on a Teiid Server. This document discuss the Teiid JDBC Client, including Sample code, architecute, etc.

## Connecting to a Teiid Server

With the following 2 steps we can connect to a Teiid Server:

* **I.** Add Teidd jdbc client jar

Add the `teiid-client` dependency can import Teiid JDBC Client:

~~~
		<dependency>
			<groupId>org.jboss.teiid</groupId>
			<artifactId>teiid-client</artifactId>
			<version>8.9.0.Alpha2-SNAPSHOT</version>
		</dependency>
~~~

* **II.** Use JDBC API connect to Teiid

Use **org.teiid.jdbc.TeiidDriver** as the driver class. Use the following URL format for JDBC connections:

~~~
jdbc:teiid:<vdb-name>@mm[s]://<host>:<port>;[prop-name=prop-value;]*
~~~

The following is a example for connecting to `Marketdata` VDB, and execute SELECT:

~~~
Class.forName("org.teiid.jdbc.TeiidDriver");
Connection conn = DriverManager.getConnection("jdbc:teiid:Marketdata@mm://localhost:31000;version=1", "user", "user");
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM Marketdata");
~~~

## Mind Map for TeiidDriver get Connection

![teiid-teiiddriver-getconn]({{ site.baseurl }}/assets/blog/teiid-getconn.png)
