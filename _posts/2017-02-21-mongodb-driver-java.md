---
layout: blog
title:  "MongoDB Java Driver Example"
date:   2017-02-21 20:00:00
categories: data
permalink: /mongodb-java
author: Kylin Soong
duoshuoid: ksoong2017021701
excerpt: MongoDB Java Driver Example
---

* Table of contents
{:toc}

## A quick tour of MongoDB Driver

### Setup Maven

~~~
<dependency>
    <groupId>org.mongodb</groupId>
    <artifactId>mongo-java-driver</artifactId>
    <version>2.13.1</version>
</dependency>
~~~ 

### Connect to mydb on the local machine

~~~
String remoteServerList = "mongodb://127.0.0.1:27017";
String database = "mydb";
MongoClientURI uri = new MongoClientURI(remoteServerList);
MongoClient mongoClient = new MongoClient(uri);
DB db = mongoClient.getDB(database);
mongoClient.close();
~~~

### Getting a Collection

~~~
DBCollection coll = db.getCollection("testCollection");
mongoClient.setWriteConcern(WriteConcern.JOURNALED);
~~~

### Inserting a Document

~~~
BasicDBObject doc = new BasicDBObject("name", "MongoDB")
            .append("type", "database")
            .append("count", 1)
            .append("info", new BasicDBObject("x", 203).append("y", 102));
coll.insert(doc);
~~~ 

### Basic Query

~~~
DBCollection collection = db.getCollection("testCollection");
Cursor results = collection.find();
while(results.hasNext()) {
    DBObject result = results.next();
    System.out.println(result);
}
~~~

## Metadata

### List Collections/Tables

~~~
db.getCollectionNames().forEach(tableName -> System.out.println(tableName));
~~~

### List Document attribute name/value/value type

~~~
db.getCollectionNames().forEach(tableName -> {
    DBCollection collection = db.getCollection(tableName);
    DBCursor cursor = collection.find();
    while(cursor.hasNext()) {
        BasicDBObject row = (BasicDBObject)cursor.next();
        row.keySet().forEach(key -> {
            Object value = row.get(key);
            System.out.print(key + " |" + value + " |" + value.getClass() + ", ");                    
         });
        System.out.println();
    }
    System.out.println();
});
~~~
