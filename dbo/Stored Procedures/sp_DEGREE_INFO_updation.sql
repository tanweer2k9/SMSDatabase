CREATE procedure  [dbo].[sp_DEGREE_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update DEGREE_INFO
 
     set
         
          DGRE_NAME =  @DEFINITION_NAME,
          DGRE_DESC =  @DEFINITION_DESC,
          DGRE_STATUS =  @DEFINITION_STATUS
 
 where 
 
	DGRE_ID = @DEFINITION_ID
 
 
end