---
layout: blog
title:  "JBoss keycloak"
date:   2016-01-07 18:40:12
categories: jboss
permalink: /jboss-keycloak
author: Kylin Soong
duoshuoid: ksoong2016010701
excerpt: Diving into [keycloak](https://github.com/keycloak/keycloak) - Identity and Access Management for Modern Applications, Services and APIs  
---

* Table of contents
{:toc}

## Install from source code

~~~
$ git clone https://github.com/keycloak/keycloak.git
$ cd keycloak
$ mvn -Dmaven.test.skip=true clean install -Pdistribution
$ cd distribution/server-dist/target/
$ unzip keycloak-1.8.0.CR1-SNAPSHOT.zip
$ cd keycloak-1.8.0.CR1-SNAPSHOT/
$ ./bin/standalone.sh
~~~


