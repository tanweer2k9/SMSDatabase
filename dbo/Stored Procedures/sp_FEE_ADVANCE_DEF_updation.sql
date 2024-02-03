create procedure  [dbo].[sp_FEE_ADVANCE_DEF_updation]
                                               
                                               
          @ADV_FEE_DEF_ID  numeric,
          @ADV_FEE_DEF_PID  numeric,
          @ADV_FEE_DEF_FROM_DATE  date,
          @ADV_FEE_DEF_TO_DATE  date,
          @ADV_FEE_DEF_AMOUNT  float,
          @ADV_FEE_DEF_ADJUST_DATE  date,
          @ADV_FEE_DEF_STATUS  char(2) 
   
   
     as begin 
   
   
     update FEE_ADVANCE_DEF
 
     set
          ADV_FEE_DEF_PID =  @ADV_FEE_DEF_PID,
          ADV_FEE_DEF_FROM_DATE =  @ADV_FEE_DEF_FROM_DATE,
          ADV_FEE_DEF_TO_DATE =  @ADV_FEE_DEF_TO_DATE,
          ADV_FEE_DEF_AMOUNT =  @ADV_FEE_DEF_AMOUNT,
          ADV_FEE_DEF_ADJUST_DATE =  @ADV_FEE_DEF_ADJUST_DATE,
          ADV_FEE_DEF_STATUS =  @ADV_FEE_DEF_STATUS
 
     where 
          ADV_FEE_DEF_ID =  @ADV_FEE_DEF_ID 
 
end