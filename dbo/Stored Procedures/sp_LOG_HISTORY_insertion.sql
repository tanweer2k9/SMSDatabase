CREATE procedure  [dbo].[sp_LOG_HISTORY_insertion]
                                               
                                               
          @LOG_HD_ID  numeric,
          @LOG_BR_ID  numeric,
          @LOG_USER_ID  numeric,          
          @LOG_EVENT_NAME  nvarchar(50) ,
          @LOG_TIME  datetime,
          @LOG_PAGE  nvarchar(50) ,
          @LOG_DESC  nvarchar(500) ,
          @LOG_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into LOG_HISTORY
     values
     (       
        @LOG_HD_ID,
        @LOG_BR_ID,
        @LOG_USER_ID,
        @LOG_EVENT_NAME,
        @LOG_TIME,
        @LOG_PAGE,
        @LOG_DESC,
        @LOG_STATUS    
     )
     
end