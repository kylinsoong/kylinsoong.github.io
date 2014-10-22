---
layout: blog
title:  "Use Mysql to store teiid command and audit log"
date:   2014-10-22 16:06:00
categories: teiid
permalink: /teiid-extentions-mysql
author: Kylin Soong
duoshuoid: ksoong2014102202
---

[Teiid Extensions](https://github.com/teiid/teiid-extensions) enable audit and command logging to the database, this article depict how use mysql database to store teiid command and audit log.

## Install Teiid Extensions with Mysql

* Maven build [teiid/teiid-extensions](https://github.com/teiid/teiid-extensions) and unzip the **build/target/build-${version}-dist.zip**, on to JBoss EAP installation.

For example, the following is commands unzip 0.0.1-SNAPSHOT to EAP:

~~~
unzip build-0.0.1-SNAPSHOT-dist.zip -d /home/kylin/work/jdv/jboss-eap-6.1
~~~

* Edit <jboss-eap-6.x>/bin/jboss-cli.xml and make sure the following property is set to true:

~~~
<resolve-parameter-values>false</resolve-parameter-values>
~~~

* Edit <jboss-eap-6.x>/bin/scripts/teiid-logger-ds.properties, make sure it point to a exist mysql database.

The following is a example configuration:

~~~
db.driver_name=mysql-connector-java-5.1.6.jar
db.url=jdbc:mysql://localhost:3306/jdv60
db.user=jdv_user
db.password=jdv_pass
~~~

> [http://ksoong.org/jboss-mysql/](http://ksoong.org/jboss-mysql/) have steps for setup mysql datasource in EAP 6

* Install Teiid Extensions via CLI

~~~
./jboss-cli.sh --file=scripts/teiid-add-database-logger.cli --properties=./scripts/teiid-logger-ds.properties
~~~

## Test Installation

Two ables will generate after installation, use show tables in mysql client have the following output:

~~~
mysql> show tables;
+--------------------+
| Tables_in_jdv60    |
+--------------------+
| auditlog           |
| commandlog         |
| hibernate_sequence |
+--------------------+
~~~

Execute a JDBC query against a exist VDB, then use the following SQL query commandlog table have the following output:

~~~
mysql> select id, applicationname, executionid, requestid, sessionid, sqlcmd from commandlog;
+----+-----------------+-------------+----------------+--------------+----------------------------------------------+
| id | applicationname | executionid | requestid      | sessionid    | sqlcmd                                       |
+----+-----------------+-------------+----------------+--------------+----------------------------------------------+
| 17 | JDBC            | NULL        | U57z7Jf+2uRo.0 | U57z7Jf+2uRo | SELECT * FROM Marketdata                     |
| 18 | NULL            | 4           | U57z7Jf+2uRo.0 | U57z7Jf+2uRo | EXEC FilesVDB.getTextFiles('marketdata.csv') |
| 19 | NULL            | 4           | U57z7Jf+2uRo.0 | U57z7Jf+2uRo | NULL                                         |
| 20 | NULL            | NULL        | U57z7Jf+2uRo.0 | U57z7Jf+2uRo | NULL                                         |
+----+-----------------+-------------+----------------+--------------+----------------------------------------------+
~~~
