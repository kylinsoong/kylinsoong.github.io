---
layout: blog
title:  "Phoenix/HBase SQL Support"
date:   2015-01-15 13:20:00
categories: data
permalink: /phoenix-sql
author: Kylin Soong
duoshuoid: ksoong2015011502
---

* Table of contents
{:toc}

## Prerequisites

Download [order-records-phoenix.sql]({{ site.baseurl }}/assets/download/sql/order-records-phoenix.sql), execute psql.py against a Phoenix/HBase server

~~~
$ ./bin/psql.py 127.0.0.1:2181 order-records-phoenix.sql
~~~

This will create 3 tables with initialization data:

**Orders**

![Phoenix Table Orders]({{ site.baseurl }}/assets/blog/data/phoenix-table-orders.png)

**Customers**

![Phoenix Table Customers]({{ site.baseurl }}/assets/blog/data/phoenix-table-customers.png)

**Items**

![Phoenix Table Items]({{ site.baseurl }}/assets/blog/data/phoenix-table-items.png)

## Functions

[http://phoenix.apache.org/language/functions.html](http://phoenix.apache.org/language/functions.html) list all functions Phoenix supported

### Aggregate Functions

#### AVG

~~~
SELECT ITEMID, AVG(QUANTITY) AVG_QUANTITY 
FROM ORDERS 
GROUP BY ITEMID 
ORDER BY ITEMID DESC
~~~

#### COUNT

~~~
SELECT COUNT(*), COUNT(ITEMID), COUNT(DISTINCT ITEMID) FROM ORDERS
~~~

#### MAX, MIN, SUM

~~~
SELECT MAX(QUANTITY), MIN(QUANTITY), SUM(QUANTITY) FROM ORDERS
SELECT ITEMID, MAX(QUANTITY), MIN(QUANTITY), SUM(QUANTITY) FROM ORDERS GROUP BY ITEMID
~~~ 

### String Functions

#### SUBSTR

~~~
SELECT SUBSTR(CUSTOMERNAME, 15) FROM Customers WHERE CUSTOMERID = 'C005'
SELECT SUBSTR(CUSTOMERNAME, 15, 9) FROM Customers WHERE CUSTOMERID = 'C005'
~~~

#### LPAD

~~~
SELECT LPAD(COUNTRY, 15) FROM Customers WHERE CUSTOMERID = 'C005'
SELECT LPAD(COUNTRY, 15, '*') FROM Customers WHERE CUSTOMERID = 'C005'
~~~

#### UPPER

~~~
SELECT UPPER(COUNTRY) FROM Customers WHERE CUSTOMERID = 'C005'
~~~

#### INSTR

~~~
SELECT INSTR(CUSTOMERNAME, 'Applian') FROM Customers WHERE CUSTOMERID = 'C005'
~~~

### Time and Date Functions

### Numeric Functions

### Array Functions

### Math Functions

### Other Functions


## DML/DDL Commands

The [TestPhoenixDML](https://github.com/kylinsoong/data/blob/master/phoenix-quickstart/src/test/java/org/apache/phoenix/teiid/TestPhoenixDML.java) use Phoenix to execute a series DML unit test, including:

* testMetaData
* testInsert
* testBatchedInsert
* testSelect
* testSelectOrderBy
* testSelectGroupBy
* testSelectLimit
* testConditionAndOr
* testConditionComparison
* testFunctions
* testTimesTypes

The Coresponding SQL like:

~~~
CREATE TABLE IF NOT EXISTS "Customer"("ROW_ID" VARCHAR PRIMARY KEY, "customer"."city" VARCHAR, "customer"."name" VARCHAR, "sales"."amount" VARCHAR, "sales"."product" VARCHAR)

UPSERT INTO "Customer" VALUES (?, ?, ?, ?, ?)
UPSERT INTO "Customer"("ROW_ID", "city", "name", "amount", "product") VALUES (?, ?, ?, ?, ?)
UPSERT INTO "Customer" VALUES (?, ?, ?, ?, ?)

SELECT * FROM "Customer"
SELECT "city", "amount" FROM "Customer"
SELECT DISTINCT "city" FROM "Customer"
SELECT COUNT("ROW_ID") FROM "Customer" WHERE "name"='John White'
SELECT "city", "amount" FROM "Customer" WHERE "ROW_ID"='105'

SELECT * FROM "Customer" ORDER BY "ROW_ID"
SELECT * FROM "Customer" ORDER BY "ROW_ID" ASC
SELECT * FROM "Customer" ORDER BY "ROW_ID" DESC
SELECT * FROM "Customer" ORDER BY "name", "city" DESC

SELECT "name", COUNT("ROW_ID") FROM "Customer" GROUP BY "name"
SELECT "name", COUNT("ROW_ID") FROM "Customer" GROUP BY "name" HAVING COUNT("ROW_ID") > 1
SELECT "name", "city", COUNT("ROW_ID") FROM "Customer" GROUP BY "name", "city"
SELECT "name", "city", COUNT("ROW_ID") FROM "Customer" GROUP BY "name", "city" HAVING COUNT("ROW_ID") > 1


SELECT * FROM "Customer" LIMIT 3
SELECT * FROM "Customer" ORDER BY "ROW_ID" DESC LIMIT 3

SELECT * FROM "Customer" WHERE "ROW_ID"='105' OR "name"='John White'
SELECT * FROM "Customer" WHERE "ROW_ID"='105' AND "name"='John White'
SELECT * FROM "Customer" WHERE "ROW_ID"='105' AND ("name"='John White' OR "name"='Kylin Soong')
SELECT * FROM "Customer" WHERE "ROW_ID" = '108'
SELECT * FROM "Customer" WHERE "ROW_ID" > '108'
SELECT * FROM "Customer" WHERE "ROW_ID" < '108'
SELECT * FROM "Customer" WHERE "ROW_ID" >= '108'
SELECT * FROM "Customer" WHERE "ROW_ID" <= '108'
SELECT * FROM "Customer" WHERE "ROW_ID" BETWEEN '105' AND '108'
SELECT * FROM "Customer" WHERE "ROW_ID" LIKE '10%'
SELECT * FROM "Customer" WHERE "ROW_ID" IN ('105', '106')

SELECT COUNT("ROW_ID") AS totalCount FROM "Customer" WHERE "name" = 'Kylin Soong'


UPSERT INTO "Customer" VALUES('101', 'Los Angeles, CA', 'John White', '$400.00', 'Chairs')
UPSERT INTO "Customer" VALUES('102', 'Atlanta, GA', 'Jane Brown', '$200.00', 'Lamps')
UPSERT INTO "Customer" VALUES('103', 'Pittsburgh, PA', 'Bill Green', '$500.00', 'Desk')
UPSERT INTO "Customer" VALUES('104', 'St. Louis, MO', 'Jack Black', '$8000.00', 'Bed')
UPSERT INTO "Customer" VALUES('105', 'Los Angeles, CA', 'John White', '$400.00', 'Chairs')
UPSERT INTO "Customer" VALUES('108', 'Beijing', 'Kylin Soong', '$8000.00', 'Crystal Orange')
~~~


