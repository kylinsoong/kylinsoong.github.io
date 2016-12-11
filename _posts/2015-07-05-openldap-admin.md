---
layout: blog
title:  "OpenLDAP 安装, 配置与示例"
date:   2015-07-05 17:20:00
categories: linux
permalink: /linux-ldap
author: Kylin Soong
duoshuoid: ksoong2015070501
---

本文基于 OpenLDAP 2.4，内容主要包括 OpenLDAP 的简单配置及示例，详细关于 OpenLDAP 请参照 [OpenLDAP 文档]（http://www.openldap.org）。

* Table of contents
{:toc}

## OpenLDAP 安装

[Building and Installing OpenLDAP Software](http://www.openldap.org/doc/admin24/install.html).

### 在 RHEL 7 上安装 OpenLDAP

* Install the following packages:

~~~
yum install -y openldap openldap-clients openldap-servers migrationtools
~~~

* Generate a LDAP password from a secret key (here redhat):

~~~
slappasswd -s redhat -n > /etc/openldap/passwd
~~~

* Generate a X509 certificate valid for 365 days:

~~~
openssl req -new -nodes -out /etc/openldap/certs/cert.pem -keyout /etc/openldap/certs/priv.pem -days 365
~~~

* Secure the content of the /etc/openldap/certs directory:

~~~
cd /etc/openldap/certs/
chown ldap:ldap *
chmod 600 priv.pem
~~~

* Prepare the LDAP database:

~~~
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
~~~

* Generate database files

~~~
slaptest
~~~

* Change LDAP database ownership:

~~~
chown ldap:ldap /var/lib/ldap/*
~~~

* Activate the slapd service at boot:

~~~
systemctl enable slapd.service
~~~

* Start the slapd service:

~~~
systemctl start slapd.service
~~~

* Check the LDAP activity:

~~~
systemctl status slapd.service
netstat -lt | grep ldap
~~~

## OpenLDAP 配置

### 配置 slapd.conf

Linux 操作系统安装完成后，slapd.conf 文件的路径为 '/etc/openldap/slapd.conf', 编辑该文件，配置 root domain name:

~~~
database        bdb
suffix          "dc=example,dc=com"
checkpoint      1024 15
rootdn          "cn=Manager,dc=example,dc=com"
rootpw           secret 
directory       /var/lib/ldap
~~~

> NOTE: `rootdn` 和 `rootpw` 是 root domain，客户端连接，或第三方整合都需要此配置。

### 停止，启动，重起及查看状态命令

~~~
# service slapd stop
# service slapd start
# service slapd restart
# service slapd status
~~~

### 添加，删除，查看 entries

~~~
# ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f hr.ldif
# ldapdelete -v 'ou=HR,dc=example,dc=com' -D "cn=Manager,dc=example,dc=com" -w redhat
# ldapsearch -x
~~~

## OpenLDAP 示例

### Customers

本示例演示创建一个 Group `Tester`, 且在 Group `Tester` 下创建三个 Users: kylin, user1, user2.

[customer-security.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/customer-security.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f customer-security.ldif' 可完成创建

运行 Java 客户端代码 [OpenLDAPCustomerClient.java](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/src/main/java/org/jboss/teiid/ldap/OpenLDAPCustomerClient.java) 会有如下输出:

~~~
kylin, Kylin Soong, ksoong@example.com, Kylin
user1, User Test, user1@example.com, Test
user2, User Test, user2@example.com, Test
uniqueMember: uid=kylin,ou=Customers,dc=example,dc=com, uid=user1,ou=Customers,dc=example,dc=com, uid=user2,ou=Customers,dc=example,dc=com
uid=kylin,ou=Customers,dc=example,dc=com
uid=user1,ou=Customers,dc=example,dc=com
uid=user2,ou=Customers,dc=example,dc=com
~~~

### HR

本示例演示创建一个 Group `HR`，及在 Group `HR` 中添加 3 个 entries。 

[hr.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/hr.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f hr.ldif' 可完成创建

### WildFly RBAC

本示例演示创建组 Users，System，Groups，用户 ksoong，user1，user2，user3，user4，user5，以及 LDAP Admin Group，Special Account for Authentication.

[rbac.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/rbac.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f rbac.ldif' 可完成创建

