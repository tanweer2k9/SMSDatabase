CREATE procedure  [dbo].[sp_RELIGION_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update RELIGION_INFO
 
     set
         
          RELIGION_NAME =  @DEFINITION_NAME,
          RELIGION_DESC =  @DEFINITION_DESC,
          RELIGION_STATUS =  @DEFINITION_STATUS
 
 where 
 
	RELIGION_ID = @DEFINITION_ID
 
 
end