---
layout: blog
title:  "Teiid SQL Join"
date:   2017-03-09 18:00:00
categories: teiid
permalink: /teiid-sql-join
author: Kylin Soong
duoshuoid: ksoong2017030901
excerpt: The Teiid SQL Join, INNER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN, CROSS JOIN
---

* Table of contents
{:toc}

## SQL Joins

Teiid supports the following JOIN syntaxes in FROM clause specifies the target table(s) for SELECT, UPDATE, and DELETE statements:

* `table1` **INNER JOIN** `table2` **ON** `join-criteria` 
* `table1` **LEFT OUTER JOIN** `table2` **ON** `join-criteria`
* `table1` **RIGHT OUTER JOIN** `table2` **ON** `join-criteria`
* `table1` **FULL OUTER JOIN** `table2` **ON** `join-criteria`
* `table1` **CROSS JOIN** `table2`

### Sample join tables in source

There are 2 tables in source, T1 has a integer column `a`, have 3 rows, 1, 2, 3 in table:

![T1]({{ site.baseurl }}/assets/blog/teiid/teiid-sql-join-t1.png)

T2 has a integer column `b`, have 2 rows, 2, 4 in table:

![T2]({{ site.baseurl }}/assets/blog/teiid/teiid-sql-join-t2.png)

## INNER JOIN
