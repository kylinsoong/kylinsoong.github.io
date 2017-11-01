---
layout: blog
title:  "微服务系列 I - 概念汇总"
date:   2017-11-01 19:00:00
categories: microservice
author: Kylin Soong
---

* Table of contents
{:toc}

## 什么是微服务

* 通过一系列松散耦合的服务去实现满足业务需求的应用，这种架构能使大的、复杂的应用通过CI/CD、DevOps 等方式去管理维护，极大的缩短了复杂应用从开发到部署的时间（数量级）。

## 传统单体(Monolith)架构

![Monolith Architecture]({{ site.baseurl }}/assets/blog/2017/monolith-architecture.png)

传统单体(Monolith)架构是指将实现满足业务需求的应用打包成一个部署包或一个可执行包，目前最常见的单体架构应用是通过 JavaEE、Spring 技术开发，打包构建生成一个大的 WAR/EAR 包，最后部署到应用服务上(Tomcat，JBoss)。
