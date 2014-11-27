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
