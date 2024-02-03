CREATE procedure  [dbo].[sp_SMS_QUEUE_RETRIEVE_selection]
                                               
     @STATUS char(10),
     @SMS_QUEUE_ID  numeric,
     @HD nvarchar(100),
     @BR nvarchar(100),
     @PC_NAME nvarchar(150),
     @PC_MAC nvarchar(150),
     @PC_WIN nvarchar(150)
     --@SMS_QUEUE_HD_ID  numeric,
     --@SMS_QUEUE_BR_ID  numeric   
   
   
     AS BEGIN 
	
	
	
	 --declare @STATUS char(10) = 'S'
  --   declare @SMS_QUEUE_ID  numeric = 10
  --   declare @HD nvarchar(100) = 'yes'
  --   declare @BR nvarchar(100)= ''
  --   declare @PC_NAME nvarchar(150) = 'tanweer'
  --   declare @PC_MAC nvarchar(150) = '45623155'
  --   declare @PC_WIN nvarchar(150) = 'windows7'
  
	if @STATUS = 'A'
	BEGIN
		select MAIN_INFO_ID as ID, MAIN_INFO_INSTITUTION_FULL_NAME as  Name from MAIN_HD_INFO where MAIN_INFO_INSTITUTION_FULL_NAME != ''
		select BR_ADM_ID as ID, BR_ADM_NAME as Name, BR_ADM_HD_ID as [HD] from BR_ADMIN 
		
		select SMS_CONFIG_ID as [ID], SMS_CONFIG_AVAILABLE_SMS as [Avail SMS], SMS_CONFIG_USER as [User],
		SMS_CONFIG_PASSWORD as [Password]
		from SMS_CONFIG
	END
   
     else if @STATUS = 'L'
     BEGIN
				declare @numeber int = 20
				declare @deduct_sms int = 0
				declare @availsms int = (select SMS_CONFIG_AVAILABLE_SMS from SMS_CONFIG)
				if @availsms < 20
				begin
					set @numeber = @availsms
				end
				
			 select top(@numeber) SMS_QUEUE_ID as ID, SMS_QUEUE_MOBILE_NO as [Mobile No], SMS_QUEUE_MESSAGE as [Msg],
			 SMS_QUEUE_SCREEN_ID as [Screen ID], SMS_QUEUE_USER_ID as [User ID], SMS_QUEUE_DATE_TIME as [Date],
			 SMS_QUEUE_STATUS as [Status]
			FROM SMS_QUEUE        
			where
				SMS_QUEUE_HD_ID in (select val from dbo.split(@HD, ',')) and
				SMS_QUEUE_BR_ID in (select val from dbo.split(@BR, ',')) and	
				SMS_QUEUE_STATUS = 'Q'
			
			
			
			set @deduct_sms = (select COUNT(*)ID FROM SMS_QUEUE where
								SMS_QUEUE_HD_ID in (select val from dbo.split(@HD, ',')) and
								SMS_QUEUE_BR_ID in (select val from dbo.split(@BR, ',')) and	
								SMS_QUEUE_STATUS = 'Q' )
			
			update top(@numeber) SMS_QUEUE set SMS_QUEUE_STATUS = 'P' 
			where
				SMS_QUEUE_HD_ID in (select val from dbo.split(@HD, ',')) and
				SMS_QUEUE_BR_ID in (select val from dbo.split(@BR, ',')) and
				SMS_QUEUE_STATUS = 'Q'

			update SMS_CONFIG set SMS_CONFIG_AVAILABLE_SMS = SMS_CONFIG_AVAILABLE_SMS - @deduct_sms
			
				select SMS_CONFIG_ID as [ID], SMS_CONFIG_AVAILABLE_SMS as [Avail SMS], SMS_CONFIG_USER as [User],
				SMS_CONFIG_PASSWORD as [Password]
				from SMS_CONFIG
     END  
     
     else if @STATUS = 'S' --sent msg
     BEGIN
     declare @sms_status char(2) = 'T'
     declare @count int = 0
     declare @pc_info_id int = 0     
     
     set @pc_info_id = (select top(1) SMS_CLIENT_PC_ID from SMS_CLIENT_PC_INFO where SMS_CLIENT_PC_NAME = @PC_NAME and SMS_CLIENT_PC_MAC = @PC_MAC and SMS_CLIENT_PC_WINDOWS = @PC_WIN)
		if @pc_info_id is null
		begin
			insert into SMS_CLIENT_PC_INFO values (@PC_NAME, @PC_WIN, @PC_MAC)
			set @pc_info_id = (select MAX(SMS_CLIENT_PC_ID) from SMS_CLIENT_PC_INFO)
		end
		
		if @HD = 'no'
		begin
			set @sms_status = 'F'
			update SMS_CONFIG set SMS_CONFIG_AVAILABLE_SMS = SMS_CONFIG_AVAILABLE_SMS + 1
		end
		
		set @count = (select COUNT(*) from SMS_QUEUE where SMS_QUEUE_ID = @SMS_QUEUE_ID)
		
		if @count > 0
		begin
			insert into SMS_SENT_HISTORY 
			select SMS_QUEUE_HD_ID, SMS_QUEUE_BR_ID, SMS_QUEUE_MOBILE_NO, SMS_QUEUE_MESSAGE, SMS_QUEUE_SCREEN_ID, SMS_QUEUE_USER_ID, GETDATE(), @sms_status, @pc_info_id from SMS_QUEUE where SMS_QUEUE_ID = @SMS_QUEUE_ID
			
			delete from SMS_QUEUE where SMS_QUEUE_ID = @SMS_QUEUE_ID
			select 'ok' as [status]
		end
		else
		BEGIN
			select 'not ok' as [status]
		END
		
     END
 
     END