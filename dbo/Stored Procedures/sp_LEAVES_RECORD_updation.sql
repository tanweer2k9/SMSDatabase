 
     CREATE procedure  [dbo].[sp_LEAVES_RECORD_updation]
                                               
                                               
          @LEAVES_RECORD_ID  numeric,
          @LEAVES_RECORD_HD_ID  numeric,
          @LEAVES_RECORD_BR_ID  numeric,
          @LEAVES_RECORD_STAFF_ID  numeric,
          @LEAVES_RECORD_FROM_DATE  date,
          @LEAVES_RECORD_TO_DATE  date,
          @LEAVES_RECORD_IS_CAUSAL_LEAVES  bit,
          @LEAVES_RECORD_IS_ANNUAL_LEAVES  bit,
		  @LEAVES_RECORD_REASON  nvarchar(500)
   
   
     as begin 
   
   
     update LEAVES_RECORD
 
     set
          LEAVES_RECORD_STAFF_ID =  @LEAVES_RECORD_STAFF_ID,
          LEAVES_RECORD_FROM_DATE =  @LEAVES_RECORD_FROM_DATE,
          LEAVES_RECORD_TO_DATE =  @LEAVES_RECORD_TO_DATE,
          LEAVES_RECORD_IS_CAUSAL_LEAVES =  @LEAVES_RECORD_IS_CAUSAL_LEAVES,
          LEAVES_RECORD_IS_ANNUAL_LEAVES =  @LEAVES_RECORD_IS_ANNUAL_LEAVES,
		  LEAVES_RECORD_REASON = @LEAVES_RECORD_REASON
 
     where 
          LEAVES_RECORD_ID =  @LEAVES_RECORD_ID 
 
end