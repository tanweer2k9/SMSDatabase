
CREATE procedure  [dbo].[sp_SHORT_LEAVE_insertion]
                                               
                                               
          @SHORT_LEAVE_STAFF_ID  numeric,
		  @SHORT_LEAVE_HD_ID  numeric,
		  @SHORT_LEAVE_BR_ID  numeric,
          @SHORT_LEAVE_DATE  date,
          @SHORT_LEAVE_FROM_TIME  nvarchar(100) ,
          @SHORT_LEAVE_TO_TIME  nvarchar(100) ,
          @SHORT_LEAVE_REASON  nvarchar(100) ,
          @SHORT_LEAVE_STATUS  char(2),
		  @SHORT_LEAVE_FROM_ANNUAL bit,
		  @SHORT_LEAVE_ID numeric 
   
   
     as  begin
   

   declare @count int = 0


   set @count = (select COUNT(*) from SHORT_LEAVE where SHORT_LEAVE_DATE = @SHORT_LEAVE_DATE and SHORT_LEAVE_STAFF_ID = @SHORT_LEAVE_STAFF_ID)
	

	if @count = 0
	begin

		 insert into SHORT_LEAVE
		 values
		 (
			@SHORT_LEAVE_HD_ID,
			@SHORT_LEAVE_BR_ID,
			@SHORT_LEAVE_STAFF_ID,			
			@SHORT_LEAVE_DATE,
			@SHORT_LEAVE_FROM_TIME,
			@SHORT_LEAVE_TO_TIME,
			@SHORT_LEAVE_REASON,
			@SHORT_LEAVE_STATUS,
			@SHORT_LEAVE_FROM_ANNUAL
		 )
	end

	else
	begin
		
	update SHORT_LEAVE 
     set
          SHORT_LEAVE_STAFF_ID =  @SHORT_LEAVE_STAFF_ID,
          SHORT_LEAVE_DATE =  @SHORT_LEAVE_DATE,
          SHORT_LEAVE_FROM_TIME =  @SHORT_LEAVE_FROM_TIME,
          SHORT_LEAVE_TO_TIME =  @SHORT_LEAVE_TO_TIME,
          SHORT_LEAVE_REASON =  @SHORT_LEAVE_REASON,
          SHORT_LEAVE_STATUS =  @SHORT_LEAVE_STATUS,
		  SHORT_LEAVE_IS_ANNUAL = @SHORT_LEAVE_FROM_ANNUAL

	where 
	SHORT_LEAVE_ID = @SHORT_LEAVE_ID
		--SHORT_LEAVE_DATE = @SHORT_LEAVE_DATE and SHORT_LEAVE_STAFF_ID = @SHORT_LEAVE_STAFF_ID
	end

     
end