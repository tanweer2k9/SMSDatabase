CREATE procedure  [dbo].[sp_INSTITUTION_LEVEL_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update INST_INFO
 
     set
         
          INST_NAME =  @DEFINITION_NAME,
          INST_DESC =  @DEFINITION_DESC,
          INST_STATUS =  @DEFINITION_STATUS
 
 where 
 
	INST_ID = @DEFINITION_ID
 
 
end