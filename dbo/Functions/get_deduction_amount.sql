CREATE function [dbo].[get_deduction_amount] ( @STAFF_ID numeric , @STAFF_DEFF_ID numeric, @crrnt_date date, @status char(1), @per_day_salary float) returns float
as 
begin


		--declare @STAFF_ID numeric = 5
		--declare @STAFF_DEFF_ID numeric = 2
		--declare @crrnt_month int = 03
		--declare @per_day_salary int = 210
		declare @VALUE_TYPE nvarchar(100)
		declare @ded_months nvarchar(100)
		declare @monthly_type nvarchar(20)
		Declare @count int = 1
		Declare @month int	
		declare @amount float
		declare @crrnt_month int
		declare @crrnt_year int

		set @crrnt_month = ( select DATEPART(MM,@crrnt_date) )
		set @crrnt_year = ( select DATEPART(yyyy,@crrnt_date) )

		if @status = 'D'
		begin
					set @VALUE_TYPE = (select STAFF_DEDUCTION_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
											STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)
											
											
					set @monthly_type = (select STAFF_DEDUCTION_VAL_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID  
					and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID and STAFF_DEDUCTION_STATUS = 'T')	
											
						set @ded_months = (select STAFF_DEDUCTION_MONTHS from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
											STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)
											
						set @amount = 0

						if @VALUE_TYPE != 'Fixed'
						begin
						
								if @monthly_type = 'Monthly'
								begin
										set @amount = [dbo].[get_percent_amount](@STAFF_ID, @STAFF_DEFF_ID, @status,@per_day_salary)
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
																	
																	set @amount = [dbo].[get_percent_amount](@STAFF_ID, @STAFF_DEFF_ID, @status,@per_day_salary)
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
											set @amount = (select STAFF_DEDUCTION_PRCNT_BS from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
											STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)
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
																	
																	set @amount = (select STAFF_DEDUCTION_PRCNT_BS from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
																	STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)
																	--select @amount
																	break;
																end
															
															
															
															set @count = @count + 3
																						
												end
									
								end
								

						End

							--select @amount

						
		end


		else if @status = 'A'
		begin
				set @VALUE_TYPE = (select STAFF_ALLOWANCE_TYPE from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)
											
											
						set @monthly_type = (select STAFF_ALLOWANCE_VAL_TYPE from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)					
											
						set @ded_months = (select STAFF_ALLOWANCE_MONTHS from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)
											
						set @amount = 0

						if @VALUE_TYPE != 'Fixed'
						begin
								if @monthly_type = 'Monthly'
								begin
										set @amount = [dbo].[get_percent_amount](@STAFF_ID, @STAFF_DEFF_ID, @status,@per_day_salary)
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
																	
																	set @amount = [dbo].[get_percent_amount](@STAFF_ID, @STAFF_DEFF_ID, @status,@per_day_salary)
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
										set @amount = (select STAFF_ALLOWANCE_AMOUNT from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)	
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
																	
															set @amount = (select STAFF_ALLOWANCE_AMOUNT from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
															STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)	
																	--select @amount
																	break;
																end																																							
															set @count = @count + 3
																						
												end
								end
							
							--select @amount
			end
				end		
		else if @status = 'L'
			begin
			
			set @amount = ( select LOAN_TYPE_AMOUNT from LOAN_TYPE where LOAN_TYPE_LOAN_ID = @STAFF_DEFF_ID and LOAN_TYPE_INSTALLEMENT_STATUS = 'F' and LOAN_TYPE_MONTH = @crrnt_month
					and LOAN_TYPE_YEAR = @crrnt_year and LOAN_TYPE_STATUS = 'T')
						
			end
	set @amount = (select isnull( @amount,0))
	return @amount
end