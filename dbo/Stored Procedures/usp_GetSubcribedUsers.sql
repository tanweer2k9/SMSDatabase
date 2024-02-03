

CREATE PROC [dbo].[usp_GetSubcribedUsers] 
 @ClassIds nvarchar(MAX),
 @NotificationType nvarchar(50), 
 @StudentIds nvarchar(MAX),
 @UserType nvarchar(100)

AS
--declare @ClassIds nvarchar(100) = 30120
--declare @UserType nvarchar(50) = 'Parent'
--declare @StudentIds nvarchar(100) = ''

if @NotificationType = 'Activity' OR @NotificationType = 'Notice' OR @NotificationType = 'Homework' --Includes Activity, Notice,Homework
BEGIN

select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
	join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T' and u.USER_TYPE = 'Parent'
	join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
	where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) AND (@ClassIds = '' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@ClassIds, ',')))



	--select distinct PlayerId, u.USER_ID UserId from USER_INFO u
	--join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null'
	--join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE

	--where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) AND (@ClassIds = '' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@ClassIds, ',')))
END
ELSE if @NotificationType = 'Attendance'
BEGIN
	select distinct PlayerId, u.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId
	join STUDENT_INFO s on s.STDNT_ID = CAST(@StudentIds as numeric)
	join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID
	where u.USER_CODE = sp.CLASS_TEACHER and m.PlayerId != 'null' and IsLoggedIn = 1
END
ELSE if @NotificationType = 'FeeChallanGenerate' OR @NotificationType = 'FeePaymentDeclined' OR @NotificationType = 'FeePaymentSuccessful'
BEGIN
select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId
	join STUDENT_INFO s on s.STDNT_ID = CAST(@StudentIds as numeric) and u.USER_CODE = s.STDNT_PARANT_ID 

	join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
	where  m.PlayerId != 'null' and IsLoggedIn = 1

END
ELSE if @NotificationType = 'StudentAttendance'
BEGIN
	select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
	join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T' and u.USER_TYPE = 'Parent'
	join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
	where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) 
END
ELSE IF @NotificationType = 'ScheduledPTM'
BEGIN
	if @UserType = 'Parent'
	BEGIN
		select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
		join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T' and u.USER_TYPE = 'Parent'
		join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
		where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) AND (@ClassIds = '' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@ClassIds, ',')))
	END
	else if @UserType = 'Teacher'
	BEGIN
		select distinct PlayerId, u.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
		join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and USER_TYPE = 'Teacher'
		join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.tech_id 
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = sp.CLASS_ID
		where m.IsLoggedIn = 1 and (@ClassIds = '' OR sp.CLASS_ID in (select CAST(val as numeric)from dbo.split(@ClassIds, ',')))  and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ',')))
	END
END
ELSE IF @NotificationType = 'RequestsPTM'
BEGIN
	select distinct PlayerId, u.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null'
	join MobileAppPreSchoolAdmin a on a.UserId = m.UserId
	join STUDENT_INFO s on s.STDNT_BR_ID = u.USER_BR_ID and u.USER_TYPE = 'A'
	where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) 
END
ELSE IF @NotificationType = 'RequestsPTMAccept'
BEGIN
	if @UserType = 'Parent'
	BEGIN
		select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
		join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T' and u.USER_TYPE = 'Parent'
		join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
		where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) AND (@ClassIds = '' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@ClassIds, ',')))
	END
	else if @UserType = 'Teacher'
	BEGIN
		select distinct PlayerId, u.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
		join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and USER_TYPE = 'Teacher'
		join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.tech_id 
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = sp.CLASS_ID
		where m.IsLoggedIn = 1 and (@ClassIds = '' OR sp.CLASS_ID in (select CAST(val as numeric)from dbo.split(@ClassIds, ',')))  and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ',')))
	END
END
ELSE IF @NotificationType = 'RequestsPTMReject'
BEGIN
	select distinct PlayerId, u1.USER_ID UserId from USER_INFO u
	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
	join STUDENT_INFO s on s.STDNT_PARANT_ID = u.USER_CODE and s.STDNT_STATUS = 'T' and u.USER_TYPE = 'Parent'
	join USER_INFO u1 on u1.USER_CODE = s.STDNT_ID and u1.USER_TYPE = 'Student'
	where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) AND (@ClassIds = '' OR s.STDNT_CLASS_PLANE_ID in (select CAST(val as numeric) from dbo.split(@ClassIds, ',')))
END
ELSE IF @NotificationType = 'ApplyForLeave'
BEGIN
		select distinct PlayerId, u.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null'
		join MobileAppPreSchoolAdmin a on a.UserId = m.UserId
		join STUDENT_INFO s on s.STDNT_BR_ID = u.USER_BR_ID and u.USER_TYPE = 'A'
		where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) 
		union
		select distinct PlayerId, u.USER_ID UserId from USER_INFO u
		join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
		join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and USER_TYPE = 'Teacher'
		join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.tech_id 
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = sp.CLASS_ID
		where m.IsLoggedIn = 1 and (@ClassIds = '' OR sp.CLASS_ID in (select CAST(val as numeric)from dbo.split(@ClassIds, ',')))  and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ',')))
	--if @UserType = 'A'
	--BEGIN
	--	select distinct PlayerId, u.USER_ID UserId from USER_INFO u
	--	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null'
	--	join MobileAppPreSchoolAdmin a on a.UserId = m.UserId
	--	join STUDENT_INFO s on s.STDNT_BR_ID = u.USER_BR_ID and u.USER_TYPE = 'A'
	--	where m.IsLoggedIn = 1 and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ','))) 
	--END
	--else if @UserType = 'Teacher'
	--BEGIN
	--	select distinct PlayerId, u.USER_ID UserId from USER_INFO u
	--	join MoibleAppSubscribedUsers m on u.USER_ID = m.UserId and m.PlayerId != 'null' 
	--	join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and USER_TYPE = 'Teacher'
	--	join SCHOOL_PLANE sp on sp.CLASS_TEACHER = t.tech_id 
	--	join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = sp.CLASS_ID
	--	where m.IsLoggedIn = 1 and (@ClassIds = '' OR sp.CLASS_ID in (select CAST(val as numeric)from dbo.split(@ClassIds, ',')))  and (@StudentIds = '' OR s.STDNT_ID in (select CAST(val as numeric) from dbo.split(@StudentIds, ',')))
	--END

END