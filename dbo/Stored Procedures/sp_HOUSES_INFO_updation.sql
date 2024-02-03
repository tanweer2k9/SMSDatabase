create procedure  [dbo].[sp_HOUSES_INFO_updation]
                                               
                                               
          @HOUSES_ID  numeric,
          @HOUSES_HD_ID  numeric,
          @HOUSES_BR_ID  numeric,
          @HOUSES_NAME  nvarchar(50) ,
          @HOUSES_DESC  nvarchar(500) ,
          @HOUSES_STATUS  char(2) 
   
   
     as begin 
   
   
     update HOUSES_INFO
 
     set
          HOUSES_NAME =  @HOUSES_NAME,
          HOUSES_DESC =  @HOUSES_DESC,
          HOUSES_STATUS =  @HOUSES_STATUS
 
     where 
          HOUSES_ID =  @HOUSES_ID and 
          HOUSES_HD_ID =  @HOUSES_HD_ID and 
          HOUSES_BR_ID =  @HOUSES_BR_ID 
 
end