-- Creating a an indexed view

USE KinetEcoDW
GO

CREATE VIEW dbo.OrdersBYDate
	WITH SCHEMABINDING
	AS
		SELECT Orders.OrderID, orders.CustomerKey, Orders.OrderTotal,
			Date.FullDate, Date.DayName, Date.DayNumber,
			Date.MonthName, Date.MonthNumber, Date.QuarterNumber, Date.Year
		FROM Fact.Orders JOIN Dimension.Date ON Orders.DateKey = Date.DateKey
;
GO

CREATE UNIQUE CLUSTERED INDEX IDX_OrdersByDate
	ON dbo.OrdersByDate (OrderID);
GO

SELECT * FROM dbo.OrdersBYDate;
GO