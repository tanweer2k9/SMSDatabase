
CREATE PROC [dbo].[usp_MobileAppLoginInfo]

@UserId numeric,
@UserType nvarchar(50)

AS



--declare @UserId numeric= 0
--declare @UserType nvarchar(50) = ''

declare @IsUserSubcribed bit = 0
declare @IsMobileAppAdmin bit = 0

select @IsUserSubcribed = IIF(COUNT(*) = 0, 0, 1)  from MoibleAppSubscribedUsers where UserId = @UserId

select @IsMobileAppAdmin = IIF(COUNT(*) = 0, 0, 1)  from MobileAppPreSchoolAdmin where UserId = @UserId

if @UserType = 'Parent' 
BEGIN
	
	select s.STDNT_FIRST_NAME StudentName, ISNULL(t.TECH_FIRST_NAME, '') TeacherName ,s.STDNT_ID Id,  sp.CLASS_Name ClassName, s.STDNT_IMG StudentImage,  sp.CLASS_ID ClassId, u.USER_TYPE UserType,  u.USER_ID UserId, @IsUserSubcribed IsUserSubcribed, CAST(0 as bit) IsMobileAppAdmin, s.STDNT_BR_ID BrId, l.LEVEL_LEVEL ClassLevel, us .USER_ID StudentUserId
	from USER_INFO u
	join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T'
	join USER_INFO us on us.USER_CODE = s.STDNT_ID and us.USER_TYPE = 'Student'
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID and sp.CLASS_STATUS = 'T'
	join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID
	left join TEACHER_INFO t on t.TECH_ID = sp.CLASS_TEACHER
	
	where u.USER_ID = @UserId and l.LEVEL_LEVEL <= 4
END
ELSE if @UserType = 'Teacher' OR @UserType = 'A' 
BEGIN
	if @IsMobileAppAdmin = 1
	BEGIN
		select '' StudentName,u.USER_DISPLAY_NAME TeacherName, m.Id Id,  sp.CLASS_Name ClassName, 'Images/Teacher/logo_male.png' StudentImage,  sp.CLASS_ID ClassId, u.USER_TYPE UserType,  u.USER_ID UserId, @IsUserSubcribed IsUserSubcribed, @IsMobileAppAdmin IsMobileAppAdmin, u.USER_BR_ID BrId, l.LEVEL_LEVEL ClassLevel, 0 StudentUserId
		from USER_INFO u
		left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and t.TECH_STATUS = 'T'
		cross join SCHOOL_PLANE sp 
		join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID
		join BR_ADMIN b on b.BR_ADM_SESSION = sp.CLASS_SESSION_ID and b.BR_ADM_ID = sp. CLASS_BR_ID and b.BR_ADM_STATUS = 'T'
		join MobileAppPreSchoolAdmin m on m.UserId = u.USER_ID
		where u.USER_ID = @UserId and l.LEVEL_LEVEL <= 4 and sp.CLASS_BR_ID = u.USER_BR_ID and sp.CLASS_STATUS = 'T'
	END
	ELSE 
	BEGIN
		select '' StudentName,t.TECH_FIRST_NAME TeacherName, t.TECH_ID Id,  sp.CLASS_Name ClassName, t.TECH_IMG StudentImage,  sp.CLASS_ID ClassId, u.USER_TYPE UserType,  u.USER_ID UserId, @IsUserSubcribed IsUserSubcribed, @IsMobileAppAdmin IsMobileAppAdmin, u.USER_BR_ID BrId, l.LEVEL_LEVEL ClassLevel,0 StudentUserId
		from USER_INFO u
		join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and t.TECH_STATUS = 'T'
		join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.TECH_ID and sp.CLASS_STATUS = 'T'
		join LEVELS l on l.LEVEL_ID = sp.CLASS_LEVEL_ID
		join BR_ADMIN b on b.BR_ADM_SESSION = sp.CLASS_SESSION_ID  and b.BR_ADM_ID = sp. CLASS_BR_ID and b.BR_ADM_STATUS = 'T'
		where u.USER_ID = @UserId and  l.LEVEL_LEVEL <= 4
	END
END