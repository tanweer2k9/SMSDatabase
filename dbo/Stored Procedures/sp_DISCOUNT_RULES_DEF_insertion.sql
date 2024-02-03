create procedure  [dbo].[sp_DISCOUNT_RULES_DEF_insertion]
                                               
                                               
          @DIS_RUL_DEF_PID  numeric,
          @DIS_RUL_DEF_FEE_ID  numeric,
          @DIS_RUL_DEF_DISCOUNT  float,
          @DIS_RUL_DEF_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into DISCOUNT_RULES_DEF
     values
     (
        @DIS_RUL_DEF_PID,
        @DIS_RUL_DEF_FEE_ID,
        @DIS_RUL_DEF_DISCOUNT,
        @DIS_RUL_DEF_STATUS
     
     
     )
     
end