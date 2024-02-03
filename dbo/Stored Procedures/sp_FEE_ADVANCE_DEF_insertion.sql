
CREATE procedure  [dbo].[sp_FEE_ADVANCE_DEF_insertion]
                                               
                                               
          @ADV_FEE_DEF_PID  numeric,
          @ADV_FEE_DEF_FROM_DATE  date,
          @ADV_FEE_DEF_TO_DATE  date,
          @ADV_FEE_DEF_AMOUNT  float,
          @ADV_FEE_DEF_ADJUST_DATE  date,
		  @ADV_FEE_DEF_FEE_COLLECT_ID numeric,
          @ADV_FEE_DEF_STATUS  char(2) 
   
   
     as  begin
   
   
	--if @ADV_FEE_DEF_PID = 0
	--begin
	--	set @ADV_FEE_DEF_PID = (select MAX(ID) from VFEE_ADVANCE) 
	--end

   
     insert into FEE_ADVANCE_DEF
     values
     (
        @ADV_FEE_DEF_PID,
        @ADV_FEE_DEF_FROM_DATE,
        @ADV_FEE_DEF_TO_DATE,
        @ADV_FEE_DEF_AMOUNT,
        @ADV_FEE_DEF_ADJUST_DATE,
		@ADV_FEE_DEF_FEE_COLLECT_ID,
        @ADV_FEE_DEF_STATUS
     
     
     )
     
end