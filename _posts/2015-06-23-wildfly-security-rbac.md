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

RBAC roles 包括: Monitor, Operator, Maintainer, Deployer, SuperUser, Administrator, Auditor. [详细内容参照 WildFly 文档](https://docs.jboss.org/author/display/WFLY9/RBAC)。 

## simple 切换到 rbac

执行如下命令可切换 simple 到 rbac:

~~~
/core-service=management/access=authorization:write-attribute(name=provider,value=rbac)
/core-service=management/access=authorization/role-mapping=SuperUser/include=admin:add(name=admin,realm=ManagementRealm,type=USER)
:reload()
~~~

> role-mapping 必须关联一个存在的user和realm. 登录 http://localhost:9990 可查看切换是否成功.


