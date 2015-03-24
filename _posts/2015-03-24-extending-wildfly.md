---
layout: blog
title:  "扩展 WildFly 示例"
date:   2015-03-24 12:45:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015032401
---

本文介绍 WildFly 文档 [Extending WildFly 8](https://docs.jboss.org/author/display/WFLY8/Extending+WildFly+8) 的 `acme-subsystem` 示例。

详细运行 `acme-subsystem` 参照 [acme-subsystem README.md](https://github.com/jbosschina/acme-subsystem)

以下是本示例中用到的主要接口:

### [org.jboss.as.controller.Extension](https://github.com/wildfly/wildfly-core/blob/master/controller/src/main/java/org/jboss/as/controller/Extension.java)

An extension to the WildFly Server, Implementations of this interface should have a zero-arg constructor. Extension modules must contain a `META-INF/services/org.jboss.as.controller.Extension` file with a line containing the name of the implementation class.

For example, [org.jboss.as.controller.Extension](https://github.com/jbosschina/acme-subsystem/blob/master/src/main/resources/META-INF/services/org.jboss.as.controller.Extension) contain Zimplementation class `com.acme.corp.tracker.extension.TrackerExtension`.

### [org.jboss.as.server.deployment.DeploymentUnitProcessor](https://github.com/wildfly/wildfly-core/blob/master/server/src/main/java/org/jboss/as/server/deployment/DeploymentUnitProcessor.java)

The [org.jboss.as.server.deployment.DeploymentUnitProcessor](https://github.com/wildfly/wildfly-core/blob/master/server/src/main/java/org/jboss/as/server/deployment/DeploymentUnitProcessor.java) is a deployment processor. Instances of this interface represent a step in the deployer chain. They may perform a variety of tasks, including (but not limited to):

* Parsing a deployment descriptor and adding it to the context
* Reading a deployment descriptor's data and using it to produce deployment items
* Replacing a deployment descriptor with a transformed version of that descriptor
* Removing a deployment descriptor to prevent it from being processed


