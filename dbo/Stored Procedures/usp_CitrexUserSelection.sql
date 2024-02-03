CREATE PROC [dbo].[usp_CitrexUserSelection]

@UserId numeric 

AS


--declare @UserId numeric = 294002

declare @UserType nvarchar(50)= (select USER_TYPE from USER_INFO where USER_ID = @UserId) 



if @UserType = 'Student'
BEGIN

	declare @Id numeric = 0 

	insert into CitrextUserInfoMaster
	select u.USER_BR_ID BrId, u.USER_ID UserId, s.STDNT_FIRST_NAME Name, 'student' Role, p.PARNT_CELL_NO MobileNo, u.USER_NAME + '@ngs.edu.pk' Email, GETDATE() DateTime,'' Response from USER_INFO u
	join STUDENT_INFO s on s.STDNT_ID = u.USER_CODE
	join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
	join CitrexKeys ck on ck.BrId = s.STDNT_BR_ID
	where u.USER_ID = @UserId and u.USER_TYPE = 'Student' and s.STDNT_STATUS = 'T' and ISNULL(s.Stdnt_is_citrix,0) = 1 and ck.status = 1

	set @Id = SCOPE_IDENTITY()

	select u.USER_BR_ID BrId, u.USER_ID UserId, s.STDNT_FIRST_NAME Name, 'student' Role, p.PARNT_CELL_NO MobileNo, u.USER_NAME + '@ngs.edu.pk' Email, GETDATE() DateTime,'' Response,  CitrexSchoolId, CitrexEncyprtionKey from USER_INFO u
	join STUDENT_INFO s on s.STDNT_ID = u.USER_CODE
	join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
	join CitrexKeys ck on ck.BrId = s.STDNT_BR_ID
	where u.USER_ID = @UserId and u.USER_TYPE = 'Student' and s.STDNT_STATUS = 'T' and ISNULL(s.Stdnt_is_citrix,0) = 1 and ck.status = 1



	insert into CitrextUserInfoDetail
	select @Id,sp.CLASS_ID ClassId, sp.CLASS_Name ClassName, si.SESSION_DESC Session from USER_INFO u
	join STUDENT_INFO s on s.STDNT_ID = u.USER_CODE
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	join SESSION_INFO si on si.SESSION_ID = CLASS_SESSION_ID
	where u.USER_ID = @UserId and u.USER_TYPE = 'Student' and s.STDNT_STATUS = 'T'

	select sp.CLASS_ID ClassId, sp.CLASS_Name ClassName, si.SESSION_DESC Session from USER_INFO u
	join STUDENT_INFO s on s.STDNT_ID = u.USER_CODE
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	join SESSION_INFO si on si.SESSION_ID = CLASS_SESSION_ID
	where u.USER_ID = @UserId and u.USER_TYPE = 'Student' and s.STDNT_STATUS = 'T'
END
ELSE if @UserType  = 'Teacher'
BEGIN

	declare @IdStaff numeric = 0 


	insert into CitrextUserInfoMaster
	select u.USER_BR_ID BrId, u.USER_ID UserId, t.TECH_FIRST_NAME Name, 'teacher' Role, t.TECH_CELL_NO MobileNo, u.USER_NAME + '@ngs.edu.pk' Email, GETDATE() DateTime,'' Response from USER_INFO u
	join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
	join CitrexKeys ck on ck.BrId = t.TECH_BR_ID
	where u.USER_ID = @UserId and (u.USER_TYPE = 'Teacher' ) and t.TECH_STATUS = 'T' and ck.status = 1

	set @IdStaff = SCOPE_IDENTITY()

	select u.USER_BR_ID BrId, u.USER_ID UserId, t.TECH_FIRST_NAME Name, 'teacher' Role, t.TECH_CELL_NO MobileNo, u.USER_NAME + '@ngs.edu.pk' Email, GETDATE() DateTime,'' Response, CitrexSchoolId,CitrexEncyprtionKey from USER_INFO u
	join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
	join CitrexKeys ck on ck.BrId = t.TECH_BR_ID
	where u.USER_ID = @UserId and (u.USER_TYPE = 'Teacher' ) and t.TECH_STATUS = 'T' and ck.status = 1


	insert into CitrextUserInfoDetail
	select distinct @IdStaff, sp.CLASS_ID ClassId, sp.CLASS_Name ClassName, si.SESSION_DESC Session from USER_INFO u
	join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
	join SCHOOL_PLANE_DEFINITION spd on  spd.DEF_TEACHER = t.TECH_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = spd.DEF_CLASS_ID
	join BR_ADMIN b on b.BR_ADM_ID = sp.CLASS_BR_ID and b.BR_ADM_SESSION = sp.CLASS_SESSION_ID
	join SESSION_INFO si on si.SESSION_ID = CLASS_SESSION_ID

	where u.USER_ID = @UserId and u.USER_TYPE = 'Teacher' and t.TECH_STATUS = 'T' and spd.DEF_STATUS = 'T'


	select distinct sp.CLASS_ID ClassId, sp.CLASS_Name ClassName, si.SESSION_DESC Session from USER_INFO u
	join TEACHER_INFO t on t.TECH_ID = u.USER_CODE
	join SCHOOL_PLANE_DEFINITION spd on  spd.DEF_TEACHER = t.TECH_ID
	join SCHOOL_PLANE sp on sp.CLASS_ID = spd.DEF_CLASS_ID
	join BR_ADMIN b on b.BR_ADM_ID = sp.CLASS_BR_ID and b.BR_ADM_SESSION = sp.CLASS_SESSION_ID
	join SESSION_INFO si on si.SESSION_ID = CLASS_SESSION_ID

	where u.USER_ID = @UserId and u.USER_TYPE = 'Teacher' and t.TECH_STATUS = 'T' and spd.DEF_STATUS = 'T'
END