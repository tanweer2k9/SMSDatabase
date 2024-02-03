CREATE procedure  [dbo].[sp_GRADE_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update GRADE_INFO
 
     set
         
          GRADE_NAME =  @DEFINITION_NAME,
          GRADE_DESC =  @DEFINITION_DESC,
          GRADE_STATUS =  @DEFINITION_STATUS
 
 where 
 
	GRADE_ID = @DEFINITION_ID
 
 
end