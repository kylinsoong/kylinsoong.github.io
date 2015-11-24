---
layout: blog
title:  "Customer SQL Schema"
date:   2015-11-24 13:30:12
categories: database
permalink: /sql-customer
author: Kylin Soong
duoshuoid: ksoong2015112401
---

Customer SQL Schema contain 4 tables(CUSTOMER, ACCOUNT, PRODUCT, HOLDINGS) and several test data in conresponding tabtes, it used as Test and experiment purpose. 

[customer-schema-h2.sql]({{ site.baseurl }}/assets/download/customer-schema-h2.sql)

[customer-schema-mysql.sql]({{ site.baseurl }}/assets/download/customer-schema-mysql.sql)

E-R Diagram as below

![customer ER diagram]({{ site.baseurl }}/assets/blog/er-products.png)

Once the `customer-schema-x.sql` execute success, all tables(CUSTOMER, ACCOUNT, PRODUCT, HOLDINGS) be created, 17 rows insert to CUSTOMER, 17 rows insert to ACCOUNT, 25 rows insert to PRODUCT, and 41 rows insert to HOLDINGS.

## SQL Queries

~~~
SELECT * FROM PRODUCT;
SELECT * FROM HOLDINGS;

SELECT * FROM PRODUCT A LEFT JOIN HOLDINGS B ON A.ID = B.PRODUCT_ID;
SELECT * FROM PRODUCT A LEFT JOIN HOLDINGS B ON A.ID = B.PRODUCT_ID WHERE B.PRODUCT_ID IS NULL;

SELECT * FROM PRODUCT A RIGHT JOIN HOLDINGS B ON A.ID = B.PRODUCT_ID;
SELECT * FROM PRODUCT A RIGHT JOIN HOLDINGS B ON A.ID = B.PRODUCT_ID WHERE A.ID IS NULL;

ELECT * FROM PRODUCT A INNER JOIN HOLDINGS B ON A.ID = B.PRODUCT_ID;
~~~
