CREATE procedure  [dbo].[sp_SMS_VARIABLES_selection]
                                               
                                               
     @STATUS char(10),
     @SMS_VARIABLES_ID  numeric,
     @SMS_VARIABLES_HD_ID  numeric,
     @SMS_VARIABLES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT SMS_VARIABLES_ID as ID, SMS_VARIABLES_NAME as [Variable Name], SMS_VARIABLES_STATUS As [Status]
     FROM SMS_VARIABLES
     where
     SMS_VARIABLES_HD_ID =  @SMS_VARIABLES_HD_ID and 
     SMS_VARIABLES_BR_ID =  @SMS_VARIABLES_BR_ID and
     SMS_VARIABLES_STATUS != 'D'  
     END  
     ELSE
     BEGIN
  SELECT * FROM SMS_VARIABLES
 
 
     WHERE
     SMS_VARIABLES_ID =  @SMS_VARIABLES_ID and 
     SMS_VARIABLES_HD_ID =  @SMS_VARIABLES_HD_ID and 
     SMS_VARIABLES_BR_ID =  @SMS_VARIABLES_BR_ID 
 
     END
 
     END