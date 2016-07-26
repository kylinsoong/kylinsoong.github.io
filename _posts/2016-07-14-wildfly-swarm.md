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

## Maven plugins in swarm

### wildfly-swarm-fraction-plugin

A fraction in wildfly-swarm-fraction-plugin represent a maven assets, which consisted by groupId, artifactId and version. wildfly-swarm-fraction-plugin has defined several mojo goals, including:

* **fraction-list** - Used to generate fractions descriptors, refer to [how fraction list works](#how-fraction-list-works) for details.
* **process** - , refer to [how process works](#how-process-works) for details 

#### how fraction-list works

If configu fraction plugin as below

~~~
<plugin>
     <groupId>org.wildfly.swarm</groupId>
     <artifactId>wildfly-swarm-fraction-plugin</artifactId>
     <executions>
       <execution>
         <id>fraction-list</id>
         <phase>generate-resources</phase>
         <goals>
           <goal>fraction-list</goal>
         </goals>
       </execution>
     </executions>
</plugin>
~~~

then the plugin mainly do 2 apsects work:

Firstly, the plugin 

1. collect all dependencies which defined in dependencyManagement
2. filter all dependencies which groupId start with `org.wildfly.swarm`
3. convert all dependencies to MavenProjects
4. filter all MavenProjects which project has defined any of these 3 properties(`swarm.fraction.stability`, `swarm.fraction.tags`, `swarm.fraction.internal`).
5. convert all MavenProjects to fractions and keep in a map(groupId:artifactId -> fraction)
6. create a org.wildfly.swarm, container fraction, and put it to map, and set all fractions dependent on container fraction.

Secondly, generate fractions descriptors

* generate a `fraction-list.txt` under classspath, a example line in `fraction-list.txt`:

~~~
org.wildfly.swarm:jaxrs:2016.7-SNAPSHOT = org.wildfly.swarm:ee:2016.7-SNAPSHOT, org.wildfly.swarm:request-controller:2016.7-SNAPSHOT, org.wildfly.swarm:security:2016.7-SNAPSHOT, org.wildfly.swarm:naming:2016.7-SNAPSHOT, org.wildfly.swarm:undertow:2016.7-SNAPSHOT, org.wildfly.swarm:io:2016.7-SNAPSHOT, org.wildfly.swarm:logging:2016.7-SNAPSHOT, org.wildfly.swarm:container:2016.7-SNAPSHOT
org.wildfly.swarm:connector:2016.7-SNAPSHOT = org.wildfly.swarm:container:2016.7-SNAPSHOT
~~~

> NOTE: `fraction-list.txt` contain all fractions and it's depdencies, in above, `jaxrs` depend on `ee`, `request-controller`, `security`, `naming`, `undertow`, `io`, `logging`, `container`. and `connector` only depend on `container`.

* generate a `fraction-list.json` under classpath, a example line in `fraction-list.json`:

~~~
 {
  "groupId" : "org.wildfly.swarm",
  "artifactId" : "jaxrs",
  "version" : "2016.7-SNAPSHOT",
  "name" : "JAX-RS",
  "description" : "RESTful Web Services with RESTEasy",
  "tags" : "JavaEE,Web",
  "internal" : false,
  "stabilityIndex" : 3,
  "stabilityDescription" : "stable"
},
{
  "groupId" : "org.wildfly.swarm",
  "artifactId" : "connector",
  "version" : "2016.7-SNAPSHOT",
  "name" : "Connector",
  "description" : "Connector",
  "tags" : "",
  "internal" : true,
  "stabilityIndex" : 3,
  "stabilityDescription" : "stable"
}
~~~

> NOTE: `fraction-list.json` contains all fractions, as above are `jaxrs` and `connector` fractions. 

* generate a `fraction-list.js` under classpath, this file only contain one line, as below

~~~
fractionList = [{"groupId":"org.wildfly.swarm","artifactId":"jaxrs","version":"2016.7-SNAPSHOT","name"    :"JAX-RS","description":"RESTful Web Services with RESTEasy","tags":"JavaEE,Web","internal":false,"stabilityIndex":3,"stabilityDescription":"stable"},{"groupId":"org.wildfly.swarm","artifactId":"connector","version":"2016.7-SNAPSHOT"    ,"name":"Connector","description":"Connector","tags":"","internal":true,"stabilityIndex":3,"stabilityDescription":"stable"}]
~~~

> NOTE: fractionList in `fraction-list.js` contains all fractions, in above only contain `jaxrs` and `connector` fractions.

#### how process works

If configu fraction plugin as below

~~~
<plugin>
  <groupId>org.wildfly.swarm</groupId>
  <artifactId>wildfly-swarm-fraction-plugin</artifactId>
  <executions>
    <execution>
      <id>process</id>
      <phase>process-classes</phase>
      <goals>
        <goal>process</goal>
      </goals>
    </execution>
  </executions>
</plugin>
~~~

then the process task do the following:

1. Generate modules - this depend on a `module.conf` file which under project base directory. In this file, every line define a module, eg, `org.apache.camel export=true services=export`. All this lines of modules be used as new created modules' dependencies.
2. Set up bootstrap - this will create a `wildfly-swarm-bootstrap.conf` under classpath, which comtain the module created in step 1.
3. Generate Provided Dependencies - this depend on `provided-dependencies.txt` which under resources dir. This step will create `META-INF/wildfly-swarm-classpath.conf` which contains all dependences.`
4. Filter Modules - this depend on `module-rewrite.conf` 

