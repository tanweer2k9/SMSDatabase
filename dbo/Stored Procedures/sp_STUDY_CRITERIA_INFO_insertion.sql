CREATE procedure  [dbo].[sp_STUDY_CRITERIA_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_FORMAT nvarchar(50),
          @DEFINITION_STATUS  char(2) 
   
   
   
     as  begin
   
  
   
     insert into STUDY_CRITERIA_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_FORMAT,        
        @DEFINITION_STATUS
        
     
     )
     
end