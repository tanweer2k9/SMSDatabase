CREATE procedure  [dbo].[sp_TERM_ASSESSMENT_INFO_updation]
                                               
                                               
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
   
   
     update TERM_ASSESSMENT_INFO
 
     set
         
          TERM_ASSESS_NAME =  @DEFINITION_NAME,
          TERM_ASSESS_DESC =  @DEFINITION_DESC,
          TERM_ASSESS_STATUS =  @DEFINITION_STATUS,
          TERM_ASSESS_START_DATE = @DEFINITION_START_DATE,
          TERM_ASSESS_END_DATE = @DEFINITION_END_DATE,
          TERM_ASSESS_SESSION_START_DATE = @DEFINITION_SESSION_START_DATE,
          TERM_ASSESS_SESSION_END_DATE = @DEFINITION_SESSION_END_DATE,
          TERM_ASSESS_RANK = @DEFINITION_RANK
 
 where 
 
	TERM_ASSESS_ID = @DEFINITION_ID
 
 
end