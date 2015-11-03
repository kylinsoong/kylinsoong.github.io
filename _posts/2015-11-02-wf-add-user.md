---
layout: blog
title:  "使用 add-user 脚本创建用户和角色"
date:   2015-11-03 16:45:12
categories: jboss
author: Kylin Soong
duoshuoid: ksoong2015110301
excerpt: JBoss/WildFly, add-user.sh/add-user.bat, Users/Roles
---

安装完 WildFly，进入到 $WF_HOME/bin 目录，

~~~
$ cd wildfly-10.0.0.CR4/bin/
$ ls
~~~

我们会发现 `add-user.sh` 和 `add-user.bat` 脚本，本文演示使用  add-user 脚本创建用户和角色，依次执行:

~~~
./bin/add-user.sh -a -u admin -p password1! -g admin
./bin/add-user.sh -a -u kylin -p password1! -g user
./bin/add-user.sh -a -u customer-portal -p password1! -g login
./bin/add-user.sh -a -u product-portal -p password1! -g login
./bin/add-user.sh -a -u third-party -p password1! -g oauth
~~~

如上我们创建了 5 个用户（admin, kylin, customer-portal, product-portal, third-party)位于不同的角色组(admin, user, login, oauth).

