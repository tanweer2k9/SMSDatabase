CREATE procedure  [dbo].[sp_ASSESSMENT_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update ASSESSMENT_INFO
 
     set
         
          ASSESSMENT_NAME =  @DEFINITION_NAME,
          ASSESSMENT_DESC =  @DEFINITION_DESC,
          ASSESSMENT_STATUS =  @DEFINITION_STATUS
 
 where 
 
	ASSESSMENT_ID = @DEFINITION_ID
 
 
end