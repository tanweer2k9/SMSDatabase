CREATE procedure  [dbo].[sp_SMS_NOTIFICATION_SETTINGS_updation]
                                               
                                               
          @SMS_NOTIFICATION_ID  numeric,
          @SMS_NOTIFICATION_HD_ID  numeric,
          @SMS_NOTIFICATION_BR_ID  numeric,
          @SMS_NOTIFICATION_NAME  nvarchar(150) ,
          @SMS_NOTIFICATION_EVENT_DAYS  int,
          @SMS_NOTIFICATION_SHOW_AT_DASHBOARD  char(2) ,
          @SMS_NOTIFICATION_STATUS  char(2) 
   
   
     as begin 
   
   
     update SMS_NOTIFICATION_SETTINGS
 
     set
          SMS_NOTIFICATION_HD_ID =  @SMS_NOTIFICATION_HD_ID,
          SMS_NOTIFICATION_BR_ID =  @SMS_NOTIFICATION_BR_ID,
          SMS_NOTIFICATION_NAME =  @SMS_NOTIFICATION_NAME,
          SMS_NOTIFICATION_EVENT_DAYS =  @SMS_NOTIFICATION_EVENT_DAYS,
          SMS_NOTIFICATION_SHOW_AT_DASHBOARD =  @SMS_NOTIFICATION_SHOW_AT_DASHBOARD,
          SMS_NOTIFICATION_STATUS =  @SMS_NOTIFICATION_STATUS
 
     where 
          SMS_NOTIFICATION_ID =  @SMS_NOTIFICATION_ID 
 
end