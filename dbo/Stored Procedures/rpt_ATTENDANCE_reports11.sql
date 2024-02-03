CREATE PROC [dbo].[rpt_ATTENDANCE_reports11]

@START_DATE date,
@END_DATE date,
@STATUS nvarchar,
@City nvarchar(50),
@Department nvarchar(50),
@BR_ID numeric,
@Staff_ID numeric

AS

--declare @START_DATE date = '2014-07-01'
--declare @END_DATE date = '2014-07-31'
--declare @STATUS nvarchar(100) = 'Overtime'

--declare @City nvarchar(50) = '0'
--declare @Department nvarchar(50) = '0'
--declare @BR_ID numeric = 0
--declare @Staff_ID numeric = 0









declare @city_like nvarchar(50)='%'
declare @department_like nvarchar(50)='%'
declare @br_id_like nvarchar(50)='%'
declare @staff_id_like nvarchar(50)='%'


if @City != '0'
	set @city_like = @City

if @Department != '0'
	set @department_like = @Department

if @BR_ID != 0
	set @br_id_like = CAST((@BR_ID) as nvarchar(50))

if @Staff_ID != 0
	set @staff_id_like = CAST((@Staff_ID) as nvarchar(50))





declare  @tbl_all_dates table ([date] date)

declare @i int = 0
declare @days_count int = 0
declare @date_columns as varchar(max) = ''
declare @date_columns_isnull as varchar(max) = ''
declare @query nvarchar(MAX) = ''
declare @late_minutes int = 0


set @late_minutes = (select BR_ADM_PAYROLL_LATE_MINUTES from BR_ADMIN where BR_ADM_ID = @BR_ID)

set @days_count = DATEDIFF(DD,@START_DATE,@END_DATE) + 1


while @i < @days_count
begin
	insert into @tbl_all_dates values (DATEADD(DD,@i,@START_DATE))	
	set @i = @i + 1
end


select @date_columns = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), CAST(([date]) as nvarchar(50)), 120)) from @tbl_all_dates
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @date_columns_isnull = STUFF((SELECT ','+'ISNULL(' + QUOTENAME(convert(varchar(50), CAST(([date]) as nvarchar(50))  , 120)) + ',''-'') as [' +CAST(([date]) as nvarchar(50)) + ']' from @tbl_all_dates
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')


declare @value_column varchar(MAX) = ''
declare @value_column2b varchar(MAX) = ''

if @STATUS = 'Remarks'
	set @value_column = 'Remarks'
else if @STATUS = 'Time'
	set @value_column = '[Time In] + CHAR(13) + [Time Out]'
else if @STATUS = 'Overtime'
	set @value_column = ' CASE WHEN (CAST(([Time Out]) as datetime) - CAST(([Time In]) as datetime)) >= (CAST(([Current Time Out]) as datetime) - CAST(([Current Time In]) as datetime))
							THEN CONVERT(nvarchar(500),(CAST(([Time Out]) as datetime) - CAST(([Time In]) as datetime)) - (CAST(([Current Time Out]) as datetime) - CAST(([Current Time In]) as datetime)),24)
							ELSE ''-'' + CONVERT(nvarchar(500),(CAST(([Current Time Out]) as datetime) - CAST(([Current Time In]) as datetime)) - (CAST(([Time Out]) as datetime) - CAST(([Time In]) as datetime)),24)
							END'
else if @STATUS = 'Absent'
	set @value_column = ' CASE WHEN Remarks = ''A'' or Remarks = ''LE'' THEN Remarks ELSE ''-'' END '
else if @STATUS = 'Early'
   set @value_column = 'CASE WHEN CAST(([Time In]) as datetime) > DATEADD(MI,' + CAST((@late_minutes) as nvarchar(50)) + ', CAST(([Current Time In]) as datetime)) THEN [Time In] + CHAR(13) +  CONVERT(nvarchar(50),CAST(([Time In]) as datetime) - CAST(([Current Time In]) as datetime),24) ELSE ''-'' END '
else if @STATUS = 'Late'
   set @value_column = 'CASE WHEN CAST(([Time Out]) as datetime) < CAST(([Current Time Out]) as datetime) THEN [Time Out] + CHAR(13) +  CONVERT(nvarchar(50),CAST(([Current Time Out]) as datetime) - CAST(([Time Out]) as datetime),24) ELSE ''-'' END '

--(Remarks + char(13) + [Time In] + CHAR(13) + [Time Out]) + CHAR(13) + (CONVERT(nvarchar(50),((CAST(([Time Out]) as datetime) - CAST(([Time In]) as datetime)) - (CAST(([Current Time Out]) as datetime) - CAST(([Current Time In]) as datetime)) ),24))


;with tbl as

(
select t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME as Name, d.DEP_NAME as Department, a.ATTENDANCE_STAFF_DATE as [Date],a.ATTENDANCE_STAFF_TIME_IN as [Time In], 
a.ATTENDANCE_STAFF_TIME_OUT as [Time Out], 
CASE WHEN a.ATTENDANCE_STAFF_REMARKS = 'A' or a.ATTENDANCE_STAFF_REMARKS = 'LE' THEN '12:00 AM' ELSE a.ATTENDANCE_STAFF_CURRENT_TIME_IN END as [Current Time In], 
CASE WHEN a.ATTENDANCE_STAFF_REMARKS = 'A' or a.ATTENDANCE_STAFF_REMARKS = 'LE' THEN '12:00 AM' ELSE a.ATTENDANCE_STAFF_CURRENT_TIME_OUT END as [Current Time Out], 
a.ATTENDANCE_STAFF_REMARKS as Remarks
from ATTENDANCE_STAFF a
join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE
and c.CITY_NAME like @city_like 
and d.DEP_NAME like @department_like 
and t.TECH_ID like @staff_id_like 
and t.TECH_BR_ID like @br_id_like 
union

select id,code,Name,Department,date,[Time In],[Time Out], [Current Time In],[Current Time Out],Remarks
from 
(select * from 
(select [date], 'WH' as Remarks from @tbl_all_dates where [date] not in ( select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE  )
union all
select ANN_HOLI_DATE, 'EH' as Remarks from ANNUAL_HOLIDAYS where ANN_HOLI_DATE between @START_DATE and @END_DATE)A

CROSS JOIN

(select t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME as Name, d.DEP_NAME as Department,'00:00' [Time In], 
'00:00' [Time Out], '00:00' [Current Time In], '00:00' [Current Time Out]
from
TEACHER_INFO t
join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where c.CITY_NAME like  @city_like 
and d.DEP_NAME like @department_like 
and t.TECH_ID like @staff_id_like 
and t.TECH_BR_ID like @br_id_like 
and t.TECH_ID in (select ATTENDANCE_STAFF_TYPE_ID from ATTENDANCE_STAFF where ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE)
)B
)C

)
, tbl2 as 

(select id, Code, Name, Department, CONVERT(nvarchar(50), Date,105) as Date, Remarks from tbl
) 

select 1 sr, ID,Code,Name,Department,Date,Remarks from tbl2
union
select 2 sr,ID,Code,Name,Department,'4T.D',CONVERT(nvarchar(50),@days_count)as Remarks from tbl2 group by ID,Code,Name,Department
union
select 3 sr,ID,Code,Name,Department,'5T.P',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl2 where Remarks='P' group by ID,Code,Name,Department
union
select 4,ID,Code,Name,Department,'6T.A',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl2 where Remarks='A' group by ID,Code,Name,Department
union
select 5,ID,Code,Name,Department,'7T.LE',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl2 where Remarks='LE' group by ID,Code,Name,Department
union
select 6,ID,Code,Name,Department,'8T.LA',CONVERT(nvarchar(50),COUNT(*)) as Remarks from tbl2 where Remarks='LA' group by ID,Code,Name,Department