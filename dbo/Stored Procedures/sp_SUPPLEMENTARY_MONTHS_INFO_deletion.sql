CREATE PROCEDURE  [dbo].[sp_SUPPLEMENTARY_MONTHS_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SUPL_MONTH_ID  numeric,
          @SUPL_MONTH_HD_ID  numeric,
          @SUPL_MONTH_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from SUPPLEMENTARY_MONTHS_INFO
 
 
     where 
          SUPL_MONTH_ID =  @SUPL_MONTH_ID  
        
 
end