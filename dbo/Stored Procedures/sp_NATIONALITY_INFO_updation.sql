create procedure  [dbo].[sp_NATIONALITY_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
   
     update NATIONALITY_INFO
 
     set
         
          NATIONALITY_HD_ID =  @DEFINITION_HD_ID,
          NATIONALITY_NAME =  @DEFINITION_NAME,
          NATIONALITY_DESC =  @DEFINITION_DESC,
          NATIONALITY_STATUS =  @DEFINITION_STATUS
 
 where 
 
	NATIONALITY_ID = @DEFINITION_ID
 
 
end