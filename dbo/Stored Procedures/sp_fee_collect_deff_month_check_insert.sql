

CREATE procedure [dbo].[sp_fee_collect_deff_month_check_insert]
	 @FEE_COLLECT_HD_ID numeric,
	 @FEE_COLLECT_BR_ID numeric,
	 @crrnt_month int,
	 @mounth_diff2 int,
	 @idd_def numeric,
	 @def_name int,
	 @def_fee float,
	 @FEE_COLLECT_MONTHS float,
	 @VCH_MAIN_ID nvarchar(50),
	 @DISCOUNT_RULE_ID numeric,
	 @INVOICE_ID numeric 
	 
	 

as begin
	--	Declare @FEE_COLLECT_HD_ID numeric = 2
	-- Declare @FEE_COLLECT_BR_ID numeric =10011
	-- Declare @crrnt_month int = 10
	-- Declare @mounth_diff2 int = 1
	-- Declare @idd_def numeric = 467070
	-- Declare @def_name int = 10109
	-- Declare @def_fee float = 5600
	--declare @FEE_COLLECT_MONTHS float = 1,
	-- @VCH_MAIN_ID nvarchar(50) = 'SI-0001',
	-- @DISCOUNT_RULE_ID numeric = 0,
	-- @INVOICE_ID numeric = 27921
	
	
	--Declare @FEE_COLLECT_DEF_ID numeric
	--Declare @FEE_COLLECT_DEF_FEE_NAME nvarchar(50)
	--Declare @FEE_COLLECT_DEF_FEE float
	
	declare @total_fee float = 0
	Declare @def_info_id numeric
	Declare @fee_type nvarchar(20)
	Declare @fee_months nvarchar(50)
	Declare @count int = 1
	Declare @month int	
	declare @count_differ_month int = 1
	declare @operator char(1) = ''
	declare @std_id int = 0
	declare @fees_per_month float = 0
	declare @is_once_paid char(1) = ''
	declare @VCH_DEF_COA nvarchar(50) = ''
	declare @VCH_TYPE nvarchar(50) = ''
	declare @debit float = 0
	declare @credit float = 0
	declare @VCH_reference_no nvarchar(50) = ''
	declare @datetime datetime = ''
	declare @HD_ID nvarchar(50) = ''
	declare @BR_ID nvarchar(50) = ''
	declare @std_fee_plan_def_id numeric = 0


	set @HD_ID = CAST((@FEE_COLLECT_HD_ID) as nvarchar(50))
	set @BR_ID = CAST((@FEE_COLLECT_BR_ID) as nvarchar(50))
		--set @FEE_COLLECT_DEF_ID = ( select MAX(FEE_COLLECT_DEF_ID) from FEE_COLLECT_DEF)
		--set @FEE_COLLECT_DEF_FEE_NAME = (select FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @FEE_COLLECT_DEF_ID )		
		--set @FEE_COLLECT_DEF_FEE = ( select FEE_COLLECT_DEF_FEE from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @FEE_COLLECT_DEF_ID )
		
		--set @def_info_id = ( select FEE_ID from FEE_INFO where FEE_HD_ID = @FEE_COLLECT_HD_ID and FEE_BR_ID = @FEE_COLLECT_BR_ID and FEE_NAME = @def_name )			
		set @def_info_id = @def_name
		set @fee_type = ( select Fee_TYPE from FEE_INFO where FEE_ID = @def_info_id )
		set @fee_months = ( select FEE_MONTHS from FEE_INFO where FEE_ID = @def_info_id )		
		select @VCH_DEF_COA = COA_UID, @VCH_TYPE = COA_type from TBL_COA where  CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
		(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0

		

		--declare @discount_prcnt float =  (select DIS_RUL_DEF_DISCOUNT from DISCOUNT_RULES_DEF where DIS_RUL_DEF_PID = @DISCOUNT_RULE_ID and DIS_RUL_DEF_FEE_ID = @def_name)		
		--set @discount_prcnt = ISNULL(@discount_prcnt,0)
		--declare @discount_amount float = 0


				set @std_id	= (select top(1) FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID in (select top(1) FEE_COLLECT_DEF_PID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @idd_def))
				select top(1) @is_once_paid = PLAN_FEE_IS_ONCE_PAID, @std_fee_plan_def_id = PLAN_FEE_DEF_ID  from PLAN_FEE_DEF where PLAN_FEE_DEF_FEE_NAME = @def_name  and PLAN_FEE_DEF_STATUS = 'T'
				and   PLAN_FEE_DEF_PLAN_ID in (select STDNT_CLASS_FEE_ID from STUDENT_INFO where STDNT_ID = @std_id)
				set @is_once_paid = ISNULL(@is_once_paid, 'N')


			if (select FEE_NAME from FEE_INFO where FEE_ID = @def_name) = 'Scholarship Withdrawal' and @def_fee > 0
			BEGIN
				declare @PID numeric = 0
				declare @class_id numeric = 0
				
				set @PID = (select top(1) FEE_COLLECT_DEF_PID from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @idd_def)
				set @class_id = (select top(1) FEE_COLLECT_PLAN_ID from FEE_COLLECT where FEE_COLLECT_ID =@PID)
				
				if (select FEE_COLLECT_DEF_ARREARS from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @idd_def) = 0
				BEGIN
					delete from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @idd_def
				END
				ELSE
				BEGIN
					update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = 0 where FEE_COLLECT_DEF_ID =@idd_def
				END

				--First Supplementry Bills was pending at a time one
				--if (select COUNT(*) from SCHOLARSHIP_GENERATION where SCH_GEN_STD_ID = @std_id and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_CLASS_ID = @class_id) > 0
				--BEGIN
				--	update SCHOLARSHIP_GENERATION set SCH_GEN_FEE_COLLECT_ID = @PID, SCH_GEN_VCH_MAIN_ID = @VCH_MAIN_ID, SCH_GEN_VCH_DEF_COA = @VCH_DEF_COA, SCH_GEN_FEE = SCH_GEN_FEE + @def_fee 
				--	where SCH_GEN_STD_ID = @std_id and SCH_GEN_IS_CLEARED = 0 and SCH_GEN_CLASS_ID = @class_id
				--END
				--ELSE
				--BEGIN
					insert into SCHOLARSHIP_GENERATION
					select @FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID, @std_id, @PID, @def_info_id,@class_id, @VCH_MAIN_ID, @VCH_DEF_COA, @def_fee, 0,0,0,'','','',''
				--END

			END

			ELSE
			BEGIN
				if @fee_type = 'Yearly' or @fee_type = 'Custom' or @fee_type = 'Custom Once'
																																												begin
					while @count < (select LEN(@fee_months))
						begin
						
							  --select CONVERT(int, ( (select SUBSTRING(@fee_months,@count,2)) ) ) 
							  
						set @month = ( select convert(int, (select SUBSTRING(@fee_months,@count,2)) ) )
						set @count_differ_month = 1
								while @count_differ_month <= @mounth_diff2
									begin
										--if @crrnt_month - @mounth_diff2 + @count_differ_month = @month --due to left side is equal to 0 it means it is 12
										declare @fee_month_calculated int = 0
										set @fee_month_calculated = @crrnt_month - @mounth_diff2 + @count_differ_month
											if @fee_month_calculated = 0
												set @fee_month_calculated = 12
											if @fee_month_calculated = @month
											begin				
												--select @crrnt_month
												if @fee_type = 'Custom Once'
												BEGIN
													if @is_once_paid = 'F'
													BEGIN
														set @total_fee = @total_fee + @def_fee
													END
												END
												ELSE
												BEGIN
													set @total_fee = @total_fee + @def_fee
												END
												--break;
											end
										
										--else
				--escape by me						--	begin
										--		set @def_fee = 0.0;
										--	end
										set @count_differ_month = @count_differ_month + 1
										
									end
						set @count = @count + 3
						end
				
				--set @fees_per_month = ISNULL((select BR_ADM_FEES_PER_MONTHS from BR_ADMIN where BR_ADM_ID = @FEE_COLLECT_BR_ID),1)
				
			end -- end != monthly loop
			
				else if @fee_type = 'Monthly'
							begin
				set @total_fee = @def_fee * @mounth_diff2 *	@FEE_COLLECT_MONTHS		-- @FEE_COLLECT_MONTHS variable is month fees count e.g NGS is 1.2
			end
			
				else if @fee_type = 'Once' and @is_once_paid = 'F'
				BEGIN
					set @total_fee = @def_fee 	
					update PLAN_FEE_DEF set PLAN_FEE_IS_ONCE_PAID = 'T' where PLAN_FEE_DEF_ID = @std_fee_plan_def_id
				END
			
				
					--if @mounth_diff2 = 0
					--begin
					--	set @mounth_diff2 = 1
					--end
				
					--select @total_fee
					select @operator = FEE_COLLECT_DEF_OPERATION from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @idd_def
					if @operator = '-'
					begin
						if (select FEE_NAME from FEE_INFO where FEE_ID = @def_name) = 'Discount' 
						BEGIN
							update FEE_COLLECT_DEF set @total_fee = FEE_COLLECT_DEF_FEE = FEE_COLLECT_DEF_ARREARS, FEE_COLLECT_DEF_ARREARS = 0 where FEE_COLLECT_DEF_ID = @idd_def
						END
						ELSE
						BEGIN
							set @total_fee = (select isnull(ROUND(@total_fee,0),0))
							update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE =  @total_fee  where FEE_COLLECT_DEF_ID = @idd_def
						END

						set @VCH_TYPE = 'Debit' 
					end
					ELSE
					BEGIN
				
						set @total_fee = (select isnull(ROUND(@total_fee,0),0))
						--set @discount_amount = ((@total_fee * @discount_prcnt) / 100)
						--set @total_fee = @total_fee
						update FEE_COLLECT_DEF
						--set FEE_COLLECT_DEF_FEE = @def_fee 	 * (@mounth_diff2) 			escape by me  	
						set FEE_COLLECT_DEF_FEE = @total_fee	  	
						where FEE_COLLECT_DEF_ID = @idd_def
					END
					--declare @discount_fee_id numeric = 0
					--set @discount_fee_id = (select ID from VFEE_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID and Name = 'Discount' and [Status] = 'T')
					--set @discount_fee_id = ISNULL(@discount_fee_id,0)
				
					--update FEE_COLLECT_DEF set FEE_COLLECT_DEF_FEE = FEE_COLLECT_DEF_FEE + @discount_amount, FEE_COLLECT_DEF_TOTAL = FEE_COLLECT_DEF_TOTAL + @discount_amount
					--where FEE_COLLECT_DEF_PID = @INVOICE_ID and FEE_COLLECT_DEF_FEE_NAME = @discount_fee_id

					update FEE_COLLECT set FEE_COLLECT_FEE = FEE_COLLECT_FEE, FEE_COLLECT_NET_TOATAL = FEE_COLLECT_NET_TOATAL
					where FEE_COLLECT_ID = @INVOICE_ID
					if @VCH_TYPE = 'Debit' 
						begin
							set @debit = @total_fee 
						end
					ELSE 
						begin
							set @credit = @total_fee
						end
					
				
					if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1

					BEGIN
						set @datetime = GETDATE()
						set @VCH_reference_no = CAST((@idd_def) as nvarchar(50))
						set @HD_ID = CAST((@FEE_COLLECT_HD_ID) as nvarchar(50))
						set @BR_ID = CAST((@FEE_COLLECT_BR_ID) as nvarchar(50))
						exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID, @BR_ID,0,1,''
					END

				END
				--update FEE_COLLECT_DEF
				--set FEE_COLLECT_DEF_FEE = 0					  	
				--where FEE_COLLECT_DEF_ID = @idd_def
				--and FEE_COLLECT_DEF_FEE_NAME = 'Late Fee Fine'
				
	
	
				
	

	
end