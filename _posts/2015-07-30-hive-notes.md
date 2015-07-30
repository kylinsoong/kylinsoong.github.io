---
layout: blog
title:  "Hive 学习笔记"
date:   2015-07-30 20:00:00
categories: data
permalink: /hive-notes
author: Kylin Soong
duoshuoid: ksoong2015073001
excerpt: Apache Hive 学习笔记
---

## 概念

### 什么是 Hive

* Hive 是建立在 Hadoop HDFS 上的数据库仓库基础建构
* Hive 可以用来进行数据库提取转化加载（ETL）
* Hive 定义了简单的类似 SQL 查询语言，称为 HQL，它允许熟悉 SQL 的用户查询数据
* Hive 允许熟悉 MapReduce 的开发者自定义 mapper 和 reducer 来处理内建的 mapper 和 reducer 无法完成的复杂工作
* Hive 是 SQL 解析引擎，它将 SQL 语句转化成 M/R Job，然后在 Hadoop 执行
* Hive 的表其实就是 HDFS 的目录/文件

### Hive 的元数据

* Hive 将元数据存储在数据库中(metastore)，支持 mysql, derby 等
* Hive 中的元数据包括: 表的名字，表的列和分区及其属性，表的属性(是否为外部表)，表的数据所在目录等
