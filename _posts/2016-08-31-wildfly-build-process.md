---
layout: blog
title:  "Wildfly New Build Process"
date:   2016-08-31 18:40:12
categories: jboss
permalink: /wildfly-build
author: Kylin Soong
duoshuoid: ksoong2016083101
excerpt: Build WildFly Distribution from a small Feature Pack, Wildfly Build Process Example, wildfly-feature-pack-build-maven-plugin, wildfly-server-provisioning-maven-plugin
---

* Table of contents
{:toc}

## Overview

As below figure

![Wildfly Build Process]({{ site.baseurl }}/assets/slide/wildfly-feature-pack.png)

start from WildFly 9.0.0.Final, WildFly use the new build process:

1. The **dependencies**(defined in pom) and **modules**(contains module.xml files, these files not use <resource> references, but instead use references of the form: <artifact name="${groupId:artifactId}"/>) from code base be build to a **feature pack**(a lightweight artifact that contains a complete description of a set of server features, these feature packs can be provisioned into full servers) `wildfly-feature-pack-build-maven-plugin` 
2. Build the **dist** from **feature pack** via `wildfly-server-provisioning-maven-plugin`

This document will demonstrate Wildfly New Build Process via a example.

## Example

![Wildfly Build Process Example]({{ site.baseurl }}/assets/blog/wildfly/wildfly-build-process-example.png)

As the figure, Wildfly Build Process Example use a wildfly liked structure, contain 3 modules.

### Download

[build-process.zip]({{ site.baseurl }}/assets/download/files/build-process.zip).

### Build

~~~
$ unzip build-process.zip
$ cd build-process/
$ mvn clean install
~~~

Once build success, you can get **feature pack**(`feature-pack/target/build-example-feature-pack-1.0.0-SNAPSHOT.zip`), and **dist**(`dist/target/build-example-1.0.0-SNAPSHOT.zip`).

### Run

~~~
$ cd dist/target/build-example-1.0.0-SNAPSHOT/
$ ./bin/run.sh
~~~

## Why use new build process

I think there are several aspects advantage if use new build process:

Firstly, More efficient, in previous, the module.xml use resource reference to a root jar, eg,

~~~
<resources>
    <resource-root path="teiid-admin-${project.version}.jar" />
</resources>
~~~

you have to consider the jar's version, and try to copy reference jar in build dist

~~~
<dependencySet>
    <outputDirectory>${wildfly-module-root}/org/jboss/teiid/admin/main</outputDirectory>
    <includes>
        <include>org.jboss.teiid:teiid-admin</include>
    </includes>
    <useProjectArtifact>false</useProjectArtifact>
</dependencySet>
~~~

but in new build process, you don't need pay attention to version control and hard copy, maven plugin can do this.

Also it's time saving if you want to build more dist, in previous, you have to unzip more dist to a new folder and zip again, but now you just need config provisioning plugin, like configue dependency, then maven plugin will generate server dist. Eg, if you have `teiid-feature-pack` and `wildfly-feature-pack`, confgiure these 2 to provisioning plugin, the plugin will generate you a server dist.

