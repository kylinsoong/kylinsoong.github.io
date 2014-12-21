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

## SQL Statements

* SQL `GROUP BY` Statement

Aggregate functions often need an added `GROUP BY` statement. The `GROUP BY` statement is used in conjunction with the aggregate functions to group the result-set by one or more columns.

~~~
mysql> SELECT COUNT(orders.OrderID) AS NumberOfOrders FROM orders LEFT JOIN shippers ON orders.ShipVia = shippers.ShipperID WHERE shippers.CompanyName='Federal Shipping';
mysql> SELECT COUNT(orders.OrderID) AS NumberOfOrders FROM orders LEFT JOIN shippers ON orders.ShipVia = shippers.ShipperID WHERE shippers.CompanyName='Speedy Express';
mysql> SELECT COUNT(orders.OrderID) AS NumberOfOrders FROM orders LEFT JOIN shippers ON orders.ShipVia = shippers.ShipperID WHERE shippers.CompanyName='United Package';

mysql> SELECT shippers.CompanyName, COUNT(orders.OrderID) AS NumberOfOrders FROM orders LEFT JOIN shippers ON orders.ShipVia = shippers.ShipperID GROUP BY CompanyName;
~~~

## SQL Operators

* SQL `AND & OR` Operators

The `AND & OR` operators are used to filter records based on more than one condition.

~~~
mysql> SELECT * FROM customers WHERE Country = 'Germany' AND City = 'Berlin';
mysql> SELECT * FROM customers WHERE Country = 'Germany' OR City = 'München';
mysql> SELECT * FROM customers WHERE Country = 'Germany' AND (City = 'Berlin' OR City = 'München');
~~~

* SQL `IN` Operator

The `IN` operator allows you to specify multiple values in a WHERE clause.

~~~
mysql> SELECT * FROM customers  WHERE City IN ('Paris','London'); 
~~~

* SQL `LIKE` Operator

The `LIKE` operator is used in a WHERE clause to search for a specified pattern in a column.

~~~
mysql> SELECT * FROM customers  WHERE City LIKE '%s';
mysql> SELECT * FROM customers WHERE Country LIKE '%land%';
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
