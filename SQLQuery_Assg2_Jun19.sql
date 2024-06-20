-- 1. How many products can you find in the Production.Product table?
-- ANS: 504
SELECT COUNT(p.ProductID) AS NumOfProducts
FROM Production.Product p

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(p.ProductSubcategoryID) AS NumOfProdinSubCategory
FROM Production.Product p

-- 3.     How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts
-- -------------------- ---------------

SELECT p.ProductSubcategoryID, COUNT(p.ProductID) AS CountedProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID


-- 4. How many products that do not have a product subcategory.
-- ANS: 209
SELECT p.ProductSubcategoryID, COUNT(p.ProductID) AS CountedProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NULL
GROUP BY p.ProductSubcategoryID

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.

SELECT SUM(pi.Quantity) AS SumOfProdQuantity
FROM Production.ProductInventory pi 

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
            --   ProductID    TheSum
            --   -----------        ----------
SELECT pi.ProductID ,SUM(pi.Quantity) AS TheSum
FROM Production.ProductInventory pi 
WHERE pi.LocationID = 40
GROUP BY pi.ProductID
HAVING SUM(pi.Quantity)<100


-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
    -- Shelf      ProductID    TheSum
    -- ----------   -----------        -----------

SELECT pi.Shelf,pi.ProductID ,SUM(pi.Quantity) AS TheSum
FROM Production.ProductInventory pi 
WHERE pi.LocationID = 40
GROUP BY pi.Shelf, pi.ProductID
HAVING SUM(pi.Quantity)<100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT pi.ProductID, AVG(pi.Quantity) AS AverageQuantity
FROM Production.ProductInventory pi 
WHERE pi.LocationID = 10 
GROUP BY pi.ProductID

-- 9.  Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
    -- ProductID   Shelf      TheAvg
    -- ----------- ---------- -----------

SELECT pi.ProductID, pi.Shelf,AVG(pi.Quantity) AS AverageQuantity
FROM Production.ProductInventory pi 
GROUP BY pi.ProductID, pi.Shelf

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
    -- ProductID   Shelf      TheAvg
    -- ----------- ---------- -----------

SELECT pi.ProductID, pi.Shelf,AVG(pi.Quantity) AS AverageQuantity
FROM Production.ProductInventory pi 
WHERE pi.Shelf != 'N/A'
GROUP BY pi.ProductID, pi.Shelf


-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
    -- Color                        Class              TheCount          AvgPrice
    -- -------------- - -----    -----------            ---------------------

SELECT p.Color, p.Class, COUNT(*) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p 
WHERE p.Color IS NOT NULL 
AND p.Class IS NOT NULL
GROUP BY p.Color, p.Class


-- 12. .   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
    -- Country                        Province
    -- ---------                          ----------------------

SELECT pc.Name AS Country, ps.Name AS Province
FROM person.CountryRegion pc 
JOIN person.StateProvince ps 
ON pc.CountryRegionCode = ps.CountryRegionCode


-- 13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--     Country                        Province
--     ---------                          ----------------------

SELECT pc.Name AS Country, ps.Name AS Province
FROM person.CountryRegion pc 
JOIN person.StateProvince ps 
ON pc.CountryRegionCode = ps.CountryRegionCode
WHERE pc.Name = 'Germany' 
OR pc.Name = 'Canada' 
ORDER BY Country

-- 14. List all Products that has been sold at least once in last 27 years.

-- List of all the distinct products 
SELECT DISTINCT p.ProductID, p.ProductName
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID
JOIN Orders o 
ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
ORDER BY p.ProductID


-- List of all the Products with its orederid and orderdate
SELECT p.ProductID, p.ProductName, od.OrderID, o.OrderDate
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID
JOIN Orders o 
ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
ORDER BY p.ProductID

-- 15.  List top 5 locations (Zip Code) where the products sold most.

-- Removing NULL values
SELECT TOP 5 o.ShipPostalCode AS ZipCode, SUM(od.Quantity) AS ProductsSold
FROM [Order Details] od 
JOIN Orders o 
ON o.OrderID = od.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY ProductsSold DESC


-- There are orders which doesnot have a zipcode value and it is in top 5
SELECT TOP 5 o.ShipPostalCode AS ZipCode, SUM(od.Quantity) AS ProductsSold
FROM [Order Details] od 
JOIN Orders o 
ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY ProductsSold DESC

-- 16. List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT TOP 5 o.ShipPostalCode AS ZipCode, SUM(od.Quantity) AS ProductsSold
FROM [Order Details] od 
JOIN Orders o 
ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY ProductsSold DESC

-- 17. List all city names and number of customers in that city.     

SELECT c.City, COUNT(c.CustomerID) AS NumOfCustomers
FROM Customers c
GROUP BY c.City 
ORDER BY NumOfCustomers DESC


-- 18. List city names which have more than 2 customers, and number of customers in that city

SELECT c.City, COUNT(c.CustomerID) AS NumOfCustomers
FROM Customers c
GROUP BY c.City 
HAVING COUNT(c.CustomerID) > 2
ORDER BY NumOfCustomers DESC

-- 19. List the names of customers who placed orders after 1/1/98 with order date.

SELECT c.ContactName AS CustomerName, o.OrderDate 
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
WHERE OrderDate > '1998-01-01'
ORDER BY c.ContactName


-- 20. List the names of all customers with most recent order dates

SELECT c.ContactName AS CustomerName, MAX(o.OrderDate) 
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY c.ContactName


-- 21. Display the names of all customers  along with the  count of products they bought

SELECT c.ContactName, COUNT(p.ProductName) AS CountofProducts
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od 
ON od.OrderID = o.OrderID
JOIN Products p
ON p.ProductID = od.ProductID
GROUP BY c.ContactName
ORDER BY COUNT(p.ProductName) DESC


-- 22. Display the customer ids who bought more than 100 Products with count of products.

SELECT c.CustomerID, COUNT(p.ProductName) AS CountofProducts
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od 
ON od.OrderID = o.OrderID
JOIN Products p
ON p.ProductID = od.ProductID
GROUP BY c.CustomerID
HAVING COUNT(p.ProductName)>100
ORDER BY COUNT(p.ProductName) DESC

-- 23.  List all of the possible ways that suppliers can ship their products. Display the results as below
    -- Supplier Company Name                Shipping Company Name
    -- ---------------------------------            ----------------------------------

SELECT DISTINCT s.CompanyName AS [Supplier Company Name ], sp.CompanyName AS [Shipping Company Name]
FROM Suppliers s 
CROSS JOIN Shippers sp 


-- 24. Display the products order each day. Show Order date and Product Name.

SELECT o.OrderDate, p.ProductName
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID 
JOIN Orders o 
ON o.OrderID = od.OrderID 
ORDER BY o.OrderDate


-- 25. Displays pairs of employees who have the same job title.

SELECT e1.EmployeeID AS E1EmpID, e1.FirstName + ' ' + e1.LastName,e2.EmployeeID AS E2EmpID, e2.FirstName + ' ' + e2.LastName, e1.Title
FROM Employees e1
JOIN Employees e2 
ON e1.Title = e2.Title
AND e1.EmployeeID < e2.EmployeeID


-- 26. Display all the Managers who have more than 2 employees reporting to them.

SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS EmpName
FROM (
SELECT e1.ReportsTo , COUNT(e1.FirstName + ' ' + e1.LastName) AS Count  
FROM Employees e1
JOIN Employees e2
ON e1.ReportsTo = e2.EmployeeID
GROUP BY e1.ReportsTo
HAVING COUNT(e1.FirstName + ' ' + e1.LastName)>2) AS t
LEFT JOIN Employees e
ON t.ReportsTo = e.EmployeeID

-- 27. Display the customers and suppliers by city. The results should have the following columns
-- City
-- Name
-- Contact Name,
-- Type (Customer or Supplier)

SELECT c.City, c.CompanyName As Name, c.ContactName , 'Customer' AS Type
FROM Customers c
UNION ALL
SELECT s.City, s.CompanyName As Name,  s.ContactName, 'Supplier' AS Type
FROM Suppliers s 
ORDER BY City

















