create procedure  [dbo].[sp_FEE_ADVANCE_updation]
                                               
                                               
          @ADV_FEE_ID  numeric,
          @ADV_FEE_STD_ID  numeric,
          @ADV_FEE_FROM_DATE  date,
          @ADV_FEE_TO_DATE  date,
          @ADV_FEE_AMOUNT  float,
          @ADV_FEE_DATE  date,
          @ADV_FEE_STATUS  char(2) 
   
   
     as begin 
   
   
     update FEE_ADVANCE
 
     set
          ADV_FEE_STD_ID =  @ADV_FEE_STD_ID,
          ADV_FEE_FROM_DATE =  @ADV_FEE_FROM_DATE,
          ADV_FEE_TO_DATE =  @ADV_FEE_TO_DATE,
          ADV_FEE_AMOUNT =  @ADV_FEE_AMOUNT,
          ADV_FEE_DATE =  @ADV_FEE_DATE,
          ADV_FEE_STATUS =  @ADV_FEE_STATUS
 
     where 
          ADV_FEE_ID =  @ADV_FEE_ID 
 
end