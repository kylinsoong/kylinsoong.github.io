---
layout: blog
title:  "Cassandra Quick Start"
date:   2014-08-29 17:10:00
categories: data
permalink: /cassandra-quickstart
author: Kylin Soong
duoshuoid: ksoong2014082901
---

## Quick installation

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

## create a keyspace and table

`bin/cqlsh` is an interactive command line interface for Cassandra. cqlsh allows you to execute CQL (Cassandra Query Language) statements against Cassandra. Run the following command to connect to your local Cassandra instance with cqlsh: 

~~~
$ bin/cqlsh
~~~

* To create the keyspace “demo”, at the CQL shell prompt, type:

~~~
cqlsh> CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
~~~

* To use the keyspace we’ve just created, type:

~~~
cqlsh> USE demo;
~~~

* Create a “users” table within the keyspace “demo” so that we can insert some data into our database:

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

## Java Client Quick Start 

Java Client can connect to Cassandra, The basic sample for connecting to Cassandra likes:

~~~
Cluster.Builder builder  = Cluster.builder().addContactPoint(address).withRetryPolicy(DefaultRetryPolicy.INSTANCE).withPort(port);
		
if(null != username && null != password) {
	builder.withCredentials(username, password);
}
		
this.cluster = builder.build();
this.metadata = cluster.getMetadata();
this.session = cluster.connect(keyspace);
~~~

[Here is the completed code](https://github.com/kylinsoong/data/blob/master/cassandra/quickstart/src/main/java/com/cassandra/quickstart/CassandraQuickStart.java), including INSERT, SELECT, DELETE operation.



