---
layout: blog
title:  "Setup jBPM cluster with WildFly Domain Server"
date:   2016-12-30 18:00:12
categories: jbpm
permalink: /jbpm-cluster-domain
author: Kylin Soong
duoshuoid: ksoong2016123001
---

WildFly Domain mode means a physic server contain multiple VM instances, each VM instance can run a jBPM node, this article will setup a 2 servers(server1 and server2) cluster which can

* Both servers point to a shred Mysql database
* Both servers point to a shred Maven repository
* Apache Zookeeper and Helix used to replicate assets(process, data modules) between 2 git repositories
* Quartz Job Scheduler used to run complexed timer related process

* Table of contents
{:toc}

## Download

### Download jBPM

~~~
wget https://download.jboss.org/jbpm/release/6.5.0.Final/jbpm-6.5.0.Final-installer-full.zip
~~~

### Download Helix

Download `helix-core-0.6.6-pkg.tar` from http://helix.apache.org/0.6.6-docs/download.cgi

### Download zookeeper

~~~
wget http://apache.claz.org/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
~~~

## Installation

With [Download](#download) section's zip/tar files, the following steps are used to setup jBPM cluster.

### 1. Get jbpm-installer

~~~
unzip jbpm-6.5.0.Final-installer-full.zip
~~~

> NOTE: A `jbpm-installer` folder will be generated, the following installation steps depend on this folder.

### 2. Install WildFly

~~~
unzip jbpm-installer/lib/jboss-wildfly-10.0.0.Final.zip
mkdir -p wildfly-10.0.0.Final/clustering/server-one
mkdir wildfly-10.0.0.Final/installation
mkdir wildfly-10.0.0.Final/clustering/quartz
mkdir wildfly-10.0.0.Final/clustering/server-two
~~~

> NOTE: The `clustering` used to keep zookeeper, helix, clustering related files, etc. The `installation` used to keep installation related files.

### 3. Install Zookeeper

~~~
tar -xvf zookeeper-3.4.9.tar.gz -C wildfly-10.0.0.Final/clustering/
~~~

### 4. Install Helix

~~~
tar -xvf helix-core-0.6.6-pkg.tar -C wildfly-10.0.0.Final/clustering/
~~~

### 5. Prepare WildFly Domain Server

This section many will parepare jbpm cluster related datasources, system properties, etc.

#### 5.1. Prepare Database

Create a mysql database `jbpm` and user/password, more details related to http://ksoong.org/mariadb.

> In the following settings, the database name is `jbpm`, the user is `jbpm_user`, and password is `jbpm_pass`.

#### 5.2 Execute quartz related DDL

~~~
mysql -u jbpm_user -p jbpm < ./jbpm-installer/db/ddl-scripts/mysql5/quartz_tables_mysql.sql
~~~

#### 5.3 Setup DataSource

* Download mysql driver (http://dev.mysql.com/downloads/connector/) to wildfly-10.0.0.Final/installation. Assuming the `mysql-connector-java-5.1.38.jar` will be downloaded.

* Download [module-add-mariadb.cli]({{ site.baseurl }}/assets/download/jbpm/module-add-mariadb.cli) to wildfly-10.0.0.Final/installation.

* Download [domain-create-mysql-ds.cli]({{ site.baseurl }}/assets/download/jbpm/domain-create-mysql-ds.cli) to wildfly-10.0.0.Final/installation. 

* Change into WildFly home, start WildFly

~~~
cd wildfly-10.0.0.Final/
./bin/domain.sh
~~~

* Execute the CLI to finish datasource setup

~~~
./bin/jboss-cli.sh --connect --file=installation/module-add-mysql.cli
./bin/jboss-cli.sh --connect --file=installation/domain-create-mysql-ds.cli
~~~

### 6. Setup system properties

* Download [server-system-properties.cli]({{ site.baseurl }}/assets/download/jbpm/server-system-properties.cli) to wildfly-10.0.0.Final/installation.

* Change into WildFly home, start WildFly

~~~
cd wildfly-10.0.0.Final/
./bin/domain.sh
~~~

* Execute the CLI to finish system properties setup

~~~
./bin/jboss-cli.sh --connect --file=installation/server-system-properties.cli
~~~

### 7. Deploy jBPM console

~~~
unzip jbpm-installer/lib/jbpm-console-6.5.0.Final-wildfly-10.0.0.Final.war -d wildfly-10.0.0.Final/installation/jbpm-console
~~~

Edit `wildfly-10.0.0.Final/installation/jbpm-console//WEB-INF/classes/META-INF/persistence.xml`

* Locate the <jta-data-source> tag and change it to the JNDI name of your data source, for example:

~~~
<jta-data-source>java:jboss/datasources/MysqlDS</jta-data-source>
~~~

* Locate the <properties> tag and change the hibernate.dialect property, for example: 

~~~
<property name="hibernate.dialect" value="org.hibernate.dialect.MySQL5Dialect" />
~~~

* Change into wildfly-10.0.0.Final/installation

~~~
zip -r jbpm-console.war jbpm-console/
~~~

* Change into WildFly home, make sure WildFly is runing

~~~
./bin/jboss-cli.sh --connect --commands="deploy installation/jbpm-console.war --server-groups=main-server-group"
~~~

### 8. Deploy kie Server

~~~
unzip jbpm-installer/lib/kie-server-6.5.0.Final-wildfly-10.0.0.Final.war -d wildfly-10.0.0.Final/installation/kie-server
~~~ 

* Change into wildfly-10.0.0.Final/installation

~~~
zip -r kie-server.war kie-server/
~~~

* Change into WildFly home, make sure WildFly is runing

~~~
./bin/jboss-cli.sh --connect --commands="deploy installation/kie-server.war --server-groups=main-server-group"
~~~

### 9. Add test user

Change into WildFly Home, execute add users shell script [add-users.sh]({{ site.baseurl }}/assets/download/shell/add-users.sh):

~~~
./add-users.sh
~~~ 

## Setup Zookeeper

Change into `wildfly-10.0.0.Final/clustering`, create 3 instances

~~~
cp -r zookeeper-3.4.9 zookeeper-1
cp -r zookeeper-3.4.9 zookeeper-2
cp -r zookeeper-3.4.9 zookeeper-3
~~~

Create 3 dataDir

~~~
mkdir zookeeper-1/dataDir
mkdir zookeeper-2/dataDir
mkdir zookeeper-3/dataDir
~~~

Assign node id to each zookeeper nodes

~~~
echo "1" > zookeeper-1/dataDir/myid
echo "2" > zookeeper-2/dataDir/myid
echo "3" > zookeeper-3/dataDir/myid
~~~

### Configure Zookeeper 1

* Create `zoo.cfg` under `zookeeper-1/conf/`

~~~
cd zookeeper-1/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit zoo.cfg, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/home/kylin/jbpm/wildfly-10.0.0.Final/clustering/zookeeper-1/dataDir
clientPort=2181
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

### Configure Zookeeper 2

* Create `zoo.cfg` under `zookeeper-2/conf/`

~~~
cd zookeeper-2/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit zoo.cfg, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/home/kylin/jbpm/wildfly-10.0.0.Final/clustering/zookeeper-2/dataDir
clientPort=2182
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

### Configure Zookeeper 3

* Create `zoo.cfg` under `zookeeper-3/conf/`

~~~
cd zookeeper-3/conf/
cp zoo_sample.cfg zoo.cfg
~~~

* Edit zoo.cfg, make sure dataDir, clientPort, ensemble definition as below

~~~
dataDir=/home/kylin/jbpm/wildfly-10.0.0.Final/clustering/zookeeper-3/dataDir
clientPort=2183
server.1=localhost:2888:3888
server.2=localhost:2889:3889
server.3=localhost:2890:3890
~~~

* Change into zookeeper home start Zookeeper

~~~
./bin/zkServer.sh start
~~~

## Setup Helix

* Change into Helix core

~~~
cd wildfly-10.0.0.Final/clustering/helix-core-0.6.6/
~~~

* Add the cluster

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addCluster jbpm-domain-cluster
~~~

* Add nodes to the cluster

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode jbpm-domain-cluster server-one:12345
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addNode jbpm-domain-cluster server-two:12346
~~~

* Add resources to the cluster

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --addResource jbpm-domain-cluster vfs-repo-domain 1 LeaderStandby AUTO_REBALANCE
~~~

* Rebalance the cluster

~~~
./bin/helix-admin.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --rebalance jbpm-domain-cluster vfs-repo-domain 1
~~~

* Start the Helix controller

~~~
./bin/run-helix-controller.sh --zkSvr localhost:2181,localhost:2182,localhost:2183 --cluster jbpm-domain-cluster 2>&1 > ./controller.log &
~~~

## Setup quartz

Download [quartz-definition-mysql.properties]({{ site.baseurl }}/assets/download/jbpm/quartz-definition-mysql.properties) to wildfly-10.0.0.Final/clustering/quartz.
