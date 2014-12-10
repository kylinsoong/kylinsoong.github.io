---
layout: blog
title:  "Apache Phoenix Resources Gallery"
date:   2014-12-10 21:45:00
categories: data
permalink: /phoenix-resources
author: Kylin Soong
duoshuoid: ksoong2014121001
---

This article contains Apache Phoenix Resources like slides, sample, etc.

### Slides

**Transforming HBase into a SQL Database**

<iframe src="//www.slideshare.net/slideshow/embed_code/35986700" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/Hadoop_Summit/w-145p230-ataylorv2" title="Apache Phoenix: Transforming HBase into a SQL Database" target="_blank">Apache Phoenix: Transforming HBase into a SQL Database</a> </strong> from <strong><a href="//www.slideshare.net/Hadoop_Summit" target="_blank">Hadoop_Summit</a></strong> </div>

**Taming HBase with Apache Phoenix and SQL**

<iframe src="//www.slideshare.net/slideshow/embed_code/35937868" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/HBaseCon/ecosystem-session-1" title="Taming HBase with Apache Phoenix and SQL" target="_blank">Taming HBase with Apache Phoenix and SQL</a> </strong> from <strong><a href="//www.slideshare.net/HBaseCon" target="_blank">HBaseCon</a></strong> </div>

### Mapping Phoenix table to an existing HBase table

From [Phoenix F.A.Q. Question: How I map Phoenix table to an existing HBase table?](http://phoenix.apache.org/faq.html#How_I_map_Phoenix_table_to_an_existing_HBase_table):

You can create both a Phoenix table or view through the CREATE TABLE/CREATE VIEW DDL statement on a pre-existing HBase table. In both cases, we’ll leave the HBase metadata as-is, except for with a TABLE we turn KEEP_DELETED_CELLS on. For CREATE TABLE, we’ll create any metadata (table, column families) that doesn’t already exist. We’ll also add an empty key value for each row so that queries behave as expected (without requiring all columns to be projected during scans). More details refer to [http://phoenix.apache.org/faq.html#How_I_map_Phoenix_table_to_an_existing_HBase_table](http://phoenix.apache.org/faq.html#How_I_map_Phoenix_table_to_an_existing_HBase_table).

**F.A.Q. example**

Run [FAQHBaseTableCreation](https://github.com/kylinsoong/data/blob/master/phoenix-quickstart/src/main/java/org/apache/phoenix/examples/faq/FAQHBaseTableCreation.java) will create tabele `t1`.

Run [FAQHBaseTablePutData](https://github.com/kylinsoong/data/blob/master/phoenix-quickstart/src/main/java/org/apache/phoenix/examples/faq/FAQHBaseTablePutData.java) put 5 rows data.

[HBaseTableMappingTest](https://github.com/kylinsoong/data/blob/master/phoenix-quickstart/src/test/java/org/apache/phoenix/examples/HBaseTableMappingTest.java) including 2 methods:

* testViewMapping()
* testTableMapping()

Coresponding shows View mapping HBase table and Table mapping HBase Table.


