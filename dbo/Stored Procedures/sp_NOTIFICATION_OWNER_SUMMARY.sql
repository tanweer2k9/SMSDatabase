CREATE PROC [dbo].[sp_NOTIFICATION_OWNER_SUMMARY]

@START_DATE date,
@END_DATE date,
@HD_ID numeric ,
@BR_ID numeric,
@SCREEN_NAME nvarchar(100)

AS


--declare @START_DATE date = '2013-04-01'
--declare @END_DATE date = '2013-12-01'
--declare @HD_ID int = 1
--declare @BR_ID int = 1
--declare @SCREEN_NAME nvarchar(100) = ''


declare @branch nvarchar(100) = ''
declare @fee_generated float = 0
declare @fee_received float = 0
declare @salary_generate float = 0
declare @salary_paid float = 0
declare @coa_expense float = 0
declare @coa_income float = 0
declare @staff_total int = 0
declare @staff_join int = 0
declare @staff_left int = 0
declare @staff_present int = 0
declare @staff_absent int = 0
declare @staff_leave int = 0
declare @staff_late int = 0
declare @staff_avg_time_in nvarchar(100) = 0
declare @staff_avg_time_out nvarchar(100) = 0
declare @staff_avg_working_hours nvarchar(100) = 0

declare @student_total int = 0
declare @student_join int = 0
declare @student_left int = 0
declare @student_present int = 0
declare @student_absent int = 0
declare @student_leave int = 0
declare @student_late int = 0


select @fee_generated = ISNULL(SUM(FEE_COLLECT_FEE),0) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID
select @fee_received = ISNULL(SUM(FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED),0) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_RECEIVED between @START_DATE and @END_DATE and FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID
select @salary_generate = ISNULL(sum(STAFF_SALLERY_NET_TOLTAL),0)  from STAFF_SALLERY where STAFF_SALLERY_MONTH_DATE between @START_DATE and @END_DATE and STAFF_SALLERY_HD_ID = @HD_ID and STAFF_SALLERY_BR_ID in (select [BR ID] from dbo.get_centralized_br_id('S', @BR_ID))
select @salary_paid = ISNULL(sum(STAFF_SALLERY_NET_RECEIVED),0)  from STAFF_SALLERY where STAFF_SALLERY_RECEIVED_DATE between @START_DATE and @END_DATE and STAFF_SALLERY_HD_ID = @HD_ID and STAFF_SALLERY_BR_ID in (select [BR ID] from dbo.get_centralized_br_id('S', @BR_ID))
select @coa_expense = ISNULL(SUM(Value),0) from VTRANS where Type = 'E' and Status = 'T' and [Date] between @START_DATE and @END_DATE
select @coa_income = ISNULL(SUM(Value),0) from VTRANS where Type = 'I' and Status = 'T' and [Date] between @START_DATE and @END_DATE

set @branch = (select BR_ADM_NAME from BR_ADMIN where BR_ADM_ID = @BR_ID)


--staff attendance calculation
;with atendnce_staff as
(
select 1 as grp,t.TECH_ID as ID, a.ATTENDANCE_STAFF_DATE as [Date],a.ATTENDANCE_STAFF_REMARKS as [Remarks], 
a.ATTENDANCE_STAFF_TIME_IN as [Time In], a.ATTENDANCE_STAFF_TIME_OUT as [Time Out]
from ATTENDANCE_STAFF a
join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
where a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE
and a.ATTENDANCE_STAFF_HD_ID = @HD_ID and ATTENDANCE_STAFF_BR_ID in (select [BR ID] from dbo.get_centralized_br_id('S',@BR_ID))
)
, change_absent_time as
(
	select grp,ID, Date,Remarks,case when Remarks = 'A' or Remarks = 'LE' then '00:00 AM' ELSE [Time In] END as [Time In],
	case when Remarks = 'A' or Remarks = 'LE' then NULL ELSE [Time Out] END as [Time Out]
	from atendnce_staff
)

,full_time_added as
(
select grp,ID, Date, Remarks,
case when [Time In] like '%AM' or [Time In] like '12:%' then LEFT([Time In], LEN([Time In]) - 3) else CAST((LEFT([Time In],(LEN([Time In]) - 6)) + 12) AS NVARCHAR(10)) + ':' + RIGHT(LEFT([Time In],(LEN([Time In]) - 3)), 2) END as [Time In],
case when [Time Out] like '%AM' or [Time Out] like '12:%' then LEFT([Time Out], LEN([Time Out]) - 3) else CAST((LEFT([Time Out],(LEN([Time Out]) - 6)) + 12) AS NVARCHAR(10)) + ':' + RIGHT(LEFT([Time Out],(LEN([Time Out]) - 3)), 2) END as [Time Out] 
from change_absent_time
)
, pivot_table as
(
select * from full_time_added
pivot 
(MAX(Remarks) for [Remarks] in ([P], [A], [LE], [LA])) as final_tbl
)
,average_time as
(
select COUNT(P) as Present, COUNT(A) as Absent, COUNT(LE) as Leave, COUNT(LA) as Late,

CASE when (COUNT(P) + COUNT(LA)) > 0 then
RIGHT(DATEADD(MINUTE,DATEDIFF(MINUTE,'1900-01-01',DATEADD(SS,0,CAST(SUM(CAST(CAST(LEFT(CAST(([Time In]) as time), 12) 
as datetime) AS FLOAT)) AS datetime)))/ (COUNT(P) + COUNT(LA)),'1900-01-01'),8) ELSE '00:00AM'END as [Average Time In],

CASE when (COUNT(P) + COUNT(LA)) > 0 then
RIGHT(DATEADD(MINUTE,DATEDIFF(MINUTE,'1900-01-01',DATEADD(SS,0,CAST(SUM(CAST(CAST(LEFT(CAST(([Time Out]) as time), 12) 
as datetime) AS FLOAT)) AS datetime)))/ (COUNT(P) + COUNT(LA)),'1900-01-01'),8) ELSE '00:00AM'END as [Average Time Out]

from pivot_table group by grp
)
select @staff_present = Present, @staff_absent = Absent, @staff_leave = Leave, @staff_late = Late,
@staff_avg_time_in = [Average Time In], @staff_avg_time_out = [Average Time Out],
@staff_avg_working_hours = CASE WHEN [Average Time In] != '00:00AM' THEN
REPLACE(REPLACE(CAST((RIGHT(DATEADD(MINUTE,datediff(MINUTE,[Average Time In],[Average Time Out]) + 1,'1900-01-01'),8)) as Nvarchar(10)), 'AM',''),'PM','') 
ELSE '00:00' END
 from average_time

select @staff_total = COUNT(*) from TEACHER_INFO where TECH_STATUS = 'T'
select @staff_join = COUNT(*) from TEACHER_INFO where TECH_JOINING_DATE between @START_DATE and @END_DATE
select @staff_left = COUNT(*) from TEACHER_INFO where TECH_LEFT_DATE between @START_DATE and @END_DATE



--Student Attendance Information
;with atendnce_student as
(

select 1 as grp,s.STDNT_ID as ID, a.ATTENDANCE_DATE as [Date], a.ATTENDANCE_REMARKS as Remarks
from ATTENDANCE a
join STUDENT_INFO s on s.STDNT_ID = a.ATTENDANCE_TYPE_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
where a.ATTENDANCE_DATE between @START_DATE and @END_DATE 
and a.ATTENDANCE_HD_ID = @HD_ID and ATTENDANCE_BR_ID = @BR_ID

)

, pivot_table_std as
(
select * from atendnce_student
pivot 
(MAX(Remarks) for [Remarks] in ([P], [A], [LE], [LA])) as final_tbl
)

, tbl_grp_by as
(
select grp,COUNT(P) as Present, COUNT(A) as Absent, COUNT(LE) as Leave, COUNT(LA) as Late
 from pivot_table_std group by grp
)
select @student_present = Present, @student_absent = Absent, @student_leave = Leave,
@student_late = Late from tbl_grp_by


select @student_total = COUNT(*) from STUDENT_INFO where STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID and STDNT_STATUS = 'T'
select @student_join = COUNT(*) from STUDENT_INFO where STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID and STDNT_REG_DATE between @START_DATE and @END_DATE

--left date
--select @student_left = COUNT(*) from STUDENT_INFO where STDNT_HD_ID = @HD_ID and STDNT_BR_ID = @BR_ID and STDNT_REG_DATE between @START_DATE and @END_DATE

select @START_DATE as [Start Date], @END_DATE as [End Date],@fee_generated as [Fee Generated], @fee_received as [Fee Received], @fee_generated - @fee_received as [Fee Receivable],@salary_generate as [Salary Generated], 
@salary_paid as [Salary Paid], @salary_generate - @salary_paid as [Salary Payable], @coa_income as [COA Income], @coa_expense as [COA Expense], @staff_total as [Total Staff],
@staff_join as [New Staff], @staff_left as [Left Staff], @staff_present as [Staff Present], @staff_absent as [Staff Absent], 
@staff_leave as [Staff Leave], @staff_late as [Staff Late], @staff_avg_time_in as [Average Time In], @staff_avg_time_out as [Average Time Out], 
@staff_avg_working_hours as [Average Working Hours], @student_total as [Total Students], @student_join as [New Students],
@student_left as [Left Students], @student_present as [Student Present], @student_absent as [Student Absent], 
@student_leave as [Student Leave], @student_late as [Student Late], @branch as [Branch Name]

EXEC dbo.sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME,@HD_ID,@BR_ID

select SUPER_ADMIN_ID as ID, SUPER_ADMIN_NAME as Name, SUPER_ADMIN_MOBILE_NO as [Mobile No] from SUPER_ADMIN_INFO where SUPER_ADMIN_STATUS = 'T'