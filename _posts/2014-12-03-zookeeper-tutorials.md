---
layout: blog
title:  "Java ZooKeeper Tutorials"
date:   2014-12-03 21:45:00
categories: data
permalink: /zookeeper-tutorials
author: Kylin Soong
duoshuoid: ksoong2014120301
---

## Installing Apache ZooKeeper 

Download `zookeeper-3.4.6.tar.gz` from [Apache ZooKeeper Download Page](http://zookeeper.apache.org/releases.html#download), to install ZooKeeper just unzip the tar file:

~~~
$ tar xvf zookeeper-3.4.6.tar.gz
~~~

[ZooKeeper Getting Started Guide](http://zookeeper.apache.org/doc/trunk/zookeeperStarted.html) is a good for get you started with  ZooKeeper.

## Connecting To ZooKeeper

[org.apache.zookeeper.tutorials.ZooKeeperConnector](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/ZooKeeperConnector.java) demonstrate how java application connect to ZooKeeper.

[org.apache.zookeeper.tutorials.TestZkConnection](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/TestZkConnection.java) test ZooKeeper Connection, run it as java application will output all znode name, for example in my environment, the output like:

~~~
zookeeper
zk_test
~~~

## Creating ZNode

[org.apache.zookeeper.tutorials.CreateZNode](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/CreateZNode.java) show how to create znode, run it as java application will create znode `/sampleznode` with data `sample znode data`. 

## Updating ZNode

[org.apache.zookeeper.tutorials.UpdateZNode](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/UpdateZNode.java) show how to update znode, run it as java application will update znode `/sampleznode`.

## Reading ZNode Data 

[org.apache.zookeeper.tutorials.ReadZNode](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/ReadZNode.java) show how to read znode data, run it as java application will output the data under znode `/sampleznode`.

## Deleting Znode 

[org.apache.zookeeper.tutorials.DeleteZNode](https://github.com/kylinsoong/data/blob/master/zookeeper-tutorials/src/main/java/org/apache/zookeeper/tutorials/DeleteZNode.java) show how to delete a exist znode, run it as java application will delete znode `/sampleznode`.



