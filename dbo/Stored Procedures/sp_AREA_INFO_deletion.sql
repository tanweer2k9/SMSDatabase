CREATE PROCEDURE  [dbo].[sp_AREA_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @AREA_ID  numeric,
          @AREA_HD_ID  numeric,
          @AREA_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update AREA_INFO
	 set AREA_STATUS = 'D'
 
 
     where 
          AREA_ID =  @AREA_ID 
 
end