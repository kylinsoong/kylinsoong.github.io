---
layout: blog
title:  "Netty 4 学习笔记"
date:   2015-12-09 21:25:30
categories: netty
permalink: /netty4-notes
author: Kylin Soong
duoshuoid: ksoong2015120901
---

Netty 是什么？ Netty是一个高性能、异步事件驱动的NIO框架，它提供了对TCP、UDP和文件传输的支持，作为一个异步NIO框架，Netty的所有IO操作都是异步非阻塞的，通过Future-Listener机制，用户可以方便的主动获取或者通过通知机制获得IO操作结果。作为当前最流行的NIO框架，Netty在互联网领域、大数据分布式计算领域、游戏行业、通信行业等获得了广泛的应用，一些业界著名的开源组件也基于Netty的NIO框架构建。 
## 典型阻塞通信案例与弊端

Tomcat 默认使用阻塞通信(BIO)通信模式的服务端，如下图

![Tomcat BIO]({{ site.baseurl }}/assets/blog/tomcat-bio.png)

通常由一个独立的Acceptor线程负责监听客户端的连接，接收到客户端连接之后为客户端连接创建一个新的线程处理请求消息，处理完成之后，返回应答消息给客户端，线程销毁，这就是典型的一请求一应答模型。该架构最大的问题就是不具备弹性伸缩能力，当并发访问量增加后，服务端的线程个数和并发访问数成线性正比，由于线程是JAVA虚拟机非常宝贵的系统资源，当线程数膨胀之后，系统的性能急剧下降，随着并发量的继续增加，可能会发生句柄溢出、线程堆栈溢出等问题，并导致服务器最终宕机。

## 相关链接

[Netty系列之Netty高性能之道](http://www.infoq.com/cn/articles/netty-high-performance)
