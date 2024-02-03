CREATE procedure  [dbo].[sp_SMS_QUEUE_updation]
                                               
                                               
          @SMS_QUEUE_ID  numeric,
          @SMS_QUEUE_HD_ID  numeric,
          @SMS_QUEUE_BR_ID  numeric,
          @SMS_QUEUE_MOBILE_NO  nvarchar(100) ,
          @SMS_QUEUE_MESSAGE  nvarchar(200) ,
          @SMS_QUEUE_SCREEN_ID  float,
          @SMS_QUEUE_USER_ID  numeric ,
          @SMS_QUEUE_DATE_TIME  datetime,
          @SMS_QUEUE_STATUS  char(2) 
   
   
     as begin 
   
   
     update SMS_QUEUE
 
     set
          SMS_QUEUE_MOBILE_NO =  @SMS_QUEUE_MOBILE_NO,
          SMS_QUEUE_MESSAGE =  @SMS_QUEUE_MESSAGE,
          SMS_QUEUE_SCREEN_ID =  @SMS_QUEUE_SCREEN_ID,
          SMS_QUEUE_USER_ID =  @SMS_QUEUE_USER_ID,
          SMS_QUEUE_DATE_TIME =  @SMS_QUEUE_DATE_TIME,
          SMS_QUEUE_STATUS =  @SMS_QUEUE_STATUS
 
     where 
          SMS_QUEUE_ID =  @SMS_QUEUE_ID and 
          SMS_QUEUE_HD_ID =  @SMS_QUEUE_HD_ID and 
          SMS_QUEUE_BR_ID =  @SMS_QUEUE_BR_ID 
 
end