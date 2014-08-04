---
layout: blog
title:  "如何解决中国防火墙阻塞 Google Fonts Service 的问题"
date:   2014-08-04 21:30:12
categories: css
author: Kylin Soong
duoshuoid: ksoong2014080402
---


Google Fonts 是一种在线字体，它目的让前端专业的设计师与开发者可以快速、简便的使用在线字体，例如 [本站](http://ksoong.org/) 使用 Google Fonts，css 文件中通过如下行来引用:

~~~
@import url(http://fonts.googleapis.com/css?family=Marvel:400,700)
~~~

## 问题

当 [本站](http://ksoong.org/) 运行时，也面加载非常慢，页面停滞在 `Connecting to fonts.googleapis.com...`，直到 timeout 时间（大约 30 秒）后页面才继续运行，且当点击下一链接又继续等待 timeout 时间。出现问题的原因是 **China Great Wall Blocked Google Founts Service**.

## 解决办法

* 删除 Google Fonts Link，例如修改引用行如下:

~~~
@import url()
~~~

* Use Google Fonts locally, but I don't test currently.

## 相关连接

* [Update the css/js for avoiding use fonts.googleapis.com #1](https://github.com/kylinsoong/kylinsoong.github.io/issues/1)
