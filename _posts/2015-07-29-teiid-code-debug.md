---
layout: blog
title:  "Tips for debug Teiid source code"
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

### 3. Enable Logging

Logging is first steps for reading code, [EmbeddedHelper](https://raw.githubusercontent.com/teiid/teiid-embedded-examples/master/common/src/main/java/org/teiid/example/EmbeddedHelper.java) is a example that supply static logger metod, A simple way of enable logger is 

~~~
EmbeddedHelper.enableLogger(Level.ALL);
~~~

### 4. Set Breakpoint to debug Engine

As below figure, set the Breakpoint Engine's Entry Mehod `org.teiid.dqp.internal.process.DQPCore` around line 245

![Engine's Entry Method]({{ site.baseurl }}/assets/blog/teiid-debug-engine-entry.png)

RequestMessage as parameter be passed from client which wrapped a sql command, ResultsFuture<ResultsMessage> (wrap a ResultsMessage) will be return at the end of this method.

[teiid-mind-map](http://ksoong.org/teiid-mind-map/) 'Statement execute Query' section has a mind map which can help to debug the engine.
