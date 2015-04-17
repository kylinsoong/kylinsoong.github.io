---
layout: blog
title:  "使用 JDBC 操作 Microsoft Access"
date:   2015-04-17 17:40:00
categories: data
permalink: /jdbc-access
author: Kylin Soong
duoshuoid: ksoong2015041701
---

本文介绍通过两种方法使用 JDBC 操作 Microsoft Access。

## 使用 JDBC ODBC Bridge 驱动

~~~
Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
Connection conn = DriverManager.getConnection("jdbc:odbc:Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=src/main/resources/ODBCTesting.accdb");
~~~

[具体示例](https://github.com/kylinsoong/data/blob/master/ms-file/src/main/java/org/jboss/teiid/datasources/MSAccessJDBCODBCClient.java)

## 使用 UCanAccess 驱动

~~~
Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
Connection conn= DriverManager.getConnection(jdbc:ucanaccess://src/test/resources/ucanaccess/ODBCTesting.accdb);
~~~

[具体示例](https://github.com/kylinsoong/data/blob/master/ms-file/src/main/java/org/jboss/teiid/datasources/UCanAccessJDBCClient.java)
