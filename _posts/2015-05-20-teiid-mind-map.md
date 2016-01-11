---
layout: blog
title:  "Teiid Code Analysis - Mind Map"
date:   2015-05-20 21:10:00
categories: teiid
permalink: /teiid-mind-map
author: Kylin Soong
duoshuoid: ksoong2015052001
excerpt: Teiid Mind Map Gallery Contains a series Mind Map diagrams
---

* Table of contents
{:toc}

## TeiidDriver create a Connection

Teiid provide a JDBC Driver used by client to connect to Teiid Virtual Database (VDB) it use the below formated URL to create connection,

~~~
DriverManager.getConnection("jdbc:teiid:Marketdata@mm://localhost:31000;version=1", "user", "user")
~~~

The Mind map for creating a Connection:

![teiid-teiiddriver-getconn]({{ site.baseurl }}/assets/blog/teiid-getconn.png)

Base on above figure, we the seperate DriverManager getConnection into three steps:

* create SocketServerConnectionFactory, init OioObjectChannelFactory
* create ServerConnection, init a SocketServerInstanceImpl which carry a OioObjectChannel, the OioObjectChannel contain a socket which connect to the Teiid Server
* create ConnectionImpl base on ServerConnection

We can use the following code to simulate the whole connection creatation process:

~~~
/*
 * 1. create SocketServerConnectionFactory, init OioObjectChannelFactory
 */
SocketServerConnectionFactory factory = SocketServerConnectionFactory.getInstance();
		
/*
 * 2. create ServerConnection
 */
Properties prop = new Properties();
prop.setProperty("ApplicationName", "JDBC");
prop.setProperty("version", "1");
prop.setProperty("serverURL", "mm://localhost:31000");
prop.setProperty("user", "user");
prop.setProperty("password", "user");
prop.setProperty("VirtualDatabaseVersion", "1");
prop.setProperty("VirtualDatabaseName", "Marketdata");
		
ServerConnection serverConn = factory.getConnection(prop);
		
/*
 * 3. create ConnectionImpl
 */
String url = "jdbc:teiid:Marketdata@mm://localhost:31000;version=1";
prop.put("clientIpAddress", "127.0.0.1");
prop.put("clientHostName", "localhost");
		
ConnectionImpl conn = new ConnectionImpl(serverConn, prop, url);
~~~

## TeiidDriver create a Connection in embedded

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver, in Embedded mode the URL used create a connection like

~~~
Connection conn = driver.connect("jdbc:teiid:Marketdata", null);
~~~

The Mind Map for creating a connection in embedded:

![teiid embedded get connection]({{ site.baseurl }}/assets/blog/DriverGetConnection.png)


## Statement execute Query

Once the Connection be created, we can use the Connection execute JDBC query like

~~~
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM Customer");
~~~

The Mind Map of Statement execute Query:

![teiid embedded statement get resultset]({{ site.baseurl }}/assets/blog/StatementExecuteQuery.png)

## Teiid Embedded Server Initialization

Teiid Embedded Server can be thought of an easy-to-use JDBC Driver with an embed Query Engine which can be used in any Java Application. Embedded Server Initialization like

~~~
EmbeddedServer server = new EmbeddedServer();
~~~

The Mind Map for Embedded Server Initialization:

![Teiid EmbededServer init]({{ site.baseurl }}/assets/blog/EmbededServer_init.png)

* EmbeddedProfile implements `org.teiid.jdbc.ConnectionProfile`
* DQPCore implements `org.teiid.client.DQP`
* VDBRepository represents repository for VDBs
* SessionServiceImpl implements `org.teiid.dqp.service.SessionService`
* BufferServiceImpl implements `org.teiid.dqp.service.BufferService`
* TransactionServerImpl implements `org.teiid.dqp.service.TransactionService`
* ClientServiceRegistryImpl implements `org.teiid.transport.ClientServiceRegistry`

## Teiid Embedded Server startup

Teiid Embedded Server startup with an EmbeddedConfiguration like

~~~
server.start(new EmbeddedConfiguration());
~~~

The Mind Map for Embedded Server start

![Teiid EmbededServer start]({{ site.baseurl }}/assets/blog/EmbededServer_start.png)

Combine with previous EmbeddedServer Initialization, total 16 threads created so far:

* TimeTask in **new SessionServiceImpl()** and **getBufferService()** relevant 2 daemon threads up
* Infinispan Cachemanager start 3 local cache `resultset`, `resultset-repl`, `preparedplan` cause 3 transaction clean up threads and 1 eviction thread up
* Netty's **new NioServerSocketChannelFactory()** start up 8 `New I/O worker ` threads and 1 accept thread `New I/O server boss`

## Teiid Embedded Server deployVDB

Teiid Embedded Server deploy vdb:

~~~
server.deployVDB("vdb.xml");
~~~

The Mind Map for Embedded Server deploy VDB

![Teiid EmbededServer deployVDB]({{ site.baseurl }}/assets/blog/teiid-deployvdb.png)

