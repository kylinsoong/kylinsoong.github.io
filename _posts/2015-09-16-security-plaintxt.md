---
layout: blog
title:  "使用 Plain-text 加密 REST Web 应用"
date:   2015-09-16 21:40:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015091601
excerpt: 使用 Plain-text 加密 REST 服务, WildFly 安全, JAAS
---

本文说明如何使用 JAAS Plain-text LoginModule 加密 REST Web Service，**customer.war** 是一个提供 REST 服务的 Web 应用，它需要部署到 WildFly 对外提供服务。使用 Plain-text 加密 REST Web 应用分如下几个步骤：

* 创建 security domain
* 创建 Application User
* 配置 web.xml
* 配置 jboss-web.xml

本文的结尾有一个完整的示例，演示使用 Plain-text 加密 REST Web 应用 customer.

## 创建 security domain

启动 WildFly，执行如下 CLI 命令创建 security domain `test-security`:

~~~
/subsystem=security/security-domain=test-security:add(cache-type=default)
/subsystem=security/security-domain=test-security/authentication=classic:add()
/subsystem=security/security-domain=test-security/authentication=classic/login-module=RealmDirect:add(code=RealmDirect, flag=sufficient, module-options=[("password-stacking"=>"useFirstPass")])
~~~

上述命令执行成功，WildFly 配置文件会出现如下配置：

~~~
<security-domain name="test-security" cache-type="default">
    <authentication>
        <login-module code="RealmDirect" flag="sufficient">
            <module-option name="password-stacking" value="useFirstPass"/>
        </login-module>
    </authentication>
</security-domain>
~~~

## 创建 Application User

使用 WildFly add-user.sh 脚本创建 Application User:

~~~
$ ./bin/add-user.sh -a -u kylin -p password1! -g test
~~~

如上命令执行成功创建 Application User `kylin` 位于 `test` Group。

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

> NOTE: role-name 和 '创建 Application User' 中创建的 Group 相同。

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
$ cd security-examples/customer-security-file
$ mvn clean install
~~~

Build 成功会产生 customer.war 位于 target 目录下。

### 启动 WildFly 执行 CLI 命令

~~~
$ cd wildfly-9.0.0.Final/
$ ./bin/add-user.sh -a -u kylin -p password1! -g test
$ ./bin/standalone.sh
$ cp ~/src/security-examples/customer-security-file/src/scripts/create-security-domain-file.cli ./
$ ./bin/jboss-cli.sh --connect --file=create-security-domain-file.cli
~~~

### 部署 customer.war 测试

部署

~~~
$ cp target/customer.war ~/server/wildfly-9.0.0.Final/standalone/deployments/
~~~

访问 http://localhost:8080/customer/customerList 测试，会出现如下界面：

![Customer Security Plain File]({{ site.baseurl }}/assets/blog/customer-security-plainfile.png)

输入用户名 `kylin` 密码 `password1!` 认证成功。
