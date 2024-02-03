CREATE PROCEDURE  [dbo].[sp_ROYALTY_FEE_SETTING_deletion]
                                               
                                               
          @STATUS char(10),
          @ROYALTY_ID  numeric,
          @ROYALTY_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from ROYALTY_FEE_SETTING
 
 
     where 
          ROYALTY_ID =  @ROYALTY_ID  
 
end