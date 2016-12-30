---
layout: blog
title:  "Helix Quickstart"
date:   2016-12-29 18:00:12
categories: architecture
permalink: /helix-quickstart
author: Kylin Soong
duoshuoid: ksoong2016121901
excerpt: In this Quickstart, we'll set up a master-slave replicated, partitioned system. Then we'll demonstrate how to add a node, rebalance the partitions, and show how Helix manages failover.
---

* Table of contents
{:toc}

## Overview

This article contain the steps and scripts to run Helix Quickstart which referred in [Helix Document](http://helix.apache.org/0.6.6-docs/Quickstart.html). we'll do the following:

* Define a cluster
* Add two nodes to the cluster
* Add a 6-partition resource with 1 master and 2 slave replicas per partition
* Verify that the cluster is healthy and inspect the Helix view
* Expand the cluster: add a few nodes and rebalance the partitions
* Failover: stop a node and verify the mastership transfer

## Set up ZooKeeper

In this section will will set up Zookeeper ensemble with 3 nodes run one localhost.

### Download and install

~~~
wget http://apache.claz.org/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
tar -xvf zookeeper-3.4.9.tar.gz
cp -r zookeeper-3.4.9 zookeeper-1
cp -r zookeeper-3.4.9 zookeeper-2
cp -r zookeeper-3.4.9 zookeeper-3
~~~

#### Setup zookeeper 1

* Create `zoo.cfg` under `zookeeper-1/conf/`

~~~
cd zookeeper-1/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit `zoo.cfg`, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/tmp/zookeeper-1
clientPort=2181
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Create dataDir, assign a node ID

~~~
mkdir -p /tmp/zookeeper-1
echo "1" > /tmp/zookeeper-1/myid
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

> NOTE: A `zookeeper.out` file generate which contain zookeeper log.

#### Setup zookeeper 2

* Create `zoo.cfg` under `zookeeper-2/conf/`

~~~
cd zookeeper-2/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit `zoo.cfg`, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/tmp/zookeeper-2
clientPort=2182
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Create dataDir, assign a node ID

~~~
mkdir -p /tmp/zookeeper-2
echo "2" > /tmp/zookeeper-2/myid
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

#### Setup zookeeper 3

* Create `zoo.cfg` under `zookeeper-3/conf/`

~~~
cd zookeeper-3/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit `zoo.cfg`, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/tmp/zookeeper-3
clientPort=2183
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Create dataDir, assign a node ID

~~~
mkdir -p /tmp/zookeeper-3
echo "3" > /tmp/zookeeper-3/myid
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

#### Monitor the zookeeper ensemble

~~~
$ jps -l
12275 org.apache.zookeeper.server.quorum.QuorumPeerMain
12005 org.apache.zookeeper.server.quorum.QuorumPeerMain
11741 org.apache.zookeeper.server.quorum.QuorumPeerMain

$ netstat -antulop | grep 11741
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp6       0      0 :::2181                 :::*                    LISTEN      11741/java           off (0.00/0/0)
tcp6       0      0 127.0.0.1:3888          :::*                    LISTEN      11741/java           off (0.00/0/0)
tcp6       0      0 :::60540                :::*                    LISTEN      11741/java           off (0.00/0/0)
tcp6       0      0 127.0.0.1:53849         127.0.0.1:2889          ESTABLISHED 11741/java           off (0.00/0/0)
tcp6       0      0 127.0.0.1:3888          127.0.0.1:60408         ESTABLISHED 11741/java           off (0.00/0/0)
tcp6       0      0 127.0.0.1:3888          127.0.0.1:60393         ESTABLISHED 11741/java           off (0.00/0/0)
~~~

## Install Helix

* Download `helix-core-0.6.6-pkg.tar` from http://helix.apache.org/0.6.6-docs/download.cgi

* Extract `helix-core-0.6.6-pkg.tar` to install

~~~
tar -xvf helix-core-0.6.6-pkg.tar
~~~

## Define the Cluster

In this section we'll set up a cluster `helix-quickstart-cluster` cluster with these attributes:

* 3 instances running on localhost at ports 12913,12914,12915
* One database named myDB with 6 partitions
* Each partition will have 3 replicas with 1 master, 2 slaves

### Create the Cluster helix-quickstart-cluster

~~~
cd helix-core-0.6.6/
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addCluster helix-quickstart-cluster
~~~

### Add Nodes to the Cluster

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12913
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12914
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12915
~~~

### Define the Resource and Partitioning

In this example, the resource is a database, partitioned 6 ways.

#### Create a Database with 6 Partitions using the MasterSlave State Model

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addResource helix-quickstart-cluster myDB 6 MasterSlave
~~~

#### Let Helix Assign Partitions to Nodes

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --rebalance helix-quickstart-cluster myDB 3
~~~

### Start the Helix Controller

~~~
./bin/run-helix-controller.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster 2>&1 > ./controller.log &
~~~

### Start up the Cluster to be Managed

~~~
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12913 --steModelType MasterSlave 2>&1 > ./participant_12913.log &
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12914 --steModelType MasterSlave 2>&1 > ./participant_12914.log &
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12915 --steModelType MasterSlave 2>&1 > ./participant_12915.log &
~~~

### Inspect the Cluster

#### list cluster

~~~
$ ./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --listClusters
Existing clusters:
helix-quickstart-cluster
~~~

#### Helix view of cluster

~~~
$ ./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --listClusterInfo helix-quickstart-cluster
Existing resources in cluster helix-quickstart-cluster:
myDB
Instances in cluster helix-quickstart-cluster:
localhost_12913
localhost_12914
localhost_12915
~~~

#### The details of an instance

~~~
$ ./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --listInstanceInfo helix-quickstart-cluster localhost_12913
InstanceConfig: {
  "id" : "localhost_12913",
  "mapFields" : {
  },
  "listFields" : {
  },
  "simpleFields" : {
    "HELIX_ENABLED" : "true",
    "HELIX_HOST" : "localhost",
    "HELIX_PORT" : "12913"
  }
}
~~~

#### Query Information about a Resource

~~~
$ ./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --listResourceInfo helix-quickstart-cluster myDB
IdealState for myDB:
{
  "id" : "myDB",
  "mapFields" : {
    "myDB_0" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "MASTER",
      "localhost_12915" : "SLAVE"
    },
    "myDB_1" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "MASTER"
    },
    "myDB_2" : {
      "localhost_12913" : "MASTER",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "SLAVE"
    },
    "myDB_3" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "MASTER"
    },
    "myDB_4" : {
      "localhost_12913" : "MASTER",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "SLAVE"
    },
    "myDB_5" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "MASTER",
      "localhost_12915" : "SLAVE"
    }
  },
  "listFields" : {
    "myDB_0" : [ "localhost_12914", "localhost_12915", "localhost_12913" ],
    "myDB_1" : [ "localhost_12915", "localhost_12913", "localhost_12914" ],
    "myDB_2" : [ "localhost_12913", "localhost_12914", "localhost_12915" ],
    "myDB_3" : [ "localhost_12915", "localhost_12913", "localhost_12914" ],
    "myDB_4" : [ "localhost_12913", "localhost_12914", "localhost_12915" ],
    "myDB_5" : [ "localhost_12914", "localhost_12913", "localhost_12915" ]
  },
  "simpleFields" : {
    "IDEAL_STATE_MODE" : "AUTO",
    "NUM_PARTITIONS" : "6",
    "REBALANCE_MODE" : "SEMI_AUTO",
    "REBALANCE_STRATEGY" : "DEFAULT",
    "REPLICAS" : "3",
    "STATE_MODEL_DEF_REF" : "MasterSlave",
    "STATE_MODEL_FACTORY_NAME" : "DEFAULT"
  }
}

ExternalView for myDB:
{
  "id" : "myDB",
  "mapFields" : {
    "myDB_0" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "MASTER",
      "localhost_12915" : "SLAVE"
    },
    "myDB_1" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "MASTER"
    },
    "myDB_2" : {
      "localhost_12913" : "MASTER",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "SLAVE"
    },
    "myDB_3" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "MASTER"
    },
    "myDB_4" : {
      "localhost_12913" : "MASTER",
      "localhost_12914" : "SLAVE",
      "localhost_12915" : "SLAVE"
    },
    "myDB_5" : {
      "localhost_12913" : "SLAVE",
      "localhost_12914" : "MASTER",
      "localhost_12915" : "SLAVE"
    }
  },
  "listFields" : {
  },
  "simpleFields" : {
    "BUCKET_SIZE" : "0",
    "IDEAL_STATE_MODE" : "AUTO",
    "NUM_PARTITIONS" : "6",
    "REBALANCE_MODE" : "SEMI_AUTO",
    "REBALANCE_STRATEGY" : "DEFAULT",
    "REPLICAS" : "3",
    "STATE_MODEL_DEF_REF" : "MasterSlave",
    "STATE_MODEL_FACTORY_NAME" : "DEFAULT"
  }
}
~~~

#### Query Information about a Resource partitions

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --listResourceInfo helix-quickstart-cluster myDB_0
~~~

### Expand the Cluster

#### Add more nodes

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12916
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12917
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode helix-quickstart-cluster localhost:12918
~~~

#### Start up new instances

~~~
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12916 --stateModelType MasterSlave 2>&1 > ./participant_12916.log &
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12917 --stateModelType MasterSlave 2>&1 > ./participant_12917.log &
./bin/start-helix-participant.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster helix-quickstart-cluster --host localhost --port 12918 --stateModelType MasterSlave 2>&1 > ./participant_12918.log &
~~~

#### rebalance

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --rebalance helix-quickstart-cluster myDB 3
~~~


