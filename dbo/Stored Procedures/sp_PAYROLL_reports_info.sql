
CREATE PROC [dbo].[sp_PAYROLL_reports_info]

@HD_ID  numeric,
@BR_ID numeric
AS


select ROW_NUMBER() over(order by (select 0)) as ID, Name from (select distinct Name from VCITY_INFO where Status = 'T' and [Branch ID] = 1)A
select BR_ADM_ID as ID, BR_ADM_NAME as Name, c.CITY_NAME as City from BR_ADMIN b
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where b.BR_ADM_STATUS = 'T' and c.CITY_STATUS = 'T'
--select * from TEACHER_INFO t
--join DEPARTMENT_INFO d on t.TECH_DEPARTMENT = d.DEP_ID
select ID, Name, [Branch ID] from VDEPARTMENT_INFO where Status = 'T'
select TECH_ID as ID, TECH_EMPLOYEE_CODE as Code,TECH_FIRST_NAME + ' ' + TECH_LAST_NAME as Name, d.DEP_NAME as Department, TECH_BR_ID as [Branch ID],
 c.CITY_NAME as City
from TEACHER_INFO t
join BR_ADMIN b on b.BR_ADM_ID = t.TECH_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
join DEPARTMENT_INFO d on t.TECH_DEPARTMENT = d.DEP_ID
where b.BR_ADM_STATUS = 'T' and c.CITY_STATUS = 'T' and d.DEP_STATUS = 'T'

select a.ALLOWANCE_ID as ID, a.ALLOWANCE_NAME as Name,c.CITY_NAME as City, b.BR_ADM_ID as [BR ID] from ALLOWANCE a
join BR_ADMIN b on b.BR_ADM_ID = a.ALLOWANCE_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where a.ALLOWANCE_STATUS = 'T' and b.BR_ADM_STATUS = 'T' and c.CITY_STATUS = 'T' and a.ALLOWANCE_BR_ID = @BR_ID


select d.DEDUCTION_ID ID, d.DEDUCTION_NAME as Name,c.CITY_NAME as City, b.BR_ADM_ID as [BR ID] from DEDUCTION d
join BR_ADMIN b on b.BR_ADM_ID = d.DEDUCTION_BR_ID
join CITY_INFO c on c.CITY_ID = b.BR_ADM_CITY
where d.DEDUCTION_STATUS = 'T' and b.BR_ADM_STATUS = 'T' and c.CITY_STATUS = 'T' and DEDUCTION_BR_ID = @BR_ID