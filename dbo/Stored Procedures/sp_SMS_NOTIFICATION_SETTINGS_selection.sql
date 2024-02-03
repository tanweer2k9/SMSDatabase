CREATE procedure  [dbo].[sp_SMS_NOTIFICATION_SETTINGS_selection]
                                               
     @SMS_NOTIFICATION_BR_ID numeric,                                         
     @STATUS char(2)
   
     AS BEGIN 
     If @STATUS='L'
     begin
   
   select SMS_NOTIFICATION_ID as ID, SMS_NOTIFICATION_NAME as Name,
   SMS_NOTIFICATION_EVENT_DAYS as Days, SMS_NOTIFICATION_SHOW_AT_DASHBOARD as [Dashboard Show],
    SMS_NOTIFICATION_STATUS as Status from SMS_NOTIFICATION_SETTINGS where SMS_NOTIFICATION_ID is null
     END  
     else
     begin
		   select SMS_NOTIFICATION_ID as ID, SMS_NOTIFICATION_NAME as Name,
	   SMS_NOTIFICATION_EVENT_DAYS as Days, SMS_NOTIFICATION_SHOW_AT_DASHBOARD as [Dashboard Show],
		SMS_NOTIFICATION_STATUS as Status from SMS_NOTIFICATION_SETTINGS
		where SMS_NOTIFICATION_BR_ID = @SMS_NOTIFICATION_BR_ID
		end
    end