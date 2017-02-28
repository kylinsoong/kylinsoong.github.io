---
layout: blog
title:  "Get Start with Couchbase Server"
date:   2017-02-17 20:00:00
categories: data
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

## Couchbase Server

* Flexible Data Model, Dynamic Schemas - Couchbase documents are JSON, a self-describing format capable of representing rich structures and relationships
* N1QL -  an expressive, powerful, and complete SQL dialect for querying, transforming, and manipulating JSON data.
* Couchbase Server is a memory-centric system that intelligently keeps frequently accessed documents, metadata, and indexes in RAM, yielding high read/write throughput at very low latency.
*  Cross Datacenter Replication with Timestamp-based Conflict Resolution
 

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

## N1QL 

### First N1QL Query

~~~
SELECT name FROM `beer-sample` WHERE  brewery_id ="mishawaka_brewing";
~~~

* create the primary index: 

~~~
CREATE PRIMARY INDEX ON `travel-sample` USING GSI;
~~~

* returns the different values used for the type field:

~~~
SELECT DISTINCT type FROM `beer-sample`;
~~~

* returns one brewery document and lists all the fields it contains:

~~~
SELECT * FROM `beer-sample` WHERE type="brewery" LIMIT 5;
~~~

* returns all fields in one beer document:

~~~
SELECT * 
FROM `beer-sample` 
WHERE brewery_id IS NOT MISSING 
AND type="beer" 
LIMIT 5;
~~~

### N1QL Language Statements

* Data Definition Language (DDL) statements to create, modify, and delete indexes.
* Data Manipulation Language (DML) statements to select from, insert, update, delete, and upsert data into JSON documents.

### Queries and Results

* SELECT name, brewery_id from `beer-sample` WHERE brewery_id IS NOT MISSING LIMIT 2

~~~
N1qlQuery query = N1qlQuery.simple("SELECT name, brewery_id from `beer-sample` WHERE brewery_id IS NOT MISSING LIMIT 2");
N1qlQueryResult result = bucket.query(query);
result.forEach(row -> System.out.println(row));
~~~

The results looks

~~~
{"name":"21A IPA","brewery_id":"21st_amendment_brewery_cafe"}
{"name":"563 Stout","brewery_id":"21st_amendment_brewery_cafe"}
~~~

* Querying Datastores

~~~
query = N1qlQuery.simple("SELECT * FROM system:datastores");
result = bucket.query(query);
result.forEach(row -> System.out.println(row));
~~~

The results looks

~~~
{"datastores":{"url":"http://127.0.0.1:8091","id":"http://127.0.0.1:8091"}}
~~~

* Querying Namespaces

~~~
query = N1qlQuery.simple("SELECT * FROM system:namespaces");
result = bucket.query(query);
result.forEach(row -> System.out.println(row));
~~~

The results looks

~~~
[
  {
    "namespaces": {
      "datastore_id": "http://127.0.0.1:8091",
      "id": "default",
      "name": "default"
    }
  }
]
~~~

* Querying Keyspaces

~~~
query = N1qlQuery.simple("SELECT * FROM system:keyspaces");
result = bucket.query(query);
result.forEach(row -> System.out.println(row));
~~~

The results looks

~~~
{"keyspaces":{"datastore_id":"http://127.0.0.1:8091","name":"beer-sample","id":"beer-sample","namespace_id":"default"}}
{"keyspaces":{"datastore_id":"http://127.0.0.1:8091","name":"default","id":"default","namespace_id":"default"}}
{"keyspaces":{"datastore_id":"http://127.0.0.1:8091","name":"gamesim-sample","id":"gamesim-sample","namespace_id":"default"}}
{"keyspaces":{"datastore_id":"http://127.0.0.1:8091","name":"travel-sample","id":"travel-sample","namespace_id":"default"}}
~~~

* Querying Indexs

~~~
query = N1qlQuery.simple("SELECT * FROM system:indexes");
result = bucket.query(query);
result.forEach(row -> System.out.println(row));
~~~

The results looks

~~~
{"indexes":{"index_key":["`sourceairport`","`destinationairport`","(distinct (array (`v`.`day`) for `v` in `schedule` end))"],"keyspace_id":"travel-sample","condition":"(`type` = \"route\")","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_route_src_dst_day","id":"32bceca1e1b4e559","state":"online"}}
{"indexes":{"index_key":["`type`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_type","id":"89ab5d7f66748e19","state":"online"}}
{"indexes":{"index_key":["`icao`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_icao","id":"ab1bb365da8952d5","state":"online"}}
{"indexes":{"index_key":[],"keyspace_id":"beer-sample","using":"gsi","is_primary":true,"namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"beer_primary","id":"af948434ef478f","state":"online"}}
{"indexes":{"index_key":[],"keyspace_id":"travel-sample","using":"gsi","is_primary":true,"namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_primary","id":"508ad28de027b7c9","state":"online"}}
{"indexes":{"index_key":["`airportname`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_airportname","id":"df2f2e8364472202","state":"online"}}
{"indexes":{"index_key":["`faa`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_faa","id":"d884c54663a159af","state":"online"}}
{"indexes":{"index_key":[],"keyspace_id":"travel-sample","using":"gsi","is_primary":true,"namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"#primary","id":"b2affacb556d0e5e","state":"online"}}
{"indexes":{"index_key":["`sourceairport`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_sourceairport","id":"2611f7d60bb315a1","state":"online"}}
{"indexes":{"index_key":["array (`s`.`utc`) for `s` in `schedule` end"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_schedule_utc","id":"e5986183f80b28aa","state":"online"}}
{"indexes":{"index_key":[],"keyspace_id":"default","using":"gsi","is_primary":true,"namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"#primary","id":"934acc448df2ee7e","state":"online"}}
{"indexes":{"index_key":[],"keyspace_id":"gamesim-sample","using":"gsi","is_primary":true,"namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"gamesim_primary","id":"25534556a97fb1d7","state":"online"}}
{"indexes":{"index_key":["`name`"],"keyspace_id":"travel-sample","condition":"(`_type` = \"User\")","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_name_type","id":"e2ea8caf0eee3bfa","state":"online"}}
{"indexes":{"index_key":["`city`"],"keyspace_id":"travel-sample","using":"gsi","namespace_id":"default","datastore_id":"http://127.0.0.1:8091","name":"def_city","id":"e76df3426ca6f2e4","state":"online"}}
~~~


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


## Simba Couchbase JDBC Driver

The Simba Couchbase JDBC Driver is used for direct SQL and N1QL access to Couchbase Server, enabling OLAP on Couchbase-based data. The driver efficiently transforms an application’s SQL query into the equivalent form in N1QL. The driver interrogates Couchbase Server to obtain schema information to present to a SQL-based application. Queries, including joins, are translated from SQL to N1QL.

### Features

* **SQL Connector** - The SQL Connector feature of the driver allows applications to use normal SQL queries against Couchbase Server, translating standard SQL-92 queries into equivalent N1QL client API calls.
* **Data Types** - The Simba Couchbase JDBC Driver supports all Couchbase data types, and converts data between Couchbase, SQL, and Java data types as needed.

## Rest API

* http://10.66.192.120:8093/admin/clusters/default/nodes

~~~
[{"cluster":"default","name":"10.66.192.120","queryEndpoint":"http://10.66.192.120:8093/query/service","adminEndpoint":"http://10.66.192.120:8093/admin","options":null}]
~~~

## Examples

### Example.1 - List all Bucket/Keyspace

~~~
N1qlQuery query = N1qlQuery.simple("SELECT * FROM system:keyspaces");
N1qlQueryResult result = bucket.query(query);
result.forEach(row -> {
    JsonObject json = (JsonObject) row.value().get("keyspaces");
    System.out.println(json.get("name"));
});
~~~

### Example.2 - List all document attribute datatype

~~~
N1qlQuery query = N1qlQuery.simple("SELECT * FROM `default`");
N1qlQueryResult result = bucket.query(query);
result.forEach(row -> {
    JsonObject json = (JsonObject) row.value().get("default");
    json.getNames().forEach(key -> {
        System.out.print(key + "/" + json.get(key).getClass().getSimpleName() + ", ");
    });
    System.out.println();
 );
~~~

### Example.3 Select

Assume the following documents exist in Keyspace `default`:

~~~
[
  {
    "default": {
      "Name": "John Doe",
      "SavedAddresses": [
        "123 Main St.",
        "456 1st Ave"
      ],
      "Type": "Customer"
    }
  },
  {
    "default": {
      "CreditCard": {
        "CVN": 123,
        "CardNumber": "4111 1111 1111 111",
        "Expiry": "12/12",
        "Type": "Visa"
      },
      "CustomerID": "Customer_12345",
      "Items": [
        {
          "ItemID": 89123,
          "Quantity": 1
        },
        {
          "ItemID": 92312,
          "Quantity": 5
        }
      ],
      "Type": "Oder"
    }
  }
]
~~~

#### FROM

~~~
SELECT * FROM default
SELECT * FROM default USE KEYS "customer"
SELECT * FROM default USE PRIMARY KEYS "customer"
SELECT * FROM default USE KEYS ["customer", "order"]
SELECT * FROM default USE PRIMARY KEYS ["customer", "order"]
SELECT * FROM default:default // The keyspace can be prefixed with an optional namespace

SELECT * FROM default.Items USE PRIMARY KEYS "order"

SELECT S FROM default.SavedAddresses AS S USE PRIMARY KEYS "customer"
SELECT S[0] FROM default.SavedAddresses AS S USE PRIMARY KEYS "customer"
~~~
