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



