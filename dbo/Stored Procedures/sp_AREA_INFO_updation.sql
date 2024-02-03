create procedure  [dbo].[sp_AREA_INFO_updation]
                                               
                                               
          @AREA_ID  numeric,
          @AREA_HD_ID  numeric,
          @AREA_BR_ID  numeric,
          @AREA_NAME  nvarchar(50) ,
          @AREA_DESC  nvarchar(500) ,
          @AREA_STATUS  char(2) 
   
   
     as begin 
   
   
     update AREA_INFO
 
     set
          AREA_NAME =  @AREA_NAME,
          AREA_DESC =  @AREA_DESC,
          AREA_STATUS =  @AREA_STATUS
 
     where 
          AREA_ID =  @AREA_ID and 
          AREA_HD_ID =  @AREA_HD_ID and 
          AREA_BR_ID =  @AREA_BR_ID 
 
end