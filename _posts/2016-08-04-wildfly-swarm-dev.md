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

https://github.com/kylinsoong/wildfly-swarm-teiid/commit/0eebd5bafde38c9b5242182d793011933b7285cc

## NullPointerException

~~~
[ERROR] Failed to execute goal org.wildfly.swarm:wildfly-swarm-fraction-plugin:30:process (process) on project teiid-translator-modules: Execution process of goal org.wildfly.swarm:wildfly-swarm-fraction-plugin:30:process failed. NullPointerException -> [Help 1]
org.apache.maven.lifecycle.LifecycleExecutionException: Failed to execute goal org.wildfly.swarm:wildfly-swarm-fraction-plugin:30:process (process) on project teiid-translator-modules: Execution process of goal org.wildfly.swarm:wildfly-swarm-fraction-plugin:30:process failed.
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:224)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:153)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:145)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:116)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:80)
	at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:51)
	at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:120)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:355)
	at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:155)
	at org.apache.maven.cli.MavenCli.execute(MavenCli.java:584)
	at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:216)
	at org.apache.maven.cli.MavenCli.main(MavenCli.java:160)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:483)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
	at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
	at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
Caused by: org.apache.maven.plugin.PluginExecutionException: Execution process of goal org.wildfly.swarm:wildfly-swarm-fraction-plugin:30:process failed.
	at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:143)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:208)
	... 19 more
Caused by: java.lang.NullPointerException
	at org.wildfly.swarm.plugin.ModuleGenerator.generate(ModuleGenerator.java:66)
	at org.wildfly.swarm.plugin.ModuleGenerator.execute(ModuleGenerator.java:60)
	at org.wildfly.swarm.plugin.ProcessMojo.executeModuleGenerator(ProcessMojo.java:98)
	at org.wildfly.swarm.plugin.ProcessMojo.execute(ProcessMojo.java:53)
	at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:132)
	... 20 more
~~~

### Resolution

If module.conf added, there must be source code exist

## Archive deploy failed

~~~
 Exception in thread "main" java.lang.reflect.InvocationTargetException
 	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
 	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 	at java.lang.reflect.Method.invoke(Method.java:483)
 	at org.wildfly.swarm.bootstrap.Main.invoke(Main.java:84)
 	at org.wildfly.swarm.bootstrap.Main.run(Main.java:48)
 	at org.wildfly.swarm.bootstrap.Main.main(Main.java:43)
 Caused by: org.jboss.shrinkwrap.impl.base.ExtensionLoadingException: No constructor with a single argument of type org.jboss.shrinkwrap.api.Archive could be found
 	at org.jboss.shrinkwrap.impl.base.ServiceExtensionLoader.findConstructor(ServiceExtensionLoader.java:394)
 	at org.jboss.shrinkwrap.impl.base.ServiceExtensionLoader.createExtension(ServiceExtensionLoader.java:347)
 	at org.jboss.shrinkwrap.impl.base.ServiceExtensionLoader.createFromLoadExtension(ServiceExtensionLoader.java:223)
 	at org.jboss.shrinkwrap.impl.base.ServiceExtensionLoader.load(ServiceExtensionLoader.java:108)
 	at org.jboss.shrinkwrap.impl.base.ArchiveBase.as(ArchiveBase.java:686)
 	at org.jboss.shrinkwrap.api.ArchiveFactory.create(ArchiveFactory.java:150)
 	at org.jboss.shrinkwrap.api.ArchiveFactory.create(ArchiveFactory.java:110)
 	at org.jboss.shrinkwrap.api.ShrinkWrap.create(ShrinkWrap.java:136)
 	at org.teiid.test.swarm.Main.main(Main.java:29)
 	... 7 more
~~~

### Resolution

Use a public construct method: https://github.com/kylinsoong/wildfly-swarm-teiid/commit/262557f366cf172535b83a2a0312c067756dc9ad

## NullPointerException

~~~
Caused by: java.lang.NullPointerException
	at java.util.regex.Matcher.getTextLength(Matcher.java:1283)
	at java.util.regex.Matcher.reset(Matcher.java:309)
	at java.util.regex.Matcher.<init>(Matcher.java:229)
	at java.util.regex.Pattern.matcher(Pattern.java:1093)
	at org.eclipse.aether.artifact.DefaultArtifact.<init>(DefaultArtifact.java:65)
	at org.eclipse.aether.artifact.DefaultArtifact.<init>(DefaultArtifact.java:51)
	at org.wildfly.swarm.plugin.ModuleFiller.execute(ModuleFiller.java:113)
	at org.wildfly.swarm.plugin.ProcessMojo.executeModuleFiller(ProcessMojo.java:129)
	at org.wildfly.swarm.plugin.ProcessMojo.execute(ProcessMojo.java:57)
	at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:132)
	... 20 more
~~~
