---
layout: blog
title:  "Scalar Subqueries"
date:   2017-01-17 18:00:00
categories: teiid
permalink: /suqueries
author: Kylin Soong
duoshuoid: ksoong2017011701
excerpt: Scalar Subqueries, Scalar Subquery Projection, Correlated Subqueries, Correlated Subquery Limit, In Criteria Subquery
---

* Table of contents
{:toc}

## Scalar Subqueries

What's the `Scalar Subqueries`? In general terms, a scalar subquery resembles a scalar function. Remember that a scalar function returns a single value, given an argument which is some sort of expression — well, a scalar subquery returns a single value, given an argument which is a <query expression>. Since that value must be a scalar value, 

### Examples

~~~
CREATE TABLE T1 (C1 INT, C2 CHAR(5) NOT NULL);
INSERT INTO T1 VALUES(100, 'abcde');
CREATE TABLE T2 (C1 INT, C2 CHAR(5) NOT NULL);
INSERT INTO T2 VALUES(100, 'abcde');

-- scalar subquery in a select list
SELECT (SELECT C1 FROM T1) FROM T2;
+---------------------+
| (SELECT C1 FROM T1) |
+---------------------+
|                 100 |
+---------------------+

-- scalar subquery in an UPDATE ... SET clause
UPDATE T1 SET C1 = (SELECT AVG(C1) FROM T2);

-- scalar subquery in a comparison
SELECT * FROM T1 WHERE (SELECT MAX(C1) FROM T1) = (SELECT MIN(C1) FROM T2);
+------+-------+
| C1   | C2    |
+------+-------+
|  100 | abcde |
+------+-------+

-- scalar subquery with arithmetic
INSERT INTO T1 (C1) VALUES (1 + (SELECT C1 FROM T2));
~~~  

## Scalar Subquery Projection

In terms of SQL Query, there always have the concepts of `Projection` and `Selection`, which they are 2 opposite noun,

* `Projection` means selecting the columns of table
* `Selection` means select the rows of table

So how to definite the Scalar Subquery Projection? it's resembles the Scalar Subquery, just focus on choosing which columns (or expressions) the query shall return.

### Examples

~~~
SELECT C2 FROM T1 WHERE (SELECT MAX(C1) FROM T1) = (SELECT MIN(C1) FROM T2);
+-------+
| C2    |
+-------+
| abcde |
+-------+
~~~
