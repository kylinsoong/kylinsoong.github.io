---
layout: blog
title:  "Get Start Teiid From Source Code"
date:   2016-04-06 17:00:00
categories: teiid
permalink: /teiid-getstart-code
author: Kylin Soong
duoshuoid: ksoong2016040601
excerpt: Teiid is a Open Source Data Virtulization Platform, which means the souce code are totally open, this article will guide you to get start teiid from source code.
---

* Table of contents
{:toc}

## Install from source code

### To build Teiid

The following are prerequisites to build Teiid:

1. install JDK 1.7 or higher
2. install maven 3 - [http://maven.apache.org/download.html](http://maven.apache.org/download.html)
3. Set Up Git - [https://help.github.com/articles/set-up-git/](https://help.github.com/articles/set-up-git/)
4. Create a github account and fork Teiid

Enter the following:

~~~
$ git clone https://github.com/<yourname>/teiid.git
$ cd teiid
$ mvn clean install -P release -Dmaven.javadoc.skip=true -s settings.xml
~~~

### To install Teiid
Standalone Mode

~~~
$ unzip build/target/teiid-9.0.0.Alpha3-SNAPSHOT-wildfly-server.zip
$ cd teiid-9.0.0.Alpha3-SNAPSHOT/
$ ./bin/standalone.sh  
$ ./bin/jboss-cli.sh --connect --file=bin/scripts/teiid-standalone-mode-install.cli  
~~~
Domain Mode

~~~
$ unzip build/target/teiid-9.0.0.Alpha3-SNAPSHOT-wildfly-server.zip
$ cd teiid-9.0.0.Alpha3-SNAPSHOT/
$ ./bin/domain.sh  
$ ./bin/jboss-cli.sh --connect --file=bin/scripts/teiid-domain-mode-install.cli 
~~~

## Create User

The User including dashboardUser, teiidUser, restUser, odataUser, ManagementUser, use create-user script to create:

~~~
$ ./bin/add-user.sh -a -u dashboardAdmin -p password1! -g admin  
$ ./bin/add-user.sh -a -u teiidUser -p password1! -g user  
$ ./bin/add-user.sh -a -u restUser -p password1! -g rest  
$ ./bin/add-user.sh -a -u odataUser -p password1! -g odata  
$ ./bin/add-user.sh admin password1!  
~~~

## Run Quick Start

If teiid-quickstart not exist under WildFly Home, Clone it to WildFly Home:

~~~
$ git clone https://github.com/teiid/teiid-quickstarts.git
~~~ 

### dynamicvdb-datafederation

~~~
$ cp -r teiid-quickstarts/dynamicvdb-datafederation/src/teiidfiles/ ./
$ ./bin/jboss-cli.sh --connect --file=teiid-quickstarts/dynamicvdb-datafederation/src/scripts/setup.cli
$ cd standalone/deployments/
$ cp ../../teiid-quickstarts/dynamicvdb-datafederation/src/vdb/portfolio-vdb.xml* ./
~~~

[PortfolioCient](https://github.com/kylinsoong/teiid-test/blob/master/client/src/main/java/org/teiid/test/jdbc/client/PortfolioCient.java)

### dynamicvdb-materialization

~~~
$ cd standalone/deployments/
$ cp ../../teiid-quickstarts/dynamicvdb-materialization/src/vdb/portfolio* ./
~~~

[PortfolioMaterializeClient](https://github.com/kylinsoong/teiid-test/blob/master/client/src/main/java/org/teiid/test/jdbc/client/PortfolioMaterializeClient.java)

[PortfolioInterMaterializeClient](https://github.com/kylinsoong/teiid-test/blob/master/client/src/main/java/org/teiid/test/jdbc/client/PortfolioInterMaterializeClient.java)
