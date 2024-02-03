CREATE PROCEDURE  [dbo].[sp_ANNUAL_HOLIDAYS_deletion]
                                               
                                               
          @STATUS char(10),
          @ANN_HOLI_ID  numeric,
          @ANN_HOLI_HD_ID  numeric,
          @ANN_HOLI_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE ANNUAL_HOLIDAYS
     SET ANN_HOLI_STATUS = 'D'
 
 
     where 
          ANN_HOLI_ID =  @ANN_HOLI_ID and 
          ANN_HOLI_HD_ID =  @ANN_HOLI_HD_ID and 
          ANN_HOLI_BR_ID =  @ANN_HOLI_BR_ID 
 
end