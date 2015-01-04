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

~~~

		

