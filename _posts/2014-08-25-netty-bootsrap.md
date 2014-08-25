---
layout: blog
title:  "2 ways of bootstrap netty"
date:   2014-08-25 11:10:12
categories: netty
permalink: /2-ways-bootstrap-netty
author: Kylin Soong
duoshuoid: ksoong20140825
---

This documents list 2 code snippets for bootstrap netty: ServerBootstrap and ClientBootstrap.

* ServerBootstrap

~~~	
ChannelFactory factory = new NioServerSocketChannelFactory(Executors.newCachedThreadPool(), Executors.newCachedThreadPool(), 4);
ServerBootstrap bootstrap = new ServerBootstrap(factory);
bootstrap.setPipelineFactory(new ChannelPipelineFactory() {});
bootstrap.setOption("child.tcpNoDelay", true);
bootstrap.setOption("child.keepAlive", true);
bootstrap.setOption("reuseAddress", true);
bootstrap.bind(new InetSocketAddress("localhost", 8080));
~~~

* ClientBootstrap

~~~
ChannelFactory factory = new NioClientSocketChannelFactory(Executors.newCachedThreadPool(),Executors.newCachedThreadPool(), 4);
ClientBootstrap bootstrap = new ClientBootstrap(factory);
bootstrap.setPipelineFactory(new ChannelPipelineFactory() {});
bootstrap.setOption("tcpNoDelay", true);
bootstrap.setOption("keepAlive", true);
bootstrap.connect(new InetSocketAddress("localhost", 8080));
~~~



