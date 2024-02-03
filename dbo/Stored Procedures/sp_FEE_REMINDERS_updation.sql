
CREATE procedure  [dbo].[sp_FEE_REMINDERS_updation]
                                               
                                               
          @FEE_REMIDNERS_ID  numeric,
          @FEE_REMIDNERS_HD_ID  numeric,
          @FEE_REMIDNERS_BR_ID  numeric,
          @FINAL_FEE_REMINDERS  nvarchar(max) ,
          @FEE_REMINDERS  nvarchar(max) ,
		  @WITHDRAWL_NOTICE  nvarchar(max) 
   
     as begin 
   
   
		declare @count int = 0

		set @count = (select COUNT(*) from FEE_REMINDERS where FEE_REMIDNERS_HD_ID = @FEE_REMIDNERS_HD_ID and FEE_REMIDNERS_BR_ID	= @FEE_REMIDNERS_BR_ID)


	if @count = 1
	BEGIN
     update FEE_REMINDERS
 
     set          
          FINAL_FEE_REMINDERS =  @FINAL_FEE_REMINDERS,
          FEE_REMINDERS =  @FEE_REMINDERS,
		  WITHDRAWL_NOTICE = @WITHDRAWL_NOTICE
 
     where 
          FEE_REMIDNERS_HD_ID =  @FEE_REMIDNERS_HD_ID and
		  FEE_REMIDNERS_BR_ID = @FEE_REMIDNERS_BR_ID

	END

	ELSE
	BEGIN
		insert into FEE_REMINDERS
		 values
		 (
			@FEE_REMIDNERS_HD_ID,
			@FEE_REMIDNERS_BR_ID,
			@FINAL_FEE_REMINDERS,
			@FEE_REMINDERS,
			@WITHDRAWL_NOTICE
		 )
	END
		  
 
end