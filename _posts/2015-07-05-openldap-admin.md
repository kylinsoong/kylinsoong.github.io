---
layout: blog
title:  "OpenLDAP 配置与示例"
date:   2015-07-05 17:20:00
categories: data
permalink: /openldap-admin
author: Kylin Soong
duoshuoid: ksoong2015070501
---

本文基于 OpenLDAP 2.4，内容主要包括 OpenLDAP 的简单配置及示例，详细关于 OpenLDAP 请参照 [OpenLDAP 文档]（http://www.openldap.org）。

## OpenLDAP 配置

### 安装

[Building and Installing OpenLDAP Software](http://www.openldap.org/doc/admin24/install.html).

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

## OpenLDAP HR 示例

本示例演示创建一个 Group `HR`，及在 Group `HR` 中添加 3 个 entries。 

[hr.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/hr.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f hr.ldif' 可完成创建

## OpenLDAP RBAC 示例

本示例演示创建组 Users，System，Groups，用户 ksoong，user1，user2，user3，user4，user5，以及 LDAP Admin Group，Special Account for Authentication.

[rbac.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/rbac.ldif)

> NOTE: 执行 'ldapadd -x -D "cn=Manager,dc=example,dc=com" -w redhat -f rbac.ldif' 可完成创建


