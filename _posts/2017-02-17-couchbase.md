---
layout: blog
title:  "Get Start with Couchbase Server"
date:   2017-02-17 20:00:00
categories: teiid
permalink: /couchbase
author: Kylin Soong
duoshuoid: ksoong2017021701
excerpt: Couchbase Server Translator/Connector Development scripts. 
---

* Table of contents
{:toc}

## Download and install Couchbase Server on Red Hat Linux 7

### Download

~~~
wget http://packages.couchbase.com/releases/4.5.0/couchbase-server-community-4.5.0-centos7.x86_64.rpm
~~~

### Install

~~~
rpm --install couchbase-server-community-4.5.0-centos7.x86_64.rpm
~~~

### Set up Couchbase Server

https://developer.couchbase.com/documentation/server/current/install/init-setup.html#topic12527

## Couchbase Java Client

### Maven dependency

~~~
<dependency>
    <groupId>com.couchbase.client</groupId>
    <artifactId>java-client</artifactId>
    <version>2.4.2</version>
</dependency>
~~~


### An Example of using the SDK

#### Initialize the Connection

~~~
Cluster cluster = CouchbaseCluster.create("10.66.192.120"); 
Bucket bucket = cluster.openBucket("default");
~~~

#### Create a JSON Document

~~~
JsonObject arthur = JsonObject.create()
        .put("name", "Arthur")
        .put("email", "kingarthur@couchbase.com")
        .put("address", JsonArray.from("Holy Grail", "African Swallows"));
~~~

#### Store the Document

~~~
bucket.upsert(JsonDocument.create("u:king_arthur", arthur));
~~~

#### Load the Document

~~~
bucket.get("u:king_arthur")
~~~

#### Create a N1QL Primary Index and perform a Query

~~~
bucket.bucketManager().createN1qlPrimaryIndex(true, false);
        
N1qlQueryResult result = bucket.query(N1qlQuery.simple("SELECT name, email, address FROM default"));
for (N1qlQueryRow row : result.allRows()) {
    System.out.println(row);
}
~~~

#### Disconnecting

~~~
bucket.close();
cluster.disconnect();
~~~

## N1QL Basic

http://query.pub.couchbase.com/tutorial/#1

### Metadata for spacific Bucket/Keyspace

~~~
SELECT META(`beer-sample`) AS meta FROM `beer-sample`
~~~

A sample results:

~~~
[
  {
    "meta": {
      "cas": 1487216396995199000,
      "flags": 33554438,
      "id": "21st_amendment_brewery_cafe",
      "type": "json"
    }
  },
  {
    "meta": {
      "cas": 1487216397215072300,
      "flags": 33554438,
      "id": "21st_amendment_brewery_cafe-21a_ipa",
      "type": "json"
    }
  },
~~~

### Performing Simple Arithmetic

~~~
SELECT name, srm + 100 AS srm, type FROM `beer-sample` LIMIT 10;
~~~
