---
layout: blog
title:  "Simba Couchbase JDBC Driver"
date:   2017-03-16 20:00:00
categories: data
permalink: /couchbase-simba
author: Kylin Soong
duoshuoid: ksoong2017031601
excerpt: Simba Couchbase JDBC Driver
---

* Table of contents
{:toc}

## Simba Couchbase JDBC Driver

* The driver efficiently transforms an application’s SQL query into the equivalent form in N1QL. The driver interrogates Couchbase Server to obtain **schema information** to present to a SQL-based application. Queries, including joins, are translated from SQL to N1QL.
* If the database does not contain a schema, then the driver generates and caches a temporary schema to use. 

> NOTE: the schema are recommended to pre-defined.

## Defining a Schema
