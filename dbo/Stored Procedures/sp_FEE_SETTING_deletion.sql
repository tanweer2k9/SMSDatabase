CREATE PROCEDURE  [dbo].[sp_FEE_SETTING_deletion]
                                               
                                               
          @STATUS char(10),
          @FEE_SETTING_ID  numeric,
          @FEE_SETTING_HD_ID  numeric,
          @FEE_SETTING_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from FEE_SETTING
 
 
     where 
          FEE_SETTING_ID =  @FEE_SETTING_ID and 
          FEE_SETTING_HD_ID =  @FEE_SETTING_HD_ID and 
          FEE_SETTING_BR_ID =  @FEE_SETTING_BR_ID 
 
end