CREATE procedure  [dbo].[sp_TERM_ASSESSMENT_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) ,
          @DEFINITION_START_DATE date,
          @DEFINITION_END_DATE date,
          @DEFINITION_SESSION_START_DATE date,
          @DEFINITION_SESSION_END_DATE date,
          @DEFINITION_RANK int
   
   
   
     as  begin
   
  
   
     insert into TERM_ASSESSMENT_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS,
        @DEFINITION_START_DATE,
        @DEFINITION_END_DATE,
        @DEFINITION_SESSION_START_DATE,
        @DEFINITION_SESSION_END_DATE,
        @DEFINITION_RANK
     
     )
     
end