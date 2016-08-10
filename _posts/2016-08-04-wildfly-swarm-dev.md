---
layout: blog
title:  "WildFly Swarm Develop Exception List"
date:   2016-08-04 18:40:12
categories: jboss
permalink: /wildfly-swarm-error
author: Kylin Soong
duoshuoid: ksoong2016080401
excerpt: Exception lists in wildfly swarm teiid developing
---

* Table of contents
{:toc}

## java.lang.ClassNotFoundException

~~~
Caused by: java.lang.ClassNotFoundException: org.jboss.teiid from [Module "org.jboss.teiid:main" from BootModuleLoader@4c762604 for finders [BootstrapClasspathModuleFinder, BootstrapModuleFinder(org.wildfly.swarm.bootstrap:main), ClasspathModuleFinder, ApplicationModuleFinder(swarm.application:main), FlattishApplicationModuleFinder(swarm.application:flattish)]]
	at org.jboss.modules.ModuleClassLoader.findClass(ModuleClassLoader.java:198)
	at org.jboss.modules.ConcurrentClassLoader.performLoadClassUnchecked(ConcurrentClassLoader.java:363)
	at org.jboss.modules.ConcurrentClassLoader.performLoadClass(ConcurrentClassLoader.java:351)
	at org.jboss.modules.ConcurrentClassLoader.loadClass(ConcurrentClassLoader.java:93)
	at org.wildfly.swarm.container.runtime.internal.ServerConfigurationBuilder.internalBuild(ServerConfigurationBuilder.java:230)
	at org.wildfly.swarm.container.runtime.internal.ServerConfigurationBuilder.build(ServerConfigurationBuilder.java:293)
	at org.wildfly.swarm.container.runtime.RuntimeServer.fromAnnotation(RuntimeServer.java:540)
	at org.wildfly.swarm.container.runtime.RuntimeServer.findAnnotationServerConfigurations(RuntimeServer.java:529)
	at org.wildfly.swarm.container.runtime.RuntimeServer.loadFractionConfigurations(RuntimeServer.java:463)
	at org.wildfly.swarm.container.runtime.RuntimeServer.start(RuntimeServer.java:167)
	at org.wildfly.swarm.container.Container.start(Container.java:343)
	at org.wildfly.swarm.container.Container.start(Container.java:326)
	at org.teiid.test.swarm.Main.main(Main.java:15)
~~~

### Resolution

`Configuration` be deprecated, change

~~~
@Configuration(
        marshal = true,
        extension="org.jboss.teiid",
        extensionClassName = "org.teiid.jboss.TeiidExtension"
)
~~~

to 

~~~
@ExtensionModule("org.jboss.teiid")
@ExtensionClassName("org.teiid.jboss.TeiidExtension")
@MarshalDMR
~~~

resolved the issue in my development.

## ClassNotFound in Maven Pojo Plugin

~~~
[WARNING] 
java.lang.reflect.InvocationTargetException
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:483)
	at org.codehaus.mojo.exec.ExecJavaMojo$1.run(ExecJavaMojo.java:293)
	at java.lang.Thread.run(Thread.java:745)
Caused by: java.lang.NoClassDefFoundError: org/apache/maven/model/io/xpp3/MavenXpp3Reader
	at org.wildfly.swarm.teiid.modules.generator.Generator.getArtifactsDependencies(Generator.java:160)
	at org.wildfly.swarm.teiid.modules.generator.Generator.processGeneratorTargets(Generator.java:86)
	at org.wildfly.swarm.teiid.modules.generator.Generator.main(Generator.java:63)
	... 6 more
Caused by: java.lang.ClassNotFoundException: org.apache.maven.model.io.xpp3.MavenXpp3Reader
	at java.net.URLClassLoader$1.run(URLClassLoader.java:372)
	at java.net.URLClassLoader$1.run(URLClassLoader.java:361)
	at java.security.AccessController.doPrivileged(Native Method)
	at java.net.URLClassLoader.findClass(URLClassLoader.java:360)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	... 9 more
~~~

### Resolution

If a maven pojo plugin depend on a dependency, and this dependency internal has dependencies, then these dependencies should not be provided scope.

## Fraction NoClassDefFoundError

~~~
Caused by: java.lang.NoClassDefFoundError: Failed to link org/wildfly/swarm/teiid/TeiidFraction (Module "org.wildfly.swarm.teiid:api" from BootModuleLoader@481a15ff for finders [BootstrapClasspathModuleFinder, BootstrapModuleFinder(org.wildfly.swarm.bootstrap:main), ClasspathModuleFinder, ApplicationModuleFinder(swarm.application:main), FlattishApplicationModuleFinder(swarm.application:flattish)]): org/wildfly/swarm/config/Teiid
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	at java.lang.reflect.Constructor.newInstance(Constructor.java:408)
	at org.jboss.modules.ModuleClassLoader.defineClass(ModuleClassLoader.java:446)
	at org.jboss.modules.ModuleClassLoader.loadClassLocal(ModuleClassLoader.java:274)
	at org.jboss.modules.ModuleClassLoader$1.loadClassLocal(ModuleClassLoader.java:78)
	at org.jboss.modules.Module.loadModuleClass(Module.java:605)
	at org.jboss.modules.ModuleClassLoader.findClass(ModuleClassLoader.java:190)
	at org.jboss.modules.ConcurrentClassLoader.performLoadClassUnchecked(ConcurrentClassLoader.java:363)
	at org.jboss.modules.ConcurrentClassLoader.performLoadClass(ConcurrentClassLoader.java:351)
	at org.jboss.modules.ConcurrentClassLoader.loadClass(ConcurrentClassLoader.java:93)
	at org.wildfly.swarm.container.runtime.internal.ServerConfigurationBuilder.internalBuild(ServerConfigurationBuilder.java:214)
	at org.wildfly.swarm.container.runtime.internal.ServerConfigurationBuilder.build(ServerConfigurationBuilder.java:293)
	at org.wildfly.swarm.container.runtime.RuntimeServer.fromAnnotation(RuntimeServer.java:540)
	at org.wildfly.swarm.container.runtime.RuntimeServer.findAnnotationServerConfigurations(RuntimeServer.java:529)
	at org.wildfly.swarm.container.runtime.RuntimeServer.loadFractionConfigurations(RuntimeServer.java:463)
	at org.wildfly.swarm.container.runtime.RuntimeServer.start(RuntimeServer.java:167)
	at org.wildfly.swarm.container.Container.start(Container.java:343)
	at org.wildfly.swarm.container.Container.start(Container.java:326)
	at org.teiid.test.swarm.Main.main(Main.java:15)
	... 7 more
~~~

### Resolution

https://github.com/kylinsoong/wildfly-swarm-teiid/commit/bcdd1801faed2c61c0724d151bc2e6004ec9822e

## Teiid Fraction start dailed due to infinispan 

~~~
2016-08-10 18:39:47,046 ERROR [org.jboss.as.controller.management-operation] (ServerService Thread Pool -- 20) WFLYCTL0013: Operation ("add") failed - address: ([("subsystem" => "teiid")]) - failure description: "TEIID50094 Resultset cache configured without the Infinispan's Cache Container name. Check and provide <resultset-cache infinispan-container=\"{name}\"/> in configuration."
~~~

### Resolution
