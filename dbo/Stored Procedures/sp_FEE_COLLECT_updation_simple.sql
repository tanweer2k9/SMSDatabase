

CREATE procedure  [dbo].[sp_FEE_COLLECT_updation_simple]                                                                                              
    --      @FEE_COLLECT_ID  numeric,         
    --      @FEE_COLLECT_STD_ID numeric,
    --      @FEE_COLLECT_FEE_STATUS  nvarchar(50),          
		  --@FEE_COLLECT_DATE date,
		  --@FEE_COLLECT_FEE float,
		  --@FEE_COLLECT_ARREARS_RECEIVED float,
		  --@FEE_CASH_IN_HAND_AMOUNT float,
		  --@FEE_CASH_AT_BANK_AMOUNT float,
		  --@FEE_CASH_IN_HAND_CODE nvarchar(50),
		  --@FEE_CASH_AT_BANK_CODE nvarchar(50),
		  --@FEE_COLLECT_CHEQUE_NO nvarchar(50),
		  --@FEE_COLLECT_CHEQUE_DATE date,
		  --@STATUS nvarchar(50),
		  --@LATE_FEE_FINE float,
		  @FEE_COLLECT_BR_ID numeric,

         @dt [type_FEE_Collection_Simple_Multiple_Students] readonly
     as  	

	 --sp_FEE_COLLECT_ACCOUNTS_UPDATE_FEE_WITH_ACCOUNTS	 
		update fd set fd.FEE_COLLECT_DEF_FEE =  t.[Late fee Fine], fd.FEE_COLLECT_DEF_TOTAL = fd.FEE_COLLECT_DEF_TOTAL + t.[Late fee Fine],
		FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE,
			  FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS,
			  FEE_COLLECT_DEF_ROYALTY_PAID = FEE_COLLECT_DEF_ROYALTY,
			  FEE_COLLECT_DEF_STATUS = 'R'
		from FEE_COLLECT_DEF fd

		join @dt t on t.ID = fd.FEE_COLLECT_DEF_PID
		join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME and f.FEE_BR_ID = @FEE_COLLECT_BR_ID
		where f.FEE_NAME = 'Late Fee Fine' and t.[Net Total] + t.[Late fee Fine] = t.[Received Amount]


		update fd set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE,
			  FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS,
			  FEE_COLLECT_DEF_ROYALTY_PAID = FEE_COLLECT_DEF_ROYALTY,
			  FEE_COLLECT_DEF_STATUS = 'R'
		from FEE_COLLECT_DEF fd

		join @dt t on t.ID = fd.FEE_COLLECT_DEF_PID
		join FEE_INFO f on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME and f.FEE_BR_ID = @FEE_COLLECT_BR_ID
		where  t.[Net Total] + t.[Late fee Fine] = t.[Received Amount]



		update f set FEE_COLLECT_FEE = FEE_COLLECT_FEE + t.[Late fee Fine], FEE_COLLECT_NET_TOATAL = FEE_COLLECT_NET_TOATAL + t.[Late fee Fine],
		 FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE + t.[Late fee Fine],
          FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS,          
          FEE_COLLECT_DATE_FEE_RECEIVED = t.Date,
		  FEE_COLLECT_ROYALTY_PAID = FEE_COLLECT_ROYALTY_FEE,
          FEE_COLLECT_FEE_STATUS = 'Fully Received',
		  FEE_COLLECT_PAYMENT_MODE = 'Multiple'

		from FEE_COLLECT f
		join @dt t on t.ID = f.FEE_COLLECT_ID

		where t.[Net Total] + t.[Late fee Fine] = t.[Received Amount] 



		-- update fee_collect_def arrears
		declare @count int = 0, @i int = 1, @j int = 1

		set @count = (select COUNT(*) from @dt t where t.[Net Total] + t.[Late fee Fine] != t.[Received Amount] )
		
		declare @std_total_fee_paid_amount float, @fee_def_amount float, @fee_id numeric, @fee_def_id numeric, @arrears float, @currentFee float, @currentFeeDeduct bit = 0
		WHILE @i <= @count
		BEGIN
			select @std_total_fee_paid_amount = A.[Received Amount], @currentFee = [Current Fee] + [Late fee Fine], @arrears =  Arrears,@fee_id = ID from (select ROW_NUMBER() over(order by (select 0)) as Sr,* from @dt)A where Sr = @i
				 
			set @j = 1

			if @std_total_fee_paid_amount = @arrears
			BEGIN
				update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_PID = @fee_id
			END
			else if @std_total_fee_paid_amount = @currentFee
			BEGIN
				update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @fee_id
			END
			ELSE
			BEGIN
				
				

				if @std_total_fee_paid_amount > @arrears
				BEGIN
					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_PID = @fee_id
					set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @arrears
					set @currentFeeDeduct = 1

					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_FEE from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_ARREARS DESC) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_FEE > 0  and FEE_COLLECT_DEF_OPERATION = '+')A join FEE_INFO f on f.FEE_ID = A.FEE_COLLECT_DEF_FEE_NAME  where sr = @j order by f.FEE_DISCOUNT_PRIORITY
				END
				ELSE
				BEGIN
					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_ARREARS from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_ARREARS DESC) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id and FEE_COLLECT_DEF_ARREARS > 0  and FEE_COLLECT_DEF_OPERATION = '+')A join FEE_INFO f on f.FEE_ID = A.FEE_COLLECT_DEF_FEE_NAME  where sr = @j order by f.FEE_DISCOUNT_PRIORITY

					set @currentFeeDeduct = 0

				END

				WHILE @std_total_fee_paid_amount > 0
				BEGIN
				

				if @std_total_fee_paid_amount > @fee_def_amount
					BEGIN
					if @currentFeeDeduct = 1
					BEGIN
						update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_ID = @fee_def_id 
					END
					else
					BEGIN
						update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_ID = @fee_def_id 
					END
					
						set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
					END
					ELSE
					BEGIN
						if @currentFeeDeduct = 1
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
						END
						else
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED =  @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
						END

						
						set @std_total_fee_paid_amount = 0
					END

				set @j = @j + 1
				END
			END

			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = (select SUM(FEE_COLLECT_DEF_ARREARS_RECEIVED) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id), FEE_COLLECT_FEE_PAID = (select SUM(FEE_COLLECT_DEF_FEE_PAID) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @fee_id), FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @fee_id
			

		set @i = @i + 1
	END
		  insert into FEE_HISTORY
		  select FEE_COLLECT_ID,FEE_COLLECT_FEE,FEE_COLLECT_FEE_PAID,FEE_COLLECT_DATE_FEE_GENERATED,FEE_COLLECT_FEE_STATUS,FEE_COLLECT_ARREARS,FEE_COLLECT_NET_TOATAL,FEE_COLLECT_ARREARS_RECEIVED, '' from FEE_COLLECT f
		  join @dt t on t.ID = f.FEE_COLLECT_ID
		  																
								
			insert into FEE_HISTORY_DEF
			select t.ID, fh.FEE_HISTORY_ID, FEE_COLLECT_DEF_FEE_NAME, FEE_COLLECT_DEF_FEE, FEE_COLLECT_DEF_FEE_PAID, FEE_COLLECT_DEF_MIN, FEE_COLLECT_DEF_MAX, FEE_COLLECT_DEF_OPERATION, FEE_COLLECT_DEF_ARREARS, FEE_COLLECT_DEF_ARREARS_RECEIVED,FEE_COLLECT_DEF_TOTAL  from FEE_COLLECT_DEF fd
			 join @dt t on t.ID = fd.FEE_COLLECT_DEF_PID
			 join FEE_HISTORY fh on fh.FEE_HISTORY_PID = t.ID
			
			
			
			declare @one int = 1
          declare @COA_ACCOUNT nvarchar(50) = ''
		  declare @Amount float = 0
		  --set @Amount = @FEE_COLLECT_FEE + @FEE_COLLECT_ARREARS_RECEIVED + @LATE_FEE_FINE

				--		if @FEE_CASH_IN_HAND_AMOUNT > 0
				--		BEGIN
				--			set @COA_ACCOUNT = @FEE_CASH_IN_HAND_CODE							
				--		END

				--		if @FEE_CASH_AT_BANK_AMOUNT > 0
				--		BEGIN
				--			set @COA_ACCOUNT = @FEE_CASH_AT_BANK_CODE
				--		END

          insert into FEE_MULTIPLE_RECEIVED_AMOUNT 
			select b.BR_ADM_HD_ID, @FEE_COLLECT_BR_ID, t.date, IIF(t.[Cash in Hand] = -1, t.[Hand Code],t.[Bank Code]), t.[Received Amount],t.ID, m.VCH_MID, ''
			from TBL_VCH_MAIN m
			join @dt t on m.VCH_referenceNo = CAST((t.ID) as nvarchar(50))
			join BR_ADMIN b on b.BR_ADM_ID = @FEE_COLLECT_BR_ID



			select 'ok'



















----		   Declare @FEE_COLLECT_ID  numeric = 37943       
----		  Declare @FEE_COLLECT_STD_ID numeric = 70613
----          Declare @FEE_COLLECT_FEE_STATUS  nvarchar(50) = 'Fully Received'
----		  Declare @FEE_COLLECT_DATE date = '2014-11-23'
----		  Declare @FEE_COLLECT_FEE float = 1200
----		  Declare @FEE_COLLECT_ARREARS_RECEIVED float = 0
----declare @FEE_CASH_IN_HAND_AMOUNT float = 0,
----		  @FEE_CASH_AT_BANK_AMOUNT float = -1,
----		  @FEE_CASH_IN_HAND_CODE nvarchar(50) = '',
----		  @FEE_CASH_AT_BANK_CODE nvarchar(50) = '01-04-01-00000',
----		  @FEE_COLLECT_CHEQUE_NO nvarchar(50)='00000001111',
----		  @FEE_COLLECT_CHEQUE_DATE date = '2014-11-25'
		  
--		  --A for Auto. When Bar Code Reader is implemented
--		  if @STATUS = 'A'
--		  BEGIN
--			  select @FEE_COLLECT_STD_ID = FEE_COLLECT_STD_ID, @FEE_COLLECT_FEE = FEE_COLLECT_FEE, @FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID
--			  set @FEE_COLLECT_FEE_STATUS = 'Fully Received'
--		  END

--		  exec sp_FEE_COLLECT_ACCOUNTS_UPDATE_FEE_WITH_ACCOUNTS @FEE_COLLECT_ID, @LATE_FEE_FINE,@FEE_COLLECT_BR_ID,@FEE_COLLECT_STD_ID,'Late Fee Fine'

--		--Declare @i int = 1
--		--Declare @count int = 0
--		Declare @FEE_COLLECT_DEF_ID numeric
--		Declare @histry_id numeric
--		Declare @histry_def_id numeric
--		--Declare @def_name int
--		Declare @def_min float
--		declare @def_max float
--		declare @def_op char(1)

--		--declare @FEE_COLLECT_PLAN_ID numeric = 0
--		--declare @acc_fee_invoice_periods nvarchar(100)= 'Fee Invoice Periods'
--		--declare @fee_months_coa_name nvarchar(100)= ''
--		--declare @FEE_COLLECT_FEE_FROM_DATE date = ''
--		--declare @FEE_COLLECT_FEE_TO_DATE date = ''
      
--		--declare @VCH_DEF_COA nvarchar(50) = ''
--		--declare @VCH_TYPE nvarchar(50) = ''
--		--declare @debit float = 0
--		--declare @credit float = 0
--		--declare @VCH_reference_no nvarchar(50) = ''
--		--declare @datetime datetime = ''
--		--declare @HD_ID nvarchar(50) = ''
--		--declare @BR_ID nvarchar(50) = ''
--		--declare @VCH_MAIN_ID nvarchar(50) = ''
--		--declare @arears float = 0
--		--declare @fee_receieved float = 0
--		--declare @accRefNo nvarchar(100) = ''
--		declare @acc_total_fee float = 0
--    	--set @FEE_COLLECT_DATE = (select MAX(FEE_COLLECT_DATE_FEE_GENERATED) from FEE_COLLECT)
--    	--set @FEE_COLLECT_DATE = (select ISNULL(@FEE_COLLECT_DATE,GETDATE()) )
    	


--		declare @payment_mode nvarchar(50)= 'Multiple'

--	--if @FEE_CASH_AT_BANK_AMOUNT = -1
--	--BEGIN
--	--	set @payment_mode = 'Cash at Bank'
--	--END

--		update FEE_COLLECT 
--		set     
		
--		  FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE,
--          FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS,          
--          FEE_COLLECT_DATE_FEE_RECEIVED = @FEE_COLLECT_DATE,
--		  FEE_COLLECT_ROYALTY_PAID = FEE_COLLECT_ROYALTY_FEE,
--          FEE_COLLECT_FEE_STATUS = 'Fully Received',
--		  FEE_COLLECT_PAYMENT_MODE = @payment_mode

		
--          where 
--		  --DATEPART(MM,FEE_COLLECT_FEE_FROM_DATE) <= DATEPART(MM,@FEE_COLLECT_DATE)
--    --      and DATEPART(YYYY,FEE_COLLECT_FEE_FROM_DATE) <= DATEPART(YYYY,@FEE_COLLECT_DATE)  and 
--		  FEE_COLLECT_ID = @FEE_COLLECT_ID
--		  --and FEE_COLLECT_FEE_STATUS != 'Fully Received'
          
          
          
--          update FEE_COLLECT_DEF
--          set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE,
--			  FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS,
--			  FEE_COLLECT_DEF_ROYALTY_PAID = FEE_COLLECT_DEF_ROYALTY,
--			  FEE_COLLECT_DEF_STATUS = 'R'
--          where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID          

--		  declare @br_id_acct numeric = 0
--		  select @br_id_acct = (select STDNT_BR_ID from STUDENT_INFO where STDNT_ID = @FEE_COLLECT_STD_ID)
		  
--		  if dbo.get_advance_accounting (@br_id_acct) = 1		  
--		  BEGIN
--					  update TBL_VCH_MAIN set VCH_chequeNo = @FEE_COLLECT_CHEQUE_NO, VCH_date = @FEE_COLLECT_DATE where VCH_referenceNo = CAST(@FEE_COLLECT_ID as nvarchar(50))
				
--							--set @VCH_reference_no = CAST((@FEE_COLLECT_ID) as nvarchar(50))
--							--select @HD_ID = CAST((STDNT_HD_ID) as nvarchar(50)), @BR_ID = CAST((STDNT_BR_ID) as nvarchar(50)) from STUDENT_INFO where STDNT_ID = @FEE_COLLECT_STD_ID
--					  --set @count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)
--					  --set @VCH_MAIN_ID = (select top(1) VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST((@FEE_COLLECT_ID) as nvarchar(50)))

--					 -- while @i <= @count
--						--BEGIN

--						--		select @def_name = FEE_COLLECT_DEF_FEE_NAME, @fee_receieved = FEE_COLLECT_DEF_FEE, 
--						--		@arears = FEE_COLLECT_DEF_ARREARS, @VCH_reference_no = CAST((FEE_COLLECT_DEF_ID) as nvarchar(50))
--						--		from (select ROW_NUMBER() over(order by (select 0)) as sr, FEE_COLLECT_DEF_FEE_NAME, FEE_COLLECT_DEF_FEE, FEE_COLLECT_DEF_ARREARS, FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID)A where sr = @i
				
				
				
--						--		set @credit= @fee_receieved + @arears
--						--		set @debit = 0
--						--		--if @VCH_TYPE = 'Debit' 
--						--		--	begin
--						--		--		set @credit = @fee_receieved + @arears						
--						--		--	end
--						--		--ELSE 
--						--		--	begin
--						--		--		set @debit = @fee_receieved + @arears
--						--		--	end
				
				
--						--	select @accRefNo = COA_UID, @VCH_TYPE = COA_type from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
--						--	(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0
--						--	--reference number as tbl voucher def countID that is auto identity
--						--	set @VCH_reference_no = (select top(1) CAST(VCH_DEF_countID as nvarchar(50)) from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID  and VCH_DEF_COA = @accRefNo )

--						--	--set
				
--						--	-- student coaUID
--						--	set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_ID = (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @FEE_COLLECT_STD_ID ) )

--						--	set @datetime = GETDATE()
--						--	declare @is_profit_loss bit = (select CAST(1 as bit))
--						--		if @debit > 0 or @credit > 0
--						--		BEGIN
--						--			exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'U','',@datetime,'','','',@HD_ID, @BR_ID,0,@is_profit_loss,@accRefNo
--						--		END
--						--	set @i = @i + 1
--						--END
			
--			--By Calling New Store Procedure to use in When Fees Received through Cash in Hand, Cash at Bank and Multiple Cheques
--			exec sp_FEE_COLLLECT_DEFINATION_UPDATION_IN_ACCOUNT_INSERTION @FEE_COLLECT_ID


--						--if from front end cash in hand amount = -1 then all fees is collected in cash in hand
--						if @FEE_CASH_IN_HAND_AMOUNT = -1
--						BEGIN
--							set @FEE_CASH_IN_HAND_AMOUNT = @FEE_COLLECT_FEE + @FEE_COLLECT_ARREARS_RECEIVED + @LATE_FEE_FINE
--						END

--						if @FEE_CASH_AT_BANK_AMOUNT = -1
--						BEGIN
--							set @FEE_CASH_AT_BANK_AMOUNT = @FEE_COLLECT_FEE + @FEE_COLLECT_ARREARS_RECEIVED + @LATE_FEE_FINE
--						END

--						EXEC sp_FEE_COLLECTION_updation_ACCOUNTS_INSERTION @FEE_COLLECT_ID,	@FEE_CASH_IN_HAND_AMOUNT,  @FEE_CASH_AT_BANK_AMOUNT , @FEE_CASH_IN_HAND_CODE ,@FEE_CASH_AT_BANK_CODE ,'Multiple Cheques' --Due to correct the logic becuase from advance collection it will be 'Multiple Cheques'
--				END -- end advance accounting
         
--								--select @acc_total_fee = (FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED), @FEE_COLLECT_FEE_FROM_DATE = FEE_COLLECT_FEE_FROM_DATE,
--								--@FEE_COLLECT_FEE_TO_DATE = FEE_COLLECT_FEE_TO_DATE, @FEE_COLLECT_PLAN_ID = FEE_COLLECT_PLAN_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID
							
--								----  Fee Invoice Months insertion in debit
--								--set @debit = 0
--								--set @credit =@acc_total_fee
--								--set @fee_months_coa_name = 'Fee ' + (SELECT LEFT(DATENAME(month, @FEE_COLLECT_FEE_FROM_DATE),3)) + ' - ' + (SELECT LEFT(DATENAME(month, @FEE_COLLECT_FEE_TO_DATE),3)) + ' '+ (SELECT RIGHT(DATENAME(YEAR, @FEE_COLLECT_FEE_TO_DATE),2))
--								--set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_Name = @fee_months_coa_name and CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_isDeleted = 0)								
--								--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,'','I','',@datetime,'','','',@HD_ID, @BR_ID,0,0,''
								
							
--								----  Student Class Plan insertion in Credit
--								--set @VCH_DEF_COA = (select top(1) COA_UID from tbl_coa where COA_ID = (select top(1) CLASS_COA_ID from SCHOOL_PLANE where CLASS_ID = @FEE_COLLECT_PLAN_ID and COA_isDeleted = 0))
--								--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,'','I','',@datetime,'','','',@HD_ID, @BR_ID,0,0,''

--								----  Final Fee Bill insertion in Credit
--								--set @VCH_DEF_COA = (select top(1) COA_UID from tbl_coa where COA_Name = 'Final Fee Bill' and CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_isDeleted = 0)
--								--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,'','I','',@datetime,'','','',@HD_ID, @BR_ID,0,0,''

								
--								----cash in hand acccount insertion
--								--set @credit = @FEE_CASH_IN_HAND_AMOUNT
--								--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @FEE_CASH_IN_HAND_CODE,@debit,@credit,0,0,'','I','',@datetime,'','','',@HD_ID, @BR_ID,0,0,''

--								----cash at bank account insertion
--								--set @credit = @FEE_CASH_AT_BANK_AMOUNT
--								--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @FEE_CASH_AT_BANK_CODE,@debit,@credit,0,0,'','I','',@datetime,'','','',@HD_ID, @BR_ID,0,0,''
				

				
        
          
          
--          insert into FEE_HISTORY
--		  select FEE_COLLECT_ID,FEE_COLLECT_FEE,FEE_COLLECT_FEE_PAID,FEE_COLLECT_DATE_FEE_GENERATED,FEE_COLLECT_FEE_STATUS,FEE_COLLECT_ARREARS,FEE_COLLECT_NET_TOATAL,FEE_COLLECT_ARREARS_RECEIVED, '' from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID																
								
--			insert into FEE_HISTORY_DEF
--			select @FEE_COLLECT_ID, isnull(  (select max(FEE_HISTORY_ID) from FEE_HISTORY where FEE_HISTORY_PID = @FEE_COLLECT_ID),0),FEE_COLLECT_DEF_FEE_NAME,FEE_COLLECT_DEF_FEE,FEE_COLLECT_DEF_FEE_PAID,FEE_COLLECT_DEF_MIN,FEE_COLLECT_DEF_MAX,FEE_COLLECT_DEF_OPERATION,FEE_COLLECT_DEF_ARREARS,FEE_COLLECT_DEF_ARREARS_RECEIVED,FEE_COLLECT_DEF_TOTAL  from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID
			
--			declare @one int = 1
--          declare @COA_ACCOUNT nvarchar(50) = ''
--		  declare @Amount float = 0
--		  set @Amount = @FEE_COLLECT_FEE + @FEE_COLLECT_ARREARS_RECEIVED + @LATE_FEE_FINE

--						if @FEE_CASH_IN_HAND_AMOUNT > 0
--						BEGIN
--							set @COA_ACCOUNT = @FEE_CASH_IN_HAND_CODE							
--						END

--						if @FEE_CASH_AT_BANK_AMOUNT > 0
--						BEGIN
--							set @COA_ACCOUNT = @FEE_CASH_AT_BANK_CODE
--						END

--          insert into FEE_MULTIPLE_RECEIVED_AMOUNT 
--			select (select top(@one) BR_ADM_HD_ID from BR_ADMIN where BR_ADM_ID = @FEE_COLLECT_BR_ID), @FEE_COLLECT_BR_ID, @FEE_COLLECT_DATE, @COA_ACCOUNT, @Amount, @FEE_COLLECT_ID, (select top(@one) VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST((@FEE_COLLECT_ID) as nvarchar(50))), ''		
          
			
	          
	          	
--	 --INSERT INTO FEE_HISTORY							         
--		--		 VALUES
--		--			   (
--		--				@FEE_COLLECT_ID
--		--			   ,@FEE_COLLECT_FEE
--		--			   ,@FEE_COLLECT_FEE
--		--			   ,@FEE_COLLECT_DATE
--		--			   ,@FEE_COLLECT_FEE_STATUS
--		--			   ,@FEE_COLLECT_ARREARS_RECEIVED
--		--			   ,0
--		--			   ,@FEE_COLLECT_ARREARS_RECEIVED
--		--			   )	
	          
--  --        				set @histry_id = (select MAX(FEE_HISTORY_ID) from FEE_HISTORY)
--		--				set @count = (select COUNT(FEE_COLLECT_DEF_ID) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID )			
--		--				set @count = (select ISNULL( @count,0) )						
--		--				set @i = 1
--		--				while  @i <= @count				
--		--				begin							
--		--					with TBL_DEF (row,id,fee,arrear,name,[min],[max],operat)
--		--					as
--		--					(
--		--						select ROW_NUMBER() OVER(ORDER BY FEE_COLLECT_DEF_ID),FEE_COLLECT_DEF_ID,FEE_COLLECT_DEF_FEE,FEE_COLLECT_DEF_ARREARS,FEE_COLLECT_DEF_FEE_NAME,FEE_COLLECT_DEF_MIN,FEE_COLLECT_DEF_MAX,FEE_COLLECT_DEF_OPERATION from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID
--		--					)																			 							
						    
--		--				    insert into FEE_HISTORY_DEF(FEE_HISTORY_DEF_HID,FEE_HISTORY_DEF_PID,FEE_HISTORY_DEF_NAME,FEE_HISTORY_DEF_FEE,FEE_HISTORY_DEF_PAID,FEE_HISTORY_DEF_MIN,FEE_HISTORY_DEF_MAX,FEE_HISTORY_DEF_OPERATION,FEE_HISTORY_DEF_ARREARS,FEE_HISTORY_DEF_ARREARS_RECEIVED,FEE_HISTORY_DEF_TOTAL)												
--		--					select @FEE_COLLECT_ID,@histry_id,name,fee,fee,[min],[max],operat,arrear,arrear,0 from  TBL_DEF where row = @i
							
							
							
							
							
							
							
							
							
							
							
							
							
--							 --select id as id, fee as fee,arrear  as arrears,name as name,[min] as [min] ,[max] as [max],operat as operate from  TBL_DEF as NEW							 							 
--						--	set @histry_def_id = ( select Max(FEE_HISTORY_DEF_ID) from FEE_HISTORY_DEF);
							
--						--	with TBL_DEF2 (row,id)
--						--	as
--						--	(
--						--		select ROW_NUMBER() OVER(ORDER BY FEE_COLLECT_DEF_ID),FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_ID
--						--	)	
							
--						--	update  FEE_COLLECT_DEF
--						--set
--						--	FEE_COLLECT_DEF_FEE_PAID = ( select FEE_HISTORY_DEF_PAID from FEE_HISTORY_DEF where FEE_HISTORY_DEF_ID = @histry_def_id),
--						--	FEE_COLLECT_DEF_STATUS = 'R',
--						--	FEE_COLLECT_DEF_ARREARS_RECEIVED = ( select FEE_HISTORY_DEF_ARREARS_RECEIVED from FEE_HISTORY_DEF where FEE_HISTORY_DEF_ID = @histry_def_id),
--						--	FEE_COLLECT_DEF_TOTAL = 0				 
--						--	where FEE_COLLECT_DEF_ID = ( select id from TBL_DEF2 where row = @i )
						
						
						
							
--						--	set @i = @i + 1				 				
--						--end
			
			


--		select 'ok'