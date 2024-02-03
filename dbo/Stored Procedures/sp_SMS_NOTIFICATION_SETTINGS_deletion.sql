CREATE PROCEDURE  [dbo].[sp_SMS_NOTIFICATION_SETTINGS_deletion]
                                               
                                               
          @STATUS char(10),
          @SMS_NOTIFICATION_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from SMS_NOTIFICATION_SETTINGS
 
 
end