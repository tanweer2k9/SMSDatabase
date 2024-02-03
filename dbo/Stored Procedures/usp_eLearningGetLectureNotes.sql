


CREATE PROC [dbo].[usp_eLearningGetLectureNotes]
@UserId numeric
As

--declare @UserId numeric = 30463
declare @UserType nvarchar(50) = '', @UserCode numeric = 0, @CountAdmin int = 0, @BranchId numeric = 0
select @UserType = USER_TYPE, @UserCode = USER_CODE,@BranchId = USER_BR_ID from USER_INFO where USER_ID = @UserId and USER_STATUS = 'T'

if @UserType = 'Teacher' 
BEGIN
	select ROW_NUMBER() over (Order by Date desc) as Serial,* from
	(select distinct el.Date,sp.Name Class, s.Name Subject, el.Topic, ISNULL(el.GeneralNotes,'') GeneralNotes,ISNULL(el.FilePath,'') FilePath, el.Id   from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
	join USER_INFO u on u.USER_CODE = t.TECH_ID
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningLectureNotes el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	where spd.DEF_TEACHER = @UserCode and DEF_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0
	)A
	order by Date desc
	
END
ELSE IF @UserType = 'A'
BEGIN
		select ROW_NUMBER() over (Order by Date desc) as Serial,* from
	(select distinct el.Date,sp.Name Class, s.Name Subject, el.Topic,ISNULL(el.GeneralNotes,'') GeneralNotes,ISNULL(el.FilePath,'') FilePath, el.Id  from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	join eLearningLectureNotes el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and u.USER_TYPE = 'A'
	left join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION 
	left join LEVELS l on l.LEVEL_ID = sp.[Level ID] 
	where u.USER_ID = @UserId and DEF_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0 and ( d.DESIGNATION_DESC is null OR cast(l.LEVEL_LEVEL as nvarchar(10)) in (select TRIM(val) from dbo.split(d.DESIGNATION_DESC, ',')))
	)A
	order by Date desc
END
ELSE IF @UserType = 'Student'
BEGIN
		select ROW_NUMBER() over (Order by Date desc) as Serial,* from
	(select distinct el.Date,c.CLASS_NAME Class, s.SUB_NAME Subject, el.Topic,ISNULL(el.GeneralNotes,'') GeneralNotes,ISNULL(el.FilePath,'') FilePath , el.Id 
	from eLearningLectureNotes el
 join SCHOOL_PLANE sp on sp.CLASS_ID = el.ClassId
 join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID = sp.CLASS_ID
 join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS
 join SUBJECT_INFO s on s.SUB_ID = el.SubjectId


 join CLASS_INFO c1 on c1.CLASS_ID = c.CLASS_ID
 join SCHOOL_PLANE sp1 on sp1.CLASS_CLASS = c1.CLASS_ID
 join STUDENT_INFO st on st.STDNT_CLASS_PLANE_ID = sp1.CLASS_ID
 join BR_ADMIN b on b.BR_ADM_ID = st.STDNT_BR_ID and b.BR_ADM_SESSION = sp.CLASS_SESSION_ID
 where st.STDNT_ID = @UserCode and spd.DEF_STATUS = 'T' and st.STDNT_STATUS = 'T' and ISNULL(el.IsDeleted,0) = 0
	--from SCHOOL_PLANE_DEFINITION spd
	--join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID	
	--join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	--join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	--join STUDENT_INFO st on st.STDNT_CLASS_PLANE_ID = sp.ID and u.USER_CODE = st.STDNT_ID
	--join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	--join eLearningLectureNotes el on el.ClassId = sp.ID and el.SubjectId =  spd.DEF_SUBJECT 
	--where u.USER_ID = @UserId and DEF_STATUS = 'T'
	)A
	order by Date desc
END