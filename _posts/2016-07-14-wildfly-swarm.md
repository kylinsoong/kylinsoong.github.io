---
layout: blog
title:  "WildFly Swarm Get Start Tips"
date:   2016-07-14 18:40:12
categories: jboss
permalink: /wildfly-swarm
author: Kylin Soong
duoshuoid: ksoong2016071401
excerpt: WildFly Swarm Get Start Tips
---

* Table of contents
{:toc}

## System Properties

### swarm.debug.bootstrap

Add `-Dswarm.debug.bootstrap=true` before start swarm Container will enable bootstrap modules related detailed log.

### swarm.project.stage.file

Add `-Dswarm.project.stage.file=/path/to/stage-file` before start swarm Container will use a pre-configured stage file, more details about Project Stages refer to [Configuration overlays using stage properties](https://wildfly-swarm.gitbooks.io/wildfly-swarm-users-guide/content/configuration/project_stages.html).

### swarm.http.eager

Add `-Dswarm.http.eager=true` to enable eagerly Open

### swarm.node.id

Add `-Dswarm.node.id={node id}` define the swarm node id, alternatively.

### swarm.bind.address

Add `-Dswarm.bind.address={ip addr}` to bind servers, defaults to 0.0.0.0

### swarm.port.offset

Add `-Dswarm.port.offset={number}` to set a global port adjustment, defaults to 0

### swarm.http.port

Add `-Dswarm.http.port={port}` to set he HTTP port to be used, defaults to 8080.

## Develop Tips

### How to enable more log

System properties with the prefix `swarm.log.` can enable more log, eg: -Dswarm.log.org.wildfly.swarm=DEBUG

All available log levels are:

~~~
NONE
ERROR
WARN
INFO
DEBUG
TRACE
ALL
~~~

### How to debug swarm jar

Add `-agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=y` before run -swarm.jar

~~~
java -agentlib:jdwp=transport=dt_socket,address=8787,server=y,suspend=y -jar NAME-swarm.jar
~~~

## Maven plugins in swarm

### wildfly-swarm-fraction-plugin

A fraction in wildfly-swarm-fraction-plugin represent a maven assets, which consisted by groupId, artifactId and version. wildfly-swarm-fraction-plugin has defined several mojo goals, including:

* **fraction-list** - Used to generate fractions descriptors, refer to [how fraction list works](#how-fraction-list-works) for details.
* **process** - Used to generate internal modules system, refer to [how process works](#how-process-works) for details 

#### how fraction-list works

If configu fraction plugin as below

~~~
<plugin>
     <groupId>org.wildfly.swarm</groupId>
     <artifactId>wildfly-swarm-fraction-plugin</artifactId>
     <executions>
       <execution>
         <id>fraction-list</id>
         <phase>generate-resources</phase>
         <goals>
           <goal>fraction-list</goal>
         </goals>
       </execution>
     </executions>
</plugin>
~~~

then the plugin mainly do 2 apsects work:

Firstly, the plugin 

1. collect all dependencies which defined in dependencyManagement
2. filter all dependencies which groupId start with `org.wildfly.swarm`
3. convert all dependencies to MavenProjects
4. filter all MavenProjects which project has defined any of these 3 properties(`swarm.fraction.stability`, `swarm.fraction.tags`, `swarm.fraction.internal`).
5. convert all MavenProjects to fractions and keep in a map(groupId:artifactId -> fraction)
6. create a org.wildfly.swarm, container fraction, and put it to map, and set all fractions dependent on container fraction.

Secondly, generate fractions descriptors

* generate a `fraction-list.txt` under classspath, a example line in `fraction-list.txt`:

~~~
org.wildfly.swarm:jaxrs:2016.7-SNAPSHOT = org.wildfly.swarm:ee:2016.7-SNAPSHOT, org.wildfly.swarm:request-controller:2016.7-SNAPSHOT, org.wildfly.swarm:security:2016.7-SNAPSHOT, org.wildfly.swarm:naming:2016.7-SNAPSHOT, org.wildfly.swarm:undertow:2016.7-SNAPSHOT, org.wildfly.swarm:io:2016.7-SNAPSHOT, org.wildfly.swarm:logging:2016.7-SNAPSHOT, org.wildfly.swarm:container:2016.7-SNAPSHOT
org.wildfly.swarm:connector:2016.7-SNAPSHOT = org.wildfly.swarm:container:2016.7-SNAPSHOT
~~~

> NOTE: `fraction-list.txt` contain all fractions and it's depdencies, in above, `jaxrs` depend on `ee`, `request-controller`, `security`, `naming`, `undertow`, `io`, `logging`, `container`. and `connector` only depend on `container`.

* generate a `fraction-list.json` under classpath, a example line in `fraction-list.json`:

~~~
 {
  "groupId" : "org.wildfly.swarm",
  "artifactId" : "jaxrs",
  "version" : "2016.7-SNAPSHOT",
  "name" : "JAX-RS",
  "description" : "RESTful Web Services with RESTEasy",
  "tags" : "JavaEE,Web",
  "internal" : false,
  "stabilityIndex" : 3,
  "stabilityDescription" : "stable"
},
{
  "groupId" : "org.wildfly.swarm",
  "artifactId" : "connector",
  "version" : "2016.7-SNAPSHOT",
  "name" : "Connector",
  "description" : "Connector",
  "tags" : "",
  "internal" : true,
  "stabilityIndex" : 3,
  "stabilityDescription" : "stable"
}
~~~

> NOTE: `fraction-list.json` contains all fractions, as above are `jaxrs` and `connector` fractions. 

* generate a `fraction-list.js` under classpath, this file only contain one line, as below

~~~
fractionList = [{"groupId":"org.wildfly.swarm","artifactId":"jaxrs","version":"2016.7-SNAPSHOT","name"    :"JAX-RS","description":"RESTful Web Services with RESTEasy","tags":"JavaEE,Web","internal":false,"stabilityIndex":3,"stabilityDescription":"stable"},{"groupId":"org.wildfly.swarm","artifactId":"connector","version":"2016.7-SNAPSHOT"    ,"name":"Connector","description":"Connector","tags":"","internal":true,"stabilityIndex":3,"stabilityDescription":"stable"}]
~~~

> NOTE: fractionList in `fraction-list.js` contains all fractions, in above only contain `jaxrs` and `connector` fractions.

#### how process works

If configu fraction plugin as below

~~~
<plugin>
  <groupId>org.wildfly.swarm</groupId>
  <artifactId>wildfly-swarm-fraction-plugin</artifactId>
  <executions>
    <execution>
      <id>process</id>
      <phase>process-classes</phase>
      <goals>
        <goal>process</goal>
      </goals>
    </execution>
  </executions>
</plugin>
~~~

then the process task do the following:

**1. Generate modules**

This step against on compiled project's source code, usually under `target/classes` path, these code are categorized by path and add into one module with 3 slots, in other words, in this section, 3 module.xml will generate

1. main - the parent follder of a *Fraction.java, eg, `org.wildfly.swarm.teiid`
2. api - under the main module
3. runtime - under the main module

> NOTE: This step depend on a `module.conf` file which under project base directory. In this file, every line define a module, eg, `org.jboss.teiid`. All this lines of modules be added as new created modules' dependencies.

An example of generated module.xml

* target/classes/modules/org/wildfly/swarm/teiid/main/module.xml

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<module xmlns="urn:jboss:module:1.5" name="org.wildfly.swarm.teiid" slot="main">
  <dependencies>
    <system export="true">
      <paths>
        <path name="org/wildfly/swarm/config"/>
        <path name="org/wildfly/swarm/teiid/internal"/>
        <path name="org/wildfly/swarm/teiid"/>
      </paths>
    </system>
    <module export="true" name="org.wildfly.swarm.teiid" services="export" slot="api"/>
  </dependencies>
</module>
~~~

* target/classes/modules/org/wildfly/swarm/teiid/api/module.xml

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<module xmlns="urn:jboss:module:1.5" name="org.wildfly.swarm.teiid" slot="api">
  <resources>
    <artifact name="org.wildfly.swarm:teiid:2016.7-SNAPSHOT">
      <filter>
        <include-set>
          <path name="org/wildfly/swarm/config"/>
          <path name="org/wildfly/swarm/teiid/internal"/>
          <path name="org/wildfly/swarm/teiid"/>
        </include-set>
        <exclude-set/>
      </filter>
    </artifact>
  </resources>
  <dependencies>
    <module name="org.wildfly.swarm.container"/>
    <module name="org.jboss.teiid" slot="main"/>
  </dependencies>
</module>
~~~

* target/classes/modules/org/wildfly/swarm/teiid/runtime/module.xml

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<module xmlns="urn:jboss:module:1.5" name="org.wildfly.swarm.teiid" slot="runtime">
  <resources>
    <artifact name="org.wildfly.swarm:teiid:2016.7-SNAPSHOT">
      <filter>
        <exclude-set>
          <path name="org/wildfly/swarm/config"/>
          <path name="org/wildfly/swarm/teiid/internal"/>
          <path name="org/wildfly/swarm/teiid"/>
        </exclude-set>
      </filter>
    </artifact>
  </resources>
  <dependencies>
    <module name="org.wildfly.swarm.teiid" slot="main"/>
    <module name="org.wildfly.swarm.bootstrap" optional="true"/>
    <module name="org.wildfly.swarm.container" slot="runtime"/>
    <module name="org.jboss.teiid" slot="main"/>
  </dependencies>
</module>
~~~

**2. create bootstrap conf** 

Set up bootstrap means create a `wildfly-swarm-bootstrap.conf` file under classpath, which contain the bootstrap module name, there are 3 ways to do this:

1. Pre-packaged `wildfly-swarm-bootstrap.conf` file under `src/main/resources`
2. Use system proeprties `swarm.fraction.bootstrap` define the bootstrap module name, eg `-Dswarm.fraction.bootstrap=org.wildfly.swarm.teiid`
3. Walk through src, if file path end with `Fraction.java`, then this java's package as bootstrap module name, eg `org.wildfly.swarm.teiid.TeiidFraction` referenced bootstrap module name is `org.wildfly.swarm.teiid`  

> NOTE: Both step 2 and 3 will create a `wildfly-swarm-bootstrap.conf` under classpath, which comtain the bootstrap module name.

**3. Generate Dependencies** 

Firstly, collect the dependencies in `provided-dependencies.txt`. 

The dependencies can be defined in `provided-dependencies.txt` filem which under `src/main/resources/`, which define the provided dependencies. Each line in `provided-dependencies.txt` represent a dependency, a format like <groupId>:<artifactId>. 

An example of `provided-dependencies.txt`:

~~~
org.wildfly.swarm:config-api
org.wildfly.swarm:config-api-runtime
~~~

Secondly, dump the collected dependencies to `META-INF/wildfly-swarm-classpath.conf`.

An example of `META-INF/wildfly-swarm-classpath.conf`:

~~~
  1 package(org.wildfly.swarm.container) replace(org.wildfly.swarm.container:main)
  2 package(org.wildfly.swarm.container) replace(org.wildfly.swarm.container:runtime)
  3 
  4 maven(org.wildfly.swarm:config-api) remove
  5 maven(org.wildfly.swarm:config-api-runtime) remove
  6 maven(org.ow2.asm:asm-all) remove
  7 maven(org.jboss.shrinkwrap:shrinkwrap-api) remove
  8 maven(org.jboss.shrinkwrap:shrinkwrap-spi) remove
  9 maven(org.jboss.shrinkwrap:shrinkwrap-impl-base) remove
 10 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-spi) remove
 11 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-base) remove
 12 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-jboss) remove
 13 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-api-javaee) remove
 14 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-impl-base) remove
 15 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-impl-jboss) remove
 16 maven(org.jboss.shrinkwrap.descriptors:shrinkwrap-descriptors-impl-javaee) remove
 17 maven(org.yaml:snakeyaml) remove
 18 maven(org.wildfly:wildfly-naming) remove
 19 maven(org.ow2.asm:asm-all) remove
 20 maven(org.yaml:snakeyaml) remove
~~~

**4. Filter Modules** 

This steps including the following procedures:

* Load module rewrite rules

This step depend on `module-rewrite.conf` under base dir, which defines module rewrite rules. An example of `module-rewrite.conf`:

~~~
module: org.jboss.as.server
  optional: org.jboss.as.domain-http-interface
~~~

* Walk Project Modules 

Modules can be pre configured and packaged under `resources/modules`, walk Project Modules will load each module as a `availableModules` and each module's dependencies module as `requiredModules`.

* Walk Dependency Modules

Walk through all project dependencies, if a jar dependency has define the modules, then get all these modules as `availableModules`.

> NOTE: `org.wildfly.swarm:container` has defined lots of modules(more than 50), which supply the base evn of running wildfly self container, completed list refer to [modules list]({{ site.baseurl }}/assets/download/files/swarm-container-modules).

* Index Potential Modules

Walk through all project dependencies, if a feature pack zip dependency has define, then index all zip file, if there are any modules defined, the add it as `potentialModules`

~~~
<dependency>
  <groupId>org.wildfly.core</groupId>
  <artifactId>wildfly-core-feature-pack</artifactId>
  <type>zip</type>
  <scope>provided</scope>
  <exclusions>
    <exclusion>
      <groupId>*</groupId>
      <artifactId>*</artifactId>
    </exclusion>
  </exclusions>
</dependency>
<dependency>
  <groupId>org.wildfly</groupId>
  <artifactId>wildfly-servlet-feature-pack</artifactId>
  <type>zip</type>
  <scope>provided</scope>
  <exclusions>
    <exclusion>
      <groupId>*</groupId>
      <artifactId>*</artifactId>
    </exclusion>
  </exclusions>
</dependency>
<dependency>
  <groupId>org.jboss.teiid</groupId>
  <artifactId>wildfly-teiid-feature-pack</artifactId>
  <type>zip</type>
  <scope>provided</scope>
  <exclusions>
    <exclusion>
      <groupId>*</groupId>
      <artifactId>*</artifactId>
    </exclusion>
  </exclusions>
</dependency>
~~~

> NOTE: so far, there are 3 kinds of modules: `availableModules`, `requiredModules`, `potentialModules`.

* locate Fill Modules


**5. execute Jandexer**

### wildfly-swarm-plugin

The wildfly-swarm-plugin use a `BuildTool` to a build swarm jar, the `BuildTool` mainly has 2 aspects task:

Firstly, initialization.

1. init projectArtifact - create a `projectAsset` base on project's groupId, artifactId, version, etc.
2. init fractionList - the fractions predefined by `fraction-list` project, which contains all wildfly-swarm fractions
3. init properties - properties passed from mvn build
4. set main class - main class name come from plugin config
5. set bundleDependencies - bundleDependencies come from plugin config
6. set executable - executable come from plugin config
7. set executableScript - executableScript come from plugin config
8. set fractionDetectMode - fractionDetectMode come from plugin config, default value is `when_missing`
9. init ArtifactResolvingHelper - a MavenArtifactResolvingHelper be created
10. set logger - BuildTool.SimpleLogger be create
11. set additionalFractions - additionalFractions come from plugin config, BuildTool's fraction method be used to set additionalFractions
12. set dependency - any dependency of project will be set to BuildTool
13. set Resources - any resource of project will be set to BuildTool
14. set additionalModules - additionalModules come from plugin config

Secondly, build the `-swarm.jar`.

1. analyze Dependencies - scan modules dependencies, scan bootstrap dependencies, analyze module dependencies, analyze provided dependencies
2. add Wildfly Swarm Bootstrap Jar - move swarm bootstrap.jar to target archive.
3. add WildFly Bootstrap Conf - `META-INF/wildfly-swarm-bootstrap.conf` 
4. add Manifest - mainClass be used
5. add WildFly Swarm Properties - `wildfly-swarm.properties`
6. add WildFly Swarm Application Conf - `META-INF/wildfly-swarm-application.conf`
7. add WildFly Swarm Dependencies Conf - `META-INF/wildfly-swarm-dependencies.conf` 
8. add Additional Modules
9. add Project Asset
10. populate UberJar Maven Repository

A traditional config:

~~~
<plugin>
    <groupId>org.wildfly.swarm</groupId>
    <artifactId>wildfly-swarm-plugin</artifactId>
    <version>2016.7-SNAPSHOT</version>
    <configuration>
        <mainClass>org.teiid.test.swarm.Main</mainClass>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>package</goal>
            </goals>
        </execution>
    </executions>
</plugin>
~~~

#### A simplest -swarm.jar

In this section, a project with a simple Main class and no dependency, then we focus on how -swam.jar be build.

## WildFly-Swarm container

A WildFly-Swarm container is the topest interface for Micro-Service WildFly Swarm, it use to start a simple JBoss MSC container, a tradition usag is

~~~
Swarm swarm = new Swarm();
swarm.start(); 
~~~ 

Fractions can be add to Container before container start, or Archives be deloyed after container start.

A WildFly-Swarm container represented by `org.wildfly.swarm.container.Container`, it contains the following private fileds represents the `fractions`, `socketBindingGroups`, `socketBindings`, `server`, `deployer`, etc. 

### Pre Container construction - bootstrap

`java -jar X-swarm.jar` can start the lightweight container and fragment, how does this implemented? If look at the `META-INF/MANIFEST.MF` uder the unberjar,

~~~
Manifest-Version: 1.0
Main-Class: org.wildfly.swarm.bootstrap.Main
WildFly-Swarm-Main-Class: org.teiid.test.swarm.Main
~~~

> NOTE: `org.wildfly.swarm.bootstrap.Main` is the entrence of run uberjar, this Main be run before Container construction. `WildFly-Swarm-Main-Class` come from [wildfly-swarm-plugin](#wildfly-swarm-plugin)'s configuration.

![Pre Container construction]({{ site.baseurl }}/assets/blog/wildfly/swarm-bootstrap-main.png)

The bootstrap Main first set `boot.module.loader`, then invoke the `WildFly-Swarm-Main-Class.` The `getMainClass()` code looks

~~~
String mainClassName = getMainClassName();
Module module = Module.getBootModuleLoader().loadModule(ModuleIdentifier.create("swarm.application"));
module.getClassLoader().loadClass(mainClassName);
~~~

> NOTE: How to set JBoss modules's BootModuleLoader? - system properties **boot.module.loader** can be used set BootModuleLoader, for example, `System.setProperty("boot.module.loader", BootModuleLoader.class.getName())`.

#### BootModuleLoader

Pre Container construction bootstrap mainly extended the jboss modules, made jboss modules can load zip file's internal modules, this due to the implementation of `org.wildfly.swarm.bootstrap.modules.BootModuleLoader`.

The boot module loader is the initial loader that is established by the module framework. It typically is based off of the environmental module path unless it is overridden by specifying a different class name for the `boot.module.loader` system property.`

BootModuleLoader defines a series of Module Finders:

~~~
public class BootModuleLoader extends ModuleLoader {

    public BootModuleLoader() throws IOException {
        super(new ModuleFinder[]{
                new BootstrapClasspathModuleFinder(),
                new BootstrapModuleFinder(),
                new ClasspathModuleFinder(),
                new ContainerModuleFinder(),
                new ApplicationModuleFinder(),
                new FlattishApplicationModuleFinder(),
        });
    }
}
~~~

As UML diagram:

![UML of ModuleFinder]({{ site.baseurl }}/assets/blog/wildfly/modules-ModuleFinder-uml.png)

* BootstrapClasspathModuleFinder - Used only for loading dependencies of org.wildfly.bootstrap:main from its own jar. The classpath modules in bootstrap including: `javax.api`, `javax.sql.api`, `org.jboss.msc`, etc
* BootstrapModuleFinder - Module-finder used only for loading the first set of jars when run in an fat-jar scenario.
* ClasspathModuleFinder
* BootstrapModuleFinder
* ApplicationModuleFinder
* FlattishApplicationModuleFinder

### Container construction

![Container construction]({{ site.baseurl }}/assets/blog/wildfly/swarm-container-constructor.png)

As figure, Container construction mainly do the following:

1. Check the 'swarm.debug.bootstrap' system property, if true enable bootstrap debug 
2. init 'userComponentClasses', 'explicitlyInstalledFractions', 'stageConfig', 'xmlConfig', 'stageConfigUrl' 
3. init main method 'args' 
4. JBoss logger be initialized, used to as logging system for container 
5. create ShrinkWrap Domain, a domain encapsulates a shared Configuration to be used by all Archives 
6. configure command-line base on passed arguments,'Container(boolean debugBootstrap, String... args)', args are command-line arguments 
7. If stageFile not null, load stage configuration 

Once Swarm be constructed, usually, it's start method be invoked, refer below section for more details.

### Swarm start

The main procedure of Swarm start including:

1. Swarm `RuntimeServer` as a bean instance be registered in Weld SE Container, all extentions be inject via Weld SE Container
2. untimeServer statr invoke SelfContainedContainer's start() method
3. MSC container start and install services.

![Swarm start]({{ site.baseurl }}/assets/blog/wildfly/swarm-container.png)

#### bootstrapOperations initilization

#### JBoss SelfContainedContainer start

A sample code to start MSC and install services via bootstrapOptions

~~~
import org.jboss.as.server.SelfContainedContainer;
import org.jboss.dmr.ModelNode;
import org.jboss.msc.service.ServiceActivator;
import org.jboss.msc.service.ServiceContainer;

SelfContainedContainer container = new SelfContainedContainer();
List<ModelNode> bootstrapOperations = new ArrayList<>();
SimpleContentProvider contentProvider = new SimpleContentProvider();
List<ServiceActivator> activators = new ArrayList<>();
ServiceContainer serviceContainer = container.start(bootstrapOperations, contentProvider, activators);
~~~
