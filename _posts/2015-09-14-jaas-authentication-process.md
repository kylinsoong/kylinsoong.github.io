---
layout: blog
title:  "JAAS 认证过程"
date:   2015-09-14 20:20:12
categories: security
permalink: /jaas-auth-process
author: Kylin Soong
duoshuoid: ksoong2015091401
---

本文通过一个示例说明 JAAS Authentication 过程。

## 运行示例

运行示例分三步: 获取代码，编译代码，运行示例

### 获取代码

~~~
$ git clone git@github.com:kylinsoong/security-examples.git
~~~

### 编译代码

~~~
$ cd security-examples/jaas-authentication-tutorial
$ mvn clean install
~~~

> NOTE: 编译代码需要 Maven 3.x 和 Java

### 运行示例

~~~
$ java -Djava.security.auth.login.config=jaas.config -cp target/jaas-authentication-loginModule.jar javax.security.examples.auth.spi.UsernamePasswordMain
Username: admin
Password: admin
Authentication succeeded!
~~~

> NOTE: 如果输入的用户名不是 `admin` 或密码不是 `admin` 则认证失败，且如果连续三次认证失败后程序退出。

## JAAS 认证过程

![JAAS Authentication]({{ site.baseurl }}/assets/blog/jaas-auth-process.png)

如上图所示，JAAS 认证过程分如下几个步骤:

**1.** 实例化一个 `javax.security.auth.login.LoginContext` 对象，它负责协调认证过程。该过程可用如下代码描述:

~~~
LoginContext lc = new LoginContext(name, new CallbackHandler());
~~~

* name 指向安全配置文件（[jaas.config](https://raw.githubusercontent.com/kylinsoong/security-examples/master/jaas-authentication-loginModule/jaas.config)）中 loginModule 的名字
* CallbackHandler 用于处理 loginModule 传入的 callbacks  

**2.** LoginContext 获取安全配置文件（[jaas.config](https://raw.githubusercontent.com/kylinsoong/security-examples/master/jaas-authentication-loginModule/jaas.config)），实例化 Configuration 对象。如下为一个安全配置文件示例:

~~~
UsernamePassword {
   javax.security.examples.auth.spi.UsernamePasswordLoginModule required debug=true;
};
~~~

它通过系统参数传入:

~~~
-Djava.security.auth.login.config=jaas.config
~~~ 

**3.** LoginContext 通过 `javax.security.auth.login.Configuration` 对象获取 LoginModule 实例列表。通常 Configuration 对象的实现在实例化过程中加载解析配置文件。

**4.** Configuration 对象返回 LoginModule 实例列表

**5.** 客户端代码调运 LoginContext 的 login 方法

**6.** LoginContext 根据 Configuration 对象返回 LoginModule 实例列表，实例化 LoginModule。

**7.** LoginContext 调运 LoginModule 的 initialize 方法

**8.** LoginContext 调运 LoginModule 的 login 方法

**9.** LoginContext 调运 LoginModule 的 commit 方法

**10.** 认证的信息被保存在 Subject 中
