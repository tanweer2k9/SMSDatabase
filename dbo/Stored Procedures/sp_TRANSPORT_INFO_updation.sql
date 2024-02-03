create procedure  [dbo].[sp_TRANSPORT_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as begin 
   
   
     update TRANSPORT_INFO
 
     set
         
          TRANSPORT_HD_ID =  @DEFINITION_HD_ID,
          TRANSPORT_NAME =  @DEFINITION_NAME,
          TRANSPORT_DESC =  @DEFINITION_DESC,
          TRANSPORT_STATUS =  @DEFINITION_STATUS
 
 where 
 
	TRANSPORT_ID = @DEFINITION_ID
 
 
end