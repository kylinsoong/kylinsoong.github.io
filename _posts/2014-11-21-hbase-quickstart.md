---
layout: blog
title:  "HBase Quick Start"
date:   2014-11-21 18:20:00
categories: data
permalink: /hbase-java
author: Kylin Soong
duoshuoid: ksoong2014112101
---

This article contains how to quick start with Standalone HBase.

## HBase Quick Start Doc

[Entry Doc](http://hbase.apache.org/book/quickstart.html)

Use HBase For the First Time Scripts:

~~~
help
create 'test', 'cf'
list 'test'
put 'test', 'row1', 'cf:a', 'value1'
put 'test', 'row2', 'cf:b', 'value2'
put 'test', 'row3', 'cf:c', 'value3'
scan 'test'
get 'test', 'row1'
disable 'test'
drop 'test'
quit
~~~

## Add Blog Table

Execute the commands in link

[https://github.com/jbosschina/basic-hbase-examples/blob/master/etc/blog_sample_data.txt](https://github.com/jbosschina/basic-hbase-examples/blob/master/etc/blog_sample_data.txt)

will cerate `blog` table, add data to the table.

## Use Java operate HBase

Run [HbaseQuickStart](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/src/main/java/org/apache/hadoop/hbase/examples/HbaseQuickStart.java) will execute the following logic as a order:

* create table
* add some data to table
* add some more data
* get row
* delete table

Run [BlogClient](https://github.com/kylinsoong/data/blob/master/hbase-quickstart/src/main/java/org/apache/hadoop/hbase/examples/BlogClient.java) will query all blog post, which we create in above section.
