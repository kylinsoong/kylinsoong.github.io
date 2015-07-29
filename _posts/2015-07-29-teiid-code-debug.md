---
layout: blog
title:  "10 tips in debug Teiid source code"
date:   2015-07-29 17:00:00
categories: teiid
permalink: /teiid-code-debug
author: Kylin Soong
duoshuoid: ksoong2015072901
excerpt: Tips of debug teiid source code
---

### 1. Use Embedded, rather than JBoss server

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver and an embedded the Query Engine. The Embedded mode supply almost all Teiid features without JEE JBoss Container involved. So for Debug source code purpose, there is no reason to set up Debug environment in JBoss Server.

Sample code snippets:

~~~
EmbeddedServer server = new EmbeddedServer();
...
server.addTranslator("translator-h2", factory);
server.addConnectionFactory("java:/accounts-ds", ds);
...
EmbeddedConfiguration config = new EmbeddedConfiguration();
server.start(config);
...
Connection conn = server.getDriver().connect("jdbc:teiid:ResultsCachingH2VDB", info);
~~~

[https://github.com/teiid/teiid-embedded-examples](https://github.com/teiid/teiid-embedded-examples) have several examples which can help you set up a debug environment quickly.

### 2. Set a larger TimeSlice

By default, QueryProcessor assume the TimeSlice between RequestWorkItem and QueryProcessor are 2 seconds, if the time exceed 2 seconds the ExpiredTimeSliceException will throw, so set a larger TimeSlice is a prerequisite.

~~~
EmbeddedConfiguration config = new EmbeddedConfiguration();
config.setTimeSliceInMilli(Integer.MAX_VALUE);
~~~
