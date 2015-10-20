---
layout: blog
title:  "Understanding JCA Outbound resource adapter"
date:   2015-10-20 12:00:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong2015102001
---

JCA(Java EE Connector Architecture) eatures three different types of resource adapters: Outbound, Inbound, Bi-directional, the Outbound resource adapter allows the application to communicate to the Enterprise Information System (EIS). A typical example, define datasource(-ds.xml) connect to Database(Oracle, Mysql) in WildFly/JBoss container is base on JCA Outbound resource adapter. This article we will dive into the details of JCA Outbound resource adapter.

## Architecture

As below figure, the Java Connector Architecture specification consists of a number of outbound components:

![JCA outbound]({{ site.baseurl }}/assets/blog/jca-ra-outbound.png)

**Application** - The application uses the

* ConnectionFactory: Used to create a connection. In WildFly/JBoss, the connection factory is looked up by JNDI. the main methods defined in `javax.resource.cci.ConnectionFactory` including:

~~~
public Connection getConnection() throws ResourceException;
public Connection getConnection(ConnectionSpec properties throws ResourceException;
~~~

* Connection: The connection contains the Enterprise Information System (EIS) specific operations, and use to operate/interact with EIS.

**Application Server** - Like many other JEE specifications, Connection Manager and Connection Event Listener in JCA are for vendor, in WildFly/JBoss, IronJacamar(http://www.ironjacamar.org/) used to implement these api definition, it play a role as Application Server.

* ConnectionManager: The connection manager handles all managed connections in regards to pooling, transaction and security. The key method of `javax.resource.spi.ConnectionManager` is

~~~
public Object allocateConnection(ManagedConnectionFactory mcf, ConnectionRequestInfo cxRequestInfo) throws ResourceException;
~~~ 

this method gets called by the resource adapter's connection factory instance. This lets connection factory instance (provided by the resource adapter) pass a connection request to the ConnectionManager instance.

* ConnectionEventListener: The connection event listener allows the connection manager to know the status of each managed connection. The `javax.resource.spi.ConnectionEventListener` extends java.util.EventListener and provide the following methods:

~~~
public void connectionClosed(ConnectionEvent event);
public void localTransactionStarted(ConnectionEvent event);
public void localTransactionCommitted(ConnectionEvent event);
public void localTransactionRolledback(ConnectionEvent event);
public void connectionErrorOccurred(ConnectionEvent event);
~~~

**Resource Adapter** - Usually, this component are plugable, it can add to JEE container like WildFly/JBoss as a plugin. To develop a Resource Adapter, 4 interfaces need to implement, `javax.resource.cci.ConnectionFactory` and `javax.resource.cci.Connection` which we already refered in above. `javax.resource.spi.ManagedConnectionFactory` and `javax.resource.spi.ManagedConnection` which we will introduce below.

* ManagedConnectionFactory: Use to create both `javax.resource.cci.ConnectionFactory` and `javax.resource.spi.ManagedConnection`, the main methods it defined including:

~~~
public Object createConnectionFactory(ConnectionManager cxManager) throws ResourceException;
public Object createConnectionFactory() throws ResourceException;
public ManagedConnection createManagedConnection(Subject subject, ConnectionRequestInfo cxRequestInfo) throws ResourceException;
public ManagedConnection matchManagedConnections(Set connectionSet, Subject subject, ConnectionRequestInfo  cxRequestInfo) throws ResourceException;
~~~ 

* ManagedConnection: The managed connection represents a physical connection to the target Enterprise Information System (EIS). The managed connection notifies the application server of events such as connection closed and connection error.

