CREATE PROC [dbo].[sp_NOTIFICATION_ATT_STUDENT]


@START_DATE date,
@END_DATE date, 
@HD_ID numeric,
@BR_ID numeric,
@CLASS_ID numeric,
@SCREEN_NAME nvarchar(50)

AS

--declare @START_DATE date = '2013-04-01'
--declare @END_DATE date = '2013-05-02'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @CLASS_ID numeric = 0
--declare @SCREEN_NAME nvarchar(50) = ''


declare @class nvarchar(50) = '%'
if @CLASS_ID != 0
	begin
		set @class = CAST((@CLASS_ID) as nvarchar(50))
	end

;with atendnce_student as
(

select s.STDNT_ID as ID, s.STDNT_FIRST_NAME as Name, c.CLASS_Name as [Class Name], s.STDNT_CELL_NO as [Student Cell],
a.ATTENDANCE_DATE as [Date], a.ATTENDANCE_REMARKS as Remarks,
case when p.PARNT_CELL_NO = '' then p.PARNT_CELL_NO2 else p.PARNT_CELL_NO END as [Parent Cell],
case when p.PARNT_CELL_NO = '' then p.PARNT_FIRST_NAME else p.PARNT_FIRST_NAME2 END as [Guardian Name]
from ATTENDANCE a
join STUDENT_INFO s on s.STDNT_ID = a.ATTENDANCE_TYPE_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join SCHOOL_PLANE c on c.CLASS_ID = s.STDNT_CLASS_PLANE_ID
where a.ATTENDANCE_DATE between @START_DATE and @END_DATE 
and a.ATTENDANCE_HD_ID = @HD_ID and ATTENDANCE_BR_ID = @BR_ID and s.STDNT_CLASS_PLANE_ID like @class

)

, pivot_table as
(
select * from atendnce_student
pivot 
(MAX(Remarks) for [Remarks] in ([P], [A], [LE], [LA])) as final_tbl
)

, tbl_grp_by as
(
select ID,MAX(Name) as Name, MAX([Class Name]) as  [Class Name],MAX([Student Cell]) as [Student Cell], MAX([Parent Cell]) as [Parent Cell],
MAX([Guardian Name]) as [Guardian Name],DATEDIFF(DD, @START_DATE, @END_DATE) + 1 as [Total Days],
COUNT(ID) as [Study Days] ,COUNT(P) as Present, COUNT(A) as Absent, COUNT(LE) as Leave, COUNT(LA) as Late
 from pivot_table group by ID
)
select *, @START_DATE as [Start Date], @END_DATE as [End Date] from tbl_grp_by

EXEC sp_NOTIFICATION_SMS_TEMPLATE @SCREEN_NAME ,@HD_ID,@BR_ID

select ID, Name from VSCHOOL_PLANE where Status = 'T' and [Institute ID] = @hd_id and [Branch ID] = @br_id