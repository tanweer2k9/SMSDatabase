CREATE procedure  [dbo].[sp_LANG_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update LANG_INFO
 
     set
         
          LANG_NAME =  @DEFINITION_NAME,
          LANG_DESC =  @DEFINITION_DESC,
          LANG_STATUS =  @DEFINITION_STATUS
 
 where 
 
	LANG_ID = @DEFINITION_ID
 
 
end