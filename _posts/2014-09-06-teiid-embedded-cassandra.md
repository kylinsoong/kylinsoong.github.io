---
layout: blog
title:  "Teiid embedded samples Cassandra"
date:   2014-09-06 17:00:00
categories: teiid
permalink: /teiid-cassandra
author: Kylin Soong
duoshuoid: ksoong2014090601
---

Teiid Embedded is a light-weight version of Teiid, it contain an easy-to-use JDBC Driver that can embed the Query Engine in any Java application. The Embedded mode supply almost all Teiid features without JEE Container involved, it supply a convenient way for Users who want integrate Teiid with their Application.

This document show how Teiid Embedded use Cassandra as data source, the architecture as below:

![teiid-embed-cassandra]({{ site.baseurl }}/assets/blog/teiid-embed-cassandra.png)

## Cassandra

Cassandra be used in this example, as in [Cassandra Quick Start]({{ site.baseurl }}/cassandra-quickstart), Cassandra Contact Point host on *10.66.218.46*, table `users` exist in keyspace `demo`, we have the following data inserted:

~~~
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('John', 'Smith', 46, 'johnsmith@email.com', 'Sacramento');
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Jane', 'Doe', 36, 'janedoe@email.com', 'Beverly Hills');
INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Rob', 'Byrne', 24, 'robbyrne@email.com', 'San Diego');
~~~

## users VDB

A Virtual Database (VDB) is an artifact that defines the logical schema model combining one or more physical data sources to provide easy data integration. In this example, users VDB has Model `UsersView` point to Cassandra table `users`. 

[The completed content of users VDB](https://github.com/jbosschina/teiid-embedded-samples/blob/master/vdb/cassandra-vdb.xml)

## JVM

Java Application run on JVM, load the `users VDB` and query via JDBC. The mainly Code Snippets:

~~~
init("translator-cassandra", new CassandraExecutionFactory());
		
CassandraManagedConnectionFactory managedconnectionFactory = new CassandraManagedConnectionFactory();
managedconnectionFactory.setAddress(ADDRESS);
managedconnectionFactory.setKeyspace(KEYSPACE);
server.addConnectionFactory("java:/demoCassandra", managedconnectionFactory.createConnectionFactory());
		
start(false);
		
server.deployVDB(new FileInputStream(new File("vdb/cassandra-vdb.xml")));
		
conn = server.getDriver().connect("jdbc:teiid:users", null);
~~~

[Completed Source code](https://github.com/jbosschina/teiid-embedded-samples/blob/master/src/test/java/com/teiid/embedded/samples/cassandra/TestCassandraDataSource.java)

