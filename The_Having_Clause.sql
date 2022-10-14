
-- List no of customers in each country with countries with more than 7 customers:
SELECT Country, COUNT(CustomerID) AS #_of_Customers
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 7;


-- List no of customers in each country with countries with more than 7 customers Sort in Descending order:
SELECT Country, COUNT(CustomerID) AS #_of_Customers
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 7
ORDER BY COUNT(CustomerID) DESC;

-- The following SQL statement lists the employees that have registered more than 10 orders:
SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM (Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID)
GROUP BY LastName
HAVING COUNT(Orders.OrderID) > 10;

-- The following SQL statement lists if the employees "Davolio" or "Fuller" have registered more than 25 orders:
SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
WHERE LastName = 'Davolio' OR LastName = 'Fuller'
GROUP BY LastName
HAVING COUNT(Orders.OrderID) > 25;