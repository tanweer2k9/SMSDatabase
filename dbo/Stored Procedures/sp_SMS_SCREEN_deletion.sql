CREATE PROCEDURE  [dbo].[sp_SMS_SCREEN_deletion]
                                               
                                               
          @STATUS char(10),
          @SMS_SCREEN_ID  numeric,
          @SMS_SCREEN_HD_ID  numeric,
          @SMS_SCREEN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE SMS_SCREEN
     SET SMS_SCREEN_STATUS = 'D'
 
 
     where 
          SMS_SCREEN_ID =  @SMS_SCREEN_ID and 
          SMS_SCREEN_HD_ID =  @SMS_SCREEN_HD_ID and 
          SMS_SCREEN_BR_ID =  @SMS_SCREEN_BR_ID 
 
end