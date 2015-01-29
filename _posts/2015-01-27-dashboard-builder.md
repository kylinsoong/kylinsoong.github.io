---
layout: blog
title:  "Debug dashboard-builder"
date:   2015-01-27 18:40:12
categories: jboss
permalink: /dashboard-builder
author: Kylin Soong
duoshuoid: ksoong20150127
---

This article show some viewpoints for how [dashboard-builder](https://github.com/droolsjbpm/dashboard-builder/tree/master/modules) works.

## Deploy dashboard-builder to WildFly

* Clone the source code via `git clone git@github.com:droolsjbpm/dashboard-builder.git`
* Build modules via `./build.sh h2`
* Execute Maven command `mvn clean install -Dfull -DskipTests` under `builder` directory will generate `dashbuilder-6.3.0-SNAPSHOT-wildfly8.war`
* Deploy `dashbuilder-6.3.0-SNAPSHOT-wildfly8.war` to WildFly.

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

* ./modules/dashboard-commons/src/main/resources/org/jboss/dashboard/cluster/ClusterNode.hbm.xml
* ./modules/dashboard-commons/src/main/resources/org/jboss/dashboard/database/InstalledModule.hbm.xml
* ./modules/dashboard-commons/src/main/resources/org/jboss/dashboard/database/DataSourceEntry.hbm.xml

* ./modules/dashboard-security/src/main/resources/org/jboss/dashboard/security/PermissionDescriptor.hbm.xml

* ./modules/dashboard-providers/dashboard-provider-core/src/main/resources/org/jboss/dashboard/provider/DataProvider.hbm.xml

* ./modules/dashboard-displayers/dashboard-displayer-core/src/main/resources/org/jboss/dashboard/kpi/KPI.hbm.xml

* ./modules/dashboard-ui/dashboard-ui-panels/src/main/resources/org/jboss/dashboard/ui/panel/advancedHTML/HtmlCode.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-panels/src/main/resources/org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceColumnEntry.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-panels/src/main/resources/org/jboss/dashboard/ui/panel/dataSourceManagement/DataSourceTableEntry.hbm.xml

* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/ui/resources/GraphicElement.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/workspace/Section.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/workspace/PanelInstance.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/workspace/PanelParameter.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/workspace/Panel.hbm.xml
* ./modules/dashboard-ui/dashboard-ui-core/src/main/resources/org/jboss/dashboard/workspace/Workspace.hbm.xml
