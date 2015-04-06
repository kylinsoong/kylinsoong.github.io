---
layout: blog
title:  "调试 WildFly Standalone 启动过程"
date:   2015-04-06 21:30:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015040601
excerpt: 本文从调式源代码的层面深入分析WildFly Standalone 启动过程
---

本文内容包括：

* jboss-modules.jar 启动 org.jboss.as.server.Main
* JBoss MSC 启动 Services
* Controller Boot Thread

## jboss-modules.jar 启动 org.jboss.as.server.Main

当完成 WildFly 安装，我们会发现在根目录下有一个 `jboss-modules.jar`，该 jar 负责加载 WildFly 启动所需相关的 jar 包，以及启动 WildFly，我们到根目录下运行：

~~~
java -jar jboss-modules.jar -version
~~~

会输出相应 JBoss Modules 版本信息，如果以如下方式运行

~~~
java -jar jboss-modules.jar -mp modules org.jboss.as.standalone
~~~

则 `jboss-modules.jar` 会在 modules 目录下找到 `org.jboss.as.standalone` Module，运行该 Module 定义的 Main 方法。如下为 WildFly 启动脚本 standalone.sh 的部分内容，

~~~
         -jar \"$JBOSS_HOME/jboss-modules.jar\" \
         -mp \"${JBOSS_MODULEPATH}\" \
         org.jboss.as.standalone \
~~~

在 WildFly 根目录下查看 `org.jboss.as.standalone` Module 的配置文件 modules/system/layers/base/org/jboss/as/standalone/main/module.xml, 我们可以发现 `jboss-modules.jar` 启动的 Main 方法为 org.jboss.as.server.Main

~~~
<module xmlns="urn:jboss:module:1.3" name="org.jboss.as.standalone">
    <main-class name="org.jboss.as.server.Main"/>
~~~

**通过如下三步调试 jboss modules**

**Steps.1** 编辑 standalone.conf，添加如下 JVM 调试参数

~~~
JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=y"
~~~

**Steps.2** 添加 `jboss-modules.jar` 到当前 classpath

**Steps.3** 在 org.jboss.modules.Main 类 main() 方法中添加断点后，启动 JBoss，开始调试，如下图

![standalone startup modules main]({{ site.baseurl }}/assets/blog/standalone-start-modules-main.png) 


## JBoss MSC 启动 Services

运行 org.jboss.as.server.Main 会启动 WildFly 内核 JBoss MSC，随后 JBoss MSC 启动一系列 Services，如

* ApplicationServerService - the root service for an Application Server process
* ServerService - Service for the Controls reads of and modifications to a management model for an AS server instance.

**通过如下三步调式 JBoss MSC**

**Steps.1** 添加系统变量控制 MSC 线程数

MSC 是一个容器，它可启动工作线程，这些工作线程用来启动 WildFly 服务，我们可以通过如下系统变量控制 MSC 线程数：

~~~
-Dorg.jboss.server.bootstrap.maxThreads=1
~~~

如上，MSC 启动后共有一个工作线程。

> **org.jboss.server.bootstrap.maxThreads** 参数在调式过程中非常有用，WildFly 默认 JBoss MSC 的线程数为物理processor数（cores * 2）

**Steps.2** 添加相关 jar 包

Maven 项目中添加如下依赖：

~~~
            <dependency>
                <groupId>org.wildfly</groupId>
                <artifactId>wildfly-controller</artifactId>
            </dependency>
            <dependency>
                <groupId>org.wildfly</groupId>
                <artifactId>wildfly-server</artifactId>
            </dependency>
~~~

**Steps.3** 在 `org.jboss.as.server.Main` 中添加调试断点开始调试如下：

![standalone startup main]({{ site.baseurl }}/assets/blog/standalone-start-main.png)

## Controller Boot Thread

ServerService 启动了 Controller Boot Thread, 我们可以在 `org.jboss.as.controller.AbstractControllerService` start 方法中添加端点，调式 Controller Boot Thread 的启动和运行：

![standalone startup controller boot]({{ site.baseurl }}/assets/blog/standalone-start-controller-boot.png)
