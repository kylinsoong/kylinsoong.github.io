---
layout: blog
title:  "Understanding Teiid Transport"
date:   2015-12-02 18:10:00
categories: teiid
permalink: /teiid-transport
author: Kylin Soong
duoshuoid: ksoong2015120201
excerpt: Teiid Transport, Netty Server, Socket Client in JDBC Driver, Transport Security
---

* Table of contents
{:toc}

## Overview

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

The methods list in above diagram is the entry in Server side, for example, messageReceived() method will handle the JDBC Driver's Message, the detailed procedures looks

![SSLAwareChannelHandler Entry]({{ site.baseurl }}/assets/blog/teiid-seq-SSLAwareChannelHandler.png)

Once theid server start up, netty server will listen on socket address, which wait for handling any incoming socket request:

~~~
$ netstat -antulop | grep 15298
tcp6       0      0 127.0.0.1:31000         :::*                    LISTEN      15298/java           off (0.00/0/0)
~~~

> NOTE: By default, netty server will listen on port 31000 for JDBC connection.

## Socket Client in JDBC Driver

With the content of `Netty Server` section, we know that the `SocketListener` is the Server-side listener, SocketListener Constructor method init netty Server, `SSLAwareChannelHandler` registered as Netty Server's ChannelPipelineFactory, each time a client connection incoming, a revelant `SocketClientInstance` be created, the `SocketClientInstance` wrapped a netty Channel in charge of sending/receiving message from client.

Correspondingly, each client request has a related `SocketServerInstanceImpl` which wrapped a Socket, connect with Teiid Server, sending and receiving message, the UML diagram of `SocketServerInstanceImpl` looks

![uml OF SocketServerInstanceImpl]({{ site.baseurl }}/assets/blog/teiid-uml-SocketServerInstanceImpl.png)

SocketServerInstanceImpl has a ObjectChannel attribute that wrap a Socket, used to send/recieve message, the revelant code extract from `org.teiid.net.socket.OioObjectChannel`:

~~~
package org.teiid.net.socket;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

import org.teiid.netty.handler.codec.serialization.ObjectDecoderInputStream;
import org.teiid.netty.handler.codec.serialization.ObjectEncoderOutputStream;

class OioObjectChannel implements ObjectChannel {
    private final Socket socket;
    private ObjectOutputStream outputStream;
    private ObjectInputStream inputStream;

    private OioObjectChannel(Socket socket, int maxObjectSize) throws IOException{
        this.socket = socket;
        DataOutputStream out = new DataOutputStream(socket.getOutputStream());
        outputStream = new ObjectEncoderOutputStream(out, STREAM_BUFFER_SIZE);
        final ClassLoader cl = this.getClass().getClassLoader();
        inputStream = new ObjectDecoderInputStream(new AccessibleBufferedInputStream(socket.getInputStream(), STREAM_BUFFER_SIZE), cl, maxObjectSize);
    }
}
~~~ 

> Note that, netty's ObjectDecoderInputStream used to read Object message from Server(Netty Server), and ObjectEncoderOutputStream used to write Object message to Server(Netty Server).

For detailed procedure of JDBC Driver create a Connection refer to

[http://ksoong.org/teiid-s-diagram/](http://ksoong.org/teiid-s-diagram/) -> 'Teiid Client' -> How a connection be created 

While Create Connection there are 2 types of security logon:

* handshake
* logon

these 2 types security logon happens as a sequence, first do handshake to set Cryptor, then execute logon, both handshake and logon on top of SocketServerInstance. The process as below figure:

![Teiid Client logon]({{ site.baseurl }}/assets/blog/teiid-client-logon.png)

* Once Client create a socket connect to Teiid Server, Teiid Server will send a `Hansshake` message to Client
* Client received the `Handshake`, do some setting send it back to Server
* Teiid Server send handshake ack to Client
* Client send `Logon` message(contain JDBC url, username, password) to Teiid Server
* Teiid Server handle `Logon` message, send logon ack to Client

## Transport Security

### USERPASSWORD based authentication

The simplest way of authentication, 'username/password' be passed to Server side, Server do JAAS based authentication, if user is valid, authentication success, Server send a LogonResult to Client, the sequence diagram like:

![Teiid Client logon usernamepassword]({{ site.baseurl }}/assets/blog/teiid-client-logon-usernamepassword.png)


