create procedure  [dbo].[sp_SMS_VARIABLES_insertion]
                                               
                                               
          @SMS_VARIABLES_HD_ID  numeric,
          @SMS_VARIABLES_BR_ID  numeric,
          @SMS_VARIABLES_NAME  nvarchar(100) ,
          @SMS_VARIABLES_DATE_TIME  datetime ,
          @SMS_VARIABLES_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SMS_VARIABLES
     values
     (
        @SMS_VARIABLES_HD_ID,
        @SMS_VARIABLES_BR_ID,
        @SMS_VARIABLES_NAME,
        @SMS_VARIABLES_DATE_TIME,
        @SMS_VARIABLES_STATUS
     
     
     )
     
end