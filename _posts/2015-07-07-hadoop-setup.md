---
layout: blog
title:  "Hadoop Introduction"
date:   2015-07-07 15:40:00
categories: data
permalink: /hadoop-intro
author: Kylin Soong
duoshuoid: ksoong2015070701
excerpt: Hadoop Introduction, Installation, configuration, Single Node Setup
---

## Introduction

Google's revolutionary Big Data concepts `MapReduce`, `BigTable`, `GFS` has become the principle of Big Data Area, the dissertations relevant to these concepts are opened by Google, but the concepts' implementation product not a open source. 

* [MapReduce](http://static.googleusercontent.com/media/research.google.com/en/us/archive/mapreduce-osdi04.pdf)
* [BigTable](http://static.googleusercontent.com/media/research.google.com/en/us/archive/bigtable-osdi06.pdf)
* [GFS](http://static.googleusercontent.com/media/research.google.com/en/us/archive/gfs-sosp2003.pdf)

Base on Google's Big Data concepts, the Open Source Community developed a series of products, which the core produce named **Hadoop**, it mainly implement the `MapReduce` and `GFS`, another core product named **HBase**, it mainly implement the `BigTable`. Aslo there are some additional products like **Hive** which is a data warehouse infrastructure for data summarization and querying, **Spark** which is mainly a fast conputing layer for Hadoop data.

[http://hadoop.apache.org/](http://hadoop.apache.org/)

[http://hbase.apache.org/](http://hbase.apache.org/)

[http://hive.apache.org/](http://hive.apache.org/)

[http://spark.apache.org/](http://spark.apache.org/)

## Installation, configuration, Single Node Setup

The following steps demonstrate installation, configuration and Single Node Setup with Hadoop 1.2.1 and Linux System.

### Installation

~~~
$ tar -xvf hadoop-1.2.1.tar.gz
~~~

### Configuration and Single Node Setup

Edit 'hadoop-1.2.1/conf/hadoop-env.sh', comment out JAVA_HOME, make sure it point to a valid Java installation, eg:

~~~
export JAVA_HOME=/usr/java/jdk1.8.0_25
~~~

> NOTE: Hadoop 1.2.1 need Java 1.6 or higher

Edit 'hadoop-1.2.1/conf/core-site.xml', add the following 3 property in <configuration>:

~~~
<property>
     <name>hadoop.tmp.dir</name>
      <value>/home/kylin/tmp/hadoop</value>
</property>
<property>
     <name>dfs.name.dir</name>
     <value>/home/kylin/tmp/hadoop/name</value>
</property>
<property>
     <name>fs.default.name</name>
     <value>hdfs://localhost:9000</value>
</property>
~~~

> NOTE: the property's value should match to your's setting.

Edit 'hadoop-1.2.1/conf/hdfs-site.xml', add the following 2 property in <configuration>:

~~~
<property>
     <name>dfs.data.dir</name>
     <value>/home/kylin/tmp/hadoop/data</value>
</property>
<property>
     <name>dfs.replication</name>
     <value>1</value>
</property>
~~~

> NOTE: the property's value should match to your's setting.

Edit 'hadoop-1.2.1/conf/mapred-site.xml', add below in <configuration>:

~~~
<property>
    <name>mapred.job.tracker</name>
    <value>localhost:9001</value>
</property>
~~~

Format a new distributed-filesystem via execute

~~~
hadoop-1.2.1/bin/hadoop namenode -format
~~~

Start the hadoop via execute

~~~
hadoop-1.2.1/bin/start-all.sh
~~~

## HDFS 介绍

Hadoop HDFS 的组成:

* 快(Block) - HDFS 中将要存储的文件切分成块，默认块的大小为 64MB，块是文件存储处理的逻辑单元
* NameNode - 是 HDFS 管理节点，存放元数据
* DataNode - 是 HDFS 数据节点，存放数据块

下图为 Hadoop HDFS 数据管理策略

![HDFS 数据管理策略]({{ site.baseurl }}/assets/blog/hadoop-hdfs-strategy.png)

* 数据块副本: 数据块有多个副本，分布在不同机架内的不同 DataNode 上
* 心条检测: DataNode 周期性的向 NameNode 发送心跳消息
* 二级 NameNode: NameNode 的备份，元数据周期性的同步

下图为 Hadoop HDFS 读操作的步骤

![HDFS 读]({{ site.baseurl }}/assets/blog/hadoop-hdfs-read.png)

* 客户端发送读取请求到 NameNode
* NameNode 返回元数据
* 客户端根据元数据中数据块的路径读取数据块

下图为 Hadoop HDFS 写操作的步骤

![HDFS 写]({{ site.baseurl }}/assets/blog/hadoop-hdfs-write.png)

* 文件拆分成块，发送写取请求到 NameNode
* NameNode 返回元数据
* 根据元数据中可用数据块的路径写数据
* 流水线复制多个副本
* 更新元数据

> HDFS 特点: 数据冗余，硬件容错。流式数据访问，一次写入，多次读写。适合存储大文件。

> HDFS 适合批量读写，吞吐量高，适合一次写入，多次读写，顺序读写。不适合交互式应用，不支持并发写同一个数据块

### hadoop 命令的使用

~~~
$ ./hadoop fs -ls /
$ ./hadoop fs -ls /home/

$ ./hadoop fs -mkdir input
$ ./hadoop fs -put ./../NOTE.md input
$ ./hadoop fs -get input/NOTE.md note2.md 
~~~
