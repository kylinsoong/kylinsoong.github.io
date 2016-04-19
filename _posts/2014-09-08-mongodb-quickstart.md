---
layout: blog
title:  "MongoDB 学习比较"
date:   2014-09-08 16:20:00
categories: data
permalink: /mongodb-quickstart
author: Kylin Soong
duoshuoid: ksoong2014090802
---

* Table of contents
{:toc}

本文内容多摘自 [MongoDB Manual](https://docs.mongodb.org/manual/).

## MongoDB 简介

MongoDB is an open-source document database that provides 

1. high performance
2. high availability
3. automatic scaling.

数据库中保存的是类 JSON 的文件，如下

![Document DataBase]({{ site.baseurl }}/assets/blog/mongodb/mongodb-crud-annotated-document.png)

存储类 JSON 的文件格式的好处是:

* Documents (i.e. objects) correspond to native data types in many programming languages.
* Embedded documents and arrays reduce need for expensive joins.
* Dynamic schema supports fluent polymorphism.

### BSON

BSON is a binary representation of JSON documents.

[BSON spec](http://bsonspec.org/)

[BSON Types](https://docs.mongodb.org/manual/reference/bson-types/)

## Install MongoDB to Linux

### Install MongoDB 3.2 to RHEL 6

* Create a /etc/yum.repos.d/mongodb-org-3.2.repo file with the following content:

~~~
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
~~~

* Install

~~~
# yum install -y mongodb-org
~~~

* Run

For convenient run the MongoDB, Disable SELinux entirely by changing the **SELINUX** setting to **disabled** in /etc/selinux/config.

~~~
SELINUX=disable
~~~

Flush the iptables via

~~~
# iptables -F
~~~

Start MongoDB via

~~~
service mongod start
~~~

### Install MongoDB 2.6.4 to RHEL 6

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

### Create a Collection and Insert Documents Sample

In this secion we will show how to create Collection `smalla`, insert documents to it, and query documents:

~~~
> use mydb

> db.smalla.insert({"INTNUM" : 1, "INTKEY" : 1, "STRINGKEY" : "1", "STRINGNUM" : "1"})
> db.smalla.insert({"INTNUM" : 2, "INTKEY" : 2, "STRINGKEY" : "2", "STRINGNUM" : "2"})
> db.smalla.insert({"INTNUM" : 3, "INTKEY" : 3, "STRINGKEY" : "3", "STRINGNUM" : "3"})

> db.smalla.find()
~~~ 

> NOTE: when insert the first document, `smalla` be created automatically.

Use the following java code can query these 3 documents:

~~~
MongoClient mongo = new MongoClient("10.66.218.46", 27017);
DB db = mongo.getDB("mydb");
DBCollection conn = db.getCollection("smalla");
DBCursor cursor = conn.find();
try {
	while (cursor.hasNext()) {
		System.out.println(cursor.next());
	}
} finally {
	cursor.close();
}
mongo.close();
~~~

The output should be same as `db.smalla.find()`, it looks like:

~~~
{ "_id" : { "$oid" : "5476e44396e211a9df8900da"} , "INTNUM" : 1.0 , "INTKEY" : 1.0 , "STRINGKEY" : "1" , "STRINGNUM" : "1"}
{ "_id" : { "$oid" : "5476e45a96e211a9df8900db"} , "INTNUM" : 2.0 , "INTKEY" : 2.0 , "STRINGKEY" : "2" , "STRINGNUM" : "2"}
{ "_id" : { "$oid" : "5476e46996e211a9df8900dc"} , "INTNUM" : 3.0 , "INTKEY" : 3.0 , "STRINGKEY" : "3" , "STRINGNUM" : "3"}
~~~

## A quick start sampples

The [MongoDB Quick Start](https://github.com/kylinsoong/data/tree/master/mongodb-quickstart) source code use java driver to demonstrate establish connection, insert data, query data, etc.
