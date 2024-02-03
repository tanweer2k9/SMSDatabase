

CREATE FUNCTION [dbo].[sf_GetFeeMonthCustom](@fee_months nvarchar(50),@FromDate date,@ToDate date)



returns int

AS BEGIN


declare @count int = 
(select COUNT(*) from	
(SELECT  TOP (DATEDIFF(MONTH, @FromDate, @ToDate) + 1)
        Date = DATEADD(MONTH, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @FromDate)
FROM    sys.all_objects a
        CROSS JOIN sys.all_objects b
		)A where Date in (select DATEADD(DAY,1,EOMONTH(EOMONTH(DATEFROMPARTS(DATEPART(YYYY,@FromDate),val,1)),-1)) from split(@fee_months, ','))
)



return @count
END