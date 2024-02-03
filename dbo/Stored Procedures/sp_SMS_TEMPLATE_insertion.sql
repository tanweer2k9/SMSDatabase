CREATE procedure  [dbo].[sp_SMS_TEMPLATE_insertion]
                                               
                                               
          @SMS_TEMPLATE_HD_ID  numeric,
          @SMS_TEMPLATE_BR_ID  numeric,
          @SMS_TEMPLATE_SCREEN_ID  numeric,
          @SMS_TEMPLATE_INSERT_MSG  nvarchar(500) ,
          @SMS_TEMPLATE_INSERT_VAR_ID nvarchar(100),
          @SMS_TEMPLATE_UPDATE_MSG  nvarchar(500) ,
          @SMS_TEMPLATE_UPDATE_VAR_ID nvarchar(100),
          @SMS_TEMPLATE_DELETE_MSG  nvarchar(500) ,
          @SMS_TEMPLATE_DELETE_VAR_ID  nvarchar(100),
          @SMS_TEMPLATE_OPEN_MSG  nvarchar(500) ,
          @SMS_TEMPLATE_OPEN_VAR_ID  nvarchar(100),
          @SMS_TEMPLATE_USER  nvarchar(100) ,
          @SMS_TEMPLATE_DATE_TIME  datetime,
          @SMS_TEMPLATE_STATUS  char(2) 
   
   
   
     as  begin
   
   
     insert into SMS_TEMPLATE
     values
     (
        @SMS_TEMPLATE_HD_ID,
        @SMS_TEMPLATE_BR_ID,
        @SMS_TEMPLATE_SCREEN_ID,
        @SMS_TEMPLATE_INSERT_MSG,
        @SMS_TEMPLATE_INSERT_VAR_ID,
        @SMS_TEMPLATE_UPDATE_MSG,
        @SMS_TEMPLATE_UPDATE_VAR_ID,
        @SMS_TEMPLATE_DELETE_MSG,
        @SMS_TEMPLATE_DELETE_VAR_ID,
        @SMS_TEMPLATE_OPEN_MSG,
        @SMS_TEMPLATE_OPEN_VAR_ID,
        @SMS_TEMPLATE_USER,
        @SMS_TEMPLATE_DATE_TIME,
        @SMS_TEMPLATE_STATUS
     
     
     )
     
end