---
layout: blog
title:  "使用 Kerberos 加密 REST Web 应用"
date:   2015-10-06 16:45:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015100602
excerpt: 使用 Kerberos LoginModule 加密 REST 服务, WildFly 安全, JAAS
---

本文说明如何使用 JAAS Kerberos LoginModule 加密 REST Web Service，**customer.war** 是一个提供 REST 服务的 Web 应用，它需要部署到 WildFly 对外提供服务。使用 Kerberos LoginModule 加密 REST Web 应用分如下几个步骤：

* 基于 Kerberos KDC 服务器创建用户
* 创建 security domain
* 配置 web.xml
* 配置 jboss-web.xml

本文的结尾有一个完整的示例，演示使用 Kerberos LoginModule 加密 REST Web 应用 customer.

## 基于 Kerberos KDC 服务器创建用户

[http://ksoong.org/kerberos-kds-install/](http://ksoong.org/kerberos-kds-install/) 介绍了Kerberos KDC 的配置与安装，参照此文档完成安装并创建 root 用户。本部分我们需要使用 root 登录到 kadmin:

~~~
# /usr/sbin/kadmin.local -p root/admin
~~~ 

登录完场创建两个 user:

~~~
ank kylin
ank HTTP/127.0.0.1
~~~

使用 `listprincs` 命令可以查看创建的 user:

~~~
kadmin.local:  listprincs 
HTTP/127.0.0.1@EXAMPLE.COM
krbtgt/EXAMPLE.COM@EXAMPLE.COM
kylin@EXAMPLE.COM
root/admin@EXAMPLE.COM
~~~

> NOTE: **HTTP/127.0.0.1@EXAMPLE.COM** 用户作为 SPN（Service Provider Principle），会在随后的 security domain 中使用， SPN 的作用主要是和 Kerberos 交互获取 Token 完成安全认证.

与之对应，我们需要创建 keytab:

~~~
ktadd -k /home/kylin/tmp/http.keytab HTTP/127.0.0.1
ktadd -k /home/kylin/tmp/kylin.keytab kylin
~~~

## 创建 security domain

启动 WildFly，执行如下 CLI 命令创建 security domain `test-security`:

~~~
/subsystem=security/security-domain=test-security:add(cache-type=default)
/subsystem=security/security-domain=test-security/authentication=classic:add()
/subsystem=security/security-domain=test-security/authentication=classic/login-module=Kerberos:add(code=Kerberos, flag=required, module-options={"storeKey"=>"true", "useKeyTab"=>"true", "refreshKrb5Config"=>"true", "keyTab"=>"/home/kylin/tmp/http.keytab", "principal"=>"HTTP/127.0.0.1@EXAMPLE.COM", "doNotPrompt"=>"true", "debug"=>"true"})
~~~

上述命令执行成功，WildFly 配置文件会出现如下配置：

~~~
<security-domain name="test-security" cache-type="default">
    <authentication>
        <login-module code="Kerberos" flag="required">
            <module-option name="storeKey" value="true"/>
            <module-option name="useKeyTab" value="true"/>
            <module-option name="refreshKrb5Config" value="true"/>
            <module-option name="keyTab" value="/home/kylin/tmp/http.keytab"/>
            <module-option name="principal" value="HTTP/127.0.0.1@EXAMPLE.COM"/>
            <module-option name="doNotPrompt" value="true"/>
            <module-option name="debug" value="true"/>
        </login-module>
    </authentication>
</security-domain>
~~~

执行如下 CLI 命令创建系统参数:

~~~
/system-property=java.security.krb5.conf:add(value=/etc/krb5.conf)
/system-property=java.security.krb5.debug:add(value=true)
/system-property=java.security.disable.secdomain.option:add(value=true)
~~~

上述命令执行成功，WildFly 配置文件会出现如下配置：

~~~
<system-properties>
    <property name="java.security.krb5.conf" value="/etc/krb5.conf"/>
    <property name="java.security.krb5.debug" value="true"/>
    <property name="java.security.disable.secdomain.option" value="true"/>
</system-properties>
~~~

## 配置 web.xml

编辑 web.xml，添加 basic authentication 配置如下:

~~~
     <security-role>
        <description>security role</description>
        <role-name>EXAMPLE.COM</role-name>
    </security-role>

    <security-constraint>
        <display-name>require valid user</display-name>
        <web-resource-collection>
            <web-resource-name>Test Rest Application</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>EXAMPLE.COM</role-name>
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
$ cd security-examples/customer-security-kerberos
$ mvn clean install
~~~

Build 成功会产生 customer.war 位于 target 目录下。

### 启动 WildFly 执行 CLI 命令

~~~
$ cd wildfly-9.0.0.Final/
$ ./bin/standalone.sh
$ cp ~/src/security-examples/customer-security-kerberos/src/scripts/* ./
$ ./bin/jboss-cli.sh --connect --file=create-security-domain-kerberos.cli
$ ./bin/jboss-cli.sh --connect --file=system-properties-kerberos.cli
~~~

### 部署 customer.war 测试

部署

~~~
$ cp target/customer.war ~/server/wildfly-9.0.0.Final/standalone/deployments/
~~~

访问 http://localhost:8080/customer/customerList 测试，会出现如下界面：

![Customer Security Plain File]({{ site.baseurl }}/assets/blog/customer-security-plainfile.png)

输入用户名 `kylin` 密码 `password` 认证成功。
