---
layout: blog
title:  "Maven Commands Gallery"
date:   2015-09-09 18:20:12
categories: maven
permalink: /maven-commands
author: Kylin Soong
duoshuoid: ksoong2015090901
---

This documents coontains a series Maven Commands usage sample and function depiction.

### archetype

~~~
mvn archetype:create 
  -DgroupId=[your project's group id]
  -DartifactId=[your project's artifact id]
~~~

### dependency

**Copy Dependencies**

~~~
$ mvn dependency:copy-dependencies
~~~

**List Dependencies**

~~~
$ mvn dependency:list
~~~

**Dependencies Tree**

~~~
$ mvn dependency:tree
~~~
