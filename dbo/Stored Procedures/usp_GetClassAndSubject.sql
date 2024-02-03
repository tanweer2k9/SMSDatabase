
CREATE PROC [dbo].[usp_GetClassAndSubject]
@UserId numeric

As


--declare @UserId numeric = 30463




declare @UserType nvarchar(50) = '', @UserCode numeric = 0, @CountAdmin int = 0, @BranchId numeric = 0
select @UserType = USER_TYPE, @UserCode = USER_CODE,@BranchId = USER_BR_ID from USER_INFO where USER_ID = @UserId and USER_STATUS = 'T'


if @UserType = 'Teacher' 
BEGIN
	select distinct ID,Name,[Order] from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
	join USER_INFO u on u.USER_CODE = t.TECH_ID
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	where spd.DEF_TEACHER = @UserCode and spd.DEF_STATUS = 'T'
	order by [Order]

	select distinct s.ID,s.Name, spd.DEF_CLASS_ID ClassId from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID
	join TEACHER_INFO t on t.TECH_ID = spd.DEF_TEACHER 
	join USER_INFO u on u.USER_CODE = t.TECH_ID
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	where spd.DEF_TEACHER = @UserCode and spd.DEF_STATUS = 'T'
	
END

if @UserType = 'A' 
BEGIN

	select distinct ID,Name,[Order] from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID	
	join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and u.USER_TYPE = 'A'
	left join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION 
	left join LEVELS l on l.LEVEL_ID = sp.[Level ID] 
	where u.USER_ID = @UserId and spd.DEF_STATUS = 'T' and ( d.DESIGNATION_DESC is null OR cast(l.LEVEL_LEVEL as nvarchar(10)) in (select TRIM(val) from dbo.split(d.DESIGNATION_DESC, ',')))
	order by [Order]


	--select distinct ID,Name,[Order] from SCHOOL_PLANE_DEFINITION spd
	--join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID	
	--join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	--join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	--where u.USER_ID = @UserId and spd.DEF_STATUS = 'T'
	--order by [Order]

	--select distinct s.ID,s.Name, spd.DEF_CLASS_ID ClassId from SCHOOL_PLANE_DEFINITION spd
	--join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	--join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID	
	--join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	--join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	--where u.USER_ID = @UserId and spd.DEF_STATUS = 'T'


	select distinct s.ID,s.Name, spd.DEF_CLASS_ID ClassId from SCHOOL_PLANE_DEFINITION spd
	join VSCHOOL_PLANE sp on spd.DEF_CLASS_ID=sp.ID
	join VSUBJECT_INFO s on spd.DEF_SUBJECT=s.ID	
	join USER_INFO u on u.USER_BR_ID = sp.[Branch ID]
	join BR_ADMIN b on b.BR_ADM_ID = u.USER_BR_ID and b.BR_ADM_SESSION = sp.[Session Id]
	left join TEACHER_INFO t on t.TECH_ID = u.USER_CODE and u.USER_TYPE = 'A'
	left join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION 
	left join LEVELS l on l.LEVEL_ID = sp.[Level ID] 
	where u.USER_ID = @UserId and spd.DEF_STATUS = 'T' and ( d.DESIGNATION_DESC is null OR cast(l.LEVEL_LEVEL as nvarchar(10)) in (select TRIM(val) from dbo.split(d.DESIGNATION_DESC, ',')))
	
END