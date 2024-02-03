CREATE procedure  [dbo].[sp_DATE_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update DATE_INFO
 
     set
         
          DATE_NAME =  @DEFINITION_NAME,
          DATE_FORMAT =  @DEFINITION_DESC,
          DATE_STATUS =  @DEFINITION_STATUS
 
 where 
 
	DATE_ID = @DEFINITION_ID
 
 
end