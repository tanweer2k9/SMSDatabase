﻿

CREATE PROC [dbo].[rpt_FEE_REMINDER] 

@HD_ID numeric,
@BR_ID numeric

AS


--declare @HD_ID numeric = 2
--declare @BR_ID numeric = 1





select s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name], CLASS_Name as Class,CLASS_ID [Class ID], CONVERT(VARCHAR, FEE_COLLECT_DUE_DAY, 107) as [Full Date],CONVERT(VARCHAR, FEE_COLLECT_DUE_DAY, 10) as [Date], p.PARNT_FULL_NAME as [Parent Name],p.PARNT_CELL_NO [Parent Contact],p.PARNT_PERM_ADDR [Address],(select top(1) REPLACE(REPLACE(FINAL_FEE_REMINDERS,'<<Long Date>>',CONVERT(VARCHAR, FEE_COLLECT_DUE_DAY, 107)),'<<Short Date>>',CONVERT(VARCHAR, FEE_COLLECT_DUE_DAY, 10)) from FEE_REMINDERS where FEE_REMIDNERS_HD_ID = @HD_ID and FEE_REMIDNERS_BR_ID = @BR_ID  ) as [Final Fee Reminder], (select top(1) FEE_REMINDERS from FEE_REMINDERS where FEE_REMIDNERS_HD_ID = @HD_ID and FEE_REMIDNERS_BR_ID = @BR_ID  ) as [Fee Reminder],(select top(1) WITHDRAWL_NOTICE from FEE_REMINDERS where FEE_REMIDNERS_HD_ID = @HD_ID and FEE_REMIDNERS_BR_ID = @BR_ID  ) as [Withdrawl Notice] from FEE_COLLECT
join STUDENT_INFO s on s.STDNT_ID = FEE_COLLECT_STD_ID 
join SCHOOL_PLANE on CLASS_ID = FEE_COLLECT_PLAN_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
where FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID and s.STDNT_STATUS = 'T'
and  (FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED) < 1000 and (FEE_COLLECT_ARREARS + FEE_COLLECT_FEE) > 0 and FEE_COLLECT_FEE_STATUS in ('Receivable', 'Partially Received','Partially Received')

 --and ((FEE_COLLECT_FEE_STATUS in  ('Receivable') and (FEE_COLLECT_ARREARS + FEE_COLLECT_FEE) > 0) OR (FEE_COLLECT_FEE + FEE_COLLECT_ARREARS_RECEIVED) )
order by CLASS_ORDER, CAST(s.STDNT_SCHOOL_ID as int)