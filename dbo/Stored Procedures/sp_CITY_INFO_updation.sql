create procedure  [dbo].[sp_CITY_INFO_updation]
                                               
                                               
          @CITY_ID  numeric,
          @CITY_HD_ID  numeric,
          @CITY_BR_ID  numeric,
          @CITY_NAME  nvarchar(50) ,
          @CITY_DESC  nvarchar(500) ,
          @CITY_STATUS  char(2) 
   
   
     as begin 
   
   
     update CITY_INFO
 
     set
          CITY_NAME =  @CITY_NAME,
          CITY_DESC =  @CITY_DESC,
          CITY_STATUS =  @CITY_STATUS
 
     where 
          CITY_ID =  @CITY_ID and 
          CITY_HD_ID =  @CITY_HD_ID and 
          CITY_BR_ID =  @CITY_BR_ID 
 
end