CREATE PROCEDURE  [dbo].[sp_SMS_TEMPLATE_deletion]
                                               
                                               
          @STATUS char(10),
          @SMS_TEMPLATE_ID  numeric,
          @SMS_TEMPLATE_HD_ID  numeric,
          @SMS_TEMPLATE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE SMS_TEMPLATE
 SET SMS_TEMPLATE_STATUS = 'D'
 
     where 
          SMS_TEMPLATE_ID =  @SMS_TEMPLATE_ID and 
          SMS_TEMPLATE_HD_ID =  @SMS_TEMPLATE_HD_ID and 
          SMS_TEMPLATE_BR_ID =  @SMS_TEMPLATE_BR_ID 
 
end