---
layout: blog
title:  "如何调试 EAP 6/WildFly Domain 模式"
date:   2014-10-22 11:40:12
categories: jboss
permalink: /jboss-mysql
author: Kylin Soong
duoshuoid: ksoong2014102201
---

本文演示如何基于 JBoss EAP 6/WildFly 配置 Mysql 数据源，本文演示通过如下两种方式配置 Mysql 数据源：

* 手动修改配置文件

* 管理命令配置 

在 Linux 操作系统下，运行 JBoss 启动文件

~~~
./standalone.sh
~~~

启动 JBoss 后运行

~~~
./jboss-cli.sh --connect
~~~

可启动并连接到 JBoss 命令行管理界面。

我们所需的 Mysql 用户名，密码，数据库的创建如下：

~~~
    CREATE DATABASE jdv60;  
    create user 'jdv_user'@'localhost' identified by 'jdv_pass';  
    grant all on jdv60.* to jdv_user@'localhost';  
    FLUSH PRIVILEGES;  
~~~

## 手动修改配置文件

配置的大致步骤如下。

### 添加Mysql数据库驱动模块到JBoss

在JBOSS_HOME/modules/目录下创建com/mysql/main目录，将Mysql驱动jar（例如mysql-connector-java-5.1.6.jar）拷贝到此目录下，并同在此目录下创建module.xml文件，添加内容如下：

~~~
<?xml version="1.0" encoding="UTF-8"?>  
<module xmlns="urn:jboss:module:1.1" name="com.mysql">  
    <resources>  
        <resource-root path="mysql-connector-java-5.1.6.jar"/>  
    </resources>  
    <dependencies>  
        <module name="javax.api"/>  
        <module name="javax.transaction.api"/>  
    </dependencies>  
</module> 
~~~

### 添加驱动配置到JBoss服务器配置文件

编辑JBOSS_HOME/standalone/configuration/standalone.xml文件，在<subsystem xmlns="urn:jboss:domain:datasources处datasources，drivers中添加如下内容：

~~~
<driver name="mysql" module="com.mysql">     
    <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>  
</driver> 
~~~

### 配置数据源

编辑JBOSS_HOME/standalone/configuration/standalone.xml文件，在<subsystem xmlns="urn:jboss:domain:datasources处datasources中添加mysql数据源，如下：

~~~
    <datasource jndi-name="java:jboss/datasources/mysqlDS" pool-name="mysqlDSPool">    
          <connection-url>jdbc:mysql://localhost:3306/jdv60</connection-url>    
          <driver>mysql</driver>    
          <security>    
             <user-name>jdv_user</user-name>    
             <password>jdv_pass</password>    
          </security>    
    </datasource>   
~~~

## 管理命令配置

类似手动修改配置文件，配置的大致步骤如下。

### 添加Mysql数据库驱动到JBoss module

已知 Mysql 数据库驱动 mysql-connector-java-5.1.30.jar 位于 /home/kylin/tools/jars 目录，使用如下命令添加Mysql数据库驱动模块到JBoss：

~~~
module add --name=com.mysql --resources=/home/kylin/tools/jars/mysql-connector-java-5.1.30.jar --dependencies=javax.api,javax.transaction.api
~~~

### 注册 Mysql数据库驱动

~~~
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-xa-datasource-class-name=com.mysql.jdbc.jdbc2.optional.MysqlDataSource)
~~~

确认如上配置

~~~
/subsystem=datasources/jdbc-driver=mysql:read-resource
~~~

### 配置数据源

~~~
/subsystem=datasources/data-source=MysqlDS:add(jndi-name="java:jboss/datasources/mysqlDS",connection-url="jdbc:mysql://localhost:3306/jdv60",driver-name=mysql,user-name=jdv_user,password=jdv_pass)
~~~

确认如上配置

~~~
/subsystem=datasources/data-source=MysqlDS:read-resource
~~~

