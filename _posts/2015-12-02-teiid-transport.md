---
layout: blog
title:  "Understanding Teiid Transport Layer"
date:   2015-12-02 18:10:00
categories: teiid
permalink: /teiid-transport
author: Kylin Soong
duoshuoid: ksoong2015120201
---

[Teiid](http://teiid.jboss.org) supply a jdbc driver which allows java applications to use data from multiple, heterogenous data stores,

![Architecture]({{ site.baseurl }}/assets/blog/teiid-transport-architecure.png)

As above architecture, java application execute JDBC query(for example 'select * from product') via Teiid `JDBC Driver`, the Driver will assemble the query command to a Message Object, then send it to `Transport` via Socket client, the Transport listen on a port via netty server, receive the message, handle the message and pass it to `Query Enginer`, the Query Engine will choose related Resource Adapter and Translator to load and transfer Data from heterogenous data stores.

One the left of vertical broken line, we can see it was Transport Layer, this article focus on it, diving into the details of how message be transfer between JDBC Driver and Transport.

## Netty Server

`org.teiid.transport.SocketListener` is Server-side class to listen for new connection requests and create a `org.teiid.transport.SocketClientInstance` for each connection request, the revelant UML diagram as below:

![SocketListener]({{ site.baseurl }}/assets/blog/teiid-uml-transport-socketlistener.png)

In SocketListener Constructor method the Netty Server be started, the code looks

~~~
this.nettyPool = Executors.newCachedThreadPool(new NamedThreadFactory("NIO"));
if (maxWorkers == 0) {
    maxWorkers = Math.max(4, 2*Runtime.getRuntime().availableProcessors());
}
ChannelFactory factory = new NioServerSocketChannelFactory(this.nettyPool, this.nettyPool, maxWorkers);
bootstrap = new ServerBootstrap(factory);
this.channelHandler = createChannelPipelineFactory(config, storageManager);
bootstrap.setPipelineFactory(channelHandler);
bootstrap.setOption("child.tcpNoDelay", true);
bootstrap.setOption("child.keepAlive", Boolean.TRUE);
this.serverChanel = bootstrap.bind(address);
~~~

In above code snippets, the createChannelPipelineFactory() method will create a SSLAwareChannelHandler, which extends the `org.jboss.netty.channel.SimpleChannelHandler` and implment `org.jboss.netty.channel.ChannelPipelineFactory`, the UML diagram looks

![SSLAwareChannelHandler]({{ site.baseurl }}/assets/blog/teiid-uml-transport-sslwaarehandler.png)

The methods list in above diagram is the entry in Server side, for example, messageReceived() method will handle the JDBC Driver's Message.


 
