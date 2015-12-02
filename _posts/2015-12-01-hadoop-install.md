---
layout: blog
title:  "Hadoop 安装"
date:   2015-12-01 18:40:00
categories: data
permalink: /hadoop-install
author: Kylin Soong
duoshuoid: ksoong2015120101
---

Hadoop 集群支持三种模式：

* 本地模式
* 单节点分布式模式
* 多节点分布式模式

本文档分三个部分分别说明这三种模式的安装。Hadoop 集群的安装推荐使用 Linux 服务器和 Java：

~~~
$ uname -a
Linux kylin.xx.com 2.6.32-431.20.3.el6.x86_64 #1 SMP Fri Jun 6 18:30:54 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux

$ java -version
java version "1.7.0_60"
Java(TM) SE Runtime Environment (build 1.7.0_60-b19)
Java HotSpot(TM) 64-Bit Server VM (build 24.60-b09, mixed mode)
~~~

本文档以 hadoop 1.2.1 为例演示安装步骤。

## 本地模式

本地模式不具有分布式功能，它主要用于运行示例代码或代码调试。

#### 1. 下载安装

~~~
$ wget http://apache.mesi.com.ar/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
$ tar -xvf hadoop-1.2.1.tar.gz
$ cd hadoop-1.2.1
~~~

#### 2. 配置

编辑 `conf/hadoop-env.sh`，添加 JAVA_HOME 配置：

~~~
export JAVA_HOME=/usr/java/jdk1.7.0_60
~~~

> 注意: Hadoop 1.2.1 需要 java 1.6 或以上版本.

#### 3. 启动

~~~
$ mkdir input 
$ cp conf/*.xml input 
$ ./bin/hadoop jar hadoop-examples-1.2.1.jar grep input output 'dfs[a-z.]+'
$ cat output/*
~~~


## 单节点分布式模式

#### 1. 下载安装

~~~
$ wget http://apache.mesi.com.ar/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
$ tar -xvf hadoop-1.2.1.tar.gz
$ cd hadoop-1.2.1
~~~

#### 2. 配置

编辑 `conf/hadoop-env.sh`，添加 JAVA_HOME 配置：

~~~
export JAVA_HOME=/usr/java/jdk1.7.0_60
~~~

编辑 `conf/core-site.xml`，添加 fs.default.name 配置：

~~~
<configuration>
     <property>
         <name>fs.default.name</name>
         <value>hdfs://localhost:9000</value>
     </property>
</configuration>
~~~

编辑 `conf/hdfs-site.xml`，添加 dfs.replication 配置：

~~~
<configuration>
     <property>
         <name>dfs.replication</name>
         <value>1</value>
     </property>
</configuration>
~~~

编辑 `conf/mapred-site.xml`，添加 mapred.job.tracker 配置：

~~~
<configuration>
     <property>
         <name>mapred.job.tracker</name>
         <value>localhost:9001</value>
     </property>
</configuration>
~~~

格式化文件系统

~~~
./bin/hadoop namenode -format
~~~

#### 3. 启动

执行如下脚本启动所有服务

~~~
$ ./bin/start-all.sh
~~~

启动完成后将有 5 个 java 进程启动，它们分别是 `NameNode`, `SecondaryNameNode`, `DataNode`, `JobTracker`, `TaskTracker`。使用 jps 命令查看进程:

~~~
$ jps -l
4056 org.apache.hadoop.hdfs.server.namenode.NameNode
4271 org.apache.hadoop.hdfs.server.datanode.DataNode
4483 org.apache.hadoop.hdfs.server.namenode.SecondaryNameNode
4568 org.apache.hadoop.mapred.JobTracker
4796 org.apache.hadoop.mapred.TaskTracker
~~~

其中 `NameNode`, `JobTracker`, `TaskTracker` 都有对应的 Web 控制台用于查看的监控

~~~
http://localhost:50030/   for the Jobtracker
http://localhost:50070/   for the Namenode
http://localhost:50060/   for the Tasktracker
~~~

#### 4. 停止

执行如下脚本停止所有服务

~~~
# bin/stop-all.sh
~~~

## 多节点分布式模式


