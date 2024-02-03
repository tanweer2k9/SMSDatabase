


CREATE procedure  [dbo].[sp_FEE_COLLECT_updation_multiple_cheques]                                                                                              
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
		  @CHEQUE_INFO_FEE_IDS nvarchar(200),
		  @DISCOUNT_AMOUNT float,
		  @IFL float,
		  @IS_ALL_SIBLINGS_DISCOUNT bit,
		  @VOUCHER_DATE date,
		  @dt_cheque [type_CHEQUES_INFO] readonly,
		  @dt_multiple_cash [type_Multiple_Cash] readonly
   
     as begin 


	 set @FEE_CASH_IN_HAND_AMOUNT = (select SUM(ISNULL(Amount,0)) from @dt_multiple_cash)
	 set @FEE_CASH_IN_HAND_AMOUNT = ISNULL(@FEE_CASH_IN_HAND_AMOUNT,0)

	--  declare @FEE_COLLECT_ID  numeric = 174376,
 --         @FEE_COLLECT_HD_ID  numeric = 1,
 --         @FEE_COLLECT_BR_ID  numeric = 1,          
 --         @FEE_COLLECT_FEE_PAID  float =0 ,          
 --         @FEE_COLLECT_DATE  date = '2016-10-13',
 --         @FEE_COLLECT_FEE_STATUS  nvarchar(50)='',
 --         @FEE_COLLECT_ARREARS_RECEIVED float = 0,
 --         @FEE_COLLECT_FEE float = 5820,
 --         @FEE_COLLECT_ARREARS float = 0,
 --         @FEE_COLLECT_NET_TOATAL float = 5820,
 --         @FEE_COLLECT_LATE_FEE_STATUS char(2) = '',
	--	  @FEE_CASH_IN_HAND_AMOUNT float = 0,
	--	  @FEE_CASH_AT_BANK_AMOUNT float = 0,
	--	  @FEE_CASH_IN_HAND_CODE nvarchar(50) = '',
	--	  @FEE_CASH_AT_BANK_CODE nvarchar(50) = '',
	--	  @FEE_COLLECT_CHEQUE_NO nvarchar(50) = '',
	--	  @FEE_COLLECT_CHEQUE_DATE date = '2016-10-13',
	--	  @FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT float = 0,
	--	  @VCH_chequeClearanceDate date = '2016-10-13',
	--	  @VCH_chequeBankName nvarchar(50) = '',
	--	  @CHEQUE_INFO_FEE_IDS nvarchar(200) = '174376',
	-- @DISCOUNT_AMOUNT float = 100,
	--	  @IFL float = 100,
	--	  @IS_ALL_SIBLINGS_DISCOUNT bit = 0
		  
		  
	--	  declare @dt_cheque table ([ID] [numeric](18, 0) NULL, 	[Cheque No] [nvarchar](50) NULL,	[Amount] [float] NULL,	[Cheque Date] [date] NULL,	[Bank Name] [nvarchar](50) NULL,	[Clearance Date] [date] NULL,	[COA Account] [nvarchar](50) NULL,	[Is Cleared] [bit] NULL)


	--insert into @dt_cheque 
	--select 1,'1516699466',3300,'2016-10-13','bank','2016-10-13','account',0


	--insert into @dt_cheque 
	--select 2,'1516699467',20000,'2016-10-13','bank','2016-10-13','account',0

	--insert into @dt_cheque 
	--select 3,'1516699468',20000,'2016-10-13','bank','2016-10-13','account',0


		declare @payment_mode nvarchar(100) = 'Multiple'
		 declare @a int = 1

		 if (select top(@a) [Cheque No] from @dt_cheque) = 'fake001'
		 BEGIN
			set @payment_mode = 'Cash in Hand'
		 END


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


		
		
	
 
		 -- if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
		 -- BEGIN	
			--update TBL_VCH_MAIN set VCH_chequeNo = @FEE_COLLECT_CHEQUE_NO, VCH_date = @FEE_COLLECT_CHEQUE_DATE,
			--VCH_chequeClearanceDate = @VCH_chequeClearanceDate, VCH_chequeBankName = @VCH_chequeBankName	
			--where VCH_referenceNo = CAST(@FEE_COLLECT_ID as nvarchar(50))
		 -- END
    
	update FEE_COLLECT 
     set   
		  FEE_COLLECT_FEE = @FEE_COLLECT_FEE,
          --FEE_COLLECT_FEE_PAID = @FEE_COLLECT_FEE_PAID,
          FEE_COLLECT_ARREARS = @FEE_COLLECT_ARREARS,
          --FEE_COLLECT_ARREARS_RECEIVED = @FEE_COLLECT_ARREARS_RECEIVED,
          FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,
          --FEE_COLLECT_FEE_STATUS = @FEE_COLLECT_FEE_STATUS,
          FEE_COLLECT_NET_TOATAL = @FEE_COLLECT_NET_TOATAL,
          FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS
		  --FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT
		
     where 
          FEE_COLLECT_ID =  @FEE_COLLECT_ID 
		  --and 
    --      FEE_COLLECT_HD_ID =  @FEE_COLLECT_HD_ID and 
    --      FEE_COLLECT_BR_ID =  @FEE_COLLECT_BR_ID 
  
				--SET @acc_start_date = (select top(1) [Start Date] from V_BRANCH_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and ID = @FEE_COLLECT_BR_ID ) 
				--SET @acc_end_date = (select top(1) [End Date] from V_BRANCH_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and ID = @FEE_COLLECT_BR_ID ) 
				--SET @student_id = ( select top(1) FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID )
				

		  


		  declare @one int = 1 




		  --Cheques Info
		  declare @fee_id numeric = 0
		  declare @chq_fee_summary_id numeric = 0
		  declare @chq_ids nvarchar(200) = ''
		  declare @tbl_chq_ids table (cheque_id numeric)
		  declare @tbl_fee_ids table(sr int identity(1,1),fee_id numeric)
		  declare @tbl_cheques_division table (Sr int identity(1,1),ChequeId numeric, ChequeAmount float, RemainingAmount float) --For Multiple Students Detail
		  declare @count int = 0
		  declare @i int = 1
		  declare @Std_ID numeric = 0
		  declare @Cheque_Id numeric = 0 --this id is of scope_identity means primary key when inserting of cheques
		  declare @fee_collect_def_fee_id_discount numeric = 0
			declare @fee_collect_def_fee_id_ifl numeric = 0
						declare @total_fee_collect_std_current_fee float = 0
			declare @total_fee_collect_std_arrears float = 0


		  select @chq_fee_summary_id = ISNULL(CHEQ_FEE_SUMMARY_ID,0) from CHEQ_FEE_INFO where CHEQ_FEE_COLLECT_ID = @FEE_COLLECT_ID

		  insert into @tbl_fee_ids 
		  select CAST(val as numeric) from dbo.split(@CHEQUE_INFO_FEE_IDS,',')

		    set @count = (select COUNT(*) from @tbl_fee_ids)

		  WHILE @i <= @count
		  BEGIN
				select @fee_id = fee_id from @tbl_fee_ids where sr = @i

			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = 0, FEE_COLLECT_FEE_PAID = 0, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = 0, FEE_COLLECT_CASH_DEPOSITE = 0, FEE_COLLECT_PAYMENT_MODE = ''
			where FEE_COLLECT_ID = @fee_id

			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = 0, FEE_COLLECT_DEF_FEE_PAID = 0 
			where FEE_COLLECT_DEF_PID = @fee_id

			
			select @HD_ID = CAST( FEE_COLLECT_HD_ID as nvarchar(50)), @BR_ID = CAST( FEE_COLLECT_BR_ID as nvarchar(50)) from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID


			delete from FEE_ADVANCE where ADV_FEE_COLLECT_ID = @fee_id
			--update FEE_ADVANCE set ADV_FEE_STATUS = 'D' where ADV_FEE_COLLECT_ID = @fee_id

			--Delete from tbl_vch_Main and tbl_vch_Def In case of Multiple Cash Received

			delete from TBL_VCH_DEF where VCH_MAIN_ID in (select VCH_MID from TBL_VCH_MAIN m where CAST(@fee_id as nvarchar(50)) in (select val from dbo.split(VCH_referenceNo,',') ) and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and VCH_chequeBankName = 'Multiple Cash Received') and CMP_ID = @HD_ID and BRC_ID = @BR_ID 

			delete from TBL_VCH_MAIN where CAST(@fee_id as nvarchar(50)) in (select val from dbo.split(VCH_referenceNo,',') ) and CMP_ID = @HD_ID and BRC_ID = @BR_ID and VCH_chequeBankName = 'Multiple Cash Received'

			set @i = @i + 1
		  END

		  
		  set @fee_id = 0
		  
		 set @i = 1
		  if @chq_fee_summary_id != 0
		  BEGIN
			
			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = 0, FEE_COLLECT_FEE_PAID = 0, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = 0, FEE_COLLECT_CASH_DEPOSITE = 0, FEE_COLLECT_PAYMENT_MODE = ''
			where FEE_COLLECT_ID in ( select CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO where CHEQ_FEE_SUMMARY_ID = @chq_fee_summary_id)

			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = 0, FEE_COLLECT_DEF_FEE_PAID = 0 
			where FEE_COLLECT_DEF_PID in ( select CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO where CHEQ_FEE_SUMMARY_ID = @chq_fee_summary_id)
			
			
			delete from CHEQ_FEE_INFO where CHEQ_FEE_SUMMARY_ID =@chq_fee_summary_id
			delete from CHEQ_FEE_SUMMARY where CHEQ_FEE_SUM_ID = @chq_fee_summary_id
			delete from CHEQUE_INFO where CHEQ_ID in (select CHEQ_FEE_CHEQUE_ID from CHEQ_FEE_INFO where CHEQ_FEE_SUMMARY_ID = @chq_fee_summary_id)
			 
			

			
		  END

		  

		  --Set Discount and IFL
		  if @IS_ALL_SIBLINGS_DISCOUNT = 0
		  BEGIN
			set @count = 1
 		  END
		
			  set @i = 1
			  WHILE @i <= @count 
			  BEGIN

			  if @count != 1
			  BEGIN
				select @FEE_COLLECT_ID = fee_id from @tbl_fee_ids where sr = @i
			  END
			  



			select top(1) @fee_collect_def_fee_id_discount  =  FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME = 'Discount' and FEE_STATUS = 'T')

			select top(1) @fee_collect_def_fee_id_ifl  =  FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where FEE_NAME in ('Interest Free Loan','Interest Free Loan') and FEE_STATUS = 'T')

			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = @DISCOUNT_AMOUNT, FEE_COLLECT_DEF_TOTAL = FEE_COLLECT_DEF_ARREARS + @DISCOUNT_AMOUNT where FEE_COLLECT_DEF_ID = @fee_collect_def_fee_id_discount

			update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = @IFL, FEE_COLLECT_DEF_TOTAL = FEE_COLLECT_DEF_ARREARS + @IFL where FEE_COLLECT_DEF_ID = @fee_collect_def_fee_id_ifl


			set @total_fee_collect_std_current_fee = (select ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_OPERATION = '+') - (select ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_OPERATION = '-')

			set @total_fee_collect_std_arrears = (select ISNULL(SUM(FEE_COLLECT_DEF_ARREARS),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_OPERATION = '+') - (select ISNULL(SUM(FEE_COLLECT_DEF_ARREARS),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID and FEE_COLLECT_DEF_OPERATION = '-')

			--In case - operation is greater than current then it will be minus from arrears
			if @total_fee_collect_std_current_fee < 0
			BEGIN
				set @total_fee_collect_std_arrears = @total_fee_collect_std_arrears - (@total_fee_collect_std_current_fee) -- @total_fee_collect_std_current_fee is minus then it will be plus

				set @total_fee_collect_std_current_fee = 0

			END

			update FEE_COLLECT set FEE_COLLECT_FEE = @total_fee_collect_std_current_fee, FEE_COLLECT_ARREARS = @total_fee_collect_std_arrears, FEE_COLLECT_NET_TOATAL = @total_fee_collect_std_arrears + @total_fee_collect_std_current_fee where FEE_COLLECT_ID =@FEE_COLLECT_ID 
				set @i = @i + 1
			  END
		 

		  set @count = (select COUNT(*) from @tbl_fee_ids)

		  --Set Advance Fee
		  set @i = 1
		  WHILE @i <= @count
		  BEGIN
				select @fee_id = fee_id from @tbl_fee_ids where sr = @i

			if (select COUNT(*) from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = @fee_id) = 1
			BEGIN
				declare @From_Date date = ''
				declare @To_Date date = ''
				
				declare @advance_fee_adjust_amount float = 0
				declare @advance_fee_id numeric = 0
				set @advance_fee_adjust_amount = 0 
				
				select @advance_fee_adjust_amount = ADV_FEE_DEF_AMOUNT, @advance_fee_id = ADV_FEE_DEF_PID from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = @fee_id

				set @advance_fee_adjust_amount = ISNULL(@advance_fee_adjust_amount,0)
							if @advance_fee_adjust_amount > 0
							BEGIN
								update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST - @advance_fee_adjust_amount where ADV_FEE_ID = @advance_fee_id
								delete from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = @fee_id
							END
			END				

				select @Std_ID = FEE_COLLECT_STD_ID, @From_Date = FEE_COLLECT_FEE_FROM_DATE, @To_Date = FEE_COLLECT_FEE_TO_DATE from FEE_COLLECT where FEE_COLLECT_ID = @fee_id
				--declare @isCalculate bit = 0
				Exec [sp_FEE_ADVANCE_CALCULATION]  @Std_ID,@From_Date,@To_Date --@isCalculate
			

			

			set @i = @i + 1
		  END

		  set @count = 0
			set @count = (select COUNT(*) from @dt_cheque)
			set @i = 1
			--top(@i) @i is varible used due to top clause is slow when enter any number
		  if (select top(@i) [Cheque No] from @dt_cheque) != 'fake001'
		  BEGIN
			
			WHILE @i<= @count
			BEGIN
				insert into CHEQUE_INFO
				select @FEE_COLLECT_HD_ID,@FEE_COLLECT_BR_ID,[Cheque No],Amount,[Cheque Date],[Bank Name],[Clearance Date],GETDATE(),[Is Cleared],[COA Account], Remarks,[Is DisHonored] from (select ROW_NUMBER() over(order by (select 0)) as sr,* from @dt_cheque)A where sr = @i

				select @Cheque_Id = SCOPE_IDENTITY()
				insert into @tbl_chq_ids 
				select @Cheque_Id

				insert into @tbl_cheques_division
				select @Cheque_Id, (select top(@one) Amount from (select ROW_NUMBER() over(order by (select 0)) as sr,* from @dt_cheque)A where sr = @i),0

				set @i = @i + 1
			END

			set @count = 0
			set @i = 1
			select @chq_ids =  STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), cheque_id, 120))  from @tbl_chq_ids
					FOR XML PATH(''), TYPE).value('.', 'VARCHAR(1000)') ,1,1,'')
			insert into CHEQ_FEE_SUMMARY
			select 	REPLACE(REPLACE(@chq_ids,'[',''),']',''),@CHEQUE_INFO_FEE_IDS
			
			set @chq_fee_summary_id = SCOPE_IDENTITY()
			 
			 insert into CHEQ_FEE_INFO
			 select cheque_id,fee_id,@chq_fee_summary_id from @tbl_chq_ids 
			 cross join @tbl_fee_ids
			
		END	

			declare @total_amount_cheque float = 0
			declare @remaining_amount_cheques float = 0
			declare @due_amount_cheques float = 0
			declare @total_std_amount float = 0
			declare @total_std_amount_current_fee float = 0
			declare @std_amount float = 0
			declare @std_arrears float = 0
			declare @std_current_fee float = 0
			declare @total_amount_cash float = 0
			declare @due_amount_cash float = 0
			declare @remaining_amount_cash float = 0
			declare @is_advance_payment bit = 0			
			declare @is_fully_received bit = 0
			declare @is_fully_received_current_fee bit = 0
			
			declare @fee_br_id int =0 
			declare @discount float = 0
			declare @remaining_discount float = 0
			declare @fee_discount_id float = 0
			declare @j int = 1
			declare @discount_fee_amount float = 0
			declare @std_total_fee_paid_amount float = 0
			declare @fee_def_id numeric = 0
			declare @fee_def_amount float = 0
			

			
			declare @percent_cheques_detail float = 0
			declare @total_cheques_count int = 0
			
			--declare @adv_fee float = 0
			--set @adv_fee = (select SUM(ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST) from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 )
			
			--set @FEE_CASH_IN_HAND_AMOUNT = @FEE_CASH_IN_HAND_AMOUNT --- ISNULL(@adv_fee,0)

			select @total_amount_cheque = ISNULL(SUM(AMOUNT),0) from @dt_cheque where [Is DisHonored] != 1 
			set @total_amount_cash = @FEE_CASH_IN_HAND_AMOUNT

			set @count = (select COUNT(*) from @tbl_fee_ids)
			set @i = 1
			select @total_std_amount  = SUM(FEE_COLLECT_NET_TOATAL - FEE_COLLECT_ARREARS_RECEIVED - FEE_COLLECT_FEE_PAID) from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
			select @total_std_amount_current_fee  = SUM(FEE_COLLECT_FEE - FEE_COLLECT_FEE_PAID) from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
			--set @due_amount_cheques = @total_amount_cheque /@count

			declare @percent_cheque float = 0
			set @percent_cheque =  @total_amount_cheque * 100 / @total_std_amount			
			set @remaining_amount_cheques = @total_amount_cheque



			declare @percent_cash float = 0
			set @percent_cash =  @total_amount_cash * 100 / @total_std_amount			
			set @remaining_amount_cash = @total_amount_cash

			declare @total_students_remaining float = 0
			set @total_students_remaining = @total_std_amount - (@total_amount_cheque + @total_amount_cash)

			if @total_amount_cheque + @total_amount_cash = @total_std_amount
			BEGIN
				set @is_fully_received = 1
			END

			if @total_students_remaining between 1 and 10
			BEGIN
				set @is_fully_received = 1
			END

			if @total_amount_cheque + @total_amount_cash > @total_std_amount
			BEGIN
				set @is_advance_payment = 1
			END
			
			if @total_amount_cheque + @total_amount_cash = @total_std_amount_current_fee
			BEGIN
				set @is_fully_received_current_fee = 1
			END
			--
			--if @total_std_amount =  @total_amount + @FEE_CASH_IN_HAND_AMOUNT
			--BEGIN
				
			--END

			WHILE @i<= @count
			BEGIN
				set @std_id = 0
				set @std_amount = 0
				set @discount = 0
				set @remaining_discount = 0
				set @fee_discount_id = 0
				set @percent_cheques_detail = 0

				select @std_arrears = FEE_COLLECT_ARREARS - FEE_COLLECT_ARREARS_RECEIVED,@std_current_fee = FEE_COLLECT_FEE - FEE_COLLECT_FEE_PAID, @fee_id = FEE_COLLECT_ID, @fee_br_id = FEE_COLLECT_BR_ID, @std_id = FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = (select top(1) fee_id from @tbl_fee_ids where sr = @i)
				set @std_amount = @std_arrears + @std_current_fee
				
				if @i = @count
				BEGIN
					set @due_amount_cheques = @remaining_amount_cheques
					set @due_amount_cash = @remaining_amount_cash
				END
				ELSE
				BEGIN
					--if @is_fully_received_current_fee = 1
					--BEGIN
					--	set @due_amount_cheques = (@percent_cheque * @std_current_fee) / 100
					--	set @due_amount_cheques = CAST(@due_amount_cheques as int) - (CAST(@due_amount_cheques as int) % 10)

					--	set @due_amount_cash = (@percent_cash * @std_current_fee) / 100
					--	set @due_amount_cash = CAST(@due_amount_cash as int) - (CAST(@due_amount_cash as int) % 10)
					--END
					--ELSE
					--BEGIN
					--Only Take whole part
						set @due_amount_cheques = (@percent_cheque * @std_amount) / 100
						set @due_amount_cheques = FLOOR(@due_amount_cheques) --CAST(@due_amount_cheques as int) - (CAST(@due_amount_cheques as int) % 1)

						set @due_amount_cash = (@percent_cash * @std_amount) / 100
						set @due_amount_cash = FLOOR(@due_amount_cash) --CAST(@due_amount_cash as int) - (CAST(@due_amount_cash as int) % 1)
					--END
				END



				--Case If Fee is fully received
				 if @is_fully_received = 1
				 BEGIN

				
					
					if @total_amount_cash = 0
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Fully Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_amount, FEE_COLLECT_CASH_DEPOSITE = 0, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id

					END
					ELSE
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Fully Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @due_amount_cheques, FEE_COLLECT_CASH_DEPOSITE = (@std_arrears + @std_current_fee) - @due_amount_cheques, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id
					END
					set @due_amount_cash = @std_arrears + @std_current_fee - @due_amount_cheques

					set @remaining_amount_cheques = @remaining_amount_cheques - @due_amount_cheques
					
					if @total_amount_cash = 0
					BEGIN
						set @remaining_amount_cash = 0
					END
					ELSE
					BEGIN
						set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash
					END

					--THis is FeeReceiveMultipleDetail will be handled later
					--if @count > 1
					--BEGIN
					--	set @percent_cheques_detail = @std_amount / @total_amount_cheque

					--	 declare @count_cheque_detail int = 0
					--	 declare @k int = 1
					--	 declare @std_detail_amount_partial float = 0
					--	 declare @cheque_detail_amount_total float = 0
					--	 declare @RemainingAmountDetail float = 0
					  
					--	 set @count_cheque_detail = (select COUNT(*) from @tbl_cheques_division)
					--	 WHILE @k <= @count_cheque_detail
					--	 BEGIN
					--		select @cheque_detail_amount_total = ChequeAmount, @Cheque_Id = ChequeId,@RemainingAmountDetail = RemainingAmount from @tbl_cheques_division where Sr = @k
					--		if @k = @count_cheque_detail
					--		BEGIN
					--			set @std_detail_amount_partial = @cheque_detail_amount_total - @RemainingAmountDetail
					--		END
					--		ELSE
					--		BEGIN
					--			set @std_detail_amount_partial = FLOOR(@percent_cheques_detail * @cheque_detail_amount_total)
					--		END

					--		insert into FeeCollectionMultipleDetail
					--		select @fee_id, @std_detail_amount_partial, NULL, @Cheque_Id, NULL

					--		update @tbl_cheques_division set RemainingAmount = RemainingAmount + @std_detail_amount_partial where Sr = @k
					--		set @k = @k + 1
					--	 END
					--END --End if Condition of @count > 1
					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS, FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_OPERATION = '+'
				END


				--Second case if advance paymnet
				ELSE IF @is_advance_payment = 1
				BEGIN
					if @total_amount_cash = 0
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Fully Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_amount, FEE_COLLECT_CASH_DEPOSITE = 0, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id
					END
					ELSE
					BEGIN
						--set @due_amount_cheques = (@std_arrears + @std_current_fee) - @due_amount_cash
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Fully Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_amount - @due_amount_cash, FEE_COLLECT_CASH_DEPOSITE = @due_amount_cash, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id
					END
					
					declare @advance_fee_amount float = 0
					set @advance_fee_amount = (@due_amount_cheques - @std_amount+ @due_amount_cash)
					exec sp_FEE_ADVANCE_insertion @std_id,@FEE_COLLECT_DATE,@FEE_COLLECT_DATE,@advance_fee_amount,0,@advance_fee_amount,@fee_id,'Multiple Cheques',@FEE_COLLECT_DATE,'T'

										 

					set @remaining_amount_cheques = @remaining_amount_cheques - @due_amount_cheques
					
					if @total_amount_cash = 0
					BEGIN
						set @remaining_amount_cash = 0
					END
					ELSE
					BEGIN
						set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash
					END


					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS, FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_OPERATION = '+'
				END

				--Third case if only current Fee is received
				ELSE if @is_fully_received_current_fee = 1
				BEGIN
					if @total_amount_cash = 0
					BEGIN
						update FEE_COLLECT set  FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Partially Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_current_fee, FEE_COLLECT_CASH_DEPOSITE = 0, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id
						
					END
					ELSE
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Partially Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_current_fee - @due_amount_cash, FEE_COLLECT_CASH_DEPOSITE = @due_amount_cash, FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id
					END
					--set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash

					set @remaining_amount_cheques = @remaining_amount_cheques - (@std_current_fee - @due_amount_cash)
					
					if @total_amount_cash = 0
					BEGIN
						set @remaining_amount_cash = 0
					END
					ELSE
					BEGIN
						set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash
					END


					--update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @fee_id

				END

				--Last Case partially Fee Received
				ELSE
				BEGIN
					if @std_arrears >= @due_amount_cash + @due_amount_cheques
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS_RECEIVED + @due_amount_cash + @due_amount_cheques, FEE_COLLECT_FEE_STATUS = 'Partially Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @due_amount_cheques, FEE_COLLECT_CASH_DEPOSITE = @due_amount_cash , FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id

						set @remaining_amount_cheques = @remaining_amount_cheques - @due_amount_cheques
						set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash

					END
					ELSE
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE_PAID + (@due_amount_cash + @due_amount_cheques - FEE_COLLECT_ARREARS), FEE_COLLECT_FEE_STATUS = 'Partially Received', FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @due_amount_cheques, FEE_COLLECT_CASH_DEPOSITE = @due_amount_cash , FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,  FEE_COLLECT_LATE_FEE_STATUS = @FEE_COLLECT_LATE_FEE_STATUS, FEE_COLLECT_PAYMENT_MODE = @payment_mode  where FEE_COLLECT_ID = @fee_id

						set @remaining_amount_cheques = @remaining_amount_cheques - @due_amount_cheques
						set @remaining_amount_cash = @remaining_amount_cash - @due_amount_cash
					END
				 END -- @is_fully_received = 1

				 --SUppose there is no receiving all receiving will be done according to fee_Collect invoice id
				 update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = 0, FEE_COLLECT_DEF_ARREARS_RECEIVED = 0 where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_OPERATION = '+' 

				 if @is_fully_received_current_fee != 1
				 BEGIN
					-- update fee_collect_def arrears
					 select @std_total_fee_paid_amount = (FEE_COLLECT_ARREARS_RECEIVED) from FEE_COLLECT where FEE_COLLECT_ID = @fee_id
				 
					 set @j = 1
					 WHILE @std_total_fee_paid_amount > 0
					 BEGIN
						select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_ARREARS from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_ARREARS DESC) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_ARREARS > 0  and FEE_COLLECT_DEF_OPERATION = '+')A where sr = @j

						if @std_total_fee_paid_amount > @fee_def_amount
							BEGIN
								update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS_RECEIVED + FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_ID = @fee_def_id 

								set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
							END
							ELSE
							BEGIN
								update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS_RECEIVED + @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
								set @std_total_fee_paid_amount = 0
							END

						set @j = @j + 1
					 END
				 END


				-- update fee_collect_def 
				 select @std_total_fee_paid_amount = (FEE_COLLECT_FEE_PAID) from FEE_COLLECT where FEE_COLLECT_ID = @fee_id
				 set @discount = (select ISNULL(SUM(FEE_COLLECT_DEF_FEE),0) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_OPERATION = '-')
				 --set @std_total_fee_paid_amount = @std_total_fee_paid_amount + @discount
				 set @j = 1
				 WHILE @std_total_fee_paid_amount > 0
				 BEGIN
					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_FEE from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_FEE DESC) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_FEE > 0  and FEE_COLLECT_DEF_OPERATION = '+')A where sr = @j

					if @std_total_fee_paid_amount > @fee_def_amount
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE_PAID + FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_ID = @fee_def_id 

							set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
						END
						ELSE
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID =FEE_COLLECT_DEF_FEE_PAID + @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
							set @std_total_fee_paid_amount = 0
						END

					set @j = @j + 1
				 END
				 
				 
				 --set @discount = (select FEE_COLLECT_DEF_FEE from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_FEE_NAME in (select top(1) FEE_ID from FEE_INFO where FEE_NAME in ('Discount', 'Interest Free Loan','Interest Free Loan') and FEE_STATUS = 'T'))

					--WHile loop commented due to from advance fee collection the amount of fee receiving not included discount amount e.g: fees received 35000, current fee 37000 and 1800 discount means 37000-1800	
					 --set @remaining_discount = @discount
					 --set @j = 1
					 --declare @count_disc int  = (select COUNT(*) from FEE_INFO where FEE_BR_ID = @fee_br_id and FEE_STATUS = 'T' and FEE_OPERATION = '+') 
					 --if @remaining_discount > 0
					 --BEGIN
						-- WHILE @j <= @count_disc   AND @remaining_discount > 0
						-- BEGIN
						--	select @fee_discount_id = FEE_ID from (select ROW_NUMBER() over(order by FEE_DISCOUNT_PRIORITY, FEE_ID ) as sr,* from FEE_INFO where FEE_BR_ID = @fee_br_id and FEE_STATUS = 'T' )A where sr = @j
						
						--	set @discount_fee_amount = 0
						--	select @discount_fee_amount = FEE_COLLECT_DEF_FEE_PAID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @fee_id
						
						--	if @remaining_discount >@discount_fee_amount
						--	BEGIN
						--		update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = 0 where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @fee_id
						--		set @remaining_discount = @remaining_discount - @discount_fee_amount
						--	END
						--	ELSE
						--	BEGIN
						--		update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE_PAID - @remaining_discount where FEE_COLLECT_DEF_FEE_NAME = @fee_discount_id and FEE_COLLECT_DEF_PID = @fee_id
						--		set @remaining_discount = 0
						--	END
						--	set @j = @j + 1

						-- END
					 --END
					 if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
						  BEGIN	

										update TBL_VCH_MAIN set VCH_chequeNo = @FEE_COLLECT_CHEQUE_NO,VCH_date = @VOUCHER_DATE ,
			VCH_chequeClearanceDate = @VCH_chequeClearanceDate, VCH_chequeBankName = 'Multiple Cheques'	
			where VCH_referenceNo = CAST(@fee_id as nvarchar(50))
								

								--This store procedure is insertion in Student Account Credit
								exec sp_FEE_COLLLECT_DEFINATION_UPDATION_IN_ACCOUNT_INSERTION @fee_id,'Multiple Cheques'

								--accouts insertion 
								EXEC sp_FEE_COLLECTION_updation_ACCOUNTS_INSERTION @fee_id,	@due_amount_cash,  @due_amount_cheques , @FEE_CASH_IN_HAND_CODE ,@FEE_CASH_AT_BANK_CODE, 'Multiple Cheques' --Last Parameter is Vch_Def_ItemCOA and it is optional Passing Value 'Multiple Cheques' 
						  END

declare @fee_history bit = (select top(1) BR_ADM_FEE_HISTORY from FEE_SETTING where  FEE_SETTING_BR_ID = @fee_br_id)

--Fee History
if @fee_history   = 1
  begin
  
  declare @fee_history_id numeric = 0	
  declare @fee_history_date date = ''
  declare @comma nvarchar(5) = ''
  declare @fee_history_previous_date nvarchar(2000) = ''
  
  
  


	select @fee_history_id = ISNULL(FEE_HISTORY_ID,0), @fee_history_date = ISNULL(FEE_HISTORY_DATE,''), @fee_history_previous_date = ISNULL(FEE_HISTORY_PREVIOUS_DATE,'') from
	(select top(1) * from FEE_HISTORY h
	join FEE_COLLECT f on f.FEE_COLLECT_ID = h.FEE_HISTORY_PID
	
	where FEE_HISTORY_PID = f.FEE_COLLECT_ID and FEE_HISTORY_FEE = f.FEE_COLLECT_FEE
	and FEE_HISTORY_PAID = FEE_COLLECT_FEE_PAID and FEE_HISTORY_STATUS = FEE_COLLECT_FEE_STATUS and FEE_HISTORY_ARREARS = FEE_COLLECT_ARREARS
	and FEE_HISTORY_NET_TOTAL = FEE_COLLECT_NET_TOATAL and FEE_HISTORY_ARREARS_RECEIVED = FEE_COLLECT_ARREARS_RECEIVED order by FEE_HISTORY_ID DESC) A
	
	if @fee_history_previous_date != ''
		set @comma = ', '
		
	if @fee_history_id = 0
		begin
		
		 INSERT INTO FEE_HISTORY
		 
		 select FEE_COLLECT_ID,FEE_COLLECT_FEE,FEE_COLLECT_FEE_PAID,FEE_COLLECT_DATE_FEE_RECEIVED,FEE_COLLECT_FEE_STATUS,FEE_COLLECT_ARREARS,FEE_COLLECT_NET_TOATAL,
		 FEE_COLLECT_ARREARS_RECEIVED,'1900-01-01'

		  from FEE_COLLECT where FEE_COLLECT_ID = @fee_id
		 
		 							         
			 --VALUES
				--   (
				--	@FEE_COLLECT_ID
				--   ,@FEE_COLLECT_FEE
				--   ,@FEE_COLLECT_FEE_PAID
				--   ,@FEE_COLLECT_DATE
				--   ,@FEE_COLLECT_FEE_STATUS
				--   ,@FEE_COLLECT_ARREARS
				--   ,@FEE_COLLECT_NET_TOATAL
				--   ,@FEE_COLLECT_ARREARS_RECEIVED,
				--   '1900-01-01'
				--   )	
		end
		
			else
				--if @fee_history_previous_date != ''
				--	set @fee_history_previous_date = CONVERT(VARCHAR(20),@fee_history_previous_date,20) 
		
				update FEE_HISTORY set FEE_HISTORY_DATE = @FEE_COLLECT_DATE,  FEE_HISTORY_PREVIOUS_DATE =  CONVERT(VARCHAR(20),@fee_history_date,20) + @comma + @fee_history_previous_date
				where FEE_HISTORY_ID = @fee_history_id
		
		  end



				set @i = @i + 1
			END
			
			 if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
						  BEGIN	
			--Cash when comes seprate voucher entry
								if @FEE_CASH_IN_HAND_AMOUNT > 0
								BEGIN

								EXEC sp_FEE_MULTIPLE_CASH_RECEIVED_VOUCHERS_AND_INSERTION @dt_multiple_cash, @CHEQUE_INFO_FEE_IDS, @HD_ID,@BR_ID
									--EXEC sp_FE_COLLECT_MULTIPLE_CHEQUES_CASH_INSERTION_IN_ACCOUNTS_VOUCHER @FEE_COLLECT_DATE,@CHEQUE_INFO_FEE_IDS,@FEE_CASH_IN_HAND_AMOUNT, 'Multiple Cash Received',@FEE_CASH_IN_HAND_CODE,0
								END
						  END
	
		 -- ELSE
		 -- BEGIN
			--select 0
		 -- END




          
 
 
 

end