create procedure  [dbo].[sp_LOG_HISTORY_updation]
                                               
                                               
          @LOG_ID  numeric,
          @LOG_HD_ID  numeric,
          @LOG_USER_ID  numeric,
          @LOG_EVENT_NAME  nvarchar(50) ,
          @LOG_TIME  datetime,
          @LOG_DESC  nvarchar(500) ,
          @LOG_STATUS  char(2) 
   
   
     as begin 
   
   
     update LOG_HISTORY
 
     set
          LOG_HD_ID =  @LOG_HD_ID,
          LOG_USER_ID =  @LOG_USER_ID,
          LOG_EVENT_NAME =  @LOG_EVENT_NAME,
          LOG_TIME =  @LOG_TIME,
          LOG_DESC =  @LOG_DESC,
          LOG_STATUS =  @LOG_STATUS
 
     where 
          LOG_ID =  @LOG_ID 
 
end