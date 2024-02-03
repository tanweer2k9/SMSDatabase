CREATE PROCEDURE  [dbo].[sp_SALES_REPRESENTATIVE_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @SALES_ID  numeric,
          @SALES_HD_ID  numeric,
          @SALES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
    update SALES_REPRESENTATIVE_INFO set SALES_STATUS = 'D'
 
 
     where 
          SALES_ID =  @SALES_ID 
 
end