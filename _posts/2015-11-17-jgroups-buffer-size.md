---
layout: blog
title:  "WildFly Command Line"
date:   2015-11-17 17:10:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015111701
excerpt: JGroups send and receive buffers warning when run WildFly
---

Run WildFly in Linux throw the following WARN message:

~~~
WARN  [org.jgroups.protocols.UDP] (MSC service thread 1-7) JGRP000015: the send buffer of socket ManagedDatagramSocketBinding was set to 1MB, but the OS only allocated 212.99KB. This might lead to performance problems. Please set your max send buffer in the OS correctly (e.g. net.core.wmem_max on Linux)
WARN  [org.jgroups.protocols.UDP] (MSC service thread 1-7) JGRP000015: the receive buffer of socket ManagedDatagramSocketBinding was set to 20MB, but the OS only allocated 212.99KB. This might lead to performance problems. Please set your max receive buffer in the OS correctly (e.g. net.core.rmem_max on Linux)
WARN  [org.jgroups.protocols.UDP] (MSC service thread 1-7) JGRP000015: the send buffer of socket ManagedMulticastSocketBinding was set to 1MB, but the OS only allocated 212.99KB. This might lead to performance problems. Please set your max send buffer in the OS correctly (e.g. net.core.wmem_max on Linux)
WARN  [org.jgroups.protocols.UDP] (MSC service thread 1-7) JGRP000015: the receive buffer of socket ManagedMulticastSocketBinding was set to 25MB, but the OS only allocated 212.99KB. This might lead to performance problems. Please set your max receive buffer in the OS correctly (e.g. net.core.rmem_max on Linux)
~~~

These WARN throw by JGroups UDP protocol, these article deive into the underlying that why the WARN message throw.

## How to reproduce

Get the jGroups jar, run `Draw` demo:

~~~
$ java -cp jgroups-3.6.6.Final.jar org.jgroups.demos.Draw
~~~
