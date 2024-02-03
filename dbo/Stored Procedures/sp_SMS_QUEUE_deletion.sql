CREATE PROCEDURE  [dbo].[sp_SMS_QUEUE_deletion]
                                               
                                               
          @STATUS char(10),
          @SMS_QUEUE_ID  numeric,
          @SMS_QUEUE_HD_ID  numeric,
          @SMS_QUEUE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from SMS_QUEUE
 
 
     where 
          SMS_QUEUE_ID =  @SMS_QUEUE_ID and 
          SMS_QUEUE_HD_ID =  @SMS_QUEUE_HD_ID and 
          SMS_QUEUE_BR_ID =  @SMS_QUEUE_BR_ID 
 
end