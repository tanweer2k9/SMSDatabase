CREATE PROC usp_CheckMainAdminCampus

@UserId numeric
AS


select COUNT(*) cnt from  USER_INFO u
join RIGHTS_PACKAGES_PARENT p on p.PACKAGES_ID = u.USER_ROLE
where u.USER_ID = @UserId and p.PACKAGES_TYPE = 2