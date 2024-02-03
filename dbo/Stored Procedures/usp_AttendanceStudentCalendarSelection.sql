



CREATE PROC usp_AttendanceStudentCalendarSelection

 @ClassId numeric,
 @StdId numeric,
 @FromDate date,
 @ToDate date



 AS




--declare @ClassId numeric = 30198
--declare @StdId numeric = 0
--declare @FromDate date
--declare @ToDate date




declare @tbl table(AttendanceDate date, Remarks nvarchar(50))

if @StdId = 0
BEGIN
	select AttendanceDate, 'P' as Remarks  from AttendanceStudentMaster  where ClassId = @ClassId and AttendanceDate between @FromDate and @ToDate

	select '' Remarks, 0 RemarksCount
END
ELSE
BEGIN
	insert into @tbl
	select AttendanceDate, d.Remarks from AttendanceStudentMaster m 
	join AttendanceStudentDetail d on d.PId = m.Id
	where StdId = @StdId and AttendanceDate between @FromDate and @ToDate

	select * from @tbl

	select Remarks, COUNT(*) RemarksCount from @tbl group by Remarks
END