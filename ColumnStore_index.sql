-- Creating a columnstore index 

CREATE COLUMNSTORE INDEX IN_CS_FactOrders
ON Fact.Orders (OrderID, DateKey, CustomerKey, OrderTotal);