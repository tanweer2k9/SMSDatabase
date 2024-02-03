CREATE PROC [dbo].[sp_NOTIFICATION_SMS_TEMPLATE]

@SCREEN_NAME nvarchar(100),
@HD_ID numeric,
@BR_ID numeric
AS
declare @count_template int = 0
set @count_template = (Select count(*)from SMS_TEMPLATE 
join SMS_SCREEN on SMS_SCREEN.SMS_SCREEN_NAME = @SCREEN_NAME
and SMS_SCREEN.SMS_SCREEN_ID=SMS_TEMPLATE.SMS_TEMPLATE_SCREEN_ID where SMS_SCREEN_STATUS = 'T' and SMS_SCREEN_HD_ID=@HD_ID AND SMS_SCREEN_BR_ID=@BR_ID )

if @count_template = 1
begin
	Select SMS_TEMPLATE_INSERT_MSG as Msg,SMS_TEMPLATE_ID as ID,SMS_TEMPLATE_SCREEN_ID as [S ID]
	from SMS_TEMPLATE 
	join SMS_SCREEN on SMS_SCREEN.SMS_SCREEN_NAME = @SCREEN_NAME
	and SMS_SCREEN.SMS_SCREEN_ID=SMS_TEMPLATE.SMS_TEMPLATE_SCREEN_ID
	where SMS_SCREEN_STATUS = 'T'	and SMS_SCREEN_HD_ID=@HD_ID AND SMS_SCREEN_BR_ID=@BR_ID
end
else
begin
	set @count_template =  (select COUNT(*) from SMS_SCREEN where SMS_SCREEN_NAME = @SCREEN_NAME and SMS_SCREEN_STATUS = 'T')
	if @count_template = 1
	begin
		select SMS_SCREEN_ID as [S ID] from SMS_SCREEN where SMS_SCREEN_NAME = @SCREEN_NAME and SMS_SCREEN_STATUS = 'T'
	end	
	else
	begin
		select -1 as [S ID]
	end
end