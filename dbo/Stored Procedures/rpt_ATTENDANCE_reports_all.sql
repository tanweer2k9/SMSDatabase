CREATE PROC [dbo].[rpt_ATTENDANCE_reports_all]

@STATUS nvarchar(50),
@START_DATE date,
@END_DATE date,
@CITY nvarchar(50),
@DEPARTMENT nvarchar(50),
@BR_ID numeric,
@STAFF_ID numeric,
@ATTENDACNE_STATUS nvarchar(500)

AS


--declare @START_DATE date = '2015-01-01'
--declare @END_DATE date = '2015-02-07'
--declare @STATUS nvarchar(100) = 'remarks'

--declare @City nvarchar(50) = 'All'
--declare @Department nvarchar(50) = 'All'
--declare @BR_ID numeric = 0
--declare @Staff_ID numeric = 0
--declare @ATTENDACNE_STATUS nvarchar(500) = '''P'',''A'''



declare @city_like nvarchar(50)='%'
declare @department_like nvarchar(50)='%'
declare @br_id_like nvarchar(50)='%'
declare @staff_id_like nvarchar(50)='%'


if @City != 'All'
	set @city_like = @City

if @Department != 'All'
	set @department_like = @Department

if @BR_ID != 0
	set @br_id_like = CAST((@BR_ID) as nvarchar(50))

if @Staff_ID != 0
	set @staff_id_like = CAST((@Staff_ID) as nvarchar(50))


	

CREATE table #tbl_all_dates ([date] date)

declare @i int = 0
declare @days_count int = 0
declare @date_columns as varchar(max) = ''
declare @date_columns_isnull as varchar(max) = ''
declare @query nvarchar(MAX) = ''
declare @late_minutes int = 0


set @late_minutes = (select top(1) BR_ADM_PAYROLL_LATE_MINUTES from BR_ADMIN where BR_ADM_ID like @br_id_like)

set @days_count = DATEDIFF(DD,@START_DATE,@END_DATE) + 1


while @i < @days_count
begin
	insert into #tbl_all_dates values (DATEADD(DD,@i,@START_DATE))	
	set @i = @i + 1
end


select @date_columns = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), CAST(([date]) as nvarchar(50)), 120)) from #tbl_all_dates
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
				

select @date_columns_isnull = STUFF((SELECT ','+'ISNULL(' + QUOTENAME(convert(varchar(50), CAST(([date]) as nvarchar(50))  , 120)) + ',''-'') as [' +CAST(([date]) as nvarchar(50)) + ']' from #tbl_all_dates
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
				


declare @value_column varchar(MAX) = ''
declare @value_column2 varchar(MAX) = 'value'
declare @calculation_columns varchar(MAX) = ' ) select * from tbl4 '

if @STATUS = 'Remarks'
begin
	--set @value_column = 'Remarks  as value'
	set @value_column = ', value '
	set @calculation_columns = '
								A where rnk = 1 and value in (' + @ATTENDACNE_STATUS +'))
								select sr,ID,Code,Name,Department,Filter,[Day],[Date],value from tbl4
	
								union
								select 2 sr,ID,Code,Name,Department,25000001 as Filter,'''' as [Day],''T.D'',CONVERT(nvarchar(50), ' + CAST((@days_count)as nvarchar(50)) + ' )as value from tbl4 group by ID,Code,Name,Department'
								if @ATTENDACNE_STATUS LIKE '%P%'
								set @calculation_columns =@calculation_columns + 
								' union
								select 3 sr,ID,Code,Name,Department,25000002 as Filter,'''' as [Day],''T.P'',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl4 where value=''P'' group by ID,Code,Name,Department'
								if @ATTENDACNE_STATUS LIKE '%A%'
								set @calculation_columns =@calculation_columns + 
								' union
								select 4,ID,Code,Name,Department,25000003 as Filter,'''' as [Day],''T.A'',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl4 where value=''A'' group by ID,Code,Name,Department'
								if @ATTENDACNE_STATUS LIKE '%LE%'
								set @calculation_columns =@calculation_columns + 
								' union
								select 5,ID,Code,Name,Department,25000004 as Filter,'''' as [Day],''T.LE'',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl4 where value=''LE'' group by ID,Code,Name,Department'
								if @ATTENDACNE_STATUS LIKE '%LA%'
								set @calculation_columns =@calculation_columns + 
								' union
								select 6,ID,Code,Name,Department,25000005 as Filter,'''' as [Day],''T.LA'',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl4 where value=''LA'' group by ID,Code,Name,Department'
 end
else if @STATUS = 'Time'
	begin
		set @value_column = ',[Time In], [Time Out]'
		set @calculation_columns = '		
									)  
								 ,tbl5 as
								 (select *,CAST(ISNULL((select ISNULL(overtime - early_time,0)  from dbo.CALCULATE_OVERTIME(ID,CAST(CAST(Filter as nvarchar(50)) as date),CAST(CAST(Filter as nvarchar(50)) as date), ''T'')),0) as float) as overtime 
								   from tbl4 )
								 ,tbl6 as
								 (
								 select sr,ID,Code,Name,Department,Filter,[Day],[Date], REPLACE([Time In],'' '','''') [Time In],REPLACE([Time Out],'' '','''')[Time Out]  
								,CASE WHEN overtime > 0 THEN CAST(CAST(DATEADD(S,overtime,''1900-01-01'') as time)as nvarchar(50)) ELSE ''-'' + CAST(CAST(DATEADD(S,(overtime * -1 ),''1900-01-01'') as time) as nvarchar(50)) END as overtime
								 from tbl5
								 )
								 select sr,ID,Code,Name,Department,Filter,[Day],[Date] ,STUFF((
									SELECT ''% '' + [Time In] + ''-'' + [Time Out]
									FROM tbl6 
									WHERE (Filter = Results.Filter and ID = Results.ID) 
									FOR XML PATH(''''),TYPE).value(''(./text())[1]'',''VARCHAR(MAX)'')
								  ,1,2,'''') + ''% '' +MAX(REPLACE(overtime,''.0000000'','''')) AS Remarks
 
								  from tbl6 Results group by sr,ID,Code,Name,Department,Filter,[Day],[Date]'
		
	end
else if @STATUS = 'Overtime'
BEGIN
	set @value_column = ',[Time In], [Time Out]'
	set @calculation_columns = ' )  
						 ,tbl5 as
						(select *,CAST(ISNULL((select ISNULL(overtime - early_time,0)  from dbo.CALCULATE_OVERTIME(ID,CAST(CAST(Filter as nvarchar(50)) as date),CAST(CAST(Filter as nvarchar(50)) as date), ''T'')),0) as float) as overtime 
						  from tbl4 )
						 ,tbl6 as
						 (
						 select sr,ID,Code,Name,Department,Filter,[Day],[Date], [Time In],[Time Out] 
						,CASE WHEN overtime > 0 THEN CAST(CAST(DATEADD(S,overtime,''1900-01-01'') as time)as nvarchar(50)) ELSE ''-'' + CAST(CAST(DATEADD(S,(overtime * -1 ),''1900-01-01'') as time) as nvarchar(50)) END as overtime
						 from tbl5)
						 select sr,ID,Code,Name,Department,Filter,[Day],[Date],overtime as value from tbl6
						 '
END
else if @STATUS = 'Absent'
BEGIN
		set @value_column = ', value '
		set @calculation_columns = '
								A where rnk = 1)								
								select sr,ID,Code,Name,Department,Filter,[Day],[Date],CASE WHEN value = ''A'' or value = ''LE'' THEN value ELSE ''-'' END  as value from tbl4
							'
	--set @value_column = ' CASE WHEN Remarks = ''A'' or Remarks = ''LE'' THEN Remarks ELSE ''-'' END  as value'
END
else if @STATUS = 'Late'
   set @value_column = ', CASE WHEN CAST(([Time In]) as datetime) > DATEADD(MI,' + CAST((@late_minutes) as nvarchar(50)) + ', CAST(([Current Time In]) as datetime)) THEN [Time In] + CHAR(13) +  CONVERT(nvarchar(50),CAST(([Time In]) as datetime) - CAST(([Current Time In]) as datetime),24) ELSE ''-'' END  as value'
else if @STATUS = 'Early'
   set @value_column = ', CASE WHEN CAST(([Time Out]) as datetime) < CAST(([Current Time Out]) as datetime) THEN [Time Out] + CHAR(13) +  CONVERT(nvarchar(50),CAST(([Current Time Out]) as datetime) - CAST(([Time Out]) as datetime),24) ELSE ''-'' END  as value'

--(Remarks + char(13) + [Time In] + CHAR(13) + [Time Out]) + CHAR(13) + (CONVERT(nvarchar(50),((CAST(([Time Out]) as datetime) - CAST(([Time In]) as datetime)) - (CAST(([Current Time Out]) as datetime) - CAST(([Current Time In]) as datetime)) ),24))


set @query = ';with tbl as

(
select t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME as Name, d.DEP_NAME as Department, a.ATTENDANCE_STAFF_DATE as [Date],a.ATTENDANCE_STAFF_TIME_IN as [Time In], 
a.ATTENDANCE_STAFF_TIME_OUT as [Time Out], 
CASE WHEN a.ATTENDANCE_STAFF_REMARKS = ''A'' or a.ATTENDANCE_STAFF_REMARKS = ''LE'' THEN ''12:00 AM'' ELSE a.ATTENDANCE_STAFF_CURRENT_TIME_IN END as [Current Time In], 
CASE WHEN a.ATTENDANCE_STAFF_REMARKS = ''A'' or a.ATTENDANCE_STAFF_REMARKS = ''LE'' THEN ''12:00 AM'' ELSE a.ATTENDANCE_STAFF_CURRENT_TIME_OUT END as [Current Time Out], 
a.ATTENDANCE_STAFF_REMARKS as Remarks
from ATTENDANCE_STAFF a
join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where a.ATTENDANCE_STAFF_DATE between @from and @to
and c.CITY_NAME like ''' + @city_like + '''
and d.DEP_NAME like ''' +@department_like + '''
and t.TECH_ID like ''' +@staff_id_like + '''
and t.TECH_BR_ID like ''' +@br_id_like + '''
union

select id,code,Name,Department,date,[Time In],[Time Out], [Current Time In],[Current Time Out],Remarks
from 
(select * from 
(select [date], ''WH'' as Remarks from #tbl_all_dates where [date] not in ( select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE between @from and @to  )
union all
select ANN_HOLI_DATE, ''EH'' as Remarks from ANNUAL_HOLIDAYS where ANN_HOLI_DATE between @from and @to)A

CROSS JOIN

(select t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME as Name, d.DEP_NAME as Department,''00:00'' [Time In], 
''00:00'' [Time Out], ''00:00'' [Current Time In], ''00:00'' [Current Time Out]
from
TEACHER_INFO t
join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where c.CITY_NAME like ''' + @city_like + '''
and d.DEP_NAME like ''' +@department_like + '''
and t.TECH_ID like ''' +@staff_id_like + '''
and t.TECH_BR_ID like ''' +@br_id_like + '''
and t.TECH_ID in (select ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE between @from and @to)
)B
)C

)


, tbl2 as 
(
select ROW_NUMBER() over (order by id, Date,CAST([Time In] as datetime)) as srn ,id, Code, Name, Department, Date, Remarks  as value,[Time In], [Time Out], [Current Time In],[Current Time Out]  from tbl
)


,tbl3 as
(select 1 sr, ROW_NUMBER() OVER (PARTITION BY ID,Date ORDER BY srn )as rnk, ID,Code,Name,Department,CAST((CONVERT(Varchar, Date,112))as int) as Filter,[Time In], [Time Out], LEFT(DATENAME(WEEKDAY, Date),2) as [Day], LEFT(CONVERT(nvarchar(50), Date,105),2) as Date,value, [Current Time In],[Current Time Out] from 
tbl2
)
,tbl4 as
(select 
sr,ID,Code,Name,Department,Filter,[Day],[Date] ' + @value_column + ' from tbl3
' + @calculation_columns


exec sp_executesql @query, N'@from date, @to date', @from = @START_DATE, @to = @END_DATE

drop table #tbl_all_dates