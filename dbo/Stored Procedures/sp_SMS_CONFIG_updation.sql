create procedure  [dbo].[sp_SMS_CONFIG_updation]
                                               
                                               
          @SMS_CONFIG_ID  numeric,
          @SMS_CONFIG_HD_ID  numeric,
          @SMS_CONFIG_BR_ID  numeric,
          @SMS_CONFIG_AVAILABLE_SMS  numeric
         
   
   
     as begin 
   
   
     update SMS_CONFIG
 
     set
          SMS_CONFIG_AVAILABLE_SMS =  @SMS_CONFIG_AVAILABLE_SMS
          
 
     where 
          SMS_CONFIG_ID =  @SMS_CONFIG_ID and 
          SMS_CONFIG_HD_ID =  @SMS_CONFIG_HD_ID and 
          SMS_CONFIG_BR_ID =  @SMS_CONFIG_BR_ID 
 
end