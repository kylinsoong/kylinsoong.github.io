---
layout: blog
title:  "Rest Web Service CustomerList 示例"
date:   2014-09-10 16:05:00
categories: javaee
permalink: /jaxrs-customers
author: Kylin Soong
duoshuoid: ksoong2014091002
---

Rest Web Service CustomerList 提供获取所有客户信息的服务，本文演示如何部署 CustomerList 到 JBoss EAP 6，并通过客户端测试获取客户信息。。

## CustomerList 部署

* 本示例代码: [https://github.com/kylinsoong/jaxrs/tree/master/customer](https://github.com/kylinsoong/jaxrs/tree/master/customer)

* 使用 Maven 命令

~~~
mvn clean install
~~~

可以生成 `CustomerRESTWebSvc.war`,我们将 `CustomerRESTWebSvc.war` 部署到 JBoss EAP 6。

## 测试获取客户信息

通过浏览器访问 [http://localhost:8080/CustomerRESTWebSvc/MyRESTApplication/customerList](http://localhost:8080/CustomerRESTWebSvc/MyRESTApplication/customerList)，所有客户信息会显示到页面。
