CREATE function [dbo].[get_month_name_and_int]( @start_date date,@end_date date )
returns  @t table (month_name nvarchar(100), month_int int)

as begin


declare @month_name nvarchar(100) = ''
declare @month_int int = 0

if DATEPART(MM, @start_date) = DATEPART(MM,@end_date) and DATEPART(YYYY, @start_date) = DATEPART(YYYY, @end_date)
begin
	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + RIGHT(CAST(DATEPART(YYYY, @start_date)as Nvarchar(50)), 2)
	set @month_int = CAST(CAST(DATEPART(YYYY, @start_date)as nvarchar(100)) + CAST(DATEPART(MM, @start_date) as nvarchar(100)) as int)
end

else 
begin
	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + RIGHT(CAST(DATEPART(YYYY, @start_date)as Nvarchar(50)), 2) + '-' + LEFT(DATENAME(MONTH, @end_date), 3) +  RIGHT(CAST(DATEPART(YYYY, @end_date)as Nvarchar(50)), 2)
	set @month_int = CAST(CAST(DATEPART(YYYY, @start_date)as nvarchar(100)) + CAST(DATEPART(MM, @start_date) as nvarchar(100)) as int)
	
end


insert into @t select @month_name, @month_int

--declare @month_name nvarchar(100) = ''
--declare @month_int int = 0


--set @month_int = CAST(CAST(DATEPART(YYYY, @start_date)as nvarchar(100)) + case when DATEPART(MM, @start_date) > 9 then '' ELSE '0' END + 
--				CAST(DATEPART(MM, @start_date) as nvarchar(100))as int) 

--if DATEPART(MM, @start_date) = DATEPART(MM,@end_date) and DATEPART(YYYY, @start_date) = DATEPART(YYYY, @end_date)
--begin
--	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + RIGHT(CAST(DATEPART(YYYY, @start_date)as Nvarchar(50)), 2)

--end

--else 
--begin
--	set @month_name = LEFT(DATENAME(MONTH, @start_date),3) + RIGHT(CAST(DATEPART(YYYY, @start_date)as Nvarchar(50)), 2) + '-' + LEFT(DATENAME(MONTH, @end_date), 3) +  RIGHT(CAST(DATEPART(YYYY, @end_date)as Nvarchar(50)), 2)	
	
--end


--insert into @t select @month_name, @month_int




return
end