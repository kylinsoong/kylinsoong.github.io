---
layout: blog
title:  "Apache Spark 介绍"
date:   2015-07-10 18:00:00
categories: data
permalink: /spark-intro
author: Kylin Soong
duoshuoid: ksoong2015071001
excerpt: Apache Spark Introduction, Installation, configuration
---

## Installation

This section including step by step procedures for installing Apache Spark.


#### Step.1 Prerequisites

~~~
$ java -version
java version "1.7.0_60"
Java(TM) SE Runtime Environment (build 1.7.0_60-b19)
Java HotSpot(TM) 64-Bit Server VM (build 24.60-b09, mixed mode)
~~~

Hadoop is optional, refer to [http://ksoong.org/hadoop-intro/](http://ksoong.org/hadoop-intro/) Installation.

#### Step.2 Install

~~~
$ tar -xvf $ tar -xvf spark-1.4.0-bin-hadoop2.4.tgz
$ cd spark-1.4.0-bin-hadoop2.4
~~~

#### Step.3 Running the Thrift JDBC/ODBC server

~~~
$ ./sbin/start-thriftserver.sh
~~~

More details refer to [Spark Docs](https://spark.apache.org/docs/1.4.0/sql-programming-guide.html#data-sources)

## Client

### beeline

~~~
$ ./bin/beeline
beeline> !connect jdbc:hive2://localhost:10000/default
~~~

### HiveJdbcClient

~~~
Connection conn = DriverManager.getConnection("jdbc:hive2://192.168.1.105:10000/default", "hive", "");
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("show databases");
~~~

If HiveJdbcClient within Maven project, add the following dependency:

~~~
<dependency>
	<groupId>org.spark-project.hive</groupId>
	<artifactId>hive-jdbc</artifactId>
	<version>0.13.1a</version>
</dependency>
<dependency>
	<groupId>org.apache.hadoop</groupId>
	<artifactId>hadoop-core</artifactId>
</dependency>
~~~

