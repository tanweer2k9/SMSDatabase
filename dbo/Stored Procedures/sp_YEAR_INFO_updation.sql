CREATE procedure  [dbo].[sp_YEAR_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update [YEAR_INFO]
 
     set
         
          YEAR_NAME =  @DEFINITION_NAME,
          YEAR_DESC =  @DEFINITION_DESC,
          YEAR_STATUS =  @DEFINITION_STATUS
 
 where 
 
	YEAR_ID = @DEFINITION_ID
 
 
end