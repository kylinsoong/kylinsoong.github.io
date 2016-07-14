---
layout: blog
title:  "FunctionalInterface with Lambda Expressions Example"
date:   2016-07-14 18:50:12
categories: java
permalink: /lambda-expression
author: Kylin Soong
duoshuoid: ksoong2016071402
excerpt: Lambda Expressions, @FunctionalInterface
---

* Table of contents
{:toc}

## java.lang.Runnable

~~~
Runtime.getRuntime().addShutdownHook(new Thread(() -> {
    // do something
}));
~~~
