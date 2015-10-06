---
layout: blog
title:  "使用 LDAP 加密 REST Web 应用"
date:   2015-09-17 17:55:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015091701
excerpt: 使用 LDAP LoginModule 加密 REST 服务, WildFly 安全, JAAS
---

本文说明如何使用 JAAS LDAP LoginModule 加密 REST Web Service，**customer.war** 是一个提供 REST 服务的 Web 应用，它需要部署到 WildFly 对外提供服务。使用 LDAP LoginModule 加密 REST Web 应用分如下几个步骤：

* 创建 security domain
* 基于 LDAP 服务器创建 user 和 group
* 配置 web.xml
* 配置 jboss-web.xml

本文的结尾有一个完整的示例，演示使用 LDAP LoginModule 加密 REST Web 应用 customer.

## 创建 security domain

启动 WildFly，执行如下 CLI 命令创建 security domain `test-security`:

~~~
/subsystem=security/security-domain=test-security:add(cache-type=default)
/subsystem=security/security-domain=test-security/authentication=classic:add()
/subsystem=security/security-domain=test-security/authentication=classic/login-module=LdapExtended:add(code=LdapExtended, flag=required, module-options={"java.naming.factory.initial"=>"com.sun.jndi.ldap.LdapCtxFactory", "java.naming.provider.url"=>"ldap://10.66.218.46:389", "java.naming.security.authentication"=>"simple", "bindDN"=>"cn=Manager,dc=example,dc=com", "bindCredential"=>"redhat", "baseCtxDN"=>"ou=Customers,dc=example,dc=com", "baseFilter"=>"(uid={0})", "rolesCtxDN"=>"ou=Roles,dc=example,dc=com", "roleFilter"=>"(uniqueMember={1})", "roleAttributeID"=>"cn"})
~~~

上述命令执行成功，WildFly 配置文件会出现如下配置：

~~~
<security-domain name="test-security" cache-type="default">
    <authentication>
        <login-module code="LdapExtended" flag="required">
            <module-option name="java.naming.factory.initial" value="com.sun.jndi.ldap.LdapCtxFactory"/>
            <module-option name="java.naming.provider.url" value="ldap://10.66.218.46:389"/>
            <module-option name="java.naming.security.authentication" value="simple"/>
            <module-option name="bindDN" value="cn=Manager,dc=example,dc=com"/>
            <module-option name="bindCredential" value="redhat"/>
            <module-option name="baseCtxDN" value="ou=Customers,dc=example,dc=com"/>
            <module-option name="baseFilter" value="(uid={0})"/>
            <module-option name="rolesCtxDN" value="ou=Roles,dc=example,dc=com"/>
            <module-option name="roleFilter" value="(uniqueMember={1})"/>
            <module-option name="roleAttributeID" value="cn"/>
        </login-module>
    </authentication>
</security-domain>
~~~

> NOTE: security-domain 中 module-option 指向 LDAP 服务器。

## 基于 LDAP 服务器创建 user 和 group

[OpenLDAP 配置与示例](http://ksoong.org/openldap-admin/) 中说明如何配置创建 User 和 Group，参见此文档

本示例演示创建一个 Group `Tester`, 且在 Group `Tester` 下创建三个 Users: kylin, user1, user2.

[customer-security.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/customer-security.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f customer-security.ldif' 可完成创建

## 配置 web.xml

编辑 web.xml，添加 basic authentication 配置如下:

~~~
     <security-role>
        <description>security role</description>
        <role-name>Tester</role-name>
    </security-role>

    <security-constraint>
        <display-name>require valid user</display-name>
        <web-resource-collection>
            <web-resource-name>Test Rest Application</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>Tester</role-name>
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
$ cd security-examples/customer-security-ldap
$ mvn clean install
~~~

Build 成功会产生 customer.war 位于 target 目录下。

### 启动 WildFly 执行 CLI 命令

~~~
$ cd wildfly-9.0.0.Final/
$ ./bin/standalone.sh
$ cp ~/src/security-examples/customer-security-ldap/src/scripts/* ./
$ ./bin/jboss-cli.sh --connect --file=create-security-domain-ldap.cli
~~~

### 部署 customer.war 测试

部署

~~~
$ cp target/customer.war ~/server/wildfly-9.0.0.Final/standalone/deployments/
~~~

访问 http://localhost:8080/customer/customerList 测试，会出现如下界面：

![Customer Security Plain File]({{ site.baseurl }}/assets/blog/customer-security-plainfile.png)

输入用户名 `kylin`(或 `user1`, `user2`) 密码 `password` 认证成功。
