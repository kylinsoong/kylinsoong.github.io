---
layout: blog
title:  "Hive Use MariaDB as Remote Metastore Database"
date:   2015-11-08 15:00:00
categories: data
permalink: /hive-metastore-mysql
author: Kylin Soong
duoshuoid: ksoong201511081
excerpt: Steps for Hive Use MariaDB as Remote Metastore Database
---

This article demonstrates how to use MariaDB as Remote Metastore Database. 

## Prepare MariaDB

Use the following commands create a `hive` database and `hive_user` in MariaDB

~~~
CREATE DATABASE hive;
create user 'hive_user'@'localhost' identified by 'hive_pass';
grant all on hive.* to hive_user@'localhost';
FLUSH PRIVILEGES;
~~~

Copy MariaDB JDBC Driver to HIVE_HOME/lib

~~~
$ cp mariadb-java-client-1.2.3.jar ~/server/apache-hive-1.2.1-bin/lib/
~~~

## Configuration

Edit conf/hive-site.xml, configure the following properties to map to above database name, database user and password:

~~~
<property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://localhost:3306/hive</value>
</property>
<property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.mariadb.jdbc.Driver</value>
</property>
<property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hive_user</value>
</property>
<property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>hive_pass</value>
</property>
~~~
