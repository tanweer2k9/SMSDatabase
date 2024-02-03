CREATE PROCEDURE [dbo].[sp_STAFF_ALLOWANCE_selection_all_staff]

		@STATUS char(1),
		@CITY nvarchar(50),
		@DEPARTMENT nvarchar(50),
		@BR_ID numeric,
		@HD_ID numeric,
		@ALLOWANCE_ID numeric

AS


--declare @City nvarchar(50)='0',
--@Department nvarchar(50)='0',
--@BR_ID numeric=0,
--@ALLOWANCE_ID numeric = 1


--declare @city_like nvarchar(50)='%'
--declare @department_like nvarchar(50)='%'
--declare @br_id_like nvarchar(50)='%'


--if @City != 'All'
--	set @city_like = @City

--if @Department != 'All'
--	set @department_like = @Department

--if @BR_ID != 0
--	set @br_id_like = CAST((@BR_ID) as nvarchar(50))

--select TECH_ID as ID, TECH_EMPLOYEE_CODE as Code,TECH_FIRST_NAME + ' ' + TECH_LAST_NAME as Name, d.DEP_NAME as Department, t.TECH_JOINING_DATE as [Joining Date],
--(DATEDIFF(MM,t.TECH_JOINING_DATE,GETDATE()) + 1) as [Duration Months], t.TECH_SALLERY as [Basic Salary], ISNULL(sa.STAFF_ALLOWANCE_VAL_TYPE, 'Monthly') as [Value Type],
--ISNULL(sa.STAFF_ALLOWANCE_MONTHS, '') as [Months],ISNULL(sa.STAFF_ALLOWANCE_TYPE, 'Fixed') as [Type],ISNULL(sa.STAFF_ALLOWANCE_AMOUNT, t.TECH_SALLERY) as [Amount],
--'T ' [Is Allowance]

--from TEACHER_INFO t
--join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
--join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
--join DEPARTMENT_INFO d on t.TECH_DEPARTMENT = d.DEP_ID
--left join STAFF_ALLOWANCE sa on sa.STAFF_ALLOWANCE_STAFF_ID = t.TECH_ID and sa.STAFF_ALLOWANCE_ALLOW_ID = @ALLOWANCE_ID

--where b.BR_ADM_STATUS = 'T' and c.CITY_STATUS = 'T' and d.DEP_STATUS = 'T'
--and t.TECH_STATUS = 'T'
--and c.CITY_NAME like @city_like 
--and d.DEP_NAME like @department_like
--and t.TECH_BR_ID like @br_id_like


select TECH_ID as ID, TECH_EMPLOYEE_CODE as Code,TECH_FIRST_NAME + ' ' + TECH_LAST_NAME as Name, d.DEP_NAME as Department, t.TECH_JOINING_DATE as [Joining Date],
(DATEDIFF(MM,t.TECH_JOINING_DATE,GETDATE()) + 1) as [Duration Months], t.TECH_SALLERY as [Basic Salary], ISNULL(sa.STAFF_ALLOWANCE_VAL_TYPE, 'Monthly') as [Value Type],
ISNULL(sa.STAFF_ALLOWANCE_MONTHS, '') as [Months],ISNULL(sa.STAFF_ALLOWANCE_TYPE, 'Fixed') as [Type],ISNULL(sa.STAFF_ALLOWANCE_AMOUNT, 0) as [Amount],
'T ' [Is Allowance]

from TEACHER_INFO t
join DEPARTMENT_INFO d on t.TECH_DEPARTMENT = d.DEP_ID

left join STAFF_ALLOWANCE sa on sa.STAFF_ALLOWANCE_STAFF_ID = t.TECH_ID and sa.STAFF_ALLOWANCE_ALLOW_ID = @ALLOWANCE_ID

where d.DEP_STATUS = 'T'
and t.TECH_STATUS = 'T'
and t.TECH_BR_ID = @BR_ID
and t.TECH_HD_ID = @HD_ID