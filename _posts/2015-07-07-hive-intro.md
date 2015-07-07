---
layout: blog
title:  "Hive Introduction"
date:   2015-07-07 18:00:00
categories: data
permalink: /hive-intro
author: Kylin Soong
duoshuoid: ksoong2015070702
excerpt: Apache Hive Introduction, Installation, configuration, JDBC against Hive
---

## Installation

~~~
$ tar -xvf apache-hive-1.2.1-bin.tar.gz
~~~

## Running Hive

~~~
$ cd hadoop-1.2.1/
$ ./bin/hadoop fs -mkdir /tmp
$ ./bin/hadoop fs -mkdir /user/hive/warehouse
$ ./bin/hadoop fs -chmod g+w /tmp
$ ./bin/hadoop fs -chmod g+w /user/hive/warehouse

$ export HADOOP_HOME=/home/kylin/server/hadoop-1.2.1

$ cd apache-hive-1.2.1-bin/
~~~
