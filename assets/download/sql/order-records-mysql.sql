# create and use 'JOINSTEST'
CREATE DATABASE IF NOT EXISTS JOINSTEST;
USE JOINSTEST;

# create table: Orders, Customers, Items
CREATE TABLE IF NOT EXISTS Customers
(
    CustomerID char(25),
    CustomerName varchar(64),
    Country varchar(64),
    CONSTRAINT Customers_PK PRIMARY KEY(CustomerID)
);

CREATE TABLE IF NOT EXISTS Items
(
    ItemID char(25),
    ItemName varchar(64),
    Price double,
    CONSTRAINT Items_PK PRIMARY KEY(ItemID)
);

CREATE TABLE IF NOT EXISTS Orders
(
    OrderID char(25),
    CustomerID char(25),
    ItemID char(25),
    Quantity int,
    Date timestamp,
    CONSTRAINT Orders_PK PRIMARY KEY(OrderID),
    CONSTRAINT Customers_FK FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT Items_FK FOREIGN KEY(ItemID) REFERENCES Items(ItemID)
);

# Insert data to Orders, Customers, Items
## 1. Customers
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C001', 'Telefunken', 'Germany');
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C002', 'Logica', 'Belgium');
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C003', 'Salora Oy', 'Finland');
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C004', 'Alps Nordic AB', 'Sweden');
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C005', 'Gree Electric Appliances', 'China');
INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C006', 'Thales Nederland', 'Netherlands');
## 2. Items
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I001', 'BX016', 15.96);
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I002', 'MU947', 20.35);
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I003', 'MU3508', 9.60);
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I004', 'XC7732', 55.24);
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I005', 'XT0019', 12.65);
INSERT INTO Items (ItemID, ItemName, Price) VALUES ('I006', 'XT2217', 12.35);
## 3. Orders
INSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630781', 'C004', 'I001', 650, '2016-10-25 00:00:00.000');
INSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630782', 'C003', 'I006', 2500, '2016-10-27 00:00:00.000');
INSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630783', 'C002', 'I002', 340, '2016-11-28 00:00:00.000');
INSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630784', 'C004', 'I006', 1260, '2016-12-29 00:00:00.000');
INSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630785', 'C005', 'I003', 1500, '2016-10-26 00:00:00.000');

# Basic Query
SELECT * FROM Customers;
SELECT * FROM Items;
SELECT * FROM Orders;

# SQL Join Query

## 1. INNER JOIN
SELECT O.OrderID, C.CustomerName, O.Date
FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
ORDER BY O.OrderID;

## 2. LEFT JOIN
SELECT O.OrderID, C.CustomerName, O.Date
FROM Orders AS O
LEFT OUTER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
ORDER BY O.OrderID;

## 3. RIGHT JOIN
SELECT O.OrderID, C.CustomerName, O.Date
FROM Orders AS O
RIGHT OUTER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
ORDER BY O.OrderID;

## More

SELECT ItemName, sum(Price * Quantity) AS OrderValue
FROM Items
JOIN Orders
ON Items.ItemID = Orders.ItemID
WHERE Orders.CustomerID > 'C002'
GROUP BY ItemName;
