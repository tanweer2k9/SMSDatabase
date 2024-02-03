CREATE procedure  [dbo].[sp_SMS_SCREEN_selection]
                                               
                                               
     @STATUS char(10),
     @SMS_SCREEN_ID  numeric,
     @SMS_SCREEN_HD_ID  numeric,
     @SMS_SCREEN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     select * from VSMS_SCREEN
     where
     HD_ID =  @SMS_SCREEN_HD_ID and 
     BR_ID =  @SMS_SCREEN_BR_ID and
     [Status] != 'D'
     END  

 
     END