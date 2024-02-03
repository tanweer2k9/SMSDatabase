CREATE PROC [dbo].[sp_FORGOT_PASSWORD]

@STATUS char(1),
@EMAIL nvarchar(100)

AS

if @STATUS = 'S'
begin
	declare @school_id int = 0
	 select @school_id = MAIN_INFO_ID from MAIN_HD_INFO where MAIN_INFO_EMAIL = @EMAIL

	 select USER_NAME as [Username], USER_PASSWORD as [Password] from USER_INFO where USER_HD_ID = @school_id and USER_TYPE = 'SA'
end