CREATE PROC [dbo].[usp_DairyLeavesRequest_Selection]

@StdId numeric ,
@ClassId numeric,
@ImagePath nvarchar(100)

AS
--declare @StdId numeric = 181409
--declare @ClassId numeric = 30120
--declare @ImagePath nvarchar(100) = 'http://portal.nationalpreschool.pk/Admin/'



select  LeavesType, Reason, IIF(StartDate != EndDate, FORMAT(StartDate,'dd','en-US') + ' - ' + FORMAT(EndDate,'dd','en-US'),FORMAT(StartDate,'dd','en-US')  ) [Day], FORMAT(EndDate,'MMM','en-US') [Month], ISNULL(s.STDNT_FIRST_NAME, '') + ' ' + ISNULL(s.STDNT_LAST_NAME, '') StudentName, @ImagePath + s.STDNT_IMG StudentImage, FORMAT(StartDate, 'ddd, MMM dd, yyyy','en-US') Date from DiaryLeavesRequest d
join STUDENT_INFO s on s.STDNT_ID = ISNULL(d.StudentId,0)
 where ISNULL(StudentId,0) = @StdId OR ISNULL(ClassId,0) = @ClassId
 order by StartDate desc