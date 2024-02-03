

CREATE PROC [dbo].[sp_CHEQUE_CLEARANCE_updation]

@CHEQUE_ID numeric,
@CHEQUE_CLEARANCE_DATE date,
@CHEQUE_REMARKS nvarchar(1000),
@IS_CLEARED_CHEQUES bit,
@STATUS nvarchar(50) = '',
@CHEQUE_COA_ACCOUNT nvarchar(50) = ''

AS

--declare @CHEQUE_ID numeric = 201

if @STATUS = 'R'--If only Remarks
BEGIN
	update CHEQUE_INFO set CHEQ_REMARKS = @CHEQUE_REMARKS, CHEQ_COA_ACCOUNT =@CHEQUE_COA_ACCOUNT  where CHEQ_ID = @CHEQUE_ID 
END

ELSE
BEGIN

DECLARE @ErrorToBeReturned varchar(1024);
 declare @tbl_fee_ids table(sr int identity(1,1),fee_id numeric)
 declare @count int = 0
 declare @i int = 1
 declare @total_std_cheque_amount float = 0
 declare @total_std_cheque_amount_from_advance_fee float = 0



 declare @percent_cheque float = 0
 declare @remaining_amount_cheques float = 0
 declare @due_amount_cheques float = 0
 declare @std_amount float = 0
 declare @cheque_amount float = 0 
 declare @COA_ACCOUNT nvarchar(50) = ''
--if (select COUNT(distinct f1.CHEQ_FEE_SUMMARY_ID) from CHEQ_FEE_INFO f1 where  f1.CHEQ_FEE_COLLECT_ID in (select f2.CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO f2  where f2.CHEQ_FEE_CHEQUE_ID = @CHEQUE_ID)) > 1
--BEGIN
--	SET @ErrorToBeReturned = 'Same Cheques Belong Multiple Term Fees'
--	return @ErrorToBeReturned
--END
--ELSE
--BEGIN
	insert into @tbl_fee_ids
	select distinct f1.CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO f1 where  f1.CHEQ_FEE_COLLECT_ID in (select f2.CHEQ_FEE_COLLECT_ID from CHEQ_FEE_INFO f2  where f2.CHEQ_FEE_CHEQUE_ID = @CHEQUE_ID)


			select @cheque_amount =  CHEQ_AMOUNT, @COA_ACCOUNT = CHEQ_COA_ACCOUNT from CHEQUE_INFO where CHEQ_ID = @CHEQUE_ID
			set @count = (select COUNT(*) from @tbl_fee_ids)

			if @IS_CLEARED_CHEQUES = 1
			BEGIN
				set @total_std_cheque_amount = (select SUM(FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids))  
				
				set @total_std_cheque_amount_from_advance_fee = (select SUM(ADV_FEE_BANK_AMOUNT_NOT_CLEARED) from FEE_ADVANCE where ADV_FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids))
			END
			ELSE
			BEGIN
				set @total_std_cheque_amount = (select SUM(FEE_COLLECT_NET_TOATAL - FEE_COLLECT_CASH_DEPOSITE - FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids))

				set @total_std_cheque_amount_from_advance_fee = (select SUM(ADV_FEE_AMOUNT) from FEE_ADVANCE where ADV_FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids))

			END

			set @percent_cheque =  @cheque_amount * 100 / @total_std_cheque_amount			
			set @remaining_amount_cheques = @cheque_amount


		IF @total_std_cheque_amount = @cheque_amount
		BEGIN
			if @IS_CLEARED_CHEQUES = 1 -- @IS_CLEARED_CHEQUES = 1 means checques is cleared then not cleared amount will be minus otherwise will be add
			BEGIN
				update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = 0 where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
				
			END
			ELSE
			BEGIN
				
				
				
					update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = FEE_COLLECT_NET_TOATAL - FEE_COLLECT_CASH_DEPOSITE where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
				--END
			END
		END
		ELSE IF @total_std_cheque_amount + @total_std_cheque_amount_from_advance_fee = @cheque_amount
		BEGIN
			
				if @IS_CLEARED_CHEQUES = 1 -- @IS_CLEARED_CHEQUES = 1 means checques is cleared then not cleared amount will be minus otherwise will be add
			BEGIN
				update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = 0 where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
				update FEE_ADVANCE set ADV_FEE_BANK_AMOUNT_NOT_CLEARED = 0 where ADV_FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
			END
			ELSE
			BEGIN
				--	set @i = 1
				--WHILE @i<= @count
				--BEGIN
					 
				
					update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = FEE_COLLECT_NET_TOATAL - FEE_COLLECT_CASH_DEPOSITE where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)

					update FEE_ADVANCE set ADV_FEE_BANK_AMOUNT_NOT_CLEARED = ADV_FEE_AMOUNT where ADV_FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids)
				--END
			END
		END


		ELSE
		BEGIN
			set @i = 1
			WHILE @i<= @count
			BEGIN
				if @IS_CLEARED_CHEQUES = 1
				BEGIN
					select @std_amount = FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids where sr  = @i)
				END	
				ELSE
				BEGIN
					select @std_amount = FEE_COLLECT_NET_TOATAL - FEE_COLLECT_CASH_DEPOSITE from FEE_COLLECT where FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids where sr  = @i)
				END
					
					if @i = @count
					BEGIN
						set @due_amount_cheques = @remaining_amount_cheques
					END
					ELSE
					BEGIN
						set @due_amount_cheques = (@percent_cheque * @std_amount) / 100
						set @due_amount_cheques = CAST(@due_amount_cheques as int) - (CAST(@due_amount_cheques as int) % 10)
					END

					if @IS_CLEARED_CHEQUES = 1
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT - @due_amount_cheques where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids where sr  = @i)
					END
					ELSE
					BEGIN
						update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT + @due_amount_cheques where  FEE_COLLECT_ID in (select fee_id from @tbl_fee_ids where sr  = @i)
					END

					set @remaining_amount_cheques = @remaining_amount_cheques - @due_amount_cheques

					set @i = @i  + 1
			END
		END

		if @IS_CLEARED_CHEQUES = 1
		BEGIN
			update CHEQUE_INFO set CHEQ_IS_CLEARED = 1,CHEQ_CLEARANCE_DATE = @CHEQUE_CLEARANCE_DATE,CHEQ_REMARKS = @CHEQUE_REMARKS,CHEQ_COA_ACCOUNT = @CHEQUE_COA_ACCOUNT where CHEQ_ID = @CHEQUE_ID
			
			declare @fee_ids nvarchar(500) = ''
			
			select @fee_ids = CHEQ_FEE_SUM_FEE_IDS from CHEQ_FEE_SUMMARY where CHEQ_FEE_SUM_ID = (select top(1) CHEQ_FEE_SUMMARY_ID from CHEQ_FEE_INFO where CHEQ_FEE_CHEQUE_ID = @CHEQUE_ID)
			
			
			declare @vch_main_id nvarchar(50) = ''

			EXEC sp_FE_COLLECT_MULTIPLE_CHEQUES_CASH_INSERTION_IN_ACCOUNTS_VOUCHER @CHEQUE_CLEARANCE_DATE,@fee_ids,@cheque_amount, 'Multiple Cheques Received',@COA_ACCOUNT,@CHEQUE_ID,@vch_main_id

		END
		ELSE
		BEGIN
			update CHEQUE_INFO set CHEQ_IS_CLEARED = 0,CHEQ_CLEARANCE_DATE = @CHEQUE_CLEARANCE_DATE,CHEQ_REMARKS = @CHEQUE_REMARKS, CHEQ_COA_ACCOUNT = @CHEQUE_COA_ACCOUNT where CHEQ_ID = @CHEQUE_ID

			delete from TBL_VCH_DEF where VCH_MAIN_ID in (select VCH_MAIN_ID from TBL_VCH_MAIN where VCH_chequeNo = CAST(@CHEQUE_ID as nvarchar(50)) )
			delete from TBL_VCH_MAIN where VCH_chequeNo = CAST(@CHEQUE_ID as nvarchar(50))
		END

--update FEE_COLLECT set FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = 0
--where FEE_COLLECT_ID = @FEE_COLLECT_ID

END