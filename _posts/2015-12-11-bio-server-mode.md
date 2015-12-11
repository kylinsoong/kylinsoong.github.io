---
layout: blog
title:  "多线程处理阻塞IO服务器模型"
date:   2015-12-11 16:30:00
categories: java
permalink: /bio-server-mode
author: Kylin Soong
duoshuoid: ksoong2015121101
---

多线程处理阻塞IO服务器模型最常见的就是 Tomcat，Tomcat 默认使用阻塞通信(BIO)通信模式的服务器，如下图

![Tomcat BIO]({{ site.baseurl }}/assets/blog/tomcat-bio.png)

通常由一个独立的Acceptor线程负责监听客户端的连接，接收到客户端连接之后为客户端连接创建一个新的线程处理请求消息，处理完成之后，返回应答消息给客户端，线程销毁，这就是典型的一请求一应答模型。本文通过 BioEchoServer 示例说明这种模式。

## BioEchoServer

BioEchoServer 的处理流程如下图

![BioEchoServer 处理流程]({{ site.baseurl }}/assets/blog/bio-server-mode-example.png)

主线程负责接收客户的连接。在线程池中有若干工作线程，它负责具体处理客户的连接。每当主线程接收到一个客户的连接，就会把与这个客户交互的任务委派给一个空闲的工作线程，主线程继续负责下一个客户的连接。上图中红色方框标识的步骤为可能引起阻塞的步骤。从图中可以看出，当主线程接收客户连接，以及工作线程执行IO操作时，都有可能进入阻塞状态。

BioEchoServer 主线程实现

![BioEchoServer main]({{ site.baseurl }}/assets/blog/bioserver-main.png)

BioEchoServer 工作线程的接口

![BioEchoServer work interface]({{ site.baseurl }}/assets/blog/bioserver-woker-interface.png)

BioEchoServer 工作线程实现

![BioEchoServer work]({{ site.baseurl }}/assets/blog/bioserver-woker-impl.png)

[BioEchoServer 代码](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/server/src/main/java/org/teiid/test/server/netty/nio/BioEchoServer.java)

## 多线程处理阻塞IO服务器模型的局限

多线程处理阻塞IO服务器模型有两个局限:

**性能瓶颈** - 服务端的工作线程个数和并发访问数成线性正比，Java 虚拟机为每个线程分配独立的堆栈空间，工作线程越多，系统开销越大，当线程数膨胀到一定程度之后，系统的性能急剧下降，随着并发量的继续增加，可能会发生句柄溢出、线程堆栈溢出等问题，并导致服务器最终宕机。下图反应了这一趋势

![BioEchoServer 性能瓶颈]({{ site.baseurl }}/assets/blog/bioserver-bottlenet.png)

**计算资源浪费** - 工作线程的许多时间都浪费在阻塞IO操作上，CPU 的利用效率偏低，Java 虚拟机需要频繁地转让 CPU 的使用权。
