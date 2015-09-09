---
layout: blog
title:  "JAAS Authentication Tutorial"
date:   2015-09-09 19:20:12
categories: security
permalink: /jaas-auth
author: Kylin Soong
duoshuoid: ksoong2015090902
---

This article demonstrates how to run JAAS Authentication Tutorial in [http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/tutorials/GeneralAcnOnly.html](http://docs.oracle.com/javase/7/docs/technotes/guides/security/jaas/tutorials/GeneralAcnOnly.html).

## Get Code

~~~
$ git clone git@github.com:kylinsoong/security-examples.git
~~~

## Build

~~~
$ cd security-examples/jaas-authentication-tutorial
$ mvn clean install
~~~

## Run

~~~
$ java -Djava.security.auth.login.config=jaas.config -jar target/jaas-authentication-tutorial.jar 
user name: testUser
password: testPassword
		[SampleLoginModule] user entered user name: testUser
		[SampleLoginModule] user entered password: testPassword
		[SampleLoginModule] authentication succeeded
		[SampleLoginModule] added SamplePrincipal to Subject
Authentication succeeded!
~~~
