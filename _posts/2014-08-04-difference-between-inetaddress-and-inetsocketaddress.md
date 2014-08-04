---
layout: blog
title:  "Difference between InetSocketAddress and InetAddress"
date:   2014-08-04 17:57:12
categories: j2se
author: Kylin Soong
duoshuoid: ksoong20140804
---


InetAddress represents an Internet Protocol (IP) address. InetSocketAddress implements an IP Socket Address (IP address + port number) It can also be a pair (hostname + port number), in which case an attempt will be made to resolve the hostname.

The following private/public method used to get a InetAddress:

~~~
java.net.InetAddress#getByAddress(byte[])
java.net.InetAddress#getByAddress(java.lang.String, byte[])
java.net.InetAddress#getAllByName(java.lang.String)
java.net.InetAddress#getByName(java.lang.String)
java.net.InetAddress#getLocalHost()
~~~

The following constructor methods used to construct a InetSocketAddress:

~~~
public InetSocketAddress(int port)
public InetSocketAddress(InetAddress addr, int port)
public InetSocketAddress(String hostname, int port)
~~~

A Sample code snippets:

~~~
InetAddress inetAddress = InetAddress.getByName("localhost");
InetSocketAddress inetSocketAddress = new InetSocketAddress(inetAddress, 3100);

Socket socket = new Socket();
socket.setTcpNoDelay(true);//enable Nagle's algorithm to conserve bandwidth
socket.connect(inetSocketAddress);
socket.setSoTimeout(3000);
~~~
