create procedure  [dbo].[sp_ANNUAL_HOLIDAYS_updation]
                                               
                                               
          @ANN_HOLI_ID  numeric,
          @ANN_HOLI_HD_ID  numeric,
          @ANN_HOLI_BR_ID  numeric,
          @ANN_HOLI_NAME  nvarchar(200) ,
          @ANN_HOLI_DATE  date,
          @ANN_HOLI_STATUS  nvarchar(10) 
   
   
     as begin 
   
   
     update ANNUAL_HOLIDAYS
 
     set
          ANN_HOLI_NAME =  @ANN_HOLI_NAME,
          ANN_HOLI_DATE =  @ANN_HOLI_DATE,
          ANN_HOLI_STATUS =  @ANN_HOLI_STATUS
 
     where 
          ANN_HOLI_ID =  @ANN_HOLI_ID and 
          ANN_HOLI_HD_ID =  @ANN_HOLI_HD_ID and 
          ANN_HOLI_BR_ID =  @ANN_HOLI_BR_ID 
 
end