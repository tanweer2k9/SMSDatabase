

CREATE procedure [dbo].[rpt_STAFF_SALLERY_DEFF_SELECTION]

as
begin

select * from
(
select  distinct 'Basic Salary' as Name, t.TECH_SALLERY as Amount, 'E' as [Amount Type], 0 as [Deff ID], 0 as ID, s.STAFF_SALLERY_ID as PID, 'T' as [Status], 'Earning' [Type2] 

from TEACHER_INFO t
join STAFF_SALLERY s
on s.STAFF_SALLERY_STAFF_ID = t.TECH_ID
union

select a.ALLOWANCE_NAME as Name , Convert(float, ('+' +  CONVERT(varchar, s.Amount))) as Amount, s.[Amount Type],s.[Deff ID],s.ID, s.PID, s.[Status], 'Earning' [Type2] 
from ALLOWANCE a 
join VSTAFF_SALLERY_DEFF s
on s.[Deff ID] = a.ALLOWANCE_ID
where s.[Amount Type] = 'E' and
a.ALLOWANCE_STATUS = 'T'


union all


select  d.DEDUCTION_NAME as Name,  Convert(float, ('-' +  CONVERT(varchar, s.Amount))) as Amount, s.[Amount Type],s.[Deff ID],s.ID, s.PID, s.[Status] ,'Deduction'
from DEDUCTION d
join VSTAFF_SALLERY_DEFF s
on s.[Deff ID] = d.DEDUCTION_ID
where s.[Amount Type] = 'D' and
d.DEDUCTION_STATUS = 'T'

union all

select  'Loan' as Name,  Convert(float, ('-' +  CONVERT(varchar, s.Amount))) as Amount, s.[Amount Type],s.[Deff ID],s.ID, s.PID, s.[Status] ,'Loan'
from VSTAFF_SALLERY_DEFF s

where s.[Amount Type] = 'L' 
)A where A.Amount != 0

end