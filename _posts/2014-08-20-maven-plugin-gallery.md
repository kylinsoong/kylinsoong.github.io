---
layout: blog
title:  "Maven Plugin Example Gallery"
date:   2014-08-20 16:20:12
categories: maven
permalink: /maven-plugin-gallery
author: Kylin Soong
duoshuoid: ksoong20140820
---

* Table of contents
{:toc}

## maven-dependency-plugin

[Apache Maven Dependency Plugin](https://maven.apache.org/plugins/maven-dependency-plugin/) provides the capability to manipulate artifacts. It can copy and/or unpack artifacts from local or remote repositories to a specified location.

### Example: Download Unpack WildFly Server & Install Modules

This example will demonstrate:

1. Download, unpack a WildFly Server
2. Install a module to WildFly modules.

**Run and Test**

[Downlad example](https://github.com/kylinsoong/teiid-test/tree/master/console/build), execute

~~~
$ mvn clean install
~~~

Once build success, check from Command line:

~~~
$ ls -l  target/wildfly-9.0.2.Final/modules/system/layers/dv/org/jboss/as/console/main/
-rw-rw-r--. 1 kylin kylin    1565 Mar 11 15:00 module.xml
-rw-rw-r--. 1 kylin kylin 9806914 Mar 11 15:00 teiid-hal-console-2.6.1-SNAPSHOT-resources.jar
~~~

> NOTE: `wildfly-9.0.2.Final` be download and unpacked under target folder, `teiid-hal-console` modules be installed successfully.

**Plugin Configure Files**

~~~
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <executions>
        <execution>
            <id>unpack-server-deps</id>
            <phase>package</phase>
            <goals>
                <goal>unpack</goal>
            </goals>
            <configuration>
                <artifactItems>
                    <artifactItem>
                        <groupId>org.wildfly</groupId>
                        <artifactId>wildfly-dist</artifactId>
                        <version>${version.org.wildfly}</version>
                        <type>zip</type>
                        <outputDirectory>${project.build.directory}</outputDirectory>
                    </artifactItem>
                    <artifactItem>
                        <groupId>org.jboss.teiid.hal</groupId>
                        <artifactId>dist</artifactId>
                        <version>${version.teiid.console}</version>
                        <classifier>overlay</classifier>
                        <type>zip</type>
                        <outputDirectory>${project.build.directory}/${dir.wildfly}</outputDirectory>
                     </artifactItem>
                </artifactItems>
            </configuration>
        </execution>
    </executions>
</plugin>
~~~

[Completed pom.xml](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/console/build/pom.xml)

## maven-enforcer-plugin

[Maven Enforcer Plugin](https://maven.apache.org/enforcer/maven-enforcer-plugin/) provides goals to control certain environmental constraints such as Maven version, JDK version and OS family along with many more standard rules and user created rules.

### Example-1: JDK version control example

This example will demonstrate how `maven-enforcer-plugin` enforce Project build use JDK 1.9.

**Run and Test**

[Download example](https://github.com/kylinsoong/teiid-test/tree/master/console/enforcer-plugin-example), execute

~~~
$ mvn clean install
~~~

If your build environment not use JDK 1.9, build will failed with plugin notification `The build works with JDK 9 only`. 

**Plugin Configure Files**

~~~
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>1.2</version>
    <executions>
        <execution>
            <id>enforce-versions</id>
            <goals>
                <goal>enforce</goal>
            </goals>
            <configuration>
                <rules>
                    <requireJavaVersion>
                        <version>[1.9,]</version>
                        <message>*** The build works with JDK 9 only! ***</message>
                    </requireJavaVersion>
                </rules>
            </configuration>
        </execution>
    </executions>
</plugin>
~~~

[Completed pom.xml](https://raw.githubusercontent.com/kylinsoong/teiid-test/master/console/enforcer-plugin-example/pom.xml)

## maven-antrun-plugin

Maven AntRun Plugin provides the ability to run Ant tasks from within Maven. More details refer to [http://maven.apache.org/plugins/maven-antrun-plugin/](http://maven.apache.org/plugins/maven-antrun-plugin/)

Usage example, the following pom will execute ant target before maven build:

~~~
<project>
  <modelVersion>4.0.0</modelVersion>
  <artifactId>my-test-app</artifactId>
  <groupId>my-test-group</groupId>
  <version>1.0-SNAPSHOT</version>
  <build>
    <plugins>
      <plugin>
	<groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-antrun-plugin</artifactId>
        <version>1.7</version>
        <executions>
          <execution>
	    <id>process-sources</id>
            <phase>generate-sources</phase>
            <configuration>
              <target>
		<echo>This is target for maven-antrun-plugin </echo> 
	      </target>
            </configuration>
            <goals>
              <goal>run</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
</project>
~~~

## javacc-maven-plugin

JavaCC Maven Plugin uses the JavaCC parser generator to process JavaCC grammar files and generate the appropriate Java source files. More details refer to [http://mojo.codehaus.org/javacc-maven-plugin/](http://mojo.codehaus.org/javacc-maven-plugin/)

Usage example, as below pom:

~~~
<project>
  <modelVersion>4.0.0</modelVersion>
  <artifactId>my-test-app</artifactId>
  <groupId>my-test-group</groupId>
  <version>1.0-SNAPSHOT</version>
  <build>
    <plugins>
       <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>javacc-maven-plugin</artifactId>
        <version>2.6</version>
        <executions>
          <execution>
            <id>javacc</id>
            <goals>
              <goal>javacc</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
</project>
~~~

Execute maven build or execute goal `mvn javacc:javacc` will generate java via grammars .jj file.

### Example.1 SimpleExamples 

This example will demonstrate javacc plugin to compile .jj file to java.

[https://github.com/kylinsoong/teiid-test/tree/master/mvn/javacc-maven-plugin-example.1](https://github.com/kylinsoong/teiid-test/tree/master/mvn/javacc-maven-plugin-example.1)

Execute mvn commands:

~~~
$ cd javacc-maven-plugin-example.1/
$ mvn javacc:javacc
~~~

Will generate java files as below:

~~~
$ ls -R target/generated-sources/javacc/
target/generated-sources/javacc/:
IdListConstants.java     NL_XlatorConstants.java     ParseException.java    Simple1TokenManager.java  Simple2TokenManager.java  Simple3TokenManager.java  TokenMgrError.java
IdList.java              NL_Xlator.java              Simple1Constants.java  Simple2Constants.java     Simple3Constants.java     SimpleCharStream.java
IdListTokenManager.java  NL_XlatorTokenManager.java  Simple1.java           Simple2.java              Simple3.java              Token.java
~~~

[More javacc examples](https://sourceforge.net/p/dacapobench/dacapobench/ci/d13c6cf87185ce2bc92d0c2ce9dbf908c8fbfc1f/tree/tools/javacc-4.2/examples/)

## maven-bundle-plugin

## maven-jar-plugin



