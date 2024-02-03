CREATE procedure  [dbo].[sp_STAFF_ALLOWANCE_insertion_updation]                                               
                                               
          
          @STAFF_ALLOWANCE_HD_ID  numeric,
          @STAFF_ALLOWANCE_BR_ID  numeric,
          @STAFF_ALLOWANCE_ALLOW_ID  numeric,
          @STAFF_ALLOWANCE_VAL_TYPE  nvarchar(100) ,
          @STAFF_ALLOWANCE_TYPE  nvarchar(100) ,
          @STAFF_ALLOWANCE_MONTHS  nvarchar(100) ,
          @STAFF_ALLOWANCE_AMOUNT  float,
          @STAFF_ALLOWANCE_STAFF_ID  numeric,
          @STAFF_ALLOWANCE_DATE  datetime,
          @STAFF_ALLOWANCE_STATUS  char(2) 
   
   
     as begin 

	 declare @count int = 0
	 set @count = (select count(*) from STAFF_ALLOWANCE where STAFF_ALLOWANCE_ALLOW_ID = @STAFF_ALLOWANCE_ALLOW_ID and STAFF_ALLOWANCE_STAFF_ID = @STAFF_ALLOWANCE_STAFF_ID)
   
   if @count = 0
   begin
		     insert into STAFF_ALLOWANCE
			 values
			 (
				@STAFF_ALLOWANCE_HD_ID,
				@STAFF_ALLOWANCE_BR_ID,
				@STAFF_ALLOWANCE_ALLOW_ID,
				@STAFF_ALLOWANCE_VAL_TYPE,
				@STAFF_ALLOWANCE_TYPE,
				@STAFF_ALLOWANCE_MONTHS,
				@STAFF_ALLOWANCE_AMOUNT,
				@STAFF_ALLOWANCE_STAFF_ID,
				@STAFF_ALLOWANCE_DATE,
				@STAFF_ALLOWANCE_STATUS
     
     
			 )

   end
   else
   begin
		 update STAFF_ALLOWANCE
 
		 set          
			  STAFF_ALLOWANCE_VAL_TYPE =  @STAFF_ALLOWANCE_VAL_TYPE,
			  STAFF_ALLOWANCE_TYPE =  @STAFF_ALLOWANCE_TYPE,
			  STAFF_ALLOWANCE_MONTHS =  @STAFF_ALLOWANCE_MONTHS,
			  STAFF_ALLOWANCE_AMOUNT =  @STAFF_ALLOWANCE_AMOUNT,
			  STAFF_ALLOWANCE_STAFF_ID =  @STAFF_ALLOWANCE_STAFF_ID,
			  STAFF_ALLOWANCE_DATE =  @STAFF_ALLOWANCE_DATE,
			  STAFF_ALLOWANCE_STATUS =  @STAFF_ALLOWANCE_STATUS
 
		 where 
			STAFF_ALLOWANCE_ALLOW_ID = @STAFF_ALLOWANCE_ALLOW_ID and STAFF_ALLOWANCE_STAFF_ID = @STAFF_ALLOWANCE_STAFF_ID

	end
end