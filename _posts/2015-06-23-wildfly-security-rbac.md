---
layout: blog
title:  "WildFly 安全 - RBAC"
date:   2015-06-23 16:50:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015062301
excerpt: WildFly 安全之 Role Based Access Control
---

本文介绍 WildFly Management Console 相关的安全控制。WildFly 提供两种安全控制策略： `simple` 和 `rbac`， `simple` 是默认的策略，但生产过程中通过需要更的安全控制策略，这就需要 `rbac`，`rbac` 意思就是 Role Based Access Control。

WildFly RBAC 安全策略中 roles 包括: Monitor, Operator, Maintainer, Deployer, SuperUser, Administrator, Auditor. [详细内容参照 WildFly 文档](https://docs.jboss.org/author/display/WFLY9/RBAC)。 

本文从以下几个方面来介绍 WildFly RBAC 安全策略:

* 如何从 simple 切换到 rbac
* rbac 中 user/group mapping 示例
* LDAP 整合

## 如何从 simple 切换到 rbac

执行如下命令可切换 simple 到 rbac:

~~~
/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)
/core-service=management/access=authorization/role-mapping=SuperUser/include=admin:add(name=admin,realm=ManagementRealm,type=USER)
:reload()
~~~

> role-mapping 必须关联一个存在的user和realm. 登录 http://localhost:9990 可查看切换是否成功.

## rbac 中 user/group mapping 示例

本部分基于 WildFly 9 演示 rbac 安全策略下如何进行 user/group mapping.

### 安装 WildFly 9，创建 management 用户，启动 WildFly 9

~~~
$ unzip wildfly-9.0.0.Final.zip
$ ./bin/add-user.sh --silent=true admin password1!
$ ./bin/standalone.sh
~~~

> 注意: management 用户 `admin` 对应粥 RBAC 中的 SuperUser。

### simple 切换到 rbac

根据 '如何从 simple 切换到 rbac' 中内容执行如下命令:

~~~
/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)
/core-service=management/access=authorization/role-mapping=SuperUser/include=admin:add(name=admin,realm=ManagementRealm,type=USER)
:reload()
~~~

### 创建用户

执行如下命令创建 4 个用户:

~~~
./bin/add-user.sh --silent=true user1 password1!
./bin/add-user.sh --silent=true user2 password1!
./bin/add-user.sh --silent=true user3 password1!
./bin/add-user.sh --silent=true user4 password1!
~~~

### Mapping 用户

~~~
/core-service=management/access=authorization/role-mapping=Deployer:add()
/core-service=management/access=authorization/role-mapping=Maintainer:add()
/core-service=management/access=authorization/role-mapping=Operator:add()
/core-service=management/access=authorization/role-mapping=Administrator:add()
/core-service=management/access=authorization/role-mapping=Monitor:add()

/core-service=management/access=authorization/role-mapping=Deployer/include=user1:add(name=user1,type=USER,realm=ManagementRealm)
/core-service=management/access=authorization/role-mapping=Operator/include=user1:add(name=user1,type=USER,realm=ManagementRealm)

/core-service=management/access=authorization/role-mapping=Maintainer/include=user2:add(name=user2,type=USER,realm=ManagementRealm)
/core-service=management/access=authorization/role-mapping=Operator/include=user2:add(name=user2,type=USER,realm=ManagementRealm)

/core-service=management/access=authorization/role-mapping=Administrator/include=user3:add(name=user3,type=USER,realm=ManagementRealm)

/core-service=management/access=authorization/role-mapping=Monitor/include=user4:add(name=user4,type=USER,realm=ManagementRealm)
~~~

> user/group mapping 的关系如下:

* admin -> 'SuperUser'
* user1 -> 'Deployer', 'Operator'
* user2 -> 'Maintainer', 'Operator'
* user3 -> 'Administrator'
* user4 -> 'Monitor'

### 测试

使用不同的用户登录 web console (http://127.0.0.1:9990/console) 操作 WildFly。

## LDAP 整合

在实际生成环境中通常需要使用 LDAP 用户登录 WildFly，本部分我们结合 WildFly 9 和 OpenLDAP 2.4 演示 LDAP 整合。

### 安装配置 OpenLDAP

根据 [OpenLDAP 配置与示例](http://ksoong.org/openldap-admin) 中步骤完成 OpenLDAP 配置后运行 OpenLDAP RBAC 示例, 添加 [rbac.ldif](https://raw.githubusercontent.com/kylinsoong/data/master/openldap/rbac.ldif) 到 OpenLDAP。

> NOTE: OpenLDAP RBAC 示例添加的用户包括 ksoong, user1, user2, user3, user4.

### 安装 WildFly 9，创建 management 用户，启动 WildFly 9

~~~
$ unzip wildfly-9.0.0.Final.zip
$ ./bin/add-user.sh --silent=true admin password1!
$ ./bin/standalone.sh
~~~

### simple 切换到 rbac

根据 '如何从 simple 切换到 rbac' 中内容执行如下命令:

~~~
/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)
/core-service=management/access=authorization/role-mapping=SuperUser/include=ksoong:add(name=ksoong,realm=LDAPRealm,type=USER)
:reload()
~~~

### 添加 LDAPRealm

~~~
/core-service=management/security-realm=LDAPRealm:add()
/core-service=management/security-realm=LDAPRealm/authentication=ldap:add(connection=ldap,base-dn="ou=Users,dc=example,dc=com",username-attribute=uid)
// add authorization not support at the moment
~~~

编辑 standalone.xml，添加 LDAPRealm 

~~~
<security-realm name="LDAPRealm">
    <authentication>
        <ldap connection="ldap" base-dn="ou=Users,dc=example,dc=com">
            <username-filter attribute="uid"/>
        </ldap>
    </authentication>
    <authorization>
        <ldap connection="ldap">
           <group-search group-name="SIMPLE" iterative="true" group-dn-attribute="dn" group-name-attribute="cn">
                <group-to-principal base-dn="ou=Groups,dc=example,dc=com" recursive="true" search-by="DISTINGUISHED_NAME">
                    <membership-filter principal-attribute="uniqueMember" />
                </group-to-principal>
            </group-search>
        </ldap>
    </authorization>
</security-realm>
~~~

### 添加 LDAP Connection

~~~
/core-service=management/ldap-connection=ldap:add(url="ldap://10.66.218.46:389",search-dn="cn=Manager,dc=example,dc=com",search-credential="redhat")
~~~

### management-interface 使用 LDAPRealm

~~~
/core-service=management/management-interface=http-interface:write-attribute(name=security-realm,value=LDAPRealm)
~~~ 

### 测试

使用 LDAP 用户登录 WildFLy 测试.
