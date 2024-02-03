CREATE PROCEDURE  [dbo].[sp_OVETIME_ADVANCE_deletion]
                                               
                                               
          @STATUS char(10),
          @OVRTM_ADV_ID  numeric,
          @OVRTM_ADV_HD_ID  numeric,
          @OVRTM_ADV_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from OVETIME_ADVANCE
 
 
     where 
          OVRTM_ADV_ID =  @OVRTM_ADV_ID and 
          OVRTM_ADV_HD_ID =  @OVRTM_ADV_HD_ID and 
          OVRTM_ADV_BR_ID =  @OVRTM_ADV_BR_ID 
 
end