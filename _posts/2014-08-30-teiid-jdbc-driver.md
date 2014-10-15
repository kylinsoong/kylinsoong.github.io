---
layout: blog
title:  "Teiid JDBC Client"
date:   2014-08-30 22:10:00
categories: teiid
permalink: /teiid-jdbc-client
author: Kylin Soong
duoshuoid: ksoong20140830
---

The Teiid JDBC API provides Java Database Connectivity (JDBC) access to any Virtual Database (VDB) deployed on a Teiid Server. This document discuss the Teiid JDBC Client, including Sample code, architecute, etc.

## Connecting to a Teiid Server

With the following 2 steps we can connect to a Teiid Server:

* **Step I.** Add Teidd jdbc client jar

Add the `teiid-client` dependency can import Teiid JDBC Client:

~~~
		<dependency>
			<groupId>org.jboss.teiid</groupId>
			<artifactId>teiid-client</artifactId>
			<version>8.9.0.Alpha2-SNAPSHOT</version>
		</dependency>
~~~

* **Step II.** Use JDBC API connect to Teiid

Use **org.teiid.jdbc.TeiidDriver** as the driver class. Use the following URL format for JDBC connections:

~~~
jdbc:teiid:<vdb-name>@mm[s]://<host>:<port>;[prop-name=prop-value;]*
~~~

The following is a example for connecting to `Marketdata` VDB, and execute SELECT:

~~~
Class.forName("org.teiid.jdbc.TeiidDriver");
Connection conn = DriverManager.getConnection("jdbc:teiid:Marketdata@mm://localhost:31000;version=1", "user", "user");
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM Marketdata");
~~~

The following sections of this document will dive into the underlying of above sample code which connect to VDB `Marketdata` and execute query *SELECT * FROM Marketdata*, the main items including:

* How TeiidDriver create a Connection
* How a connection execute the query
* How Teiid Server handle query request
* How Teiid ResultSetImpl handle result


## How TeiidDriver create a Connection

The following mind map come from debuging the below line source code:

~~~
`DriverManager.getConnection("jdbc:teiid:Marketdata@mm://localhost:31000;version=1", "user", "user")`
~~~

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

## How a connection execute the query

The following sequence diagram shows how query sql `SELECT * FROM Marketdata` be send to Teiid Server

![teiid-execute-query]({{ site.baseurl }}/assets/blog/teiid-execute-query.png)

Start from left to right:

* StatementImpl **executeQuery** receive the query sql `SELECT * FROM Marketdata`
* StatementImpl assemble a `org.teiid.client.RequestMessage` base query sql, then invoke DQP Proxy's **executeRequest**
* RemoteInvocationHandler's **invoke** method be invoked
* RemoteInvocationHandler assemble a `org.teiid.net.socket.Message` base on passed `org.teiid.client.RequestMessage`, then SocketServerInstanceImpl's **send** method be invoked
* OioObjectChannel's **write** methd be invoked
* ObjectOutputStream which come from socket **writeObject** `org.teiid.net.socket.Message`


## How Teiid Server handle query request

![teiid-server-hanlde-request]({{ site.baseurl }}/assets/blog/teiid-server-hanlde-request.png)

* SSLAwareChannelHandler

While Teiid Server Started, it will create a SocketListener which listen for new connection requests and create a SocketClientConnection for each connection request.

The SocketListener bootstrap netty server worker threads with port number 31000, SSLAwareChannelHandler is the handler used by netty server side, it's `messageReceived()` can be thought as teiid server side entry point. Once a client request in, this method be first invoked. 

* SocketClientInstance

Sockets implementation of the communication framework class representing the server's view of a client connection. Implements the server-side of the sockets messaging protocol. The client side of the protocol is implemented in SocketServerInstance.

It's `processMessagePacket()` method be invoked for handling income request message.

* DQPWorkContext & ServerWorkItem

ServerWorkItem is a runnable class, it encapulates income request message in it's constructor:

~~~
    public ServerWorkItem(ClientInstance socketClientInstance, Serializable messageKey, Message message, ClientServiceRegistryImpl server) {
		this.socketClientInstance = socketClientInstance;
		this.messageKey = messageKey;
		this.message = message;
		this.csr = server;
	}
~~~

DQPWorkContext is a filed of SocketClientInstance, DQPWorkContext's `runInContext()` method be invoked, the constructed ServerWorkItem passed as a argument. Then ServerWorkItem's `run()` method be invoked. 


