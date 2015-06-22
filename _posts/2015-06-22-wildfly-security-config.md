---
layout: blog
title:  "WildFly 安全 - 加密配置文件"
date:   2015-06-22 16:50:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015062201
excerpt: 使用 property 文件保存配置信息， 加密敏感配置属性， 使用 vault 加密敏感配置属性
---

本文演示使用不同的方法加密 WildFly 的配置文件:

* 使用 property 文件保存配置信息
* 加密敏感配置属性
* 使用 vault 加密敏感配置属性

## 使用 property 文件保存配置信息

WildFly 默认提供 property 替换的功能，配置文件( standalone.xml, domain.xml, host.xml)中如果使用 {your.property}, 则它转化成相对应的系统属性。基于此，我们可以通过使用 property 文件保存配置信息的方法来在一定程度上加密 WildFly 的配置文件。 

### 示例.1 使用 property 文件保存 WildFly 绑定的 IP 地址

* 在 WILDFLY_HOME 在创建 wildfly.properties 文件且添加如下内容

~~~
jboss.bind.address=10.0.0.1
~~~

> 10.0.0.1 为绑定的 IP 地址，Linux 下 `ifconfig em1:1 10.0.0.1 netmask 255.255.255.0` 可用于创建一个虚拟地址.

* 启动 WildFly

~~~
$ ./bin/standalone.sh -P wildfly.properties
~~~

* 测试

查看日志确保启动完成，通过 http://10.0.0.1:8080 访问 WildFly 欢迎页面.

### 示例.2 使用 property 文件保存数据库链接属性

* 在 WILDFLY_HOME 在创建 mysql.properties 文件且添加如下内容

~~~
db.prod.conn.url=jdbc:mysql://10.0.0.1:3306/store
db.prod.uid=username
dp.prod.pwd=password
~~~

> properties 属性 db.prod.conn.url, db.prod.uid, db.prod.pwd 分别指向 Mysql 数据库的 URL, 用户名, 密码

* 配置 Mysql DataSource 如下

~~~
<subsystem xmlns="urn:jboss:domain:datasources:1.1">
    <datasources>
	<datasource jndi-name="java:jboss/MySqlDS" pool-name="MySqlDS">
		<connection-url>${db.prod.conn.url}</connection-url>
		<driver>mysql</driver>
		<security>
			<user-name>${db.prod.uid}</user-name>
			<password>${db.prod.pwd}</password>
		</security>
	</datasource>
	<drivers/>
    </datasources>
</subsystem>
~~~

* 启动 WildFly

~~~
$ ./bin/standalone.sh -P mysql.properties
~~~

* 测试

查看日志确保启动完成，使用 CLI 命令测试 MySqlDS 是否创建成功

## 加密敏感配置属性

通常我们可以使用加密算法(AES, RSA, Blowfish)来加密配置文件中的敏感配置属性，本处演示使用 `therm hash` 加密 DataSource 的配置属性。

### 示例.3 使用 `therm hash` 加密 DataSource 密码

* 生成加密串

~~~
$ java -cp modules/system/layers/base/org/picketbox/main/picketbox-4.9.2.Final.jar org.picketbox.datasource.security.SecureIdentityLoginModule password
Encoded password: 5dfc52b51bd35553df8592078de921bc
~~~

> `5dfc52b51bd35553df8592078de921bc` 即为生成的加密串

* 创建 security-domain

使用 CLI 命令创建 security-domain encrypted-security-domain:

~~~
/subsystem=security/security-domain=encrypted-security-domain:add(cache-type=default)
/subsystem=security/security-domain=encrypted-security-domain/authentication=classic:add
/subsystem=security/security-domain=encrypted-security-domain/authentication=classic/login-module=DataSource:add(code=org.picketbox.datasource.security.SecureIdentityLoginModule, flag=required,module-options={username=username, password=5dfc52b51bd35553df8592078de921bc}
~~~

> Note the password in CLI should match to above step generated string.

* 创建 DataSource

~~~
<subsystem xmlns="urn:jboss:domain:datasources:1.1">
    <datasources>
        <datasource jndi-name="java:jboss/MySqlDS" pool-name="MySqlDS">
                <connection-url>jdbc:mysql://10.0.0.1:3306/store</connection-url>
                <driver>mysql</driver>
                <security>
                        <security-domain>encrypted-security-domain</security-domain>
                </security>
        </datasource>
        <drivers/>
    </datasources>
</subsystem>

~~~

## 使用 vault 加密敏感配置属性

// coming soon
