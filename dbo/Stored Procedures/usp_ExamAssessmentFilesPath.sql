CREATE PROC [dbo].[usp_ExamAssessmentFilesPath]


@StdId numeric


AS


select e.Id,StdId, FilePath, s.EXAM_STD_TEACHER_COMMENT Comments,CAST(IIF( title='September-2021','2021-09-01 00:00:00.000','2021-10-01 00:00:00.000') as datetime) AssessmentDate, Title WeekNo  from ExamAssessmentFilesPath e 
join EXAM_STD_INFO s on s.EXAM_STD_INFO_STD_ID = e.StdId and EXAM_STD_PID= e.ParentKeyId
join EXAM_CRITERIA_KEY_Parent p on p.Id = e.ParentKeyId
join BR_ADMIN b on b.BR_ADM_ID = p.BrId and b.BR_ADM_SESSION = p.SessionId
where StdId = @StdId and ISNULL(isDeleted,0) = 0

order by p.Id desc