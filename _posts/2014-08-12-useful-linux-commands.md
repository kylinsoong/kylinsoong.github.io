---
layout: blog
title:  "Useful Linux Commands"
date:   2014-08-12 16:14:12
categories: linux
author: Kylin Soong
duoshuoid: ksoong2014081201
---

This Document Contain a series useful linux commands which used by me every day.

### How to create alternatives java?

~~~
which java
ls -l /usr/bin/java
ls -l /etc/alternatives/java
rm /etc/alternatives/java
ln -s /usr/java/jdk1.7.0_10/bin/java /etc/alternatives/java
~~~

### Check the Number of connections in one port

~~~
netstat -anp | grep :3306 | grep ESTABLISHED | wc -l
netstat -anp | grep :3306 | grep ESTABLISHED 
netstat -anp | grep :3306 
~~~
