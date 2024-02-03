
CREATE PROC [dbo].[rpt_STAFF_LEAVES_RECORD_TEMPLATE]


@START_DATE date,
@END_DATE date,
@BR_ID numeric

AS

declare @year int = 0

set @year = DATEPART(YYYY,@END_DATE)


select t.TECH_ID ID, t.TECH_EMPLOYEE_CODE COde, t.TECH_FIRST_NAME Name,d.DEP_NAME Department,CAST(d.DEP_ID as decimal) DepartmentID
from TEACHER_INFO t
join DEPARTMENT_INFO d on d.DEP_ID = CAST(t.TECH_DEPARTMENT as numeric)

where t.TECH_BR_ID = @BR_ID and  t.TECH_STATUS = 'T' 
order by d.DEP_RANK, t.TECH_RANKING,CAST(t.TECH_EMPLOYEE_CODE as int)