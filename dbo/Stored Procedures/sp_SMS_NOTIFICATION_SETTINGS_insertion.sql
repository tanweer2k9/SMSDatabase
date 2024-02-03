CREATE procedure  [dbo].[sp_SMS_NOTIFICATION_SETTINGS_insertion]
                                               
                                               
          @SMS_NOTIFICATION_HD_ID  numeric,
          @SMS_NOTIFICATION_BR_ID  numeric,
          @SMS_NOTIFICATION_NAME  nvarchar(150) ,
          @SMS_NOTIFICATION_EVENT_DAYS  int,
          @SMS_NOTIFICATION_SHOW_AT_DASHBOARD  char(2) ,
          @SMS_NOTIFICATION_STATUS  char(2) 
   
   
     as  begin
   declare @br_id numeric = @SMS_NOTIFICATION_BR_ID
   if @br_id = 0   
   begin
		set @br_id = (select MAX(BR_ADM_ID) from BR_ADMIN)
   end
   
   
     insert into SMS_NOTIFICATION_SETTINGS
     values
     (
      
        @SMS_NOTIFICATION_HD_ID,
        @br_id,
        @SMS_NOTIFICATION_NAME,
        @SMS_NOTIFICATION_EVENT_DAYS,
        @SMS_NOTIFICATION_SHOW_AT_DASHBOARD,
        @SMS_NOTIFICATION_STATUS
     
     )
     
end