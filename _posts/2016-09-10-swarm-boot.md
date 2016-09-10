---
layout: blog
title:  "WildFly Swarm vs Spring Boot"
date:   2016-09-10 23:59:12
categories: jboss
permalink: /wildfly-swarm-spring-boot
author: Kylin Soong
duoshuoid: ksoong2016091001
excerpt: WildFly Swarm vs Spring Boot, statistics of get start rest service, range from 1 to 10
---

* Table of contents
{:toc}

## Overview

Both [Wildfly Swarm](http://wildfly-swarm.io/) and [Spring Boot](http://projects.spring.io/spring-boot/) are most influential project that ran Enterprise Java in Micro way. Spring Boot is easy and convenient for developers, Wildfly Swarm are good at compatible with protocol, MicroProfile is the protocol for enterprise in Micro world.

This article focus on a comparison example, collect some statistics, comment and score [Wildfly Swarm](http://wildfly-swarm.io/) and [Spring Boot](http://projects.spring.io/spring-boot/).

> NOTE: The viewpoint of this article only represent my personal thoughts, it's not canonical. Wildfly Swarm `2016.8.1` and Spring Boot `1.4.0.RELEASE` are used in this article.

## Hello World RESTful web service 

Hello World RESTful web service is the get start RESTful web service, what you build a service that will accept HTTP GET requests at:

_http://localhost:8080/greeting_

and respond with a JSON representation of a greeting:

~~~
{"id":1,"content":"Hello, World!"}
~~~

The Example Source code under [https://github.com/kylinsoong/gs-rest-service](https://github.com/kylinsoong/gs-rest-service), you'll find two modules, `wildfly-swarm` and `spring-boot`, its' structure are almost same, looks as below

![Hello World RESTful web service folder structure]({{ site.baseurl }}/assets/blog/wildfly/gs-rest-service-code.png)

Note that, from the picture, the code structure are totally same, the only difference is Wildfly Swarm use JEE protocol to implment Hello World RESTful service, and spring boot use spring based api to implment service. 

### Build and Run

**To build and run wildfly swarm Hello World RESTful web service:**

~~~
$ cd wildfly-swarm/
$ mvn clean install
$ java -jar target/gs-rest-service-swarm.jar
~~~

**To build and run spring boot Hello World RESTful web service:**

~~~
$ cd spring-boot
$ mvn clean install
$ java -jar target/gs-rest-service.jar
~~~

`http://localhost:8080/greeting` and `http://localhost:8080/greeting?name=User` are available for both wildfly swarm anf spring boot if build and run are sucessful.

## WildFly Swarm vs Spring Boot

### Statistics of get start rest service

![Hello World RESTful web service statistics]({{ site.baseurl }}/assets/blog/wildfly/gs-rest-service-statistics.png)

#### The final fat jar

For the final fat jar, WildFly Swarm are more complex than Spring Boot,

![Hello World RESTful web service statistics -1]({{ site.baseurl }}/assets/blog/wildfly/wildfly-swarm-vs-spring-boot-stat.png)

1. WildFly Swarm are 3 times of Spring boot in size
2. WildFly Swarm are 5 times of Spring boot in the numbers of jars
3. WildFly Swarm are 5 times of Spring boot in the numbers of files
4. WildFly Swarm are 30 times of Spring boot in the numbers of directories

### Comment and Score

I will comment and score WildFly Swarm and Spring from 1 - 10 on the 11 dimensions as below table, the result get from percentage:

![Hello World RESTful web service statistics -2]({{ site.baseurl }}/assets/blog/wildfly/gs-rest-service-score.png)

#### Conclusion

![Hello World RESTful web service score -1]({{ site.baseurl }}/assets/blog/wildfly/wildfly-swarm-spring-boot-comparison.png)	

Finally, spring boot got 90 and wildfly swarm got 59.

#### Why WildFly Swarm's fat jat are more complex

In the score table's first 4 row, the size of fat jat, the number of jars/files/directories in fat jar, the Spring Boot get high score than WildFly Swarm, that because class loading framework, WildFly Swarm use JBoss Modules which are more modular and dynamic, and Spring Boot use tradational flat class loading mechanism.

#### Spring Boot bootstrap are more complex

The `META-INF/MANIFEST.MF` of Spring Boot define a lots of logic, but WildFly Swarm only define bootstrap Main and Application Main.

#### Why Spring Boot get high score in Application Server Option

Spring Boot can use tomcat, jetty, undertow, which all these are high performance, more lightweight and most popular Application Server, WildFly Swarm use WildFly, which is a JEE certified Application Server.

#### Why WildFly Swarm get high score in suply functionality

On the one side, WildFly Swarm use WildFly as Application Server, which can expose all JEE related functionality, on the other side, almost all JBoss Products(Even some popular internet companey product) be integrared in WildFly Swarm, so WildFly Swarm can supply more functionality than Spring Boot.

#### Why WildFly Swarm and more complex in architecture

The JBoss Modules class loading are more complex than tradational flat class loading framework, the runtime application server layer, WildFly are more complex than tomcat/jetty/undertow.
