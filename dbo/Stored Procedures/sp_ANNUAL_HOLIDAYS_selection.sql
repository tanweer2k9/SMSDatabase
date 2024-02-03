--     *****************************************************************************************************************************************************************
   CREATE procedure  [dbo].[sp_ANNUAL_HOLIDAYS_selection]
                                               
                                               
     @STATUS char(10),
     @ANN_HOLI_ID  numeric,
     @ANN_HOLI_HD_ID  numeric,
     @ANN_HOLI_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     
  SELECT ANN_HOLI_ID as ID, ANN_HOLI_NAME as Name, ANN_HOLI_DATE as [Date], ANN_HOLI_STATUS as [Status] FROM ANNUAL_HOLIDAYS
 
 
     WHERE      
     ANN_HOLI_HD_ID =  @ANN_HOLI_HD_ID and 
     ANN_HOLI_BR_ID =  @ANN_HOLI_BR_ID and
     ANN_HOLI_STATUS != 'D'
 
     END
 
     END