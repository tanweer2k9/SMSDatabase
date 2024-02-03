CREATE procedure  [dbo].[sp_GRADE_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(500) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as  begin
   
  
   
     insert into GRADE_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS
     
     )
     
end