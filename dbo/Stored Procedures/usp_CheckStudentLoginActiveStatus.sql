CREATE PROC usp_CheckStudentLoginActiveStatus

@StudentId numeric
--declare @StdId numeric
AS

select count(*) as CountActiveStudent from STUDENT_INFO s with (nolock)
join USER_INFO u with (nolock) on u.USER_CODE = s.STDNT_PARANT_ID and u.USER_TYPE = 'Parent'
join USER_INFO us with (nolock) on us.USER_CODE = s.STDNT_ID and us.USER_TYPE = 'Student'
where s.STDNT_ID = @StudentId and u.USER_STATUS = 'T' and s.STDNT_STATUS = 'T' and us.USER_STATUS = 'T'