create procedure  [dbo].[sp_CONDUCT_INFO_updation]
                                               
                                               
          @CONDUCT_ID  numeric,
          @CONDUCT_HD_ID  numeric,
          @CONDUCT_BR_ID  numeric,
          @CONDUCT_NAME  nvarchar(50) ,
          @CONDUCT_DESC  nvarchar(500) ,
          @CONDUCT_STATUS  char(2) 
   
   
     as begin 
   
   
     update CONDUCT_INFO
 
     set
          CONDUCT_NAME =  @CONDUCT_NAME,
          CONDUCT_DESC =  @CONDUCT_DESC,
          CONDUCT_STATUS =  @CONDUCT_STATUS
 
     where 
          CONDUCT_ID =  @CONDUCT_ID and 
          CONDUCT_HD_ID =  @CONDUCT_HD_ID and 
          CONDUCT_BR_ID =  @CONDUCT_BR_ID 
 
end