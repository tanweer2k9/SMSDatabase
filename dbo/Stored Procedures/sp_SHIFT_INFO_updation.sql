create procedure  [dbo].[sp_SHIFT_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
   
     update SHIFT_INFO
 
     set
         
       SHFT_HD_ID =  @DEFINITION_HD_ID,
        SHFT_NAME =  @DEFINITION_NAME,
          SHFT_DESC =  @DEFINITION_DESC,
          SHFT_STATUS =  @DEFINITION_STATUS
 
 where 
 
	SHFT_ID = @DEFINITION_ID
 
 
end