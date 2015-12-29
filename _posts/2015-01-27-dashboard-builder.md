---
layout: blog
title:  "Debug dashboard-builder"
date:   2015-01-27 18:40:12
categories: jboss
permalink: /dashboard-builder
author: Kylin Soong
duoshuoid: ksoong20150127
---

* Table of contents
{:toc}

## Objectives

This article is a supplement of Dashbuilder's document on [dashbuilder.org](http://www.dashbuilder.org/) and [github.com/kylinsoong/dashboard-builder](https://github.com/kylinsoong/dashboard-builder), primary purpose including:

* Build [Dashbuilder](https://github.com/kylinsoong/dashboard-builder) from source code
* Debug source code under [dashboard-builder](https://github.com/droolsjbpm/dashboard-builder/tree/master/modules).
* Trial Dashbuilder on WildFly

## Deploy dashboard-builder to WildFly

### Build from source code

~~~
$ git clone git@github.com:kylinsoong/dashboard-builder.git
$ cd dashboard-builder/
$ mvn clean install -P h2,jetty -DskipTests
$ cd builder/
$ mvn clean install
~~~

Execute above commands will generate `dashbuilder-VERSION-wildflyX.war` under 'dashboard-builder/builder/target' folder, this war need deploy to a running WildFly Server.

### Create User

Navigate to WildFly Home, execute the following commands to create two user:

~~~
$ ./bin/add-user.sh -a -u root -p password1! -g admin
$ ./bin/add-user.sh -a -u user -p password1! -g user
~~~

### Run the Dashboard Builder

Once WildFly id running, `dashbuilder-VERSION-wildflyX.war` deployed success, login Dashboard Builder via

    http://localhost:8080/dashbuilder

and use the recently created user `root/password1!` as below figure:

![Dashboard Builder Login]({{ site.baseurl }}/assets/blog/dashbuilder-login.png)

## Use Mysql with dashboard-builder

* [Step by step procedure](https://github.com/droolsjbpm/dashboard-builder/blob/master/builder/src/main/wildfly8/README.md)
* [Set up Datasource](https://github.com/jbosschina/wildfly-dev-cookbook/blob/master/persistence/create-ds-mysql.cli)

## ControllerServlet init

ControllerServlet is the entry point for UI request, all request as below will go to ControllerServlet, this section dive into ControllerServlet init

* /workspace/*
* /jsp/*
* /kpi/*

**init App Directories** 

The following directory fields be added to `org.jboss.dashboard.Application`:

* tmp/vfs/temp/temp7e145d2fd5273f6a/dashbuilder-6.3.0-SNAPSHOT-wildfly8.war-c7ba2b28938c64da
* tmp/vfs/temp/temp7e145d2fd5273f6a/dashbuilder-6.3.0-SNAPSHOT-wildfly8.war-c7ba2b28938c64da/WEB-INF/etc
* tmp/vfs/temp/temp7e145d2fd5273f6a/dashbuilder-6.3.0-SNAPSHOT-wildfly8.war-c7ba2b28938c64da/WEB-INF/lib

**Startable Start**

* `org.jboss.dashboard.database.hibernate.HibernateInitializer`
* `org.jboss.dashboard.cluster.ClusterNodesManager`
* `org.jboss.dashboard.workspace.SkinsManagerImpl`
* `org.jboss.dashboard.workspace.PanelsProvidersManagerImpl`
* `org.jboss.dashboard.workspace.EnvelopesManagerImpl`
* `org.jboss.dashboard.workspace.LayoutsManagerImpl`
* `org.jboss.dashboard.ui.resources.ResourceManagerImpl`
* `org.jboss.dashboard.security.UIPolicy`
* `org.jboss.dashboard.DeploymentScanner`
* `org.jboss.dashboard.initialModule.InitialModulesManager`

**Hibernate cfg**

~~~
org/jboss/dashboard/ui/resources/GraphicElement.hbm.xml
org/jboss/dashboard/workspace/Workspace.hbm.xml
org/jboss/dashboard/workspace/PanelParameter.hbm.xml
org/jboss/dashboard/workspace/Panel.hbm.xml
org/jboss/dashboard/workspace/PanelInstance.hbm.xml
org/jboss/dashboard/workspace/Section.hbm.xml
org/jboss/dashboard/database/InstalledModule.hbm.xml
org/jboss/dashboard/database/DataSourceEntry.hbm.xml
org/jboss/dashboard/cluster/ClusterNode.hbm.xml
org/jboss/dashboard/security/PermissionDescriptor.hbm.xml
org/jboss/dashboard/ui/panel/advancedHTML/HtmlCode.hbm.xml
org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceTableEntry.hbm.xml
org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceColumnEntry.hbm.xml
org/jboss/dashboard/provider/DataProvider.hbm.xml
org/jboss/dashboard/kpi/KPI.hbm.xml
~~~

## HibernateInitializer

[org.jboss.teiid.dashboard.hibernate.HibernateInitializerTest](https://github.com/kylinsoong/teiid-samples/blob/master/dashboard/src/main/java/org/jboss/teiid/dashboard/hibernate/HibernateInitializerTest.java)


