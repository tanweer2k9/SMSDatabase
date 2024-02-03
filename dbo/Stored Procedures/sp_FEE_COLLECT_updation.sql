



CREATE procedure  [dbo].[sp_FEE_COLLECT_updation]                                                                                              
          @FEE_COLLECT_ID  numeric,
          @FEE_COLLECT_HD_ID  numeric,
          @FEE_COLLECT_BR_ID  numeric,          
          @FEE_COLLECT_FEE_PAID  float,          
          @FEE_COLLECT_DATE  date,
          @FEE_COLLECT_FEE_STATUS  nvarchar(50),
          @FEE_COLLECT_ARREARS_RECEIVED float,
          @FEE_COLLECT_FEE float,
          @FEE_COLLECT_ARREARS float,
          @FEE_COLLECT_NET_TOATAL float,
          @FEE_COLLECT_LATE_FEE_STATUS char(2),
		  @FEE_CASH_IN_HAND_AMOUNT float,
		  @FEE_CASH_AT_BANK_AMOUNT float,
		  @FEE_CASH_IN_HAND_CODE nvarchar(50),
		  @FEE_CASH_AT_BANK_CODE nvarchar(50),
		  @FEE_COLLECT_CHEQUE_NO nvarchar(50),
		  @FEE_COLLECT_CHEQUE_DATE date,
		  @FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT float,
		  @VCH_chequeClearanceDate date,
		  @VCH_chequeBankName nvarchar(50),
		  @VOUCHER_DATE date,
		  @IS_ALL_MULTIPLE_CASH_DELETED bit,
		  @PAYMENT_MODE nvarchar(100)
   
     as begin 
		declare @acc_start_date date
		declare @acc_end_date date
		declare @student_id numeric

		declare @FEE_COLLECT_PLAN_ID numeric = 0
		declare @acc_fee_invoice_periods nvarchar(100)= 'Fee Invoice Periods'
		declare @fee_months_coa_name nvarchar(100)= ''
		declare @FEE_COLLECT_FEE_FROM_DATE date = ''
		declare @FEE_COLLECT_FEE_TO_DATE date = ''
		declare @datetime datetime = ''
		declare @HD_ID nvarchar(50) = ''
		declare @BR_ID nvarchar(50) = ''


		declare @acc_total_fee float = 0
		declare @one int = 1

		declare @fee_history bit = (select top(@one) BR_ADM_FEE_HISTORY from FEE_SETTING where FEE_SETTING_HD_ID = @FEE_COLLECT_HD_ID and FEE_SETTING_BR_ID = @FEE_COLLECT_BR_ID)
		
		if @IS_ALL_MULTIPLE_CASH_DELETED = 1
		BEGIN
			delete from FEE_MULTIPLE_RECEIVED_AMOUNT where MULTI_RECEIVE_INVOICE_ID = @FEE_COLLECT_ID
		END


 
		  if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
		  BEGIN	
			update TBL_VCH_MAIN set VCH_chequeNo = @FEE_COLLECT_CHEQUE_NO, VCH_date = @FEE_COLLECT_DATE,
			VCH_chequeClearanceDate = @VCH_chequeClearanceDate, VCH_chequeBankName = @VCH_chequeBankName	
			where VCH_referenceNo = CAST(@FEE_COLLECT_ID as nvarchar(50))
		  END
    
	--declare @payment_mode nvarchar(50)= 'Cash in Hand'

	--if @FEE_CASH_IN_HAND_AMOUNT = 0
	--BEGIN
	--	set @payment_mode = 'Cash at Bank'
	--END

	declare @Fee_Collect_Fee_Old float = 0

	select @Fee_Collect_Fee_Old = FEE_COLLECT_FEE from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID

	if @Fee_Collect_Fee_Old != @FEE_COLLECT_FEE
	BEGIN
		exec sp_FEE_COLLECT_Royalty_Calulation @FEE_COLLECT_ID,@FEE_COLLECT_BR_ID
	END

	update FEE_COLLECT 
     set   
		  FEE_COLLECT_FEE = @FEE_COLLECT_FEE,
          FEE_COLLECT_FEE_PAID = @FEE_COLLECT_FEE_PAID,
          FEE_COLLECT_ARREARS = @FEE_COLLECT_ARREARS,
          FEE_COLLECT_ARREARS_RECEIVED = @FEE_COLLECT_ARREARS_RECEIVED,
          FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,
          FEE_COLLECT_FEE_STATUS = @FEE_COLLECT_FEE_STATUS,
          FEE_COLLECT_NET_TOATAL = @FEE_COLLECT_NET_TOATAL,
          FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS,
		  FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT,
		  FEE_COLLECT_PAYMENT_MODE = @payment_mode
		
     where 
          FEE_COLLECT_ID =  @FEE_COLLECT_ID 
  
				SET @acc_start_date = (select top(1) [Start Date] from V_BRANCH_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and ID = @FEE_COLLECT_BR_ID ) 
				SET @acc_end_date = (select top(1) [End Date] from V_BRANCH_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and ID = @FEE_COLLECT_BR_ID ) 
				SET @student_id = ( select top(1) FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID )
				

		  if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
		  BEGIN	
			
				exec sp_FEE_COLLLECT_DEFINATION_UPDATION_IN_ACCOUNT_INSERTION @FEE_COLLECT_ID

				--accouts insertion 
				EXEC sp_FEE_COLLECTION_updation_ACCOUNTS_INSERTION @FEE_COLLECT_ID,	@FEE_CASH_IN_HAND_AMOUNT,  @FEE_CASH_AT_BANK_AMOUNT , @FEE_CASH_IN_HAND_CODE ,@FEE_CASH_AT_BANK_CODE
		  END



		  if @FEE_COLLECT_BR_ID = 8 --This is only for gardian town of only june receiving july automatically remove arrears becuase they have generate june july fees together and in the bank we only receive complete amount
		  BEGIN
			  declare @date date ='' , @std_id numeric = 0, @prev_fee_id numeric = 0
			  select top(1) @date =  FEE_COLLECT_FEE_FROM_DATE, @std_id = FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID

			  if @date between '2019-06-01' and '2019-06-30'
			  BEGIN
				select top(1) @prev_fee_id = FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @std_id and FEE_COLLECT_FEE_FROM_DATE between '2019-07-01' and '2019-07-31'
				if @FEE_COLLECT_FEE = @FEE_COLLECT_FEE_PAID
				BEGIN
					update FEE_COLLECT set FEE_COLLECT_ARREARS = 0, FEE_COLLECT_NET_TOATAL = FEE_COLLECT_NET_TOATAL - FEE_COLLECT_ARREARS where FEE_COLLECT_ID  = @prev_fee_id
					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS = 0, FEE_COLLECT_DEF_TOTAL = FEE_COLLECT_DEF_TOTAL - FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_OPERATION = '+' and FEE_COLLECT_DEF_PID = @prev_fee_id
				END

			  END 

		  END







          
 
  if @fee_history   = 1
  begin
  
  declare @fee_history_id numeric = 0	
  declare @fee_history_date date = ''
  declare @comma nvarchar(5) = ''
  declare @fee_history_previous_date nvarchar(2000) = ''
	select @fee_history_id = ISNULL(FEE_HISTORY_ID,0), @fee_history_date = ISNULL(FEE_HISTORY_DATE,''), @fee_history_previous_date = ISNULL(FEE_HISTORY_PREVIOUS_DATE,'') from
	(select top(1) * from FEE_HISTORY where FEE_HISTORY_PID = @FEE_COLLECT_ID and FEE_HISTORY_FEE = @FEE_COLLECT_FEE
	and FEE_HISTORY_PAID = @FEE_COLLECT_FEE_PAID and FEE_HISTORY_STATUS = @FEE_COLLECT_FEE_STATUS and FEE_HISTORY_ARREARS = @FEE_COLLECT_ARREARS
	and FEE_HISTORY_NET_TOTAL = @FEE_COLLECT_NET_TOATAL and FEE_HISTORY_ARREARS_RECEIVED = @FEE_COLLECT_ARREARS_RECEIVED order by FEE_HISTORY_ID DESC) A
	
	if @fee_history_previous_date != ''
		set @comma = ', '
		
	if @fee_history_id = 0
		begin
		
		 INSERT INTO FEE_HISTORY							         
			 VALUES
				   (
					@FEE_COLLECT_ID
				   ,@FEE_COLLECT_FEE
				   ,@FEE_COLLECT_FEE_PAID
				   ,@FEE_COLLECT_DATE
				   ,@FEE_COLLECT_FEE_STATUS
				   ,@FEE_COLLECT_ARREARS
				   ,@FEE_COLLECT_NET_TOATAL
				   ,@FEE_COLLECT_ARREARS_RECEIVED,
				   '1900-01-01'
				   )	
		end
		
	else
		--if @fee_history_previous_date != ''
		--	set @fee_history_previous_date = CONVERT(VARCHAR(20),@fee_history_previous_date,20) 
		
		update FEE_HISTORY set FEE_HISTORY_DATE = @FEE_COLLECT_DATE,  FEE_HISTORY_PREVIOUS_DATE =  CONVERT(VARCHAR(20),@fee_history_date,20) + @comma + @fee_history_previous_date
		where FEE_HISTORY_ID = @fee_history_id
		
  end
 

end