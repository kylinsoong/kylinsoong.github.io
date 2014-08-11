---
layout: blog
title:  "What's the Function of DatabasePlatform in EclipseLink"
date:   2014-08-11 17:14:12
categories: jee
author: Kylin Soong
duoshuoid: ksoong20140811
---

This document describing the Function of DatabasePlatform in EclipseLink.

* DatabasePlatform is private to EclipseLink. It encapsulates behavior specific to a database platform(eg. Oracle, Sybase, DBase), and provides protocol for EclipseLink to access this behavior. The behavior categories which require platform specific handling are SQL generation and sequence behavior. While database platform currently provides sequence number retrieval behavior, this will move to a sequence manager (when it is implemented).

* From [http://wiki.eclipse.org/Introduction_to_Data_Access_%28ELUG%29#Database_Platforms](http://wiki.eclipse.org/Introduction_to_Data_Access_%28ELUG%29#Database_Platforms), EclipseLink interacts with databases using structured query language (SQL). Because each database platform uses its own variation on the basic SQL language, EclipseLink must adjust the SQL it uses to communicate with the database to ensure that the application runs smoothly. 

* The type of database platform you choose determines the specific means by which the EclipseLink runtime accesses the database, including the type of Java Database Connectivity (JDBC) driver to use. JDBC is an application programming interface (API) that gives Java applications access to a database. EclipseLink relational projects rely on JDBC connections to read objects from, and write objects to, the database. EclipseLink applications use either individual JDBC connections or a JDBC connection pool (see Connection Pools), depending on the application architecture. 
