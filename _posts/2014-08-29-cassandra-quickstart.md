---
layout: blog
title:  "Cassandra Quick Start"
date:   2017-02-03 17:10:00
categories: data
permalink: /cassandra-quickstart
author: Kylin Soong
duoshuoid: ksoong2017020301
---

This article contain Cassandra quick installation, basic commands of create keyspace and table, and a samples for how Java Application connect to Cassandra.

* Table of contents
{:toc}

## Quick installation

### Install cassandra 2.x to RHEL

Download one of stable version from [http://archive.apache.org/dist/cassandra/](http://archive.apache.org/dist/cassandra/), for example 2.0.1. Installing via unzip:

~~~
tar -xvf apache-cassandra-2.0.1-bin.tar.gz
~~~

Start Cassandra via invoking 'bin/cassandra -f'.

Edit `conf/cassandra.yaml`, change rpc_address from localhost to a IP address,

~~~
rpc_address: 10.66.218.46
~~~

this is necessary for remote connect.

### Install cassandra 3.9 to RHEL

* Download cassandra from http://cassandra.apache.org/

~~~
wget http://mirrors.ibiblio.org/apache/cassandra/3.9/apache-cassandra-3.9-bin.tar.gz
~~~

* Install Cassandra via extract tar file

~~~
tar -xvf apache-cassandra-3.9-bin.tar.gz
~~~

* Edit `conf/cassandra.yaml`, change rpc_address from localhost to a IP address,

~~~
rpc_address: 10.66.192.120
~~~

* Change into the cassandra home, start cassandra via

~~~
./bin/cassandra -f
~~~

## create a keyspace and table

`bin/cqlsh` is an interactive command line interface for Cassandra. cqlsh allows you to execute CQL (Cassandra Query Language) statements against Cassandra. Run the following command to connect to your local Cassandra instance with cqlsh: 

~~~
$ bin/cqlsh
~~~

* To create the keyspace "demo", at the CQL shell prompt, type:

~~~
cqlsh> CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
~~~

* To use the keyspace we’ve just created, type:

~~~
cqlsh> USE demo;
~~~

* Create a “users” table within the keyspace "demo" so that we can insert some data into our database:

~~~
cqlsh> CREATE TABLE users (
firstname text,
lastname text,
age int,
email text,
city text,
PRIMARY KEY (lastname));
~~~

* Type ENTER after each statement to insert the row into the table:

~~~
cqlsh:demo> INSERT INTO users (firstname, lastname, age, email, city) VALUES ('John', 'Smith', 46, 'johnsmith@email.com', 'Sacramento');
cqlsh:demo> INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Jane', 'Doe', 36, 'janedoe@email.com', 'Beverly Hills');
cqlsh:demo> INSERT INTO users (firstname, lastname, age, email, city) VALUES ('Rob', 'Byrne', 24, 'robbyrne@email.com', 'San Diego');
~~~

* Now that we have a few rows of data in our table, let’s perform some queries against it. Using a SELECT statement will let us take a peek inside our table. To see all the rows from the users table we’ve created, type:

~~~
cqlsh:demo> SELECT * FROM users;
~~~

* Get the user record for the individual with the last name “Doe”

~~~
cqlsh:demo> SELECT * FROM users WHERE lastname= 'Doe';
~~~

* We can delete a row of data using the DELETE command:

~~~
cqlsh:demo> DELETE from users WHERE lastname = “Doe”;
~~~

## An example of using Datastax Java Driver 

### Add Maven Driver dependency

~~~
<dependency>
    <groupId>com.datastax.cassandra</groupId>
    <artifactId>cassandra-driver-core</artifactId>
    <version>3.1.3</version>
</dependency>
~~~ 

### Build a Cluster via address, port, username, password

~~~
Cluster cluster = Cluster.builder()
        .addContactPoint("10.66.192.120")
        .withPort(9042)
        .withCredentials("user", "password")
        .build();
~~~

### Metadata

~~~
Metadata metadata = cluster.getMetadata();
System.out.println(metadata.getClusterName());
metadata.getKeyspaces().forEach(km -> {
    System.out.println(km.getName());
    km.getTables().forEach(t -> System.out.println("    " + t.getName() + ", " + t.getId()));
});
~~~

> NOTE: This will print Keyspaces and the tables, by default Cassandra contains Keyspaces: `system_traces`, `system`, `system_distributed`, `system_schema`, `system_auth`.

### Session with DML

~~~
Session session = cluster.connect("demo");
~~~

#### Insert

~~~
sql = "INSERT INTO users (lastname, age, city, email, firstname) VALUES ('Soong', 29, 'Beijing', 'ksoong@redhat.com', 'Kylin')";
session.execute(sql);
~~~

#### Select

~~~
sql = "SELECT * FROM users";
ResultSet results = session.execute(sql);
results.forEach(row -> System.out.format("    %s %d\n", row.getString("firstname"),row.getInt("age")));
~~~

#### Delete

~~~
sql = "DELETE FROM users WHERE lastname = 'Soong'";
session.execute(sql);
~~~

### ProtocolVersion

~~~
ProtocolVersion version = session.getCluster().getConfiguration().getProtocolOptions().getProtocolVersion();
System.out.println(version);
~~~

### Executing Batch

~~~
List<String> updates = new ArrayList<String>();
updates.add("INSERT INTO users (lastname, age, city, email, firstname) VALUES ('Soong', 30, 'Beijing', 'ksoong@redhat.com', 'Kylin')");

BatchStatement bs = new BatchStatement();
updates.forEach(update -> bs.add(new SimpleStatement(update)));
session.executeAsync(bs);
~~~

### Executing Batch with bindng values

~~~
List<Object[]> values = new ArrayList<>();
values.add(new Object[]{"Soong", 30, "Beijing", "ksoong@redhat.com", "Kylin"});
sql = "INSERT INTO users (lastname, age, city, email, firstname) VALUES (?, ?, ?, ?, ?)";
PreparedStatement ps = session.prepare(sql);
values.forEach(v -> {
    BoundStatement bound = ps.bind(v);
    bs.add(bound);
});
session.executeAsync(bs);
~~~
