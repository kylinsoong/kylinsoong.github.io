---
layout: blog
title:  "jBPM use Mysq replace default h2"
date:   2017-01-14 17:15:12
categories: jbpm
permalink: /jbpm-mariadb
author: Kylin Soong
duoshuoid: ksoong2017011401
excerpt: Install Mysql on Linux and create jbpm database, Set up Mysql Data Source, Switch from h2 to mysql
---

jBPM default configured to use an example h2 data source, this not suitable for production. This section including setps of switch to mysql from default h2.

* Table of contents
{:toc}

## Install Mysql on Linux and create jbpm database

* Install Mysql on Linux via:

~~~
yum install mysql
~~~

* Start Mysql in Linux via:

~~~
service mysqld start
~~~

* Log into mysql with root user, create database, user and grant privileges

~~~
CREATE DATABASE jbpm;
CREATE USER 'jbpm_user'@'%' IDENTIFIED BY 'jbpm_pass';
GRANT ALL PRIVILEGES ON jbpm.* TO 'jbpm_user'@'%';
~~~

* Log into mysql with jbpm_user import the DDL script to jbpm database

~~~
mysql -u jbpm_user -p jbpm < ~/work/jbpm/jbpm-installer/db/ddl-scripts/mysql5/quartz_tables_mysql.sql
~~~

## Set up Mysql Data Source

Download mysql driver (http://dev.mysql.com/downloads/connector/) to WFY_HOME/installation, assume `mysql-connector-java-5.1.38.jar` be downloaded.

* Add Mysql Driver as a Module

Assume [module-add-mysql.cli]({{ site.baseurl }}/assets/download/jbpm/module-add-mysql.cli) already be copy to WFY_HOME/installation, make sure WildFly Server is running and execute:

~~~
./bin/jboss-cli.sh --connect --file=installation/module-add-mysql.cli
~~~

* Create Mysql Data Source

Assume [create-mysql-ds.cli]({{ site.baseurl }}/assets/download/jbpm/create-mysql-ds.cli) already be copy to WFY_HOME/installation, make sure WildFly Server is running and execute:

~~~
./bin/jboss-cli.sh --connect --file=installation/create-mysql-ds.cli
~~~

> NOTE: If above cli execute success, you will find the output like "result" ⇒ [true], if failed, please check the database name, user, passward, etc. 

### Amend Data Source

If want to chenge datasource url, log into CLI console, execute

~~~
./bin/jboss-cli.sh --connect
/subsystem=datasources/data-source=MysqlDS:write-attribute(name=connection-url,value="jdbc:mysql://191.168.1.101:3306/jbpm")
/subsystem=datasources/data-source=quartzNotManagedDS:write-attribute(name=connection-url,value="jdbc:mysql://191.168.1.101:3306/jbpm")
~~~

## Switch from h2 to mysql

Make sure WildFly Server is shut dwon, navigate to WildFly Home, Edit `standalone/deployments/jbpm-console.war/WEB-INF/classes/META-INF/persistence.xml`,

* Locate the <jta-data-source> tag and change it to the JNDI name of your data source, for example:

~~~
<jta-data-source>java:jboss/datasources/MysqlDS</jta-data-source>
~~~

* Locate the <properties> tag and change the hibernate.dialect property, for example:

~~~
<property name="hibernate.dialect" value="org.hibernate.dialect.MySQL5Dialect" />
~~~

* Assume [switch-kie-server.cli]({{ site.baseurl }}/assets/download/jbpm/switch-kie-server.cli) already be copy to WFY_HOME/installation, make sure WildFly Server is running and execute:

~~~
./bin/jboss-cli.sh --connect --file=installation/switch-kie-server.cli
~~~

* Restart WildFly Server, to make sure the switch work fine.
