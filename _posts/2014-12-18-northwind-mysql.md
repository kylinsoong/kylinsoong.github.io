---
layout: blog
title:  "Northwind database in MySql"
date:   2014-12-18 10:30:12
categories: database
permalink: /mysql-northwind
author: Kylin Soong
duoshuoid: ksoong2014121801
---

The below E-R Diagram shows Northwind database in MySql, this article contains some SQL Tutorials via Northwind.

![Northwind E-R Diagram]({{ site.baseurl }}/assets/blog/NorthWindSchema.png)

## Setup Database

[Download northwind.sql](https://github.com/kylinsoong/data/blob/master/sql/northwind.sql)

[http://ksoong.org/mysql-usage-commands/](http://ksoong.org/mysql-usage-commands/) have Basic Mysql Administration & Usage Commands, we create database `northwind`, create user `test_user` with password `test_pass` and execute sql file to setup database, the sql script as below:

~~~
mysql> CREATE DATABASE northwind;
mysql> CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'test_pass';
mysql> GRANT ALL ON northwind.* TO 'test_user'@'localhost';

$ mysql -u test_user -p

mysql> use northwind;

mysql> source /home/kylin/project/data/sql/northwind.sql
~~~

## SQL Functions

* SQL `AVG()` Function

The `AVG()` function returns the average value of a numeric column.

~~~
mysql> SELECT AVG(UnitsInStock) AS UnitsInStockAverage FROM products;
mysql> SELECT ProductName, UnitsInStock FROM products WHERE UnitsInStock > (SELECT AVG(UnitsInStock) FROM products);
~~~

* SQL `COUNT()` Function

The `COUNT()` function returns the number of rows that matches a specified criteria.

~~~
mysql> SELECT COUNT(CustomerID) AS OrdersFromCustomerIDLINOD FROM orders WHERE CustomerID='LINOD';
mysql> SELECT COUNT(*) AS NumberOfOrders FROM orders;
mysql> SELECT COUNT(DISTINCT CustomerID) AS NumberOfCustomers FROM orders;
~~~

* SQL `FIRST()` Function

The `FIRST()` function returns the first value of the selected column.

~~~
mysql> SELECT CustomerID FROM customers ORDER BY CustomerID ASC LIMIT 1;
~~~

* SQL `LAST()` Function

The `LAST()` function returns the last value of the selected column.

~~~
mysql> SELECT CustomerID FROM customers ORDER BY CustomerID DESC LIMIT 1;
~~~

* SQL `MAX()` Function

The `MAX()` function returns the largest value of the selected column.

~~~
mysql> SELECT MAX(UnitsInStock) AS HighestStock FROM products;
~~~

* The `MIN()` Function

The `MIN()` function returns the smallest value of the selected column.

~~~
mysql> SELECT MIN(UnitsInStock) AS HighestStock FROM products;
~~~

* SQL `SUM()` Function

The `SUM()` function returns the total sum of a numeric column.

~~~
mysql> SELECT SUM(Quantity) AS TotalItemsOrdered FROM order_details;
~~~

* SQL `UCASE()` Function

The `UCASE()` function converts the value of a field to uppercase.

~~~
mysql> SELECT UCASE(CompanyName) AS Company, City FROM customers;
~~~

* SQL `LCASE()` Function

The `LCASE()` function converts the value of a field to lowercase.

~~~
mysql> SELECT LCASE(CompanyName) AS Company, City FROM customers;
~~~

* SQL `MID()` Function

The `MID()` function is used to extract characters from a text field.

~~~
mysql> SELECT MID(City,1,4) AS ShortCity FROM customers;
~~~

* SQL `NOW()` Function

The `NOW()` function returns the current system date and time.

~~~
mysql> SELECT ProductName, UnitsInStock, NOW() AS PerDate FROM products;
~~~

* SQL `FORMAT()` Function

The `FORMAT()` function is used to format how a field is to be displayed.

~~~
mysql> SELECT ProductName, UnitsInStock, FORMAT(NOW(), 'YYYY-MM-DD') AS PerDate FROM products;
~~~
