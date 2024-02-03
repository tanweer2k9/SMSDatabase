create procedure  [dbo].[sp_SMS_VARIABLES_updation]
                                               
                                               
          @SMS_VARIABLES_ID  numeric,
          @SMS_VARIABLES_HD_ID  numeric,
          @SMS_VARIABLES_BR_ID  numeric,
          @SMS_VARIABLES_NAME  nvarchar(100) ,
          @SMS_VARIABLES_DATE_TIME  datetime ,
          @SMS_VARIABLES_STATUS  char(2) 
   
   
     as begin 
   
   
     update SMS_VARIABLES
 
     set
          SMS_VARIABLES_NAME =  @SMS_VARIABLES_NAME,
          SMS_VARIABLES_DATE_TIME =  @SMS_VARIABLES_DATE_TIME,
          SMS_VARIABLES_STATUS =  @SMS_VARIABLES_STATUS
 
     where 
          SMS_VARIABLES_ID =  @SMS_VARIABLES_ID and 
          SMS_VARIABLES_HD_ID =  @SMS_VARIABLES_HD_ID and 
          SMS_VARIABLES_BR_ID =  @SMS_VARIABLES_BR_ID 
 
end