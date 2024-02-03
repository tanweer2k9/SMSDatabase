CREATE procedure [dbo].[sp_func_get_complete_deduction_amount]

		 @STAFF_SALLERY_STAFF_ID numeric,		 
		 @STAFF_SALLERY_DEFF_MAX numeric,
		 @STAFF_DEFF_ID numeric,
		 @crrnt_date date,
		 @per_day_salary float,
		 @STAFF_SALLERY_HD_ID numeric,
		 @STAFF_SALLERY_BR_ID numeric,
		 @idd_def numeric,
		 @VCH_MAIN_ID nvarchar(50)

		 
		 
as 
begin		
		
		 --declare @STAFF_SALLERY_STAFF_ID numeric = 1
		 --declare @STAFF_SALLERY_DEFF_MAX numeric = 3529
		 --declare @STAFF_DEFF_ID numeric = 1
		 --declare @crrnt_date date  = '2013-10-01'
		 --declare @per_day_salary float = 221

		declare @crrnt_month int
		declare @VALUE_TYPE nvarchar(20)
		declare @ded_months nvarchar(40)
		Declare @count int = 1
		Declare @month int = 0
		declare @amount float = 0
		declare @amount_school float = 0
		declare @basic_salary float
		declare @crrnt_year int
		declare @deduct_stat char(1)				
		declare @amount_type nvarchar(20)
		declare @monthly_type nvarchar(20)
		 
		declare @VCH_reference_no nvarchar(50) = ''
		declare @datetime datetime = ''
		declare @HD_ID nvarchar(50) = ''
		declare @BR_ID nvarchar(50) = ''
		declare @VCH_DEF_COA nvarchar(50) = ''
		declare @VCH_TYPE nvarchar(50) = ''
		declare @debit float = 0
		declare @credit float = 0
		



		set @datetime = GETDATE()
		set @VCH_reference_no = CAST((@idd_def) as nvarchar(50))
		set @HD_ID = CAST((@STAFF_SALLERY_HD_ID) as nvarchar(50))
		set @BR_ID = CAST((@STAFF_SALLERY_BR_ID) as nvarchar(50))

		set @crrnt_month = ( select DATEPART(MM,@crrnt_date) )
		set @crrnt_year = ( select DATEPART(yyyy,@crrnt_date) )
		
		
		select @VCH_DEF_COA = COA_UID, @VCH_TYPE = COA_type from TBL_COA where  CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
		(select DEDUCTION_NAME from DEDUCTION where DEDUCTION_ID = @STAFF_DEFF_ID) and COA_isDeleted = 0

					set @VALUE_TYPE = (select STAFF_DEDUCTION_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
					and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')											
					set @ded_months = (select STAFF_DEDUCTION_MONTHS from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
					and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
					set @deduct_stat = (select STAFF_DEDUCTION_REFUNDABLE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
					and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
					set @monthly_type = (select STAFF_DEDUCTION_VAL_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
					and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
						set @amount = 0						
						--if @monthly_type = 'Monthly'
						--begin
						--	set @ded_months = '01,02,03,04,05,06,07,08,09,10,11,12'
						--end
						
						if @VALUE_TYPE != 'Fixed'
						begin
								
									if @monthly_type = 'Monthly'
										begin
											set @amount_type = (select STAFF_DEDUCTION_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
																		--select @amount_type amount_type
																		set @amount = (select ISNULL( STAFF_DEDUCTION_PRCNT_BS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')				
																		set @amount_school = (select ISNULL ( STAFF_DEDUCTION_PRCNT_SS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')				
																		--select @amount amount,@amount_school school_amount									
																		if @amount_type != 'Fixed'
																		begin					
																			if @amount_type = '% of Basic Salary'
																			begin
																				set @basic_salary = (select isnull(TECH_SALLERY,0) from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)																	
																				set @amount = (@amount * @basic_salary) / 100
																				set @amount_school = (@amount_school * @basic_salary) / 100
																			end
																			--select @amount total deduction amount																											
																		
																		else
																			begin
																				set @basic_salary = (select isnull(TECH_SALLERY,0) from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)																	
																				set @amount = (@amount * @per_day_salary) / 100
																				set @amount_school = (@amount_school * @per_day_salary) / 100
																			end
																	end
										end
									else
									begin
									while @count < (select LEN(@ded_months))
										begin												
												--select CONVERT(int, ( (select SUBSTRING(@fee_months,@count,2)) ) ) 													  
												set @month = ( select convert(int, (select SUBSTRING(@ded_months,@count,2)) ) )														
													if @crrnt_month = @month
														begin				
															--select @crrnt_month																														
															--set @amount = [dbo].[get_percent_amount](@STAFF_SALLERY_STAFF_ID, @STAFF_DEFF_ID, @status)															
																															
																		set @amount_type = (select STAFF_DEDUCTION_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
																		--select @amount_type amount_type
																		set @amount = (select ISNULL( STAFF_DEDUCTION_PRCNT_BS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')				
																		set @amount_school = (select ISNULL ( STAFF_DEDUCTION_PRCNT_SS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')				
																		--select @amount amount,@amount_school school_amount									
																		if @amount_type != 'Fixed'
																		begin					
																			if @amount_type = '% of Basic Salary'
																			begin
																				set @basic_salary = (select isnull(TECH_SALLERY,0) from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)																	
																				set @amount = (@amount * @basic_salary) / 100
																				set @amount_school = (@amount_school * @basic_salary) / 100
																			end
																			--select @amount total deduction amount																											
																		
																		else
																			begin
																				set @basic_salary = (select isnull(TECH_SALLERY,0) from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)																	
																				set @amount = (@amount * @per_day_salary) / 100
																				set @amount_school = (@amount_school * @per_day_salary) / 100
																			end
																	end	
															
															--select @amount
															break;
														end
													
													set @count = @count + 3
										end								
								end

						end

						ELSE
						Begin
							if @monthly_type = 'Monthly'
								begin
									set @amount = (select isnull( STAFF_DEDUCTION_PRCNT_BS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
									and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')								
									set @amount_school = (select isnull( STAFF_DEDUCTION_PRCNT_SS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
									and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
								end
							else
							begin
								while @count < (select LEN(@ded_months))
										begin												
												--select CONVERT(int, ( (select SUBSTRING(@fee_months,@count,2)) ) ) 													  
												set @month = ( select convert(int, (select SUBSTRING(@ded_months,@count,2)) ) )														
													if @crrnt_month = @month
														begin				
															--select @crrnt_month																														
															--set @amount = [dbo].[get_percent_amount](@STAFF_SALLERY_STAFF_ID, @STAFF_DEFF_ID, @status)															
																															
																							
																			set @amount = (select isnull( STAFF_DEDUCTION_PRCNT_BS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID 
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')								
																			set @amount_school = (select isnull( STAFF_DEDUCTION_PRCNT_SS,0) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID  
																			and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')
																			--select @amount total deduction amount																											
																	
																
															
															--select @amount
															break;
														end
													
													set @count = @count + 3							
							end
						End

							--select @amount
			end
	
			set @amount = ROUND((select isnull( @amount,0)),0)
			set @amount_school = ROUND((select isnull( @amount_school,0)),0)

		
		
			--select @STAFF_DEFF_ID ded_deff_id,@amount amount,@amount_school school_amount,@deduct_stat deduct_stst,@STAFF_SALLERY_DEFF_MAX deff_id_max
			
			update STAFF_SALLERY_DEFF
				set
				
				STAFF_SALLERY_DEFF_NAME = @STAFF_DEFF_ID,
				STAFF_SALLERY_DEFF_AMOUNT = @amount,			
				STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T',
				STAFF_SALLERY_DEFF_SCHOOL_CONTRIBUTION = @amount_school,
				STAFF_SALLERY_DEFF_REFUND = @deduct_stat,
				STAFF_SALLERY_DEFF_REFUND_STATUS = 'Not Refunded'
				where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX
			
			set @credit = @amount
			set @debit = 0

			if dbo.get_advance_accounting (@STAFF_SALLERY_BR_ID) = 1

				BEGIN					
					exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID, @BR_ID,0,1,''
				END

			
			--if @amount != 0
			--begin
			--	update STAFF_SALLERY_DEFF
			--	set
				
			--	STAFF_SALLERY_DEFF_NAME = @STAFF_DEFF_ID,
			--	STAFF_SALLERY_DEFF_AMOUNT = @amount,			
			--	STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T',
			--	STAFF_SALLERY_DEFF_SCHOOL_CONTRIBUTION = @amount_school,
			--	STAFF_SALLERY_DEFF_REFUND = @deduct_stat,
			--	STAFF_SALLERY_DEFF_REFUND_STATUS = 'Not Refunded'
			--	where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX
			--end
			
			--else
			--begin
			--	--delete STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX
			--end
		
	
end