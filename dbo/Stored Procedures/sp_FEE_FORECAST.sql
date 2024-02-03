CREATE PROC [dbo].[sp_FEE_FORECAST] 

@start_date date,
@end_date date,
@hd_id int,
@br_id int


AS

BEGIN




--declare @start_date date = '2012-04-01'
--declare @end_date date = '2013-12-31'
--declare @hd_id int = 1
--declare @br_id int = 1




declare @br_id_txt nvarchar(100) = '%'
declare @hd_id_txt nvarchar(100) = '%'

if @hd_id != 0
begin	
	set @hd_id_txt = CAST((@hd_id)as nvarchar(50))
end

if @br_id != 0
begin	
	set @br_id_txt = CAST((@br_id)as nvarchar(50))
end



create table #tbl_col_names (Sr# int identity (1,1), fee_name nvarchar(100))
create table #tbl_data (Sr# int identity (1,1), month_name nvarchar(100), month_int int,no_of_std int, no_of_new_std int, fee_name nvarchar(100), fee_amount float)
create table #tbl_months (from_date date, to_date date, [status] char(1))








declare @i int = 1
declare @j int = 1
declare @count_months int = 0
declare @count_fees int = 0
declare @total_stds int = 0
declare @new_stds int = 0
declare @month_name varchar(100) = ''
declare @month_int int = ''
declare @from_date date = ''
declare @to_date date = ''
declare @fee_name nvarchar(100) = ''
declare @start_date_changable date = ''
declare @mmont_difference int = 0
declare @month_exist int = 0
declare @status char(1) = 'A'


set @start_date_changable = @start_date



-- insert month names both genrated and not generated
insert into #tbl_months 
select *,'G' from (
select [Start Date], [End Date] from
(
select *,DATEADD(DD, -DAY(FEE_COLLECT_FEE_FROM_DATE) + 1,FEE_COLLECT_FEE_FROM_DATE) as [Start Date], 
DATEADD(DD, -DAY(DATEADD(mm,1,FEE_COLLECT_FEE_TO_DATE)), DATEADD(MM,1,FEE_COLLECT_FEE_TO_DATE)) as [End Date] from FEE_COLLECT 
where FEE_COLLECT_BR_ID like @br_id_txt and FEE_COLLECT_HD_ID like @hd_id_txt
)A where [Start Date] between @start_date and @end_date or [End Date] between @start_date and @end_date 
)B group by [Start Date],[END Date] 




set @mmont_difference = DATEDIFF(MM,@start_date, @end_date) + 1
--select @mmont_difference

while @i<= @mmont_difference
begin	
	set @month_exist = (select COUNT(*) from #tbl_months where @start_date_changable between from_date and to_date)	
	if @month_exist = 0
	begin
		insert into #tbl_months select DATEADD(DD,-DAY(@start_date_changable) +1, @start_date_changable), 
		DATEADD(DD, -DAY(DATEADD(MM,1,@start_date_changable)), DATEADD(MM, 1, @start_date_changable)), 'F'
	end
	set @start_date_changable = DATEADD(MM, 1, @start_date_changable)

set @i = @i + 1
end


insert into #tbl_col_names
select FEE_NAME from
(
select f.* from(select FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE != 0 and FEE_COLLECT_DEF_PID in
(
select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE between @start_date and @end_date 
and FEE_COLLECT_FEE_TO_DATE between @start_date and @end_date and FEE_COLLECT_BR_ID like @br_id_txt and FEE_COLLECT_HD_ID like @hd_id_txt
))A
join FEE_INFO f on A.FEE_COLLECT_DEF_FEE_NAME = f.FEE_ID

union

select f.* from(select PLAN_FEE_DEF_FEE_NAME from PLAN_FEE_DEF where PLAN_FEE_DEF_FEE !=0 and PLAN_FEE_DEF_PLAN_ID in
(
select PLAN_FEE_ID from PLAN_FEE where PLAN_FEE_BR_ID like @br_id_txt and PLAN_FEE_HD_ID like @hd_id_txt
))A
join FEE_INFO f on A.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID
)B group by FEE_NAME


set @count_months = (select COUNT(*) from #tbl_months)
set @i = 1
while @i <= @count_months
begin
	select @from_date = from_date, @to_date = to_date, @status = [status] from 
	(select ROW_NUMBER() over (order by (select from_date)) as sr, from_date, to_date, [status] from #tbl_months 
	)A where sr = @i


	select @month_name = month_name, @month_int = month_int from dbo.get_month_name_and_int(@from_date, @to_date)
	set @count_fees = (select COUNT(*) from #tbl_col_names)
	set @new_stds = (select COUNT(*) from STUDENT_INFO where STDNT_REG_DATE between @from_date and @to_date and STDNT_HD_ID like @hd_id_txt and STDNT_BR_ID like @br_id_txt)

	set @j = 1	
	while @j <= @count_fees
	begin
		select @fee_name = fee_name from #tbl_col_names where Sr# = @j
		insert into #tbl_data select @month_name, @month_int,total_students, @new_stds,fee_name, fee from dbo.FEE_FORECAST_DEF (@fee_name, @hd_id, @br_id,@from_date, @to_date,@status)
		set @j = @j + 1
	end
set @i = @i + 1
end

--select * from #tbl_months
--select * from #tbl_data




declare @column_names varchar(MAX) = ''
declare @columns_net_total varchar(MAX) = ''
declare @columns_grand_total varchar(MAX) = ''
declare @grand_total_forecast varchar(MAX) = ''
declare @query nvarchar(max) = ''

set @column_names = STUFF((SELECT ',' + QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data group by fee_name
					FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'')
					
set @columns_net_total = '(' + STUFF((SELECT '+' + QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data where fee_name like '%Current' group by fee_name
							FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'') + ') as [Net Total Current],'
							+
						'(' + STUFF((SELECT '+' + QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data where fee_name like '%Current Received' group by fee_name
							FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'')	+ ') as [Net Total Current Received],' 
							+
						'(' + STUFF((SELECT '+'+QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data where fee_name like '%Arrears' group by fee_name
							FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'') + ') as [Net Total Arrears],'
							+
						'(' + STUFF((SELECT '+' + QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data where fee_name like '%Arrears Received' group by fee_name
							FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'') + ') as [Net Total Arrears Received]'

set @grand_total_forecast = '(' + STUFF((SELECT '+' + QUOTENAME(convert(varchar(100), fee_name, 120))  from #tbl_data where fee_name like '%Forecast' group by fee_name
							FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)') ,1,1,'') + ') as [Grand Total Forecast]'




	
--select fee_name from #tbl_data group by fee_name
select fee_name from #tbl_col_names
--select @clumn_names

set @query = ';with tbl as 
(select b.month_name, month_int,b.no_of_std,b.no_of_new_std,b.fee_name,b.fee_amount from #tbl_data b)
,pivt_tbl as
(select * from tbl
pivot 
( MAX([fee_amount]) for fee_name in (' + @column_names +')
) as final_tble)
, net_total_tbl as
(select ROW_NUMBER() over (order by (select month_int)) as Sr#,month_name as Month,month_int,no_of_std as [Total Students],no_of_new_std as [New Students], ' + @column_names+  ',' +  @columns_net_total + ',' + @grand_total_forecast +' from pivt_tbl)
select *, ([Net Total Current] + [Net Total Arrears]) as [Grand Total Generated], ([Net Total Current Received] + [Net Total Arrears Received]) as [Grand Total Received] from net_total_tbl
'

exec (@query)



drop table #tbl_col_names
drop table #tbl_data
drop table #tbl_months

END