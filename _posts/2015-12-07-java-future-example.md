---
layout: blog
title:  "Java Future 使用案例 - Teiid 中 Future 的使用"
date:   2015-12-07 16:30:00
categories: java
permalink: /java-future-examples
author: Kylin Soong
duoshuoid: ksoong2015120701
---

在 [Java Future FutureTask 示例](http://ksoong.org/java-future/) 我们描述了 Future 接口以及 FutureTask 类，Future 接口是程序有异步化的功能，它提供了三种主要功能：

* 判断任务是否完成, 
* 能够中断任务, 
* 能够获取任务执行结果.

本文给出一些 [Teiid 代码](https://github.com/teiid/teiid) 中 Java Future 的使用的案例.

## 案例一: ResultsFuture

ResultsFuture 它实现了 `java.util.concurrent.Future` 接口，它有一个 ResultsReceiver 属性，和 LinkedList<CompletionListener<T>> 属性， UML 图如下：

![UML of FutureTask]({{ site.baseurl }}/assets/blog/teiid-uml-resultsFuture.png)

如下为 SocketServerInstanceImpl 的 read() 方法，使用 Feature 的方法异步调运远程的方法实现

![Java Future Teiid]({{ site.baseurl }}/assets/blog/java-future-teiid-resultfuture.png)

