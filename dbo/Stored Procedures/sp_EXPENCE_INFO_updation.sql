create procedure  [dbo].[sp_EXPENCE_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
   
     update EXPENCE_INFO
 
     set
         
          EXPENCE_HD_ID =  @DEFINITION_HD_ID,
          EXPENCE_NAME =  @DEFINITION_NAME,
          EXPENCE_DESC =  @DEFINITION_DESC,
          EXPENCE_STATUS =  @DEFINITION_STATUS
 
 where 
 
	EXPENCE_ID = @DEFINITION_ID
 
 
end