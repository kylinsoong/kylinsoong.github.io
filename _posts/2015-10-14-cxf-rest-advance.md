---
layout: blog
title:  "Apache CXF jaxrs-advanced example"
date:   2015-10-14 15:47:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong2015101401
---

JAX-RS Advanced Example Architecture as below figure, it contain 4 layers, from top to bottom:

**Client Layer:** A simple Java Application, use the HTTP Centric and Proxy-based Apache CXF JAX-RS client API interact with Rest Service which provider by Service Layer

**Service Layer:** JAX-RS base Rest Service, contain multiple(two) root resource, run in WildFly Swarm on top of JVM

**Storage Layer:** JPA 2 + Hibernate 3 + Spring 4 based Storage Layer, use to query/save Database and return result to Service Layer.

**DB Layer:** A relational H2 database, use to persist Service/Storage Layer Data.

Note that, a client query procedure like: Client -> Servive -> Storage -> H2 -> Storage -> Servive -> Client. 

![Architecture]({{ site.baseurl }}/assets/blog/cxf-jaxrs-advanced.png)

JAX-RS Advanced Example use technologies including: JAXRS, JPA, Apache CXF, Spring, Hibernate, JAXB, WildFly-Swarm, undertow, H2 DataBase it demonstrates:

* How to implement multiple JAX-RS root resource classes and recursive JAX-RS sub-resources
* How to implement resource methods consuming and producing data in different formats (XML and JSON)
* How to implement JAX-RS ExceptionMappers for handling exceptions thrown from the application code
* How to implement JPA2 + Hibernate + Spring + H2 Database architecture
* How to use JAX-RS Response to return status, headers and optional entities
* How to use JAX-RS UriInfo and UriBuilder for returning the links to newly created resources
* How to use Apache CXF JAX-RS WebClient interact with Rest Service
* How to use Basic JAX-RS proxy interact with Rest Service
* How to use Apache CXF Search API to Query Rest Service

## Build

~~~
$ git clone git@github.com:kylinsoong/jaxrs-examples.git
$ cd jaxrs-examples/cxf/jaxrs-advanced/
$ mvn clean install
~~~

`service-swarm.jar` and `service.war` will be generate under 'service/target' folder.

## Run

Start JAX-RS Intro Service Provider via:

~~~
$ java -jar service/target/service-swarm.jar
~~~

> Alternatively, deploy `service.war` to a running WildFly Server.

Run [RESTClient](https://raw.githubusercontent.com/kylinsoong/jaxrs-examples/master/cxf/jaxrs-advanced/client/src/main/java/org/apache/cxf/rs/examples/RESTClient.java) as Java Application:

~~~
$ cd client/
$ mvn exec:java
~~~


