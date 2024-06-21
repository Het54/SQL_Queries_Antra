-- 1. List all cities that have both Employees and Customers.

SELECT DISTINCT c.City
FROM Employees e 
JOIN Customers c 
ON e.City = c.City

-- 2. List all cities that have Customers but no Employee.
-- a.      Use sub-query
-- b.      Do not use sub-query

-- Subquery 

SELECT DISTINCT c.City
FROM Customers c 
WHERE
c.City NOT IN(
    SELECT DISTINCT e.City
    FROM Employees e
)

-- JOIN 

SELECT DISTINCT c.City, e.City
FROM Customers c 
LEFT JOIN Employees e 
ON c.City = e.City 
WHERE e.City IS NULL

-- 3. List all products and their total order quantities throughout all orders.

SELECT p.ProductID, p.ProductName, SUM(od.Quantity) as TotalOrderQuantity
FROM [Order Details] od 
JOIN Products p 
ON p.ProductID = od.ProductID 
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductID


-- 4. List all Customer Cities and total products ordered by that city.

SELECT c.City AS CustomerCities, SUM(od.Quantity) AS TotalProducts
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od 
ON od.OrderID = o.OrderID
GROUP BY c.City
ORDER BY CustomerCities

-- 5. List all Customer Cities that have at least two customers.
-- a.      Use union
-- b.      Use sub-query and no 


-- Union
SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2
UNION
SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2

-- Using subquery
SELECT c.City, c.CustomerCount
FROM (SELECT c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >= 2) c


-- 6. List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City, COUNT(DISTINCT od.ProductID) AS NumberOfProducts
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od 
ON od.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2
ORDER BY c.City


-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.


SELECT DISTINCT c.CustomerID, c.ContactName
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity


-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT TOP 5 dt.ProductName, dt.AveragePrice, dt.City, dt.Maxquantity
FROM(
SELECT p.ProductName, c.City, MAX(od.Quantity) AS Maxquantity, AVG (od.UnitPrice * od.Quantity) AS AveragePrice, RANK() OVER(PARTITION BY p.ProductName ORDER BY MAX(od.Quantity) DESC) AS Rank
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID
JOIN Orders o 
ON od.OrderID = o.OrderID 
JOIN Customers c 
ON o.CustomerID = c.CustomerID
GROUP BY p.ProductName, c.City) dt
WHERE dt.Rank = 1
ORDER BY dt.Maxquantity DESC

-- 9. List all cities that have never ordered something but we have employees there.
-- a.      Use sub-query
-- b.      Do not use sub-query


-- Subquery
SELECT e.City
FROM Employees e 
WHERE e.City NOT IN (
SELECT DISTINCT c.City
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID)


-- No subquery 
SELECT e.City
FROM Employees e 
LEFT JOIN Customers c 
ON e.City = c.City 
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL


-- 10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)


--- Considering the city of customers where the orders have been made
SELECT CityofMostOrders.City
FROM(SELECT TOP 1 e.City, COUNT(o.OrderID) AS OrderCount
FROM Employees e 
JOIN Orders o 
ON e.EmployeeID = o.EmployeeID
GROUP BY e.City
ORDER BY OrderCount DESC) AS CityofMostOrders
JOIN (
SELECT TOP 1 c.City, SUM(od.Quantity) AS TotalQuantity 
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od 
ON o.OrderID = od.OrderID 
GROUP BY c.City 
ORDER BY TotalQuantity DESC   
) AS CityOfMostQuantity 
ON CityofMostOrders.City = CityOfMostQuantity.City


-- considering the supplier city from where the most sold product came from 
SELECT CityofMostOrders.City
FROM(
SELECT TOP 1 dt.City
FROM (
SELECT e.City, COUNT(o.OrderID) AS OrderCount
FROM Employees e 
JOIN Orders o 
ON e.EmployeeID = o.EmployeeID
GROUP BY e.City) dt
ORDER BY dt.OrderCount DESC
) AS CityofMostOrders
JOIN
(
SELECT TOP 1 s.City
FROM Suppliers s 
JOIN Products p 
ON s.SupplierID = p.SupplierID 
WHERE p.ProductName IN (
SELECT TOP 1 dt.ProductName
FROM(
SELECT p.ProductName, c.City, MAX(od.Quantity) AS Maxquantity, RANK() OVER(PARTITION BY p.ProductName ORDER BY MAX(od.Quantity) DESC) AS Rank
FROM Products p 
JOIN [Order Details] od 
ON p.ProductID = od.ProductID
JOIN Orders o 
ON od.OrderID = o.OrderID 
JOIN Customers c 
ON o.CustomerID = c.CustomerID
GROUP BY p.ProductName, c.City) dt
WHERE dt.Rank = 1
ORDER BY dt.Maxquantity DESC
)
) AS CityOfMostQuantity 
ON CityofMostOrders.City = CityOfMostQuantity.City



-- 11. How do you remove the duplicates record of a table?
-- We can use 'DISTINCT' Keyword.





















