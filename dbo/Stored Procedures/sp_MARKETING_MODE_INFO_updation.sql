CREATE procedure  [dbo].[sp_MARKETING_MODE_INFO_updation]
                                               
                                               
          @MODE_ID  numeric,
          @MODE_HD_ID  numeric,
          @MODE_BR_ID  numeric,
          @MODE_NAME  nvarchar(50) ,
          @MODE_DESCRIPTION  nvarchar(200) ,
          @MODE_STATUS  char(2) 
   
   
     as begin 
   
   
     update MARKETING_MODE_INFO
 
     set
          MODE_NAME =  @MODE_NAME,
          MODE_DESCRIPTION =  @MODE_DESCRIPTION,
          MODE_STATUS =  @MODE_STATUS
 
     where 
          MODE_ID =  @MODE_ID  
 
end