---
layout: blog
title:  "微服务 II - 业务处理异步化"
date:   2017-11-06 19:00:00
categories: microservice
permalink: microservice-async-process
author: Kylin Soong
---

* Table of contents
{:toc}

## 业务处理异步化

在将业务处理微服务化之前，所有业务处理都是单体架构化的、集中式的，即在同一个计算单元（同一个 JVM 中运行应用服务器，WAR 包部署在应用服务器中），按照业务实现的顺序，进行顺序执行所有服务:

![顺序执行所有服务]({{ site.baseurl }}/assets/blog/2017/microservices-asynch-1.png)

这是常见的业务处理流程，比如 Servlet 作为服务调运的起始点，顺序执行完成与业务相关的所有服务，再通过 Servlet 返回结果给前端请求。这样顺序调运的方式造成系统处理一次前端请求所花费的时间较长，服务会话处理线程带来长时间的资源占用，带来的结果是大严重影响服务器端整体的系统吞吐量。

在微服务架构下，服务被拆分开，不同服务于不同的计算单元，且服务间松散耦合。基于这种架构，非常容器实现异步化服务调运，对于有严格先后顺序的服务保持顺序调运，对于能够同步执行的服务均采用异步化处理。通常消息中间件会实现业务处理异步化:

![异步化服务调运]({{ site.baseurl }}/assets/blog/2017/microservices-asynch-2.png)

异步化调运通常能够在几何倍数上提高服务器端系统吞吐量，提高用户体验。微服务架构可以实现业务处理异步化。

