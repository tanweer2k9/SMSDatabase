create procedure  [dbo].[sp_SESSION_INFO_insertion]
                                               
                                               
          @SESSION_HD_ID  numeric,
          @SESSION_BR_ID  numeric,
          @SESSION_DESC  nvarchar(MAX) ,
          @SESSION_STATUS  char(2) ,
          @SESSION_START_DATE  date,
          @SESSION_END_DATE  date,
          @SESSION_RANK  int
   
   
     as  begin
   
   
     insert into SESSION_INFO
     values
     (
        @SESSION_HD_ID,
        @SESSION_BR_ID,
        @SESSION_DESC,
        @SESSION_STATUS,
        @SESSION_START_DATE,
        @SESSION_END_DATE,
        @SESSION_RANK
     
     
     )
     
end