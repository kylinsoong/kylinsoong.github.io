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

**NetworkManager** is a daemon that monitors and manages network settings. The network configuration files in the `/etc/sysconfig/network-scripts` directory.


#### Viewing network information with nmcli

~~~
# nmcli connection show 
NAME     UUID                                  TYPE            DEVICE  
enp0s25  131d803f-e480-4512-8f4a-299d275e4a37  802-3-ethernet  enp0s25 
virbr0   4a9927cf-fd88-42eb-b60f-2863e2baecd1  bridge          virbr0
~~~

~~~
# nmcli connection show --active 
NAME     UUID                                  TYPE            DEVICE  
enp0s25  131d803f-e480-4512-8f4a-299d275e4a37  802-3-ethernet  enp0s25 
virbr0   4a9927cf-fd88-42eb-b60f-2863e2baecd1  bridge          virbr0 
~~~

~~~
# nmcli connection show enp0s25 
connection.id:                          enp0s25
connection.uuid:                        131d803f-e480-4512-8f4a-299d275e4a37
connection.stable-id:                   --
connection.interface-name:              enp0s25
connection.type:                        802-3-ethernet
connection.autoconnect:                 yes
...
~~~

A **device** is a network interface. A connection is a configuration used for a device which is made up of a collection of settings. Multiple connections may exist for a device, but only one may be active at a time.

~~~
# nmcli device status 
DEVICE      TYPE      STATE        CONNECTION 
virbr0      bridge    connected    virbr0     
enp0s25     ethernet  connected    enp0s25    
wlp3s0      wifi      unavailable  --         
lo          loopback  unmanaged    --      
~~~

~~~
# nmcli device show enp0s25 
GENERAL.DEVICE:                         enp0s25
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         00:21:CC:71:3B:09
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
...
~~~

#### Creating network connections with nmcli

* Define a new connection named "default" which will autoconnect as an Ethernet connecton on eth0 device using DHCP:

~~~
# nmcli connection add con-name "default" type ethernet ifname eth0
~~~

* Change back to the DHCP connection.

~~~
# nmcli connection up default
~~~

* Delete a connection

~~~
# nmcli connection delete default
~~~

* Create a static connection with the same IPv4 address, network prefix, and default gateway. Name the new connection static-eth0.

~~~
# nmcli connection add con-name "static-eth0" ifname enp0s25 type ethernet ipv4.addresses 10.66.192.121/24 ipv4.gateway 10.66.193.254
~~~

* Modify the new connection to add the DNS setting.

~~~
# nmcli connection modify "static-eth0" ipv4.dns 10.72.17.5
~~~

* Display and activate the new connection.

~~~
# nmcli connection show
# nmcli connection show --active
# nmcli connection up "static-eth0"
# nmcli connection show --active
# ip addr show enp0s25
# ip route 
# ping 10.72.17.5
# nmcli connection modify "static-eth0" connection.autoconnect no
# reboot
# nmcli connection show --active
~~~

### Editing Network Configuration Files

Interface configuration files control the software interfaces for individual network devices. These files are usually named /etc/sysconfig/network-scripts/ifcfg-<name>, where <name> refers to the name of the device or connection that the configuration file controls.

Example of static-eth0:

~~~
# cat /etc/sysconfig/network-scripts/ifcfg-static-eth0 
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=static-eth0
UUID=57e917f1-9f9a-4c35-8fba-366876eb608e
DEVICE=enp0s25
ONBOOT=no
DNS1=10.72.17.5
IPADDR=10.66.192.121
PREFIX=24
GATEWAY=10.66.193.254
PEERDNS=yes
PEERROUTES=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
~~~

After modify this configuration file, run nmcli reload and restart the interface, make sure the changes to take effect:

~~~
# nmcli connection reload
# nmcli connection down "System eth0"
# nmcli connection up "System eth0"
~~~

### Configuring Host Names and Name Resolution

#### Changing the system host name

~~~
# hostname
ksoong.org
~~~

A static host name may be specified in the **/etc/hostname** file. The `hostnamectl` command is used to modify this file and may be used to view the status of the system's fully qualified host name.

~~~
# cat /etc/hostname 
ksoong.org
~~~

~~~
# hostnamectl set-hostname ksoong.com
# hostnamectl status
~~~

#### Configuring name resolution

The stub resolver is used to convert host names to IP addresses or the reverse. The contents of the file **/etc/hosts** are checked first.

~~~
# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
~~~

~~~
# getent hosts ksoong.com
# host ksoong.com
~~~
