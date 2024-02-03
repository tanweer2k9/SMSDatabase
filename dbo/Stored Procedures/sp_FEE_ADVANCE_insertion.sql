
CREATE procedure  [dbo].[sp_FEE_ADVANCE_insertion]
                                               
                                               
          @ADV_FEE_STD_ID  numeric,
          @ADV_FEE_FROM_DATE  date,
          @ADV_FEE_TO_DATE  date,
          @ADV_FEE_AMOUNT  float,
		  @ADV_FEE_AMOUNT_ADJUST float,
          @ADV_FEE_BANK_AMOUNT_NOT_CLEARED float,
		  @ADV_FEE_COLLECT_ID numeric,
		  @ADV_FEE_DESCRIPTION nvarchar(100),
		  @ADV_FEE_DATE  date,
          @ADV_FEE_STATUS  char(2) 
   
   
     as  begin
   
   
     insert into FEE_ADVANCE
     values
     (
        @ADV_FEE_STD_ID,
        @ADV_FEE_FROM_DATE,
        @ADV_FEE_TO_DATE,
        @ADV_FEE_AMOUNT,
		@ADV_FEE_AMOUNT_ADJUST,
		@ADV_FEE_BANK_AMOUNT_NOT_CLEARED,
		@ADV_FEE_COLLECT_ID,
		@ADV_FEE_DESCRIPTION,
        @ADV_FEE_DATE,
        @ADV_FEE_STATUS
     
     
     )
     

	 select SCOPE_IDENTITY()
end