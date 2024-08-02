create database SalesRecord;
use salesRecord;

GRANT SELECT, UPDATE, DELETE
ON salesrecord.*
TO 'username'@'%';


SELECT * FROM Orderdetails;
alter table orderdetails 
modify OrderNumber INT unique;
desc orderdetails;
create table ProductDetails(
Product_ID INT auto_increment primary KEY,
STATUS varchar(90) default ('Shipped'/'Disputed'/'Inprocess'/'Cancelled'),
PRODUCTLINE varchar(80)
);
select * from productdetails;
select * FROM CustomerDATA;
 alter table customerdata
 add column CustomerID int auto_increment primary key;
select * FROM Finance;
ALTER TABLE ProductDetails
add constraint FK_CustomerProduct
foreign key (Product_ID) references customerDATA(CustomerID);

alter table orderdetails ADD
constraint fk_AmountPerOrder
foreign key (OrderNumber) references FINANCE(OrderNumber);
DROP TABLE FINANCE;

alter table FINANCE ADD
constraint fk_CustomerAmount
foreign key (Ordernumber) references cutomerdata(customerID);

ALTER table customerdata add
constraint FK_Transactions
foreign key (customerID) references finance(Ordernumber);

ALTER table  productdetails
ADD constraint FK_CustomerOrder
foreign key (product_ID) references orderdetails(Ordernumber);

COMMIT;
SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE customerdata
CHANGE COLUMN `CUSTOMER NAME` Customer_NAME VARCHAR(255);

desc customerdata;
desc finance;
desc orderdetails;
desc productdetails;

--  Total Sales
select * from finance;
ALTER TABLE Finance
CHANGE COLUMN `TOTAL SALES:` Total_sales TEXT;

select 	Total_sales FROM finance;

-- TOTAL ORDERS
SELECT COUNT(OrderNumber) AS TotalOrders
FROM Finance;

-- Average Order Value
select `AVERAGE ORDER VALUE` AS Averageorderpervalue
FROM finance;

-- Orders by Status
SELECT productdetails.STATUS, COUNT(orderdetails.OrderNumber) AS NumberOfOrders
FROM OrderDetails
JOIN ProductDetails ON orderdetails.OrderNumber = productdetails.product_ID
GROUP BY productdetails.STATUS;

-- Sales by Product Line
SELECT productdetails.PRODUCTLINE, SUM(CAST(finance.TOTAL_SALES AS DECIMAL(10, 2))) AS SalesByProductLine
FROM Finance 
JOIN OrderDetails ON finance.OrderNumber = orderdetails.OrderNumber
JOIN ProductDetails  ON orderdetails.OrderNumber = productdetails.product_ID
GROUP BY productdetails.PRODUCTLINE;


-- Orders by Customer
SELECT cd.Customer_NAME, COUNT(f.OrderNumber) AS NumberOfOrders
FROM CustomerData cd
JOIN Finance f ON cd.CustomerID = f.OrderNumber
GROUP BY cd.Customer_NAME;

-- Sales by Customer--
SELECT cd.Customer_NAME, SUM(CAST(f.TOTAL_SALES AS DECIMAL(10, 2))) AS TotalSales
FROM CustomerData cd
JOIN Finance f ON cd.CustomerID = f.OrderNumber
GROUP BY cd.Customer_NAME;

-- Sales Over Time--
SELECT 
    YEAR(od.ORDERDATE) AS Year, 
    MONTH(od.ORDERDATE) AS Month, 
    SUM(CAST(f.TOTAL_SALES AS DECIMAL(10, 2))) AS Sales
FROM OrderDetails od
JOIN Finance f ON od.OrderNumber = f.OrderNumber
GROUP BY 
    YEAR(od.ORDERDATE), 
    MONTH(od.ORDERDATE)
ORDER BY Year, Month;

-- Product Status Distribution
SELECT STATUS, COUNT(Product_ID) AS ProductCount
FROM ProductDetails
GROUP BY STATUS;

--  Order Completion Rate
SELECT 
    COUNT(CASE WHEN pd.STATUS = 'Completed' THEN 1 END) AS CompletedOrders,
    COUNT(*) AS TotalOrders
FROM ProductDetails pd
JOIN OrderDetails od ON pd.product_ID = od.OrderNumber;

SELECT * FROM Finance LIMIT 10;


SET FOREIGN_KEY_CHECKS=0;