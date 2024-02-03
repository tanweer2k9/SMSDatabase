CREATE PROC [dbo].[usp_eLearningGetAssessmentTestInfo]
@UserId numeric,
@TestDateType nvarchar(50)
As

--declare @UserId numeric = 30463
declare @UserType nvarchar(50) = '', @UserCode numeric = 0, @CountAdmin int = 0, @BranchId numeric = 0
select @UserType = USER_TYPE, @UserCode = USER_CODE,@BranchId = USER_BR_ID from USER_INFO where USER_ID = @UserId and USER_STATUS = 'T'

if @UserType = 'Teacher' 
BEGIN
	select ROW_NUMBER() over (Order by DueDate) as Serial,*,0 StudentTestCount  from
	(select distinct sp.Name Class, s.Name Subject, el.Name Name, el.DueDate,el.publishdate PublishDate,el.TotalMarks,el.TotalQuestion,el.TotalTime, el.Id, 0 ObtainedMarks, ISNULL(B.ActualQuestion,0) ActualQuestion,ISNULL(B.Marks,0) ActualMarks, CAST(0 as bit) IsCompleted  from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
	join USER_INFO u on u.USER_CODE = t.TECH_ID
	--join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningAssessmentTestInfo el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	left join (select q.AssesmentTestInfoId, COUNT(*) ActualQuestion, SUM(Marks) Marks from eLearningAssessmentQuestions q where IsDeleted = 0  and QuestionTypeId != 0
group by q.AssesmentTestInfoId)B on B.AssesmentTestInfoId = el.Id
	where spd.DEF_TEACHER = @UserCode and DEF_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0
	)A
	order by DueDate  desc
	
END
ELSE IF @UserType = 'A'
BEGIN
		select ROW_NUMBER() over (Order by DueDate) as Serial,*,0 StudentTestCount  from
	(select distinct sp.Name Class, s.Name Subject, el.Name Name, el.DueDate,el.publishdate PublishDate,el.TotalMarks,el.TotalQuestion,el.TotalTime, el.Id, 0 ObtainedMarks, ISNULL(C.ActualQuestion,0)ActualQuestion,ISNULL(C.Marks,0)ActualMarks, CAST(0 as bit) IsCompleted from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningAssessmentTestInfo el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 

	left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and u.USER_TYPE = 'A'
	left join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION 
	left join LEVELS l on l.LEVEL_ID = sp.[Level ID] 

	left join (select q.AssesmentTestInfoId, COUNT(*) ActualQuestion, SUM(Marks) Marks from eLearningAssessmentQuestions q where IsDeleted = 0 and QuestionTypeId != 0
	group by q.AssesmentTestInfoId)C on C.AssesmentTestInfoId = el.Id
	where u.USER_ID = @UserId and DEF_STATUS = 'T' and  ISNULL(el.IsDeleted,0) = 0  and ISNULL(el.IsDeleted,0) = 0  and ( d.DESIGNATION_DESC is null OR cast(l.LEVEL_LEVEL as nvarchar(10)) in (select val from dbo.split(d.DESIGNATION_DESC, ',')))
	)A
	order by DueDate desc
END
ELSE IF @UserType = 'Student'
BEGIN
	select ROW_NUMBER() over (Order by DueDate) as Serial,A.*, 0 StudentTestCount from
	(select distinct sp.Name Class, s.Name Subject, el.Name Name, el.DueDate,el.publishdate PublishDate,el.TotalMarks,el.TotalQuestion,el.TotalTime, el.Id, ISNULL(p.ObtainMarks,0) ObtainedMarks, 0 ActualQuestion, ISNULL(p.IsCompleted, CAST(0 as bit)) IsCompleted  from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join eLearningAssessmentTestInfo el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	join STUDENT_INFO st on st.STDNT_CLASS_PLANE_ID = sp.ID
	left join eLearningAssessmentStudentAnswerParent p on p.StudentId = st.STDNT_ID and p.TestInfoId = el.Id
	where (@TestDateType = 'All' AND (st.STDNT_ID = @UserCode and DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0 and CAST(GETDATE() as date) >= PublishDate ))
	OR ( @TestDateType = 'Due' AND (st.STDNT_ID = @UserCode and DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0 and CAST(GETDATE() as date) between PublishDate and DueDate))
	AND (el.Id !=  IIF(@UserCode = 192426, 0,20776 ))
	AND (el.Id !=  IIF(@UserCode = 192426, 0,20777 ))
	--where st.STDNT_ID = @UserCode and DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0 and CAST(GETDATE() as date) >= PublishDate 
	--where st.STDNT_ID = @UserCode and DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0 and CAST(GETDATE() as date) between PublishDate and DueDate
	--and ((CAST(GETDATE() as date) between PublishDate and DueDate) OR (st.STDNT_ID = 60375 and el.Id = 88))
	)A
	
	order by DueDate  desc
END