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

### 4. Import javacc QueryParser depends

If you want to debug Teiid Engine Source Code, the first steps is import javacc QueryParser depends, or else your code will have complie error, once build Teiid Source code success, extrct QueryParser depends from teiid-engine-VERSION-SNAPSHOT.jar, package it as a separate jar, add to Teiid Engine class path:

![Engine's javacc code]({{ site.baseurl }}/assets/blog/teiid-debug-engine-javacc.png)

As above figure, teiid-engine-javacc-9.x.jar will be generated, add it to classpath.

### 5. Set Breakpoint to debug Engine

As below figure, set the Breakpoint Engine's Entry Mehod `org.teiid.dqp.internal.process.DQPCore` around line 245

![Engine's Entry Method]({{ site.baseurl }}/assets/blog/teiid-debug-engine-entry.png)

RequestMessage as parameter be passed from client which wrapped a sql command, ResultsFuture<ResultsMessage> (wrap a ResultsMessage) will be return at the end of this method.

[teiid-mind-map](http://ksoong.org/teiid-mind-map/) 'Statement execute Query' section has a mind map which can help to debug the engine.

### 6. Disable Client Ping

By default, the Client ping are enabled for guaranteeing each client session has a relevant active server session(server hung, networking limited, connection reset will cause server session lose). In order to simplify debuging, add System properties to disable Client Ping:

~~~
-Dorg.teiid.sockets.DisablePing=false
~~~
