---
layout: blog
title:  "Apache CXF 微博客户端"
date:   2015-10-19 22:00:12
categories: javaee
author: Kylin Soong
duoshuoid: ksoong2015101902
---

Apache CXF (http://cxf.apache.org/) 实现了 JAX-RS 标准，基于JAX-RS 在服务器端，客户端，安全方面等都提供了很好的实现。本文演示如何通过 Apache CXF 客户端实现一个发送微博的小应用。完整的步骤如下：

* 在微博开放平台注册一个应用
* 执行微博 OAuth 2.0 认证获取 access token
* Apache CXF 客户端发微博

## 在微博开放平台注册一个应用

在微博开放平台（http://open.weibo.com/）创建一个应用如下图所示:

![weibo create app]({{ site.baseurl }}/assets/blog/weibo-api-1.png)

> NOTE: 应用可以是任意名称。

点击`创建`按钮后，添加相关的信息如下图所示

![weibo create app info 2]({{ site.baseurl }}/assets/blog/weibo-api-2.png)

> NOTE: 上图中 **App Key** 和 **App Secret** 会在获取 access token 中使用到

配置 OAuth 2.0 授权回调链接，如下：

![weibo create app info 3]({{ site.baseurl }}/assets/blog/weibo-api-3.png)

完成如上配置后保存

## 执行微博 OAuth 2.0 认证获取 access token

使用 `CustomizedTools-jar` 小工具，选择 `auth`，种类选择 `OAuth2-Weibo` 如下

* 获取 CustomizedTools-jar

~~~
$ git clone git@github.com:CustomizedTools/CustomizedTools-jar.git
$ cd CustomizedTools-jar
$ mvn clean install -P release
~~~

编译成功会获得 customizedTools-jar，位于 "build/target" 目录下。

详细关于 CustomizedTools-jar，参照 [https://github.com/CustomizedTools/CustomizedTools-jar](https://github.com/CustomizedTools/CustomizedTools-jar)

* 允许

~~~
$ java -jar build/target/customizedTools-jar.jar
[CustomizedTools /]auth -t OAuth2-Weibo
=== OAuth 2.0 Weibo Workflow ===

Enter the Client ID = 387641515121

Enter the Client Secret = 5e4f21aaddc2bd6596689fe16d8215a24e5

Enter callback = https://api.weibo.com/oauth2/default.html

Open your broswer, access below URL to execute authorization:
https://api.weibo.com/oauth2/authorize?client_id=3876415151&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html&forcelogin=true

Enter Token Secret (Auth Code, Pin) from previous step = 67132e17b0eb44c92d38da484ff57d0d

Post URL: https://api.weibo.com/oauth2/access_token?client_id=3876415151&client_secret=5e4f21ac2bd6596689fe16d8215a24e5&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&code=67132e17b0eb44c92d38da484ff57d0d
Response:
{"access_token":"2.00PZtDyBBfC2OE91c7asdsds","remind_in":"157679999","expires_in":157679999,"uid":"1803641581"}
Enter the token from above json response = 2.00PZtDyBBfC2OE91c7a884547pNg4E
~~~

认证过程出现界面如下图所示，`2.00PZtDyBBfC2OE91c7asdsds` 为 access_token。

![weibo create app info 4]({{ site.baseurl }}/assets/blog/weibo-api-4.png)

## Apache CXF 客户端发微博

Apache CXF 客户端首先需要添加如下 Maven 依赖

~~~
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-rt-rs-client</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-rt-rs-security-oauth</artifactId>
</dependency>
~~~

运行如下 Java 代码:

~~~
String statuses_update = "https://api.weibo.com/2/statuses/update.json";
WebClient wc = WebClient.create(statuses_update);
wc.form(new Form().param("status", "Apache CXF Client form").param("access_token", "2.00PZtDyBBfC2OE91c7asdsds"));
~~~

运行如上代码后会发布一条微博，登录 weibo.com 查看如下图:

![weibo create app info 5]({{ site.baseurl }}/assets/blog/weibo-api-5.png)
