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
    Quantity integer,
    Date date,
    CONSTRAINT Orders_PK PRIMARY KEY(OrderID)
);

CREATE TABLE IF NOT EXISTS TimesTest
(
    c0 char(25), 
    c1 date,
    c2 time,
    c3 timestamp,
    CONSTRAINT TimesTest_PK PRIMARY KEY(c0)
);

UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C001', 'Telefunken', 'Germany');
UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C002', 'Logica', 'Belgium');
UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C003', 'Salora Oy', 'Finland');
UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C004', 'Alps Nordic AB', 'Sweden');
UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C005', 'Gree Electric Appliances', 'China');
UPSERT INTO Customers (CustomerID, CustomerName, Country) VALUES ('C006', 'Thales Nederland', 'Netherlands');
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I001', 'BX016', 15.96);
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I002', 'MU947', 20.35);
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I003', 'MU3508', 9.60);
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I004', 'XC7732', 55.24);
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I005', 'XT0019', 12.65);
UPSERT INTO Items (ItemID, ItemName, Price) VALUES ('I006', 'XT2217', 12.35);
UPSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630781', 'C004', 'I001', 650, '2016-10-25 00:00:00.000');
UPSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630782', 'C003', 'I006', 2500, '2016-10-27 00:00:00.000');
UPSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630783', 'C002', 'I002', 340, '2016-11-28 00:00:00.000');
UPSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630784', 'C004', 'I006', 1260, '2016-12-29 00:00:00.000');
UPSERT INTO Orders (OrderID, CustomerID, ItemID, Quantity, Date) VALUES ('1630785', 'C005', 'I003', 1500, '2016-10-26 00:00:00.000');
UPSERT INTO TimesTest (c0, c1, c2, c3) VALUES ('101', '2016-11-01', '2016-11-01 11:30:57', '2016-11-01 11:30:57.987');
UPSERT INTO TimesTest (c0, c1, c2, c3) VALUES ('103', '2016-11-01', '2016-11-01 11:35:57', '2016-11-01 11:35:57.987');
