CREATE PROCEDURE  [dbo].[sp_SMS_VARIABLES_deletion]
                                               
                                               
          @STATUS char(10),
          @SMS_VARIABLES_ID  numeric,
          @SMS_VARIABLES_HD_ID  numeric,
          @SMS_VARIABLES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE SMS_VARIABLES
 set SMS_VARIABLES_STATUS = 'D'
 
     where 
          SMS_VARIABLES_ID =  @SMS_VARIABLES_ID and 
          SMS_VARIABLES_HD_ID =  @SMS_VARIABLES_HD_ID and 
          SMS_VARIABLES_BR_ID =  @SMS_VARIABLES_BR_ID 
 
end