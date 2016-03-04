---
layout: blog
title:  "Netty 4 学习笔记"
date:   2015-12-09 21:25:30
categories: netty
permalink: /netty4-notes
author: Kylin Soong
duoshuoid: ksoong2015120901
---

Netty 是什么？ Netty是一个高性能、异步事件驱动的NIO框架，它提供了对TCP、UDP和文件传输的支持，作为一个异步NIO框架，Netty的所有IO操作都是异步非阻塞的，通过Future-Listener机制，用户可以方便的主动获取或者通过通知机制获得IO操作结果。作为当前最流行的NIO框架，Netty在互联网领域、大数据分布式计算领域、游戏行业、通信行业等获得了广泛的应用，一些业界著名的开源组件也基于Netty的NIO框架构建

* Table of contents
{:toc}

## 典型阻塞通信案例与弊端

[阻塞通信案例](http://ksoong.org/bio-server-mode)

根据[多线程处理阻塞IO服务器模型](http://ksoong.org/bio-server-mode)，典型阻塞通信有两个弊端:

**性能瓶颈** - 服务端的工作线程个数和并发访问数成线性正比，Java 虚拟机为每个线程分配独立的堆栈空间，工作线程越多，系统开销越大，当线程数膨胀到一定程度之后，系统的性能急剧下降，随着并发量的继
续增加，可能会发生句柄溢出、线程堆栈溢出等问题，并导致服务器最终宕机。下图反应了这一趋势

![BioEchoServer 性能瓶颈]({{ site.baseurl }}/assets/blog/bioserver-bottlenet.png)

**计算资源浪费** - 工作线程的许多时间都浪费在阻塞IO操作上，CPU 的利用效率偏低，Java 虚拟机需要频繁地转让 CPU 的使用权。


## 相关链接

[Netty系列之Netty高性能之道](http://www.infoq.com/cn/articles/netty-high-performance)
