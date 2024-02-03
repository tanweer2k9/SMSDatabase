CREATE procedure  [dbo].[sp_SMS_QUEUE_insertion]
                                               
                                               
          @SMS_QUEUE_HD_ID  numeric,
          @SMS_QUEUE_BR_ID  numeric,
          @SMS_QUEUE_MOBILE_NO  nvarchar(100) ,
          @SMS_QUEUE_MESSAGE  nvarchar(200) ,
          @SMS_QUEUE_SCREEN_ID  float,
          @SMS_QUEUE_USER_ID  numeric,
          @SMS_QUEUE_DATE_TIME  datetime,
          @SMS_QUEUE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into SMS_QUEUE
     values
     (
        @SMS_QUEUE_HD_ID,
        @SMS_QUEUE_BR_ID,
        @SMS_QUEUE_MOBILE_NO,
        @SMS_QUEUE_MESSAGE,
        @SMS_QUEUE_SCREEN_ID,
        @SMS_QUEUE_USER_ID,
        @SMS_QUEUE_DATE_TIME,
        @SMS_QUEUE_STATUS
     
     
     )
     
end