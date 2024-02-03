CREATE PROCEDURE  [dbo].[sp_CITY_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @CITY_ID  numeric,
          @CITY_HD_ID  numeric,
          @CITY_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from CITY_INFO
 
 
     where 
          CITY_ID =  @CITY_ID  
       
 
end