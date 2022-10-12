-- calculating median using Percentile_cont

SELECT SalesOrderID, OrderQty,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY OrderQty)
        OVER (PARTITION BY SalesOrderID) AS MedianCont
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (43670, 43669, 43667, 43663)
ORDER BY SalesOrderID DESC