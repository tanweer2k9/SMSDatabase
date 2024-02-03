CREATE procedure [dbo].[rpt_ALL_STUDENTS_Filter]

@STUDENT_HD_ID numeric,
@STUDENT_BR_ID numeric,
@SessionId numeric


as
begin

--select 0 ID,'All' Name
--union all
select ID, Name From VSCHOOL_PLANE where Status = 'T' and [Branch ID] = @STUDENT_BR_ID and [Session Id] = @SessionId order by [Order]


select ID,Name from VTRANSPORT_INFO where [Branch ID] = @STUDENT_BR_ID and [Institute ID] = @STUDENT_HD_ID and Status != 'D'
select * from VSCHOOL_PLANE
end