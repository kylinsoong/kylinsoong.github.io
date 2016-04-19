---
layout: blog
title:  "Transaction in Teiid"
date:   2016-04-19 17:00:00
categories: teiid
permalink: /teiid-transactions
author: Kylin Soong
duoshuoid: ksoong2016041901
excerpt: Atomic transaction (R/W), XA datasources, two phase commit, compensating transactions 
---

* Table of contents
{:toc}

## Warming up

**Question:** How does teiid support 

1. Atomic transaction (R/W) 
2. Distributed transaction when the underlying systems are different technologies - two phase commit

**Answer 1:** Teiid can use XA datasources. For example, using it insert into Oracle and SQL Server atomically.

**Answer 2:** From [TEIID-3907](https://issues.jboss.org/browse/TEIID-3907), In Teiid, the transaction manager will fully support xa with all xa sources and a single local transaction resource. Beyond that however there is no built-in support for compensating transactions with non-XA sources.  There has been work in Narayana on compensating transactions though that could be used by custom web apps consuming Teiid. We would like to eventually offer compensating options for some of our updatable non-XA sources, but it hasn't had sufficient priority yet.

## Prerequisites

This section will list some basic prerequisites, backgroud technologies for understanding Teiid Transaction.

### XADataSource and XAResource

![Teid XA Datasource]({{ site.baseurl }}/assets/blog/teiid/teiid-uml-XADataSource.png)

**javax.sql.DataSource**

The `javax.sql.DataSource`  interface is the preferred way to expose a JDBC interface. It is a highly abstracted interface, exposing only two methods

~~~
Connection getConnection() throws SQLException;
Connection getConnection(String username, String password)throws SQLException;
~~~

**javax.sql.XADataSource**

In the context of XA transactions, a JDBC data source can be exposed as a `javax.sql.XADataSource` object. The main difference between an `XADataSource` object and a plain `DataSource` object is that the `XADataSource` object returns a `javax.sql.XAConnection` object, which you can use to access and enlist an `XAResource` object. The methods exposed:

~~~
XAConnection getXAConnection() throws SQLException;
XAConnection getXAConnection(String user, String password) throws SQLException;
~~~
