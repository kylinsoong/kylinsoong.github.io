---
layout: blog
title:  "Apache CXF jaxrs-intro example"
date:   2015-10-13 17:00:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong2015101301
---

JAX-RS Intro Example use technologies including: JAXRS, Apache CXF, Spring, JAXB, WildFly-Swarm, undertow, it demonstrates:

* How to use wildfly-swarm-undertow run simple web application
* How to implement Apache CXF JAXRS in WildFly as a service provider.
* How to expose GET (to retrieve a single Member and all Members), PUT (for updates - both single-field and multiple-field), POST (for inserts) resources, subresources in a service resource provider.
* How to use CXF JAX-RS WebClient to interact with Restful Service.

## Build

~~~
$ git clone git@github.com:kylinsoong/jaxrs-examples.git
$ cd jaxrs-examples/cxf/jaxrs-intro/
$ mvn clean install
~~~

`service-swarm.jar` and `service.war` will be generate under 'service/target' folder.

## Run

Start JAX-RS Intro Service Provider via:

~~~
$ java -jar service/target/service-swarm.jar
~~~

> Alternatively, deploy `service.war` to a running WildFly Server.

Run [RESTClient](https://raw.githubusercontent.com/kylinsoong/jaxrs-examples/master/cxf/jaxrs-intro/client/src/main/java/org/apache/cxf/rs/examples/RESTClient.java) as Java Application:

~~~
$ cd client/
$ mvn exec:java
~~~


