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
$ wget http://apache.arvixe.com/spark/spark-1.4.0/spark-1.4.0-bin-without-hadoop.tgz
$ tar -xvf spark-1.4.0-bin-without-hadoop.tgz
$ cd spark-1.4.0
~~~

#### Step.3 Configure

Create a 'hive-env.sh' under 'conf'

~~~
$ cd conf/
$ cp hive-env.sh.template hive-env.sh
$ vim hive-env.sh
~~~

comment out HADOOP_HOME and make sure point to a valid Hadoop home, for example:

~~~
HADOOP_HOME=/home/kylin/server/hadoop-1.2.1
~~~

Navigate to Hadoop Home, create '/tmp' and '/user/hive/warehouse' and chmod g+w in HDFS before running Hive:

~~~
$ ./bin/hadoop fs -mkdir /tmp
$ ./bin/hadoop fs -mkdir /user/hive/warehouse
$ ./bin/hadoop fs -chmod g+w /tmp
$ ./bin/hadoop fs -chmod g+w /user/hive/warehouse
$ ./bin/hadoop fs -chmod 777 /tmp/hive
~~~

> NOTE: Restart Hadoop services is needed, this for avoid 'java.io.IOException: Filesystem closed' in DFSClient check Open.

#### Step.4 Start and Test

~~~
$ ./bin/hive
hive>
~~~

Create/Drop database:

~~~
hive> CREATE DATABASE userdb;
hive> DROP DATABASE IF EXISTS userdb;
~~~

Create/Alter/Drop Table 

~~~
hive> CREATE TABLE IF NOT EXISTS employee (eid int, name String, salary String, destination String) STORED AS TEXTFILE;
// alternative
hive> CREATE TABLE IF NOT EXISTS employee (eid int, name String, salary String, destination String) COMMENT 'Employee details' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE;

hive> LOAD DATA LOCAL INPATH '/home/kylin/hive-sample.txt' OVERWRITE INTO TABLE employee;

hive> SELECT * FROM employee;

hive> ALTER TABLE employee RENAME TO emp;
hive> ALTER TABLE employee CHANGE name ename String;
hive> ALTER TABLE emp CHANGE salary salary Double;
hive> ALTER TABLE emp ADD COLUMNS(dept STRING COMMENT 'Department name');

hive> DROP TABLE IF EXISTS emp;
~~~

## Configure and Start HiveServer2

### Configure

Create a 'hive-site.xml' file under conf folder

~~~
$ cd apache-hive-1.2.1-bin/conf/
$ touch hive-site.xml
~~~

Edit the 'hive-site.xml', add the following content:

~~~
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>hive.server2.thrift.min.worker.threads</name>
        <value>5</value>
    </property>
    <property>
        <name>hive.server2.thrift.max.worker.threads</name>
        <value>500</value>
    </property>
    <property>
        <name>hive.server2.thrift.port</name>
        <value>10000</value>
    </property>
    <property>
        <name>hive.server2.thrift.bind.host</name>
        <value>0.0.0.0</value>
    </property>
</configuration>
~~~

> NOTE: there are other Optional properties, more refer to [Setting+Up+HiveServer2](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2)

### Start

~~~
$ ./bin/hiveserver2
~~~

### HiveJdbcClient

~~~
Connection conn = DriverManager.getConnection("jdbc:hive2://192.168.1.105:10000/default", "hive", "");
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM employee");
~~~

If HiveJdbcClient within Maven project, add the following dependency:

~~~
<dependency>
	<groupId>org.apache.hive</groupId>
	<artifactId>hive-jdbc</artifactId>
	<version>1.2.1</version>
</dependency>
<dependency>
	<groupId>org.apache.hadoop</groupId>
	<artifactId>hadoop-core</artifactId>
	<version>1.2.1</version>
</dependency>
~~~

To run HiveJdbcClient in no Maven project, need add jars in the classpath, refer to [HiveServer2Clients-JDBCClientSampleCode](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-JDBCClientSampleCode).
