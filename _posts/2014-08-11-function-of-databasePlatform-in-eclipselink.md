---
layout: blog
title:  "The Function of EclipseLink DatabasePlatform"
date:   2014-08-11 17:14:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong20140811
---

This document describing the Function of DatabasePlatform in EclipseLink.

* DatabasePlatform is private to EclipseLink. It encapsulates behavior specific to a database platform(eg. Oracle, Sybase, DBase), and provides protocol for EclipseLink to access this behavior. The behavior categories which require platform specific handling are SQL generation and sequence behavior. While database platform currently provides sequence number retrieval behavior, this will move to a sequence manager (when it is implemented).

* **http://wiki.eclipse.org/Introduction_to_Data_Access_(ELUG)#Database_Platforms**

 EclipseLink interacts with databases using structured query language (SQL). Because each database platform uses its own variation on the basic SQL language, EclipseLink must adjust the SQL it uses to communicate with the database to ensure that the application runs smoothly. 

* [http://wiki.eclipse.org/EclipseLink/Features/JPA#DatabasePlatform](http://wiki.eclipse.org/EclipseLink/Features/JPA#DatabasePlatform)

EclipseLink's DatabasePlatform encapsulates database specific behavior. While EclipseLink ships with out of the box and extended support for all of the leading database it is also possible to author a custom platform or extend an existing platform to add custom behavior. The following are the capabilities defined by a database platform
