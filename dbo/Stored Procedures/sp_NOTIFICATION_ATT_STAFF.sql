CREATE PROC [dbo].[sp_NOTIFICATION_ATT_STAFF]

@START_DATE date,
@END_DATE date,
@HD_ID numeric,
@BR_ID numeric,
@SCREEN_NAME nvarchar(50)
AS

--declare @START_DATE date = '2013-04-01'
--declare @END_DATE date = '2013-04-02'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @SCREEN_NAME nvarchar(100) = 'asd'


declare @count_template int = 0

;with atendnce_staff as
(
select t.TECH_ID as ID, t.TECH_FIRST_NAME as Name, t.TECH_DESIGNATION as Designation, t.TECH_CELL_NO as [Staff Cell],a.ATTENDANCE_STAFF_DATE as [Date],
a.ATTENDANCE_STAFF_REMARKS as [Remarks], 
a.ATTENDANCE_STAFF_TIME_IN as [Time In], a.ATTENDANCE_STAFF_TIME_OUT as [Time Out]
from ATTENDANCE_STAFF a
join TEACHER_INFO t on t.TECH_ID = a.ATTENDANCE_STAFF_TYPE_ID
where a.ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE 
and a.ATTENDANCE_STAFF_HD_ID = @HD_ID and ATTENDANCE_STAFF_BR_ID in (select [BR ID] from dbo.get_centralized_br_id('S',@BR_ID))
)
, change_absent_time as
(
	select ID, Name,Designation,[Staff Cell],Date,Remarks,case when Remarks = 'A' or Remarks = 'LE' then '00:00 AM' ELSE [Time In] END as [Time In],
	case when Remarks = 'A' or Remarks = 'LE' then NULL ELSE [Time Out] END as [Time Out]
	from atendnce_staff
)

,full_time_added as
(
select ID, Name,Designation,[Staff Cell],Date, Remarks,
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
select ID, MAX(Name) as Name, MAX(Designation) as  Designation,MAX([Staff Cell]) as [Staff Cell],DATEDIFF(DD, @START_DATE, @END_DATE) + 1 as [Total Days],
COUNT(ID) as [Working Days] ,COUNT(P) as Present, COUNT(A) as Absent, COUNT(LE) as Leave, COUNT(LA) as Late,

CASE when (COUNT(P) + COUNT(LA)) > 0 then
RIGHT(DATEADD(MINUTE,DATEDIFF(MINUTE,'1900-01-01',DATEADD(SS,0,CAST(SUM(CAST(CAST(LEFT(CAST(([Time In]) as time), 12) 
as datetime) AS FLOAT)) AS datetime)))/ (COUNT(P) + COUNT(LA)),'1900-01-01'),8) ELSE '00:00AM'END as [Average Time In],

CASE when (COUNT(P) + COUNT(LA)) > 0 then
RIGHT(DATEADD(MINUTE,DATEDIFF(MINUTE,'1900-01-01',DATEADD(SS,0,CAST(SUM(CAST(CAST(LEFT(CAST(([Time Out]) as time), 12) 
as datetime) AS FLOAT)) AS datetime)))/ (COUNT(P) + COUNT(LA)),'1900-01-01'),8) ELSE '00:00AM'END as [Average Time Out]

from pivot_table group by ID
)
select *, CASE WHEN [Average Time In] != '00:00AM' THEN
REPLACE(REPLACE(CAST((RIGHT(DATEADD(MINUTE,datediff(MINUTE,[Average Time In],[Average Time Out]) + 1,'1900-01-01'),8)) as Nvarchar(10)), 'AM',''),'PM','') 
ELSE '00:00' END as [Average Working Hours]
--,@START_DATE as [Start Date], @END_DATE as [End Date]
 from average_time

EXEC sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME ,@HD_ID,@BR_ID