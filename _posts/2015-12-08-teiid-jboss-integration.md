---
layout: blog
title:  "Understanding Teiid JBoss Integration"
date:   2015-12-08 18:10:00
categories: teiid
permalink: /teiid-jboss-integration
author: Kylin Soong
duoshuoid: ksoong2015120801
---

[WildFly](http://wildfly.org) use a modular architecture, it assembled by a series of subsystems, each subsystem can be independent or dependent. From designing/programming aspect, it's independent and pluggable，no interface interaction/implementation between two subsystems, but from service/functionality aspect, it's dependent, one subsystem can depend on other subsystems' service. [Teiid](http://teiid.org) implement WildFly Core Management/Controller API as a WildFly subsystem, which depend on subsystems' service/functionality, supply a way to run Teiid in JBoss/WildFly container.

![Architecture of Teiid Subsystem]({{ site.baseurl }}/assets/blog/teiid-jboss-integration-architecture.png)

From above figure, the big rectangle is WildFly Container run on JVM, small colored rectangle are subsystems in Container, teiid subsysem depend on other sunsystems(datasources, resource-adapters, transactions, infinispan, security, undertow, logging). JDBC, ODBC, OData, REST are services which Teiid Supplied.

This article will focus on how Teiid and JBoss/WildFly be integrated, the main topic including:



