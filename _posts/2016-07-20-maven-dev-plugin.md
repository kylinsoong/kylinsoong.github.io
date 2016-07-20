---
layout: blog
title:  "Maven 插件开发示例"
date:   2016-07-20 12:15:12
categories: maven
permalink: /maven-dev-plugin
author: Kylin Soong
duoshuoid: ksoong20160720
---

本文通过 Hello World 示例演示 Maven 插件的开发过程。

* Table of contents
{:toc}

## 创建工程

执行 Maven archetype:create 创建初始工程

~~~
mvn archetype:create -DgroupId=sample.plugin -DartifactId=hello-maven-plugin
~~~

编辑 hello-maven-plugin/pom.xml 添加如下依赖

~~~
<dependency>
    <groupId>org.apache.maven</groupId>
    <artifactId>maven-plugin-api</artifactId>
    <version>3.2.5</version>
</dependency>
<dependency>
    <groupId>org.apache.maven.plugin-tools</groupId>
    <artifactId>maven-plugin-annotations</artifactId>
    <version>3.4</version>
    <scope>provided</scope>
</dependency>
~~~

编辑 hello-maven-plugin/pom.xml，修改 packaging 为 maven-plugin

~~~
<packaging>maven-plugin</packaging>
~~~

编辑 hello-maven-plugin/pom.xml，修改 version 为 1.0

~~~
<version>1.0</version>
~~~

## 开发简单 Mojo 插件并测试

创建类 GreetingMojo 继承 AbstractMojo，再实现的方法中日志输出 Hello World 如下

~~~
package sample.plugin.maven;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;

@Mojo( name = "sayhi")
public class GreetingMojo extends AbstractMojo {

	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {

		getLog().info( "Hello, world." );
	}
}
~~~

编译 hello-maven-plugin，将其发布到本地仓库:

~~~
$ mvn clean install
~~~

### 测试

在任意 Maven 工程中配置 hello-maven-plugin 如下

~~~
...
<build>
    <plugins>
        <plugin>
            <groupId>sample.plugin</groupId>
            <artifactId>hello-maven-plugin</artifactId>
            <version>1.0</version>
        </plugin>
    </plugins>
</build>
...
~~~

配置完成执行

~~~
$ mvn sample.plugin:hello-maven-plugin:sayhi
~~~

或

~~~
$ mvn hello:sayhi
~~~

> NOTE: Maven 插件的命名如果为 ${prefix}-maven-plugin 或 maven-${prefix}-plugin，插件的执行可简化为 `mvn prefix:goal`

### 在编译的过程中执行 sayhi

在任意 Maven 工程中配置 hello-maven-plugin 如下

~~~
...
<build>
    <plugins>
        <plugin>
            <groupId>sample.plugin</groupId>
            <artifactId>hello-maven-plugin</artifactId>
            <version>1.0</version>
	    <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>sayhi</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
...
~~~

配置完成执行

~~~
$ mvn package
~~~

输出 Hello, world.

## 添加参数

修改 GreetingMojo，添加

~~~
@Parameter( property = "sayhi.greeting", defaultValue = "Hello World!" )
private String greeting;
~~~

并修改日志输出为

~~~
getLog().info(greeting);
~~~

重新编译发布 hello-maven-plugin 到本地仓库

### 测试

在任意 Maven 工程中配置 hello-maven-plugin 如下

~~~
...
<build>
    <plugins>
        <plugin>
            <groupId>sample.plugin</groupId>
            <artifactId>hello-maven-plugin</artifactId>
            <version>1.0</version>
            <configuration>
                <greeting>Welcome</greeting>
            </configuration>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>sayhi</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
...
~~~

配置完成执行

~~~
$ mvn package
~~~

输出 Welcome.

## 示例代码

* [hello-maven-plugin](https://github.com/kylinsoong/teiid-test/tree/master/mvn/hello-maven-plugin/hello-maven-plugin)
* [测试 pom.xml](https://github.com/kylinsoong/teiid-test/blob/master/mvn/hello-maven-plugin/pom.xml)

