---
layout: blog
title:  "WildFly Management Command Lines"
date:   2015-11-16 17:10:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015111601
excerpt: This article contains a series of WildFly CLI and reference introduction
---

* Table of contents
{:toc}

## Basic

### Invoking CLI commands

~~~
$ ./bin/jboss-cli.sh
~~~

## Runtime

### Checking the WildFly version

~~~
:read-attribute(name=release-version)
~~~

### Checking WildlyFly operational mode

~~~
:read-attribute(name=launch-type)
~~~

### Getting OS version

~~~
/core-service=platform-mbean/type=operating-system:read-resource(include-runtime=true,include-defaults=true)
~~~

### Getting JVM version

~~~
/core-service=platform-mbean/type=runtime:read-attribute(name=spec-version)
~~~

### Checking JVM options

~~~
/core-service=platform-mbean/type=runtime:read-attribute(name=input-arguments,include-defaults=true)
~~~

### Checking JVM memories

~~~
/core-service=platform-mbean/type=memory:read-attribute(name=heap-memory-usage,include-defaults=true)
/core-service=platform-mbean/type=memory-pool/name=Metaspace:read-resource(include-runtime=true,include-defaults=true)
/core-service=platform-mbean/type=memory-pool/name=PS_Eden_Space:read-resource(include-runtime=true,include-defaults=true)
/core-service=platform-mbean/type=memory-pool/name=PS_Survivor_Space:read-resource(include-runtime=true,include-defaults=true)
/core-service=platform-mbean/type=memory-pool/name=PS_Old_Gen:read-resource(include-runtime=true,include-defaults=true)
~~~

### Checking server status

~~~
:read-attribute(name=server-state)
~~~

### Checking JNDI tree view

~~~
/subsystem=naming:jndi-view()
~~~


