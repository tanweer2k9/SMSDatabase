
CREATE procedure  [dbo].[sp_DEPARTMENT_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2),
		  @DEFINITION_RANK int 
   
   
   
     as begin 
   
   
     update DEPARTMENT_INFO
 
     set
         
          DEP_NAME =  @DEFINITION_NAME,
          DEP_DESC =  @DEFINITION_DESC,
          DEP_STATUS =  @DEFINITION_STATUS,
		  DEP_RANK = @DEFINITION_RANK
 
 where 
 
	DEP_ID = @DEFINITION_ID
 
 
end