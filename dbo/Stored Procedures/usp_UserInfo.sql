

CREATE PROC [dbo].[usp_UserInfo]

@UserId numeric
AS

--declare @UserId numeric = 1
declare @UserType nvarchar(50) = '', @UserCode numeric = 0, @CountAdmin int = 0, @BranchId numeric = 0


select @UserType = USER_TYPE, @UserCode = USER_CODE,@BranchId = USER_BR_ID from USER_INFO where USER_ID = @UserId and USER_STATUS = 'T'

--select @CountAdmin = COUNT(*) from MobileAppPreSchoolAdmin where UserId = @UserId



if @UserType = 'Teacher' 
BEGIN
	select t.TECH_FIRST_NAME Name, ISNULL(t.TECH_ID_DESIGNATION,t.TECH_DESIGNATION) Designation, t.TECH_ID ID, @UserType UserType, '' ClassName,0 ClassId, t.TECH_IMG Image, @UserId UserId, t.TECH_BR_ID BranchId From TEACHER_INFO t where TECH_ID =@UserCode and TECH_STATUS = 'T'

	select p.RIGHTS_PAGES_NAME PageName,p.RIGHTS_PAGES_TEXT PageText, c.PACKAGES_DEF_STATUS PageStatus from USER_INFO u
	join RIGHTS_PACKAGES_CHILD c on c.PACKAGES_DEF_PID = u.USER_ROLE
	join RIGHTS_PAGES p on p.RIGHTS_PAGES_ID = c.PACKAGES_DEF_RIGHTS_PAGES_ID
	where p.RIGHTS_PAGES_TEXT = 'SMS' and  p.RIGHTS_PAGES_NAME not in ('Settings_SMS', 'Reports_SMS') and u.USER_ID = @UserId
END
ELSE IF @UserType = 'Student'
BEGIN
	select s.STDNT_FIRST_NAME Name, sp.CLASS_Name Designation, s.STDNT_ID ID, @UserType UserType, sp.CLASS_Name ClassName,sp.CLASS_ID ClassId, s.STDNT_IMG Image, @UserId UserId, s.STDNT_BR_ID BranchId From STUDENT_INFO s
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	 where STDNT_ID =@UserCode and STDNT_STATUS = 'T'

	 select p.RIGHTS_PAGES_NAME PageName,p.RIGHTS_PAGES_TEXT PageText, c.PACKAGES_DEF_STATUS PageStatus from STUDENT_INFO s
	join USER_INFO u on u.USER_CODE =s.STDNT_PARANT_ID and u.USER_TYPE = 'Parent'
	join RIGHTS_PACKAGES_CHILD c on c.PACKAGES_DEF_PID = u.USER_ROLE
	join RIGHTS_PAGES p on p.RIGHTS_PAGES_ID = c.PACKAGES_DEF_RIGHTS_PAGES_ID
	where p.RIGHTS_PAGES_TEXT = 'SMS' and  p.RIGHTS_PAGES_NAME not in ('Settings_SMS', 'Reports_SMS') and s.STDNT_ID = @UserCode
END
ELSE IF @UserType = 'A'
BEGIN
	select top(1) u.USER_DISPLAY_NAME Name, 'Branch Admin' Designation, 0 ID, @UserType UserType, '' ClassName, 0 ClassId, '' Image, @UserId UserId, @BranchId BranchId From USER_INFO u
	where u.USER_ID =@UserId and USER_TYPE = 'A' order by USER_ID --not in (select TECH_ID from TEACHER_INFO where TECH_ID = @UserCode and TECH_BR_ID = @BranchId )

	select p.RIGHTS_PAGES_NAME PageName,p.RIGHTS_PAGES_TEXT PageText, c.PACKAGES_DEF_STATUS PageStatus from USER_INFO u
	join RIGHTS_PACKAGES_CHILD c on c.PACKAGES_DEF_PID = u.USER_ROLE
	join RIGHTS_PAGES p on p.RIGHTS_PAGES_ID = c.PACKAGES_DEF_RIGHTS_PAGES_ID
	where p.RIGHTS_PAGES_TEXT = 'SMS' and  p.RIGHTS_PAGES_NAME not in ('Settings_SMS', 'Reports_SMS') and u.USER_ID = @UserId
END

--if @Type = 'Teacher' 
--BEGIN
--	select distinct ID,Name from SCHOOL_PLANE_DEFINITION spd
--	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
--	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
--	join USER_INFO u on u.USER_CODE = t.TECH_ID
--	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
--	where spd.DEF_TEACHER = @UserCode
--	order by [Order]
--END

--ELSE IF @Type = 'A' AND @CountAdmin > 0
--BEGIN
--	select distinct ID,Name from VSCHOOL_PLANE sp
--	join USER_INFO u on u.USER_ID = @user
--	join BR_ADMIN b on b.BR_ADM_ID = u. and b.BR_ADM_SESSION = sp.[Session Id]
--	where spd.DEF_TEACHER = @UserCode
--	order by [Order]
--END