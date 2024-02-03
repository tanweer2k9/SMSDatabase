
CREATE PROC [dbo].[usp_StudentAttendanceSelection]

@ClassId numeric,
@Date date

AS

--declare @ClassId numeric = 30178,
--@Date date




Select * from
(Select * from
(select Distinct s.stdnt_id StdId,s.STDNT_IMG StudentImage, s.STDNT_FIRST_NAME StudentName, s.STDNT_SCHOOL_ID StudentNo, ISNULL(IIF(@Date between l.StartDate and l.EndDate,'LE',d.Remarks), 'P') Remarks from STUDENT_INFO s
left join AttendanceStudentMaster m on m.ClassId = s.STDNT_CLASS_PLANE_ID and m.AttendanceDate = @Date
left join AttendanceStudentDetail d on d.PId = m.Id and s.STDNT_ID = d.StdId
left join DiaryLeavesRequest l on l.StudentId = s.STDNT_ID
And @Date Between l. StartDate And l. EndDate
where s.STDNT_CLASS_PLANE_ID = @ClassId and s.STDNT_STATUS = 'T' ) A

union all

select 0,'','','999999','P' --In moible Last not record not shown that's why add a last fake entry

)B

order by cast(StudentNo as int)


--select * from
--(Select * from
--(select Distinct s.stdnt_id StdId,s.STDNT_IMG StudentImage, s.STDNT_FIRST_NAME StudentName, s.STDNT_SCHOOL_ID StudentNo, ISNULL(IIF(@Date between l.StartDate and l.EndDate,'LE',d.Remarks), 'P') Remarks from STUDENT_INFO s
--left join AttendanceStudentMaster m on m.ClassId = s.STDNT_CLASS_PLANE_ID and m.AttendanceDate = @Date
--left join AttendanceStudentDetail d on d.PId = m.Id and s.STDNT_ID = d.StdId
--left join DiaryLeavesRequest l on l.StudentId = s.STDNT_ID
--And @Date Between l. StartDate And l. EndDate
--where s.STDNT_CLASS_PLANE_ID = @ClassId and s.STDNT_STATUS = 'T' ) A
--)B
--union
--select 0,'','','999999','P'
--)C
--order by cast(StudentNo as int)