---
layout: blog
title:  "WildFly Swarm Get Start Tips"
date:   2016-07-14 18:40:12
categories: jboss
permalink: /wildfly-swarm
author: Kylin Soong
duoshuoid: ksoong2016071401
excerpt: WildFly Swarm Get Start Tips
---

* Table of contents
{:toc}

## System Properties

### swarm.debug.bootstrap

Add `-Dswarm.debug.bootstrap=true` before start swarm Container will enable bootstrap modules related detailed log.

### swarm.project.stage.file

Add `-Dswarm.project.stage.file=/path/to/stage-file` before start swarm Container will use a pre-configured stage file, more details about Project Stages refer to [Configuration overlays using stage properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/content/configuration/project_stages.html).

### swarm.http.eager

Add `-Dswarm.http.eager=true` to enable eagerly Open

### swarm.node.id

Add `-Dswarm.node.id={node id}` define the swarm node id, alternatively.

### swarm.bind.address

Add `-Dswarm.bind.address={ip addr}` to bind servers, defaults to 0.0.0.0

### swarm.port.offset

Add `-Dswarm.port.offset={number}` to set a global port adjustment, defaults to 0

### swarm.http.port

Add `-Dswarm.http.port={port}` to set he HTTP port to be used, defaults to 8080.

## How to enable more log

System properties with the prefix `swarm.log.` can enable more log, eg: -Dswarm.log.org.wildfly.swarm=DEBUG

All available log levels are:

~~~
NONE
ERROR
WARN
INFO
DEBUG
TRACE
ALL
~~~

## BootModuleLoader

BootModuleLoader used for class loading, it extends jboss modules's ModuleLoader, defines the following Module Finders:

* BootstrapClasspathModuleFinder
* BootstrapModuleFinder
* ClasspathModuleFinder
* ApplicationModuleFinder
* FlattishApplicationModuleFinder

## SelfContainedContainer start

Swarm RuntimeServer invoke SelfContainedContainer's start() method, then set up MSC container.

![SelfContainedContainer start]({{ site.baseurl }}/assets/blog/wildfly/swarm-container.png)




