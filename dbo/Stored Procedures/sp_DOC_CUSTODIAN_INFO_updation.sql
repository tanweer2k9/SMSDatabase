CREATE procedure  [dbo].[sp_DOC_CUSTODIAN_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update DOC_CUSTODIAN_INFO
 
     set
         
          DOC_CUSTODIAN_NAME =  @DEFINITION_NAME,
          DOC_CUSTODIAN_DESC =  @DEFINITION_DESC,
          DOC_CUSTODIAN_STATUS =  @DEFINITION_STATUS
 
 where 
 
	DOC_CUSTODIAN_ID = @DEFINITION_ID
 
 
end