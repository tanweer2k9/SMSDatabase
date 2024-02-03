CREATE procedure  [dbo].[sp_TERM_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) ,
          @DEFINITION_START_DATE date,
          @DEFINITION_END_DATE date,
          @DEFINITION_SESSION_START_DATE date,
          @DEFINITION_SESSION_END_DATE date,
          @DEFINITION_RANK int
   
   
   
     as begin 
   
   
     update TERM_INFO
 
     set
         
          TERM_NAME =  @DEFINITION_NAME,
          TERM_DESC =  @DEFINITION_DESC,
          TERM_STATUS =  @DEFINITION_STATUS,
          TERM_START_DATE = @DEFINITION_START_DATE,
          TERM_END_DATE = @DEFINITION_END_DATE,
          TERM_SESSION_START_DATE = @DEFINITION_SESSION_START_DATE,
          TERM_SESSION_END_DATE = @DEFINITION_SESSION_END_DATE,
          TERM_RANK = @DEFINITION_RANK
 
 where 
 
	TERM_ID = @DEFINITION_ID
 
 
end