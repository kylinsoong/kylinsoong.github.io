---
layout: blog
title:  "JBoss LogManager"
date:   2015-09-28 17:30:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015092801
excerpt: A replacement and enhancement of Java Util Logging Framework.
---

JBoss LogManager 是对 Java Util Logging API 的补充与扩展：

* 补充扩展 handlers， 增加 FileHandler，AsyncHandler，PeriodicRotatingFileHandler，PeriodicSizeRotatingFileHandler 等
* 补充扩展 formatters，增加 colored format pattern 等
* 添加了 Bridge 功能，JBoss LogManager 可以 Bridge 常见的 Logging Framework 如 JBoss Logging, Log4j, SLF4j 等

## 如何使用 JBoss LogManager

通过如下三个步骤可使用 JBoss LogManager：

* 添加 jboss-logmanager jar 包到 class path，如果使用 Maven 添加如下 dependency：

~~~
<dependency>
    <groupId>org.jboss.logmanager</groupId>
    <artifactId>jboss-logmanager</artifactId>
</dependency>
~~~

* 添加系统参数指定 LogManager

~~~
-Djava.util.logging.manager=org.jboss.logmanager.LogManager
~~~

* 添加 logging.properties 到 class path, 或使用系统参数指定如下

~~~
-Dlogging.configuration=file:/path/to/logging.properties
~~~

一个示例 logging.properties：

~~~
loggers=sun.rmi,com.arjuna
 
logger.level=TRACE
logger.handlers=FILE,CONSOLE
 
logger.sun.rmi.level=WARN
logger.sun.rmi.useParentHandlers=true
 
logger.com.arjuna.level=WARN
logger.com.arjuna.useParentHandlers=true
 
handler.CONSOLE=org.jboss.logmanager.handlers.ConsoleHandler
handler.CONSOLE.level=INFO
handler.CONSOLE.formatter=COLOR-PATTERN
handler.CONSOLE.properties=autoFlush,target,enabled
handler.CONSOLE.autoFlush=true
handler.CONSOLE.target=SYSTEM_OUT
handler.CONSOLE.enabled=true
 
handler.FILE=org.jboss.logmanager.handlers.PeriodicRotatingFileHandler
handler.FILE.formatter=PATTERN
handler.FILE.properties=append,autoFlush,enabled,suffix,fileName
handler.FILE.constructorProperties=fileName,append
handler.FILE.append=true
handler.FILE.autoFlush=true
handler.FILE.enabled=true
handler.FILE.suffix=.yyyy-MM-dd
handler.FILE.fileName=target/test.log
 
formatter.PATTERN=org.jboss.logmanager.formatters.PatternFormatter
formatter.PATTERN.properties=pattern
formatter.PATTERN.pattern=%d{yyyy-MM-dd HH\:mm\:ss,SSS} %-5p \[%c\] (%t) %s%e%n
 
formatter.COLOR-PATTERN=org.jboss.logmanager.formatters.PatternFormatter
formatter.COLOR-PATTERN.properties=pattern
formatter.COLOR-PATTERN.pattern=%K{level}%d{HH\:mm\:ss,SSS} %-5p \[%c\] (%t) %s%e%n
~~~

## 怎样理解 JBoss LogManager 的 Bridge 功能

### 使用 JBoss LogManager 的 Bridge 功能的场景

一个应用系统中不同的模块使用不同的 logging framework，需要通过统一的日志配置文件来管理整个系统的日志输出。例如，JBoss/WildFly 应用服务器中，不同的模块使用不同的logging framework，而 JBoss/WildFly 启动时会加载统一的日志配置文件，通过该文件统一的管理和配置 JBoss/WildFly 的日志输出。

### 如何使用 JBoss LogManager 的 Bridge 功能

 使用 JBoss LogManager 的 Bridge 功能，只需要添加相应的 jar 包。例如 JBoss LogManager Bridge JBoss Logging 只要添加 jboss-logging jar 包即可，使用 Maven 添加如下 dependency：

~~~
<dependency>
    <groupId>org.jboss.logging</groupId>
    <artifactId>jboss-loggging</artifactId>
</dependency>
~~~

JBoss LogManager Bridge log4j 只要添加 log4j jar 包即可，使用 Maven 添加如下 dependency：

~~~
<dependency>
    <groupId>org.jboss.logmanager</groupId>
    <artifactId>log4j-jboss-logmanager</artifactId>
</dependency>
~~~

## 示例

**示例.1** JBoss LogManager colored format pattern 输出

~~~
$ git clone git@github.com:jbosschina/wildfly-dev-cookbook.git
$ cd wildfly-dev-cookbook/logging/logmanager-example/
$ mvn clean install dependency:copy-dependencies
$ java -cp target/dependency/jboss-logmanager-2.0.0.Final.jar:target/logmanager-example-1.0.0-SNAPSHOT.jar org.jboss.loggermanager.examples.JBossLogManagerExample
~~~

Console 日志输出:

![colored format pattern]({{ site.baseurl }}/assets/blog/logmanager-colored-format.png)

'target/logmanager-example.log' 输出的日志为:

~~~
2015-09-28 17:27:24,544 TRACE [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) TRACE Message
2015-09-28 17:27:24,546 DEBUG [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) DEBUG Message
2015-09-28 17:27:24,547 INFO  [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) INFO Message
2015-09-28 17:27:24,547 WARN  [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) WARN Message
2015-09-28 17:27:24,548 ERROR [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) Error Message
2015-09-28 17:27:24,548 FATAL [org.jboss.loggermanager.examples.JBossLogManagerExample] (main) FATAL Message
~~~

**示例.2** JBoss LogManager Bridge JBoss Logging

~~~
$ git clone git@github.com:jbosschina/wildfly-dev-cookbook.git
$ cd wildfly-dev-cookbook/logging/logmanager-jboss-logging
$ mvn clean install dependency:copy-dependencies
$ java -cp target/dependency/*:target/logmanager-jboss-logging-1.0.0-SNAPSHOT.jar org.jboss.loggermanager.examples.JBossLoggingExample
~~~

> NOTE: 如上 JBossLoggingExample 中我们通过 JBoss LogManager 的配置文件 `logging.properties` 控制 `org.jboss.logging.Logger`。

**示例.3** JBoss LogManager Bridge Log4j

~~~
$ git clone git@github.com:jbosschina/wildfly-dev-cookbook.git
$ cd wildfly-dev-cookbook/logging/logmanager-log4j
$ mvn clean install dependency:copy-dependencies
$ java -cp target/dependency/*:target/logmanager-log4j-1.0.0-SNAPSHOT.jar org.jboss.loggermanager.examples.Log4jExample
~~~

> NOTE: 如上 Log4jExample 中我们通过 JBoss LogManager 的配置文件 `logging.properties` 控制 `Log4jExample`。

