CREATE procedure  [dbo].[sp_SMS_SENT_HISTORY_insertion]
                                               
                                               
          @SMS_SENT_HISTORY_HD_ID  numeric,
          @SMS_SENT_HISTORY_BR_ID  numeric,
          @SMS_SENT_HISTORY_MOBILE_NO  nvarchar(100) ,
          @SMS_SENT_HISTORY_MESSAGE  nvarchar(200) ,
          @SMS_SENT_HISTORY_SCREEN_ID  float,
          @SMS_SENT_HISTORY_USER_ID  numeric ,
          @SMS_SENT_HISTORY_DATE_TIME  datetime,
          @SMS_SENT_HISTORY_STATUS  nvarchar(10), 
          @SMS_CLIENT_PC_NAME  nvarchar(100) ,
          @SMS_CLIENT_PC_WINDOWS  nvarchar(100) ,
          @SMS_CLIENT_PC_MAC  nvarchar(100) 
   
   
     as  begin
   
    declare @pc_info_id int = 0   
     
     set @pc_info_id = (select top(1) SMS_CLIENT_PC_ID from SMS_CLIENT_PC_INFO where SMS_CLIENT_PC_NAME = @SMS_CLIENT_PC_NAME and SMS_CLIENT_PC_MAC = @SMS_CLIENT_PC_MAC and SMS_CLIENT_PC_WINDOWS = @SMS_CLIENT_PC_WINDOWS)
		if @pc_info_id is null
		begin
			insert into SMS_CLIENT_PC_INFO values ( @SMS_CLIENT_PC_NAME, @SMS_CLIENT_PC_WINDOWS, @SMS_CLIENT_PC_MAC )
			set @pc_info_id = (select MAX(SMS_CLIENT_PC_ID) from SMS_CLIENT_PC_INFO)
		end
   
        
   
   
     insert into SMS_SENT_HISTORY
     values
     (
        @SMS_SENT_HISTORY_HD_ID,
        @SMS_SENT_HISTORY_BR_ID,
        @SMS_SENT_HISTORY_MOBILE_NO,
        @SMS_SENT_HISTORY_MESSAGE,
        @SMS_SENT_HISTORY_SCREEN_ID,
        @SMS_SENT_HISTORY_USER_ID,
        GETDATE(),
        @SMS_SENT_HISTORY_STATUS,
		@pc_info_id
     
     )
     
end