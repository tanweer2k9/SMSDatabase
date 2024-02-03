
CREATE PROC [dbo].[usp_eLearningGetAssignments]
@UserId numeric,
@AssignmentType nvarchar(50)
As

--declare @UserId numeric = 30463
declare @UserType nvarchar(50) = '', @UserCode numeric = 0, @CountAdmin int = 0, @BranchId numeric = 0
select @UserType = USER_TYPE, @UserCode = USER_CODE,@BranchId = USER_BR_ID from USER_INFO where USER_ID = @UserId and USER_STATUS = 'T'

if @UserType = 'Teacher' 
BEGIN
	select ROW_NUMBER() over (Order by DueDate) as Serial,* from
	(select distinct el.Date,sp.Name Class, s.Name Subject, el.Topic, ISNULL(el.Instructions,'') Instructions,el.DueDate,el.TotalMarks,CAST((select COUNT(Id) from eLearningAssignmentsFiles f where f.PId = el.Id) as nvarchar(15)) FilePath, 0 ObtainMarks,'' Remarks,el.Id, 0 SubmitId  from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
	join USER_INFO u on u.USER_CODE = t.TECH_ID
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningAssignments el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	where spd.DEF_TEACHER = @UserCode and DEF_STATUS = 'T' and el.Type in (select val from dbo.split(@AssignmentType, ',')) and ISNULL(el.IsDeleted,0) = 0
	)A
	order by DueDate desc
	
END
ELSE IF @UserType = 'A'
BEGIN
		select ROW_NUMBER() over (Order by DueDate) as Serial,* from
	(select distinct el.Date,sp.Name Class, s.Name Subject, el.Topic, ISNULL(el.Instructions,'') Instructions,el.DueDate,el.TotalMarks,CAST((select COUNT(Id) from eLearningAssignmentsFiles f where f.PId = el.Id) as nvarchar(15)) FilePath, 0 ObtainMarks,'' Remarks,el.Id,0 SubmitId from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningAssignments el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and u.USER_TYPE = 'A'
	left join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION 
	left join LEVELS l on l.LEVEL_ID = sp.[Level ID] 
	where u.USER_ID = @UserId and DEF_STATUS = 'T' and  el.Type in (select val from dbo.split(@AssignmentType, ',')) and ISNULL(el.IsDeleted,0) = 0  and ISNULL(el.IsDeleted,0) = 0  and ( d.DESIGNATION_DESC is null OR cast(l.LEVEL_LEVEL as nvarchar(10)) in (select val from dbo.split(d.DESIGNATION_DESC, ',')))
	)A
	order by DueDate desc
END
ELSE IF @UserType = 'Student'
BEGIN
		select ROW_NUMBER() over (Order by DueDate) as Serial,* from
	(select distinct el.Date,sp.Name Class, s.Name Subject, el.Topic, ISNULL(el.Instructions,'') Instructions,el.DueDate,el.TotalMarks, CAST((select COUNT(Id) from eLearningAssignmentsFiles f where f.PId = el.Id) as nvarchar(15)) FilePath,ISNULL(p.ObtainMarks,0) ObtainMarks,iSNULL(p.Remarks,'') Remarks, el.Id, ISNULL(p.Id,0) SubmitId  from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join eLearningAssignments el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	join STUDENT_INFO st on st.STDNT_CLASS_PLANE_ID = sp.ID
	join BR_ADMIN b on b.BR_ADM_ID = st.STDNT_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
		left join eLearningAssignmentsSubmitParent p on p.AssignmentId = el.Id and StudentId = @UserCode
	where st.STDNT_ID = @UserCode and DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and el.Type in (select val from dbo.split(@AssignmentType, ',')) and ISNULL(el.IsDeleted,0) = 0
	)A
	order by DueDate  desc
END