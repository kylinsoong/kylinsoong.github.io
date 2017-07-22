---
layout: blog
title:  "docker save 示例"
date:   2017-07-22 16:40:00
categories: docker
permalink: /docker-save
author: Kylin Soong
excerpt:  如果使用 docker save 导出镜像
---

本文演示使用 `docker save` 命令用来导出一个或多个镜像。


## 查看镜像列表

~~~
# docker images
REPOSITORY                                               TAG                 IMAGE ID            CREATED             SIZE
kylinsoong/vdb-datafederation-swarm                      1.1                 219cf484b287        2 weeks ago         437 MB
debezium/connect                                         0.5                 04d1ba3a2867        5 weeks ago         571 MB
debezium/kafka                                           0.5                 56a55d6813b0        5 weeks ago         565 MB
debezium/zookeeper                                       0.5                 75b21ab7d68a        5 weeks ago         5
~~~

## 导出一个

~~~
# docker save -o vdb-datafederation-swarm-1.1_`date +'%Y%m%d'`.tar.gz kylinsoong/vdb-datafederation-swarm:1.1
~~~

## 导出多个

~~~
# docker save -o debezium-0.5_`date +'%Y%m%d'`.tar.gz debezium/zookeeper:0.5 debezium/kafka:0.5 debezium/connect:0.5
~~~

## 查看

~~~
# ls
debezium-0.5_20170722.tar.gz  vdb-datafederation-swarm-1.1_20170722.tar.gz
~~~
