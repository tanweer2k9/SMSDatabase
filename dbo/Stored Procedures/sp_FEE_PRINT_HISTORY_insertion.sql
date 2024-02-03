CREATE procedure  [dbo].[sp_FEE_PRINT_HISTORY_insertion]
                                    
          @FEE_PRINT_HISTORY_HD_ID  numeric,
          @FEE_PRINT_HISTORY_BR_ID  numeric,
          @FEE_PRINT_HISTORY_BILL_ID  numeric,
          @FEE_PRINT_HISTORY_DATE  datetime,
          @FEE_PRINT_HISTORY_INSERTED_BY_ID  numeric,
          @FEE_PRINT_HISTORY_INSERTED_BY_TYPE  nvarchar(50) ,
          @FEE_PRINT_HISTORY_STATUS  char(2) 

AS BEGIN

DECLARE @FEE_PRINT_HISTORY_STATUS2 BIT = (select FEE_SETTING_REPRINT_HISTORY from FEE_SETTING where FEE_SETTING_HD_ID = @FEE_PRINT_HISTORY_HD_ID and FEE_SETTING_BR_ID = @FEE_PRINT_HISTORY_BR_ID )

declare @count int = 0
declare @fee_print_id numeric = 0
		select @count = COUNT(*) from FEE_COLLECT_DEF fd join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME where f.FEE_HD_ID = @FEE_PRINT_HISTORY_HD_ID and f.FEE_BR_ID = @FEE_PRINT_HISTORY_BR_ID and f.FEE_NAME = 'Reprinting Charges' and fd.FEE_COLLECT_DEF_PID = @FEE_PRINT_HISTORY_BILL_ID

		

		if @count = 0
		BEGIN
			set @fee_print_id = (select f.FEE_ID from FEE_INFO f where f.FEE_BR_ID = @FEE_PRINT_HISTORY_BR_ID and f.FEE_NAME = 'Reprinting Charges')
			insert into FEE_COLLECT_DEF
			select @FEE_PRINT_HISTORY_BILL_ID, @fee_print_id,0,0,0,0,'R','+',0,0,0,0,0,0,0
			declare @VCH_reference_no nvarchar(50) = ''
			declare @datetime datetime = ''
			declare @HD_ID nvarchar(50) = ''
			declare @BR_ID nvarchar(50) = ''
			declare @VCH_DEF_COA nvarchar(50) = ''
			declare @VCH_MAIN_ID nvarchar(50) = ''
			
			select @VCH_MAIN_ID = VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST(@FEE_PRINT_HISTORY_BILL_ID as nvarchar(50))
			select top(1) @VCH_DEF_COA =  COA_UID from TBL_COA where BRC_ID = 1 and COA_isDeleted = 0 and COA_Name = 'Reprinting Charges'
			set @datetime = GETDATE()
						set @VCH_reference_no = CAST((@fee_print_id) as nvarchar(50))
						set @HD_ID = CAST((@FEE_PRINT_HISTORY_HD_ID) as nvarchar(50))
						set @BR_ID = CAST((@FEE_PRINT_HISTORY_BR_ID) as nvarchar(50))						
						exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,0,0,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID, @BR_ID,0,1,''
		END

		declare @amount float = 0
		set @amount = (select ISNULL( [Reprinting Charges],0) from VFEE_SETTING where [Institute ID] = @FEE_PRINT_HISTORY_HD_ID and [Branch ID] = @FEE_PRINT_HISTORY_BR_ID)
		declare @std_id numeric = 0
		set @std_id = (select FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_PRINT_HISTORY_BILL_ID)
		 exec sp_FEE_COLLECT_ACCOUNTS_UPDATE_FEE_WITH_ACCOUNTS @FEE_PRINT_HISTORY_BILL_ID,@amount ,@FEE_PRINT_HISTORY_BR_ID,@std_id,'Reprinting Charges'

		--ELSE
		--BEGIN
		--	update FEE_COLLECT_DEF 
		--	set
		--	FEE_COLLECT_DEF_FEE = FEE_COLLECT_DEF_FEE + ( select ISNULL( [Reprinting Charges],0) from VFEE_SETTING where [Institute ID] = @FEE_PRINT_HISTORY_HD_ID and [Branch ID] = @FEE_PRINT_HISTORY_BR_ID )
		--	where FEE_COLLECT_DEF_PID = @FEE_PRINT_HISTORY_BILL_ID
		--	and FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = 'Reprinting Charges' and FEE_HD_ID = @FEE_PRINT_HISTORY_HD_ID and FEE_BR_ID = @FEE_PRINT_HISTORY_BR_ID)
		--END
	

if @FEE_PRINT_HISTORY_STATUS2 = 1
	begin
						
		INSERT INTO [FEE_PRINT_HISTORY]
		           
			VALUES
				   (
					@FEE_PRINT_HISTORY_HD_ID,
					@FEE_PRINT_HISTORY_BR_ID,
					@FEE_PRINT_HISTORY_BILL_ID,
					@FEE_PRINT_HISTORY_DATE,
					@FEE_PRINT_HISTORY_INSERTED_BY_ID,
					@FEE_PRINT_HISTORY_INSERTED_BY_TYPE,
					@FEE_PRINT_HISTORY_STATUS
				   )				
				
	End


	select 'ok'

END