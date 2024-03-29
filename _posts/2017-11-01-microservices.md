---
layout: blog
title:  "微服务 I - 概念汇总"
date:   2017-11-01 19:00:00
categories: microservice
permalink: microservice-concepts
author: Kylin Soong
---

* Table of contents
{:toc}

## 什么是微服务

* 通过一系列松散耦合的服务去实现满足业务需求的应用，这种架构能使大的、复杂的应用通过CI/CD、DevOps 等方式去管理维护，极大的缩短了复杂应用从开发到部署的时间（数量级）。

## 传统单体(Monolith)架构

![Monolith Architecture]({{ site.baseurl }}/assets/blog/2017/monolith-architecture.png)

传统单体(Monolith)架构是指将实现满足业务需求的应用打包成一个部署包或一个可执行包，目前最常见的单体架构应用是通过 JavaEE、Spring 技术开发，打包构建生成一个大的 WAR/EAR 包，最后部署到应用服务上(Tomcat，JBoss)。

尽管单体(Monolith)架构有比较成熟的开发管理等多数技术人员熟悉的方案，但随着技术革新，特别移动、互联网、大数据等对传统企业的影响，单体架构一些突出缺点严重阻碍企业发展，具体包括:

**IT 系统构建的成本增高、业务响应的周期变长** 

随着业务个数和复杂度的增加，一个由单体架构构建的系统必定有多个服务模块, 服务模块间耦合性大，整个应用代码量大。特别不同的服务模块由不同的技术团队维护与实现，每一次功能升级，则必须通过各个团队之间的合作协调来完成；每一个小模块的修改，扦一发而动全身，统一需要所有模块团队间的协调合作，这种协调合作需要很大的人力和时间成本，这必然造成一种结果，IT 系统的构建成本增高，业务响应的周期变常。

**系统可维护性差，错误难以隔离**

当单体架构的系统复杂到超出人的认知能力，没有人对系统的各个模块组件了如指掌，则系统的可维护性就变差，风险就变高，新加入的人很难快速了解系统结构。同样一旦某一个模块出错会导致整个系统不能够提供服务，错误隔离的能力差。

**应用灵活性差、可扩展性差**

单体应用的启动、部署等灵活性差。

**数据库能力容易遇到瓶颈**

单体架构的系统多个服务连接同一个数据库，跨不同服务的长事物可能性增加，服务的增加可能会导致数据库服务能力达到上限，不容易扩展。
