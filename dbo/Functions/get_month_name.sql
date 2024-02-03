CREATE function [dbo].[get_month_name] ( @start_date date,@end_date date )
returns nvarchar(100)
AS begin

declare @month_name nvarchar(100) = ''
declare @month_int int = 0

if DATEPART(MM, @start_date) = DATEPART(MM,@end_date) and DATEPART(YYYY, @start_date) = DATEPART(YYYY, @end_date)
begin
	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + '. '+RIGHT(CAST(DATEPART(YYYY, @start_date)as Nvarchar(50)), 4)
	set @month_int = CAST(CAST(DATEPART(YYYY, @start_date)as nvarchar(100)) + CAST(DATEPART(MM, @start_date) as nvarchar(100)) as int)
end

else 
begin
	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + '.' + ' to ' + LEFT(DATENAME(MONTH, @end_date), 3) +  '. '+RIGHT(CAST(DATEPART(YYYY, @end_date)as Nvarchar(50)), 4)
	set @month_int = CAST(CAST(DATEPART(YYYY, @start_date)as nvarchar(100)) + CAST(DATEPART(MM, @start_date) as nvarchar(100)) as int)
	
end

return @month_name
END