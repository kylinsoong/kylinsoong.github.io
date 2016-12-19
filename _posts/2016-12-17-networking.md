---
layout: blog
title:  "LINUX - 网络配置"
date:   2016-12-17 18:41:12
categories: linux
permalink: /linux-networking
author: Kylin Soong
duoshuoid: ksoong2016121701
excerpt: Network Configuration
---

* Table of contents
{:toc}

## Network Configuration

### Validating Network Configuration

* The **/sbin/ip** command is used to show device and address information:

~~~
$ ip addr show em1 
2: em1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 68:f7:28:1b:3d:c2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.107/24 scope global dynamic em1
       valid_lft 6249sec preferred_lft 6249sec
    inet6 fe80::6af7:28ff:fe1b:3dc2/64 scope link 
       valid_lft forever preferred_lft forever
~~~

* Display the current IP address and netmask for all interfaces:

~~~
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: em1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 68:f7:28:1b:3d:c2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.107/24 scope global dynamic em1
       valid_lft 6931sec preferred_lft 6931sec
    inet6 fe80::6af7:28ff:fe1b:3dc2/64 scope link 
       valid_lft forever preferred_lft forever
~~~

* The ip command may also be used to show statistics about newwork performance, The received(RA) and transmitted(TX) packets, errors, and dropped count etc:

~~~
$ ip -s link show em1 
2: em1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 68:f7:28:1b:3d:c2 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    183544     833      0       0       0       89     
    TX: bytes  packets  errors  dropped carrier collsns 
    162430     1195     0       0       0       0  
~~~

* Show routing information:

~~~
$ ip route 
default via 192.168.1.1 dev em1  proto static  metric 1024 
172.16.209.0/24 dev vmnet8  proto kernel  scope link  src 172.16.209.1 
172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.42.1 
192.168.1.0/24 dev em1  proto kernel  scope link  src 192.168.1.107 
192.168.1.0/24 dev wlp3s0  proto kernel  scope link  src 192.168.1.108 
192.168.173.0/24 dev vmnet1  proto kernel  scope link  src 192.168.173.1 
~~~

* The **ping** command is used to test connectivity:

~~~
$ ping -c2 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.597 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.372 ms

--- 192.168.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.372/0.484/0.597/0.114 ms
~~~

* To trace the path to a remote host, use either **traceroute** or **tracepath**

~~~
$ traceroute 192.168.1.1
traceroute to 192.168.1.1 (192.168.1.1), 30 hops max, 60 byte packets
 1  192.168.1.1 (192.168.1.1)  0.448 ms  0.399 ms  0.596 ms
~~~

~~~
$ tracepath 192.168.1.1
 1:  192.168.1.107                                         0.177ms pmtu 1500
 1:  192.168.1.1                                           1.155ms reached
 1:  192.168.1.1                                           1.084ms reached
     Resume: pmtu 1500 hops 1 back 64 
~~~

* Troubleshooting ports and services via **ss** command:

~~~
$ ss -ta
~~~

Note that ss command is meant to replace to the older netstat:

~~~
$ netstat -ta
~~~

Options for ss and netstat:

1. -n - Show numbers instead of names for interfaces and ports.
2. -t - Show TCP sockets
3. -u - Show UDP sockets
4. -l - Show only listening sockets
5. -a - Show all(listening and established) sockets
6. -p - Show the process using the socket

### Configuring Networking with nmcli


