
     CREATE procedure  [dbo].[sp_LEAVES_RECORD_insertion]
                                               
                                               
          @LEAVES_RECORD_HD_ID  numeric,
          @LEAVES_RECORD_BR_ID  numeric,
          @LEAVES_RECORD_STAFF_ID  numeric,
          @LEAVES_RECORD_FROM_DATE  date,
          @LEAVES_RECORD_TO_DATE  date,
          @LEAVES_RECORD_IS_CAUSAL_LEAVES  bit,
          @LEAVES_RECORD_IS_ANNUAL_LEAVES  bit,
		  @LEAVES_RECORD_REASON  nvarchar(500)
   
   
     as  begin
   
   
     insert into LEAVES_RECORD
     values
     (
        @LEAVES_RECORD_HD_ID,
        @LEAVES_RECORD_BR_ID,
        @LEAVES_RECORD_STAFF_ID,
        @LEAVES_RECORD_FROM_DATE,
        @LEAVES_RECORD_TO_DATE,
        @LEAVES_RECORD_IS_CAUSAL_LEAVES,
        @LEAVES_RECORD_IS_ANNUAL_LEAVES,
		@LEAVES_RECORD_REASON
     
     
     )
     
end