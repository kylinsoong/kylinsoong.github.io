---
layout: blog
title:  "Teiid JDBC Connection Transaction"
date:   2015-10-09 18:00:00
categories: teiid
permalink: /teiid-transaction
author: Kylin Soong
duoshuoid: ksoong2015100901
excerpt: Teiid JDBC Connection Transaction, TransactionManager in Teiid Embedded
---

## Overview

Teiid provide a JDBC Driver teiid-VERSION-jdbc.jar, it can download from [Teiid Downloads](http://teiid.jboss.org/downloads/). We know that Transaction related methods including:

~~~
void setAutoCommit(boolean autoCommit) throws SQLException;
void commit() throws SQLException;
void rollback() throws SQLException;
...
~~~

If set `AutoCommit` to false, each SQL request execution will relate with Transaction to ensure data integrity. Teiid JDBC Connection expose to Teiid Server side key interface DQP to implement Transaction, the relevant methods including:

~~~
ResultsFuture<?> begin() throws XATransactionException;
ResultsFuture<?> commit() throws XATransactionException;
ResultsFuture<?> rollback() throws XATransactionException;
...
~~~

This article will dive into the underlying of Transaction implementation in Teiid.

## Transaction begin

![Transaction begin]({{ site.baseurl }}/assets/blog/Transaction-begin.png)

TransactionManager be set to DQPCore when Teiid Server start up, Transaction begin finally trigger TransactionManager's begin().

## Transaction commit

![Transaction commit]({{ site.baseurl }}/assets/blog/Transaction-commit.png)

TransactionManager be set to DQPCore when Teiid Server start up, Transaction commit finally trigger TransactionManager's commit().

## Transaction rollback

![Transaction rollback]({{ site.baseurl }}/assets/blog/Transaction-rollback.png)

TransactionManager be set to DQPCore when Teiid Server start up, Transaction rollback finally trigger TransactionManager's rollback().

## Example

Run Teiid Embedded with the following codes will execute Transaction begin and commit:

~~~
EmbeddedServer server = new EmbeddedServer();
...
EmbeddedConfiguration config = new EmbeddedConfiguration();
config.setTransactionManager(EmbeddedHelper.getTransactionManager());	
server.start(config);
...
Connection c = ...
c.setAutoCommit(false);
execute(c, "INSERT INTO TEST VALUES(100,'Test')", false);
c.commit();
~~~

