CREATE PROC [dbo].[rpt_STAFF_MONTHLY_SALARY]


@STATUS char,
@START_DATE date,
@END_DATE date,
@City nvarchar(50),
@Department nvarchar(50),
@BR_ID numeric,
@Staff_ID numeric


AS


--declare @STATUS char(1) = ''
--declare @START_DATE date = '2014-04-01'
--declare @END_DATE date = '2014-07-31'


--declare @City nvarchar(50)='0',
--@Department nvarchar(50)='0',
--@BR_ID numeric=0,
--@Staff_ID numeric=0


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



select ROW_NUMBER() over(order by (select 0)) as Sr#, [Staff ID], [Emp Code],([Staff First Name] + ' ' + [Staff Last Name])  as Name, Department, Salary,[Working Days],[Total Presenets],
[Total Absents],[Total Leaves],[Late Days], ([Total Deductions] + [Absent Detuctions]) as [Deduction], [Total Earnings],[Net Total] 

from VSTAFF_SALLERY  t

join BR_ADMIN b on b.BR_ADM_ID = t.[Branch ID]
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where c.CITY_NAME like @city_like 
and t.Department like @department_like
and t.[Staff ID] like @staff_id_like
and t.[Branch ID] like @br_id_like
and t.[Month Date] between @START_DATE and @END_DATE