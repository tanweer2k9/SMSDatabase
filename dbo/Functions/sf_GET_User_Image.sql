
CREATE FUNCTION [dbo].[sf_GET_User_Image](@USER_TYPE nvarchar(50), @USER_CODE numeric, @UserRole numeric)
returns  nvarchar(100)

BEGIN
declare @User_Image nvarchar(100)

	declare @IsAdminCount int = 0
	select @IsAdminCount = COUNT(*) from RIGHTS_PACKAGES_PARENT where PACKAGES_TYPE = 2 and PACKAGES_ID = @UserRole

	if @IsAdminCount = 0
	BEGIN
		if @USER_TYPE = 'Teacher' OR @USER_TYPE = 'A'
		BEGIN
			select top(1) @User_Image = (TECH_IMG + ','+CAST(TECH_GENDER as nvarchar(1))) from TEACHER_INFO where TECH_ID  = @USER_CODE
		END
	END


return @User_Image
END