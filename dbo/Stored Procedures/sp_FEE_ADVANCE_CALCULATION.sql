
CREATE PROC [dbo].[sp_FEE_ADVANCE_CALCULATION]

	@STD_ID numeric,
	@FROM_DATE date,
	@TO_DATE date,
	@Is_Update_Fee_Collect_Table bit = 1
AS




declare @advance_fee_amount float = 0
declare @invoice_id numeric
declare @std_current_fee float = 0
declare @std_arrears float = 0
declare @std_total_fee_paid_amount float = 0
declare @fee_def_id float = 0
declare @fee_def_amount float = 0
declare @advance_fee_adjust float = 0
declare @advance_fee_adjust_remaining float = 0
declare @j int = 1
declare @count int = 0
declare @date date
declare @advance_fee_id numeric



set @advance_fee_amount = (select SUM(ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST) from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 )

if @advance_fee_amount > 0
BEGIN
	set @invoice_id = (select top(1) FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID order by FEE_COLLECT_ID DESC)
	select @std_current_fee = FEE_COLLECT_FEE, @std_arrears = FEE_COLLECT_ARREARS from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id



	if @Is_Update_Fee_Collect_Table = 1 --This store procedure used in fee_collect insertion and in fee_collection_multiple_Cheques and in multiple cheques there is no need to update fee_Collect and fee_Collect def table values because in cash amount fee advance amount is added so there is condition
	BEGIN
		if @advance_fee_amount >= @std_current_fee + @std_arrears
		BEGIN
			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Fully Received' where FEE_COLLECT_ID = @invoice_id
		END
		else if @advance_fee_amount = @std_current_fee
		BEGIN
			update FEE_COLLECT set  FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
		END
		else
		BEGIN
			if @advance_fee_amount >= @std_arrears
			BEGIN
				update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = @advance_fee_amount - FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
			END
			ELSE
			BEGIN
				update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = @advance_fee_amount, FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
			END

		END --ELse
	END --If Condition @Is_Update_Fee_Collect_Table 


	--if @advance_fee_amount <= @std_current_fee + @std_arrears
	--BEGIN
	--	set @advance_fee_adjust_remaining = 0
	--END
	--ELSE
	--BEGIN
	--	set @advance_fee_adjust_remaining = @advance_fee_amount - (@std_current_fee + @std_arrears)
	--END

	set @advance_fee_adjust_remaining = (select FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id)

	--(select FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id)

	--set @count = (select COUNT(*) from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 order by  ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST)
	
	WHILE @advance_fee_adjust_remaining > 0
	BEGIN
		select @advance_fee_id = ADV_FEE_ID, @advance_fee_adjust = ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST from (select ROW_NUMBER() over(order by (ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST))  as sr,* from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 )A where sr = @j
		
		--if @advance_fee_adjust_remaining >= @advance_fee_adjust
		--BEGIN
			update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST + @advance_fee_adjust where ADV_FEE_ID = @advance_fee_id
			set @date = GETDATE()

			EXEC sp_FEE_ADVANCE_DEF_insertion @advance_fee_id,@date,@date,@advance_fee_adjust,@date,@invoice_id,'T'
		--END
		--ELSE
		--BEGIN
		--	update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST + @advance_fee_adjust where ADV_FEE_ID = @advance_fee_id
		--	set @date = GETDATE()

		--	EXEC sp_FEE_ADVANCE_DEF_insertion @advance_fee_id,@date,@date,@advance_fee_adjust,@date,@invoice_id,'T'
		--END


		set @advance_fee_adjust_remaining = @advance_fee_adjust_remaining - @advance_fee_adjust

		

		set @j = @j + 1
	END


	if @Is_Update_Fee_Collect_Table = 1
	BEGIN
	-- update fee_collect_def arrears
				 select @std_total_fee_paid_amount = (FEE_COLLECT_ARREARS_RECEIVED) from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id
				 
				 set @j = 1
				 WHILE @std_total_fee_paid_amount > 0
				 BEGIN
					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_ARREARS from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_ARREARS ) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_ARREARS > 0 and FEE_COLLECT_DEF_OPERATION = '+' )A where sr = @j

					if @std_total_fee_paid_amount > @fee_def_amount
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_ID = @fee_def_id 

							set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
						END
						ELSE
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
							set @std_total_fee_paid_amount = 0
						END

					set @j = @j + 1
				 END



				-- update fee_collect_def 
				 select @std_total_fee_paid_amount = (FEE_COLLECT_FEE_PAID) from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id
				 
				 set @j = 1
				 WHILE @std_total_fee_paid_amount > 0
				 BEGIN
					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_FEE from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_FEE ) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_OPERATION = '+' )A where sr = @j

					if @std_total_fee_paid_amount > @fee_def_amount
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_ID = @fee_def_id 

							set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
						END
						ELSE
						BEGIN
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
							set @std_total_fee_paid_amount = 0
						END

					set @j = @j + 1
				 END

	END	 --if @Is_Update_Fee_Collect_Table = 1


END


--The logic is when Fee Advance is adjust to Fee Collect table ThenBank Amount not cleared in bank is also transfered to Fee_Collect and Minus from  advance Fee But this logic is creating problem to Cheque clearance as it is when moved to Fee Collect table then detecting how much amount is transfered to Fee Collect

--declare @advance_fee_amount float = 0
--declare @invoice_id numeric
--declare @std_current_fee float = 0
--declare @std_arrears float = 0
--declare @std_total_fee_paid_amount float = 0
--declare @fee_def_id float = 0
--declare @fee_def_amount float = 0
--declare @advance_fee_adjust float = 0
--declare @advance_fee_adjust_remaining float = 0
--declare @j int = 1
--declare @count int = 0
--declare @date date
--declare @advance_fee_id numeric
--declare @not_cleared_bank_amount float = 0
--declare @not_cleared_bank_amount_individual float = 0
--declare @remaining_not_cleared_bank_amount float = 0


-- select @advance_fee_amount = SUM(ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST), @not_cleared_bank_amount = SUM(ADV_FEE_BANK_AMOUNT_NOT_CLEARED) from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 

--if @advance_fee_amount > 0
--BEGIN
--	set @invoice_id = (select top(1) FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID order by FEE_COLLECT_ID DESC)
--	select @std_current_fee = FEE_COLLECT_FEE, @std_arrears = FEE_COLLECT_ARREARS from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id

--	if @advance_fee_amount >= @std_current_fee + @std_arrears
--	BEGIN
--		if @not_cleared_bank_amount > @std_current_fee + @std_arrears
--		BEGIN
--			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE,  FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @std_current_fee + @std_arrears ,FEE_COLLECT_FEE_STATUS = 'Fully Received' where FEE_COLLECT_ID = @invoice_id

--			--Remaining not cleared bank amount will be set in WHILE Loop
--			set @remaining_not_cleared_bank_amount = @std_current_fee + @std_arrears

--		END
--		ELSE
--		BEGIN
--			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE,  FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @not_cleared_bank_amount ,FEE_COLLECT_FEE_STATUS = 'Fully Received' where FEE_COLLECT_ID = @invoice_id
--		END
		
--	END
--	else if @advance_fee_amount = @std_current_fee
--	BEGIN
--		update FEE_COLLECT set  FEE_COLLECT_FEE_PAID = FEE_COLLECT_FEE, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @not_cleared_bank_amount ,FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
--	END
--	else
--	BEGIN
--		if @advance_fee_amount >= @std_arrears
--		BEGIN
--			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = FEE_COLLECT_ARREARS, FEE_COLLECT_FEE_PAID = @advance_fee_amount - FEE_COLLECT_ARREARS, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @not_cleared_bank_amount, FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
--		END
--		ELSE
--		BEGIN
--			update FEE_COLLECT set FEE_COLLECT_ARREARS_RECEIVED = @advance_fee_amount, FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT = @not_cleared_bank_amount ,FEE_COLLECT_FEE_STATUS = 'Partially Received' where FEE_COLLECT_ID = @invoice_id
--		END

--	END

--	-- IF zero means @remaining_not_cleared_bank_amount is set as @std_current_fee + @std_arrears
--	if @remaining_not_cleared_bank_amount = 0
--	BEGIN
--		set @remaining_not_cleared_bank_amount = @not_cleared_bank_amount

--	END
	
	 
--	set @advance_fee_adjust_remaining = (select FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id)

--	--set @count = (select COUNT(*) from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 order by  ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST)
	
--	WHILE @advance_fee_adjust_remaining > 0
--	BEGIN
--		select @advance_fee_id = ADV_FEE_ID, @advance_fee_adjust = ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST,@not_cleared_bank_amount_individual = ADV_FEE_BANK_AMOUNT_NOT_CLEARED from (select ROW_NUMBER() over(order by (ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST))  as sr,* from FEE_ADVANCE where ADV_FEE_STD_ID = @STD_ID and ADV_FEE_STATUS = 'T' and ADV_FEE_AMOUNT - ADV_FEE_AMOUNT_ADJUST > 0 )A where sr = @j
		
--		--if @advance_fee_adjust_remaining >= @advance_fee_adjust
--		--BEGIN
--		if @not_cleared_bank_amount_individual > 0
--		BEGIN
--			if @remaining_not_cleared_bank_amount >= @not_cleared_bank_amount_individual
--			BEGIN
--				set @remaining_not_cleared_bank_amount = @remaining_not_cleared_bank_amount - @not_cleared_bank_amount_individual 
--			END
--			ELSE
--			BEGIN
--				set @not_cleared_bank_amount_individual = @remaining_not_cleared_bank_amount
--				set @remaining_not_cleared_bank_amount = 0
				
--			END

--		END
--			update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST + @advance_fee_adjust, ADV_FEE_BANK_AMOUNT_NOT_CLEARED = ADV_FEE_BANK_AMOUNT_NOT_CLEARED - @not_cleared_bank_amount_individual where ADV_FEE_ID = @advance_fee_id
--			set @date = GETDATE()

--			EXEC sp_FEE_ADVANCE_DEF_insertion @advance_fee_id,@date,@date,@advance_fee_adjust,@date,@invoice_id,'T'
--		--END
--		--ELSE
--		--BEGIN
--		--	update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST + @advance_fee_adjust where ADV_FEE_ID = @advance_fee_id
--		--	set @date = GETDATE()

--		--	EXEC sp_FEE_ADVANCE_DEF_insertion @advance_fee_id,@date,@date,@advance_fee_adjust,@date,@invoice_id,'T'
--		--END


--		set @advance_fee_adjust_remaining = @advance_fee_adjust_remaining - @advance_fee_adjust

		

--		set @j = @j + 1
--	END


--	-- update fee_collect_def arrears
--				 select @std_total_fee_paid_amount = (FEE_COLLECT_ARREARS_RECEIVED) from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id
				 
--				 set @j = 1
--				 WHILE @std_total_fee_paid_amount > 0
--				 BEGIN
--					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_ARREARS from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_ARREARS ) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_ARREARS > 0 and FEE_COLLECT_DEF_OPERATION = '+' )A where sr = @j

--					if @std_total_fee_paid_amount > @fee_def_amount
--						BEGIN
--							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = FEE_COLLECT_DEF_ARREARS where FEE_COLLECT_DEF_ID = @fee_def_id 

--							set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
--						END
--						ELSE
--						BEGIN
--							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_ARREARS_RECEIVED = @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
--							set @std_total_fee_paid_amount = 0
--						END

--					set @j = @j + 1
--				 END



--				-- update fee_collect_def 
--				 select @std_total_fee_paid_amount = (FEE_COLLECT_FEE_PAID) from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id
				 
--				 set @j = 1
--				 WHILE @std_total_fee_paid_amount > 0
--				 BEGIN
--					select @fee_def_id = FEE_COLLECT_DEF_ID, @fee_def_amount = FEE_COLLECT_DEF_FEE from (select ROW_NUMBER() over(order by FEE_COLLECT_DEF_FEE ) as sr,* from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id and FEE_COLLECT_DEF_FEE > 0 and FEE_COLLECT_DEF_OPERATION = '+' )A where sr = @j

--					if @std_total_fee_paid_amount > @fee_def_amount
--						BEGIN
--							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_ID = @fee_def_id 

--							set @std_total_fee_paid_amount = @std_total_fee_paid_amount - @fee_def_amount
--						END
--						ELSE
--						BEGIN
--							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = @std_total_fee_paid_amount where FEE_COLLECT_DEF_ID = @fee_def_id 
--							set @std_total_fee_paid_amount = 0
--						END

--					set @j = @j + 1
--				 END

				 


--END
















--Previous Store Procedure

----declare @STD_ID numeric = 1
----declare @FROM_DATE date ='2014-04-01'
----declare @TO_DATE date = '2014-05-10'

--declare @invoice_id numeric = 0
--set @invoice_id = ISNULL((select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID and FEE_COLLECT_FEE_FROM_DATE = @FROM_DATE and FEE_COLLECT_FEE_TO_DATE = @TO_DATE),0)



--declare @last_def_id_from_date date = ''
--declare @last_def_id_to_date date = ''
--declare @last_def_id_date date = ''
--declare @PID numeric = 0
--declare @DEF_ID numeric = 0
--declare @DEF_ID_LAST numeric = 0
--declare @advance_fee float = 0
--declare @due_fee float

--select @advance_fee = SUM(Amount), @PID = MAX(PID), @DEF_ID = MAX(ID) from 
--(
--select * from VFEE_ADVANCE_DEF where [From Date] between @FROM_DATE and @TO_DATE and PID in (select ID from VFEE_ADVANCE where [Std ID] = @STD_ID)
--union
--select * from VFEE_ADVANCE_DEF where [To Date] between @FROM_DATE and @TO_DATE and PID in (select ID from VFEE_ADVANCE where [Std ID] = @STD_ID)
--)A
--set @advance_fee = ISNULL(@advance_fee,0)
 

--if @advance_fee > 0
--begin

--	set @due_fee = ISNULL((select FEE_COLLECT_FEE from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id),0)
--	select top(1) @DEF_ID_LAST = ADV_FEE_DEF_ID, @last_def_id_from_date = ADV_FEE_DEF_FROM_DATE, @last_def_id_to_date = ADV_FEE_DEF_TO_DATE, @last_def_id_date = ADV_FEE_DEF_TO_DATE from FEE_ADVANCE_DEF where ADV_FEE_DEF_PID = @PID order by ADV_FEE_DEF_ID DESC

--		declare @today_date date = GETDATE()	
--		declare @remaining_fee float = 0
--		declare @def_fee_count int = 0
--		declare @i int = 1
--		declare @def_fee_id int = 0
--		set @remaining_fee = @advance_fee

--	if @due_fee > @advance_fee
--	begin
		
--		update FEE_COLLECT set FEE_COLLECT_DATE_FEE_RECEIVED = @today_date, FEE_COLLECT_FEE_PAID = @advance_fee,
--		FEE_COLLECT_FEE_STATUS = 'Partially Received'
--		where FEE_COLLECT_ID = @invoice_id
--		set @def_fee_count = (select COUNT(*) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id)
		
--		while @i <= @def_fee_count
--		begin
--			select @def_fee_id = FEE_COLLECT_DEF_ID from (select ROW_NUMBER() over (order by (select 0)) as sr, FEE_COLLECT_DEF_ID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @invoice_id)A where sr = @i
--			if @remaining_fee > 0
--			begin
--				declare @fee_def_fee float = 0
--				select @fee_def_fee = FEE_COLLECT_DEF_FEE from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @def_fee_id
--				if @remaining_fee >= @fee_def_fee
--				begin
--					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_ID = @def_fee_id
--					set @remaining_fee = @remaining_fee - @fee_def_fee
--				end
--				else
--				begin
--					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = @remaining_fee where FEE_COLLECT_DEF_ID = @def_fee_id
--					set @remaining_fee = 0
--				end				
--			end
--			set @i = @i + 1
--		end
		
		
		
		
		
		
		
--		--add ic curent month from the last month
--		--if @DEF_ID != @DEF_ID_LAST
--		--begin
--		--	update FEE_ADVANCE_DEF set ADV_FEE_DEF_AMOUNT = ADV_FEE_DEF_AMOUNT + @due_fee - @advance_fee where ADV_FEE_DEF_ID = @DEF_ID
			
--		--end
--	end
--	else if @due_fee < @advance_fee
--	begin
--		if @DEF_ID = @DEF_ID_LAST
--		begin 			
 			
-- 			insert into FEE_ADVANCE_DEF VALUES( @PID,@last_def_id_from_date, @last_def_id_to_date, @advance_fee - @due_fee, @last_def_id_date, 'F')
--		end
--		else select * from FEE_ADVANCE_DEF
--		begin
--			update FEE_ADVANCE_DEF set ADV_FEE_DEF_AMOUNT = ADV_FEE_DEF_AMOUNT + @advance_fee - @due_fee where ADV_FEE_DEF_ID = @DEF_ID_LAST
--		end	
--		update FEE_ADVANCE_DEF set ADV_FEE_DEF_AMOUNT = ADV_FEE_DEF_AMOUNT - @advance_fee + @due_fee where ADV_FEE_DEF_ID = @DEF_ID_LAST	
--		update FEE_COLLECT set FEE_COLLECT_DATE_FEE_RECEIVED = @today_date, FEE_COLLECT_FEE_PAID = @due_fee, FEE_COLLECT_FEE_STATUS = 'Fully Received'
--		where FEE_COLLECT_ID = @invoice_id
--		update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @invoice_id
--	end
--	else
--	begin
--		update FEE_COLLECT set FEE_COLLECT_DATE_FEE_RECEIVED = @today_date, FEE_COLLECT_FEE_PAID = @advance_fee , FEE_COLLECT_FEE_STATUS = 'Fully Received'
--		where FEE_COLLECT_ID = @invoice_id
--		update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE_PAID = FEE_COLLECT_DEF_FEE where FEE_COLLECT_DEF_PID = @invoice_id
--	end

--	update FEE_ADVANCE_DEF set ADV_FEE_DEF_STATUS = 'T' where ADV_FEE_DEF_ID in 
--	(select ID from 
--	(
--	select * from VFEE_ADVANCE_DEF where [From Date] between @FROM_DATE and @TO_DATE and PID in (select ID from VFEE_ADVANCE where [Std ID] = @STD_ID)
--	union
--	select * from VFEE_ADVANCE_DEF where [To Date] between @FROM_DATE and @TO_DATE and PID in (select ID from VFEE_ADVANCE where [Std ID] = @STD_ID)
--	)A)

--END