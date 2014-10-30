---
layout: blog
title:  "Maven Plugin Gallery"
date:   2014-08-20 16:20:12
categories: maven
permalink: /maven-plugin-gallery
author: Kylin Soong
duoshuoid: ksoong20140820
---

This documents coontains a series Maven plugin usage sample and function depiction.

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

## maven-bundle-plugin

## maven-enforcer-plugin

## maven-jar-plugin



