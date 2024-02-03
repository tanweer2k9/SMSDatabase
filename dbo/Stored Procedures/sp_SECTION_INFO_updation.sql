create procedure  [dbo].[sp_SECTION_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
   
     update SECTION_INFO
 
     set
         
         SECT_HD_ID =  @DEFINITION_HD_ID,
         SECT_NAME =  @DEFINITION_NAME,
          SECT_DESC =  @DEFINITION_DESC,
          SECT_STATUS =  @DEFINITION_STATUS
 
 where 
 
	SECT_ID = @DEFINITION_ID
 
 
end