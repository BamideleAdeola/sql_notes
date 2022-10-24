-- Converting from current datetime to other text format
SELECT   
   GETDATE() AS CurrentDateTime,  
   CAST(GETDATE() AS NVARCHAR(30)) AS CastConversion,  
   CONVERT(nvarchar(30), GETDATE(), 126) AS UsingConvertTo_ISO8601  ;  
GO  

-- Converting from current date in text format
SELECT   
   '2022-10-24T11:11:33.407' AS CurrentDateTimeText,  
   CAST('2022-10-24T11:11:33.407' AS datetime) AS CastConversion,  
   CONVERT(datetime, '2022-10-24T11:11:33.407', 126) AS UsingConvertFrom_ISO8601 ;  
GO 