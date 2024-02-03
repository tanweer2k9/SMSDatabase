CREATE procedure  [dbo].[sp_DOC_NAME_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update DOC_NAME_INFO
 
     set
         
          DOC_NAME_NAME =  @DEFINITION_NAME,
          DOC_NAME_DESC =  @DEFINITION_DESC,
          DOC_NAME_STATUS =  @DEFINITION_STATUS
 
 where 
 
	DOC_NAME_ID = @DEFINITION_ID
 
 
end