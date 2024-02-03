CREATE PROC [dbo].[sp_OVERTIME_SALARY_HISTORY]

@STATUS char(1),
@START_DATE date,
@END_DATE date,
@City nvarchar(50),
@Department nvarchar(50),
@BR_ID numeric,
@Staff_ID numeric

AS

--declare @START_DATE date = '2014-07-01'
--declare @END_DATE date = '2014-07-31'


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

select ROW_NUMBER() over(order by (select 0)) as Sr#, t.TECH_ID as ID, t.TECH_EMPLOYEE_CODE as Code, t.TECH_FIRST_NAME as Name, 
d.DEP_NAME as Department, o.OVRTM_FROM_DATE as [From Date], o.OVRTM_END_DATE as [End Date], o.OVRTM_TOTAL_HOURS as [Total Overtime],
o.OVRTM_SHORT_HOURS as [Short Hours], o.OVRTM_NET_HOURS as [Total Hours], o.OVRTM_PER_HOUR_SALARY as Rate,o.OVRTM_TOTAL_SALARY as [Total Amount],
o.OVRTM_ADVANCE as Advance, o.OVRTM_PREVIOUS_SHORT_HOURS_AMOUNT as [Previous Short Hours Amount], o.OVRTM_NET_SALARY as [Net Amount]

from STAFF_OVERTIME_SALARY o
join TEACHER_INFO t on t.TECH_ID = o.OVRTM_STAFF_ID
join DEPARTMENT_INFO d on d.DEP_ID = t.TECH_DEPARTMENT
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY

where o.OVRTM_FROM_DATE >= @START_DATE and o.OVRTM_END_DATE <= @END_DATE

and c.CITY_NAME like @city_like 
and d.DEP_NAME like @department_like
and t.TECH_ID like @staff_id_like
and t.TECH_BR_ID like @br_id_like