
CREATE procedure  [dbo].[sp_DEPARTMENT_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) ,
		  @DEFINITION_RANK int
   
   
   
     as  begin
   
  
   
     insert into DEPARTMENT_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS,
		@DEFINITION_RANK
     
     
     )
     
end