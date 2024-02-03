CREATE procedure  [dbo].[sp_SESSION_INFO_updation]
                                               
                                               
          @SESSION_ID  numeric,
          @SESSION_HD_ID  numeric,
          @SESSION_BR_ID  numeric,
          @SESSION_DESC  nvarchar(max) ,
          @SESSION_STATUS  char(2) ,
          @SESSION_START_DATE  date,
          @SESSION_END_DATE  date,
          @SESSION_RANK  int
   
   
     as begin 
   
   
     update SESSION_INFO
 
     set
          SESSION_BR_ID =  @SESSION_BR_ID,
          SESSION_DESC =  @SESSION_DESC,
          SESSION_STATUS =  @SESSION_STATUS,
          SESSION_START_DATE =  @SESSION_START_DATE,
          SESSION_END_DATE =  @SESSION_END_DATE,
          SESSION_RANK =  @SESSION_RANK
 
     where 
          SESSION_ID =  @SESSION_ID and 
          SESSION_HD_ID =  @SESSION_HD_ID 
 
end