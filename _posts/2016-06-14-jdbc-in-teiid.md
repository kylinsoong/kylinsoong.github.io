---
layout: blog
title:  "JDBC in Teiid"
date:   2016-06-14 19:00:00
categories: teiid
permalink: /jdbc-in-teiid
author: Kylin Soong
duoshuoid: ksoong2016061401
excerpt: Teiid JDBC Driver implements most of the JDBC API, this article diving into the details of how Teiid implement the JDBC API, and JDBC in Teiid 
---

* Table of contents
{:toc}


## Driver Connection

Teiid JDBC Driver Class is **org.teiid.jdbc.TeiidDriver**, use the following URL format for JDBC connections:

~~~
jdbc:teiid:<vdb-name>@mm[s]://<host>:<port>;[prop-name=prop-value;]
~~~

### FetchSize Connection Properties

Teiid Support a series of Properties, refer to [Teiid Document](https://teiid.gitbooks.io/documents/content/client-dev/Driver_Connection.html#_url_connection_properties) for details.

`FetchSize` hints the size of the resultset, the default is 2014, which means, the resultset size is 2048. In this section, we will dive into details how FetchSize setting works in Teiid.

1. In [How a connection be created](http://ksoong.org/teiid-s-diagram#how-a-connection-be-created) step, a `org.teiid.jdbc.ConnectionImpl` be created, Property **FetchSize** be set a to connectionProerties list.
2. In [How a Statement execute the query](http://ksoong.org/teiid-s-diagram#how-a-statement-execute-the-query) setp, `org.teiid.jdbc.StatementImpl` **FetchSize** be extract from connectionProerties, parse to a integer, set to `StatementImpl`'s fetchSize filed, which this occurr in `StatementImpl`'s construct, then the **FetchSize** be sent to `org.teiid.client.RequestMessage`.
3. In [How Teiid Server handle query request](http://ksoong.org/teiid-s-diagram#how-teiid-server-handle-query-request), Parse Message get the `org.teiid.client.RequestMessage`, invoke the DQPCore's executeRequest(), **FetchSize** in RequestMessage be passed as a parameter.
4.      




