---
layout: blog
title:  "MongoDB Quick Start"
date:   2014-09-08 16:20:00
categories: data
permalink: /mongodb-quickstart
author: Kylin Soong
duoshuoid: ksoong2014090802
---

## Install MongoDB to Linux

* use `root`

~~~
su - root
~~~

* Create a /etc/yum.repos.d/mongodb.repo, add the below content:

~~~
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
gpgcheck=0
enabled=1
~~~

* Install

~~~
yum install mongodb-org
~~~

* Start

~~~
service mongod start
chkconfig mongod on
~~~

## Basic admin commands

* Connect to a mongod

~~~
mongo
~~~

* Select a database

~~~
db
~~~

* Display help

~~~
help
~~~

## A quick start sampples

The [MongoDB Quick Start](https://github.com/kylinsoong/data/blob/master/mongodb-quickstart/src/main/java/com/mongodb/quickstart/HelloWorld.java) source code use java driver to demonstrate establish connection, insert data, query data, etc.
