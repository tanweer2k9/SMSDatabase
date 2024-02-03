CREATE PROC [dbo].[sp_AUDIT_TRAIL]

@STATUS char(1),
@FROM_DATE date,
@TO_DATE date,
@LOGIN_ID numeric

AS

declare @hd_id numeric = 0
declare @br_id numeric = 0
declare @hd_id_txt nvarchar(50) = '%'
declare @br_id_txt nvarchar(50) = '%'
declare @user_type nvarchar(50) = ''

select @user_type = USER_TYPE, @hd_id = USER_HD_ID, @br_id = USER_BR_ID from user_info where user_id = @LOGIN_ID

if @user_type = 'SA' or @user_type = 'Admin'
begin
	set @hd_id_txt = CAST((@hd_id) as nvarchar(50))
end

if @user_type = 'Admin'
begin
	set @br_id_txt = CAST((@br_id) as nvarchar(50))
end



select * from VLOG_HISTORY where [Date Time]  between @FROM_DATE and @TO_DATE and [Institute ID] like @hd_id_txt and [Branch ID] like @br_id_txt