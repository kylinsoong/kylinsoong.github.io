---
layout: blog
title:  "Maven 使用本地依赖包"
date:   2019-08-12 18:20:12
categories: maven
author: Kylin Soong
---

Maven 构建应用的时，在某些情况下，依赖包只存在在本地，本文说明如何配置 Maven 的配置问题使用本地的依赖包。

## "Could not resolve dependencies" 错误

通过如果找不到依赖包，执行 mvn 命令编译构建时会抛出如下错误

~~~
$ mvn clean install
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.681 s
[INFO] Finished at: 2019-08-12T16:41:40-04:00
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal on project smaple: Could not resolve dependencies for project org.ksoong:smaple:jar:1.0: Could not find artifact org.geotools:gt-shapefile:jar:19.0 in central (https://repo.maven.apache.org/maven2) -> [Help 1]
...
~~~

## 安装本地依赖

安装本地依赖到本地 Maven 仓库

~~~
$ ls -l gt-shapefile-19.0.jar 
-rw-r--r--  1 ksoong  staff  2976 Aug 12 15:15 gt-shapefile-19.0.jar

$ mvn install:install-file -Dfile=gt-shapefile-19.0.jar -DgroupId=org.geotools -DartifactId=gt-shapefile -Dversion=19.0 -Dpackaging=jar
~~~

## 重新编译

重新编译之前错误的项目:

~~~
$ mvn clean install
...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.032 s
[INFO] Finished at: 2019-08-12T16:44:39-04:00
[INFO] ------------------------------------------------------------------------
~~~

