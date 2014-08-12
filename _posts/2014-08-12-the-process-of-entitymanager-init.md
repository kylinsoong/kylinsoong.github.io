---
layout: blog
title:  "The Process of JPA EntityManager init"
date:   2014-08-12 17:14:12
categories: jee
author: Kylin Soong
duoshuoid: ksoong2014081202
---

EclipseLink is fully support JPA 2, this documents use EclipseLink as example, diving into the Process of JPA EntityManager initiation, we mainly focus on the below figure:


![architecture]({{ site.baseurl }}/assets/blog/entityManager-init.png)

* getAbstractSession()

Returns the ServerSession that the Factory will be using and initializes it if it is not available. 

* EntityManagerSetupImpl

This class handles deployment of a persistence unit.

In predeploy the meta-data is processed and weaver transformer is returned to allow weaving of the persistent classes.

In deploy the project and session are initialize and registered.

* setupImpl.deploy()

the call to setupImpl.deploy() finishes the session creation

* new TestMySQLPlatform()

This is database platform come from persistence.xml.

Each ServerSession hold a DatasourceLogin, set Platform to DatasourceLogin if we have condifured one via persistence.xml.

* login()

This will setup database connection pool for both write and read.

* writeDDL()

Generate the DDL using the correct connection.

`eclipselink.ddl-generation` is the threshold used to enable DDL Generation, for example, *drop-and-create-tables*.

* TableCreator

The DefaultTableGenerator is a utility class used to generate a default table schema, it hold a DatabasePlatform which initialized in updateLogins().


