---
layout: blog
title:  "Java Net API"
date:   2014-08-04 17:57:12
categories: java
author: Kylin Soong
duoshuoid: ksoong20140804
---

## InetSocketAddress and InetAddress

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

## NetworkInterface

`java.net.NetworkInterface` represents a Network Interface made up of a name, and a list of IP addresses assigned to this interface. It is used to identify the local interface on which a multicast group is joined.

The bolow code snippets show how use NetworkInterface get all available addresses in a machine:

~~~
Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
while(en.hasMoreElements()){
    NetworkInterface intf = en.nextElement();
    System.out.println(intf.getName());
    Enumeration<InetAddress> addrs=intf.getInetAddresses();
    while(addrs.hasMoreElements())
        System.out.println("    " + addrs.nextElement());
}
~~~

A sample output as below:

~~~
tun0
    /10.72.7.161
docker0
    /172.17.42.1
vmnet8
    /fe80:0:0:0:250:56ff:fec0:8%vmnet8
    /172.16.209.1
vmnet1
    /fe80:0:0:0:250:56ff:fec0:1%vmnet1
    /192.168.173.1
em1
    /fe80:0:0:0:6af7:28ff:fe1b:3dc2%em1
    /192.168.1.105
lo
    /0:0:0:0:0:0:0:1%lo
    /127.0.0.1
~~~

## DatagramSocket and MulticastSocket

`java.net.DatagramSocket` represents a socket for sending and receiving datagram packets.

A simple example of using DatagramSocket send and receive Message:

~~~
InetAddress receiverAddress = InetAddress.getLocalHost();
DatagramSocket socket = new DatagramSocket(new InetSocketAddress(InetAddress.getLocalHost(), 54321));
System.out.println("Maximum Send Buffer Size " + socket.getSendBufferSize() + ", Maximum Receive Buffer Size " + socket.getReceiveBufferSize());
		
byte[] senbuf = "0123456789".getBytes();
DatagramPacket packet = new DatagramPacket(senbuf, senbuf.length, receiverAddress, 54321);
socket.send(packet);
		
byte[] recbuf = new byte[10];
DatagramPacket recpacket = new DatagramPacket(recbuf, recbuf.length);
socket.receive(recpacket);
System.out.println(new String(recbuf));
		
socket.close();
~~~

`java.net.MulticastSocket` extends of `java.net.DatagramSocket`, with additional capabilities for joining "groups" of other multicast hosts on the internet.

A simple example of using MulticastSocket send and receive Message:

~~~
String msg = "Hello";
InetAddress group = InetAddress.getByName("228.5.6.7");
MulticastSocket s = new MulticastSocket(56789);
System.out.println("Maximum Send Buffer Size " + s.getSendBufferSize() + ", Maximum Receive Buffer Size " + s.getReceiveBufferSize());
s.joinGroup(group);
		
DatagramPacket hi = new DatagramPacket(msg.getBytes(), msg.length(), group, 56789);
s.send(hi);
		
byte[] buf = new byte[10];
DatagramPacket recv = new DatagramPacket(buf, buf.length);
s.receive(recv);
System.out.println(new String(buf));
		
s.leaveGroup(group);
s.close();
~~~
