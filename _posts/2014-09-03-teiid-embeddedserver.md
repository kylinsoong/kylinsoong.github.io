---
layout: blog
title:  "Teiid Embedded Server"
date:   2014-09-03 16:25:30
categories: teiid
permalink: /teiid-es
author: Kylin Soong
duoshuoid: ksoong2014090301
---

Teiid Embedded Server can be thought of an easy-to-use JDBC Driver with an embed Query Engine which can be used in any Java Application. The following code show a simple life cycle of a Embedded Server:

~~~
EmbeddedServer server = new EmbeddedServer();
server.start(new EmbeddedConfiguration());
server.deployVDB();
~~~

This documents look into the unerlying of these steps:

* EmbeddedServer Initialization
* EmbeddedServer startup
* EmbeddedServer deployVDB

## Initialization

![Teiid EmbededServer init]({{ site.baseurl }}/assets/blog/EmbededServer_init.png)

* EmbeddedProfile implements `org.teiid.jdbc.ConnectionProfile`
* DQPCore implements `org.teiid.client.DQP`
* VDBRepository represents repository for VDBs
* SessionServiceImpl implements `org.teiid.dqp.service.SessionService`
* BufferServiceImpl implements `org.teiid.dqp.service.BufferService`
* TransactionServerImpl implements `org.teiid.dqp.service.TransactionService`
* ClientServiceRegistryImpl implements `org.teiid.transport.ClientServiceRegistry`

## startup

![Teiid EmbededServer start]({{ site.baseurl }}/assets/blog/EmbededServer_start.png)

Combine with previous EmbeddedServer Initialization, total 16 threads created so far:

* TimeTask in **new SessionServiceImpl()** and **getBufferService()** relevant 2 daemon threads up
* Infinispan Cachemanager start 3 local cache `resultset`, `resultset-repl`, `preparedplan` cause 3 transaction clean up threads and 1 eviction thread up
* Netty's **new NioServerSocketChannelFactory()** start up 8 `New I/O worker ` threads and 1 accept thread `New I/O server boss` 

## deployVDB

//coming soon
