---
layout: blog
title:  "使用 JAAS DataBase LoginModule 加密 REST Web Service"
date:   2015-09-17 15:20:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015091701
excerpt: 使用 Database LoginModule 加密 REST 服务, WildFly 安全, JAAS
---

本文说明如何使用 JAAS 数据库 LoginModule 加密 REST Web Service，**customer.war** 是一个提供 REST 服务的 Web 应用，它需要部署到 WildFly 对外提供服务。使用数据库 LoginModule 加密 REST Web 应用分如下几个步骤：

* 创建 security domain
* 在数据库中创建 user 和 role 表
* 配置 web.xml
* 配置 jboss-web.xml

本文的结尾有一个完整的示例，演示使用 数据库 LoginModule 加密 REST Web 应用 customer.

## 创建 security domain

启动 WildFly，执行如下 CLI 命令创建 security domain `test-security`:

~~~
/subsystem=security/security-domain=test-security:add(cache-type=default)
/subsystem=security/security-domain=test-security/authentication=classic:add(login-modules=[{"code"=>"Database", "flag"=>"required", "module-options"=>[("dsJndiName"=>"java:jboss/datasources/testDS"),("principalsQuery"=>"SELECT password FROM user WHERE username=?"), ("rolesQuery"=>"SELECT rolename, 'Roles' FROM role r, user u WHERE u.userid=r.userid AND u.username=?")]}])
~~~

上述命令执行成功，WildFly 配置文件会出现如下配置：

~~~
<security-domain name="test-security" cache-type="default">
    <authentication>
        <login-module code="Database" flag="required">
            <module-option name="dsJndiName" value="java:jboss/datasources/testDS"/>
            <module-option name="principalsQuery" value="SELECT password FROM user WHERE username=?"/>
            <module-option name="rolesQuery" value="SELECT rolename, 'Roles' FROM role r, user u WHERE u.userid=r.userid AND u.username=?"/>
        </login-module>
    </authentication>
</security-domain>
~~~

> NOTE: security-domain 中 dsJndiName 指向关系数据库，principalsQuery 和 rolesQuery 分别指向数据中的 user 表和 role 表。

## 在数据库中创建 user 和 role 表

在关系数据库中执行如下 SQL 创建 user 和 role 表，并添加初始化数据。

~~~
create table user (
        userid integer not null,
        username varchar(35) not null,
        password varchar(250) not null,
        primary key (userid)
);

create table role (
        roleid integer not null,
        userid integer not null,
        rolename varchar(25) not null,
        primary key (roleid)
);

alter table role add constraint fk_role_to_user foreign key (userid) references user (userid);

INSERT INTO user(userid, username, password) VALUES (1, 'kylin', 'password1!');
INSERT INTO user(userid, username, password) VALUES (2, 'user1', 'password1!');
INSERT INTO user(userid, username, password) VALUES (3, 'user2', 'password1!');

INSERT INTO role(roleid, userid, rolename) VALUES(1, 1, 'test');
INSERT INTO role(roleid, userid, rolename) VALUES(2, 2, 'test');
INSERT INTO role(roleid, userid, rolename) VALUES(3, 3, 'test');
~~~

如上 SQL 执行成功创建 User `kylin` 位于 `test` Group。

启动 WildFly，执行如下 CLI 命令创建 DataSource `testDS` 指向上面数据库，本处以 H2 数据库为例，拷贝上面 SQL 语句到 SQL 文件 create-user.sql:

~~~
/subsystem=datasources/data-source=testDS:add(jndi-name=java:jboss/datasources/testDS,  enabled=true, use-java-context=true, driver-name=h2, connection-url="jdbc:h2:mem:test-security;INIT=RUNSCRIPT FROM '${jboss.home.dir}/create-user.sql'\;",user-name=sa, password=sa)
~~~

## 配置 web.xml

编辑 web.xml，添加 basic authentication 配置如下:

~~~
     <security-role>
        <description>security role</description>
        <role-name>test</role-name>
    </security-role>

    <security-constraint>
        <display-name>require valid user</display-name>
        <web-resource-collection>
            <web-resource-name>Test Rest Application</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>test</role-name>
        </auth-constraint>
    </security-constraint>

    <login-config>
        <auth-method>BASIC</auth-method>
        <realm-name>ksoong.org</realm-name>
    </login-config>
~~~

> NOTE: role-name 和数据库 role 表中 userid 对应的 Group 名相同。

## 配置 jboss-web.xml

编辑 jboss-web.xml，添加 security security domain 配置如下:

~~~
<security-domain>java:/jaas/test-security</security-domain>
~~~

> NOTE: security-domain 名称与 '创建 security domain' 中创建的 security domain 相同。

## 示例

使用如下步骤运行示例：

### 获取 customer.war

确保 Maven 3.x 和 Java 1.7 安装且配置完成。

~~~
$ git clone git@github.com:kylinsoong/security-examples.git
$ cd security-examples/customer-security-database
$ mvn clean install
~~~

Build 成功会产生 customer.war 位于 target 目录下。

### 启动 WildFly 执行 CLI 命令

~~~
$ cd wildfly-9.0.0.Final/
$ ./bin/standalone.sh
$ cp ~/src/security-examples/customer-security-database/src/scripts/* ./
$ ./bin/jboss-cli.sh --connect --file=create-security-domain-database.cli
$ ./bin/jboss-cli.sh --connect --file=create-ds-h2.cli
~~~

### 部署 customer.war 测试

部署

~~~
$ cp target/customer.war ~/server/wildfly-9.0.0.Final/standalone/deployments/
~~~

访问 http://localhost:8080/customer/customerList 测试，会出现如下界面：

![Customer Security Plain File]({{ site.baseurl }}/assets/blog/customer-security-plainfile.png)

输入用户名 `kylin`(或 `user1`, `user2`) 密码 `password1!` 认证成功。
