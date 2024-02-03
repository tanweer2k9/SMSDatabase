CREATE function [dbo].[get_percent_amount](@STAFF_ID numeric , @STAFF_DEFF_ID numeric, @status char(1), @per_day_salary float) returns float

as 
begin

		--declare @STAFF_DEFF_ID numeric = 1
		--declare @STAFF_ID numeric = 1
		--declare @status char(1) = 'D'
		--declare @per_day_salary float = 221

		declare @amount_type nvarchar(100)
		declare @amount float
		declare @basic_salary float

		set @basic_salary = (select TECH_SALLERY from TEACHER_INFO where TECH_ID = @STAFF_ID)
--set @basic_salary = 50000
		if @status = 'D'
		begin
				set @amount_type = (select STAFF_DEDUCTION_TYPE from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
									STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)



				--select @amount_type amount_type

				set @amount = (select STAFF_DEDUCTION_PRCNT_BS from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_ID and 
									STAFF_DEDUCTION_STATUS = 'T' and STAFF_DEDUCTION_DED_ID = @STAFF_DEFF_ID)				

				--select @amount amount
									
									if @amount_type != 'Fixed'
									begin
									
													
														if @amount_type = '% of Basic Salary'
															begin
															
																set @amount = (@amount * @basic_salary) / 100
															end
															
															else if @amount_type = '% of Per Day Salary'
															
															begin
																set @amount = (@amount * @per_day_salary) / 100
															end
														
														
														--select @amount total deduction amount													
														
									end
				
		end
		
		else if @status = 'A'
		begin
				set @amount_type = (select STAFF_ALLOWANCE_TYPE from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)

--select @amount_type

						--select @amount_type amount_type

						set @amount = (select STAFF_ALLOWANCE_AMOUNT from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_ID and 
											STAFF_ALLOWANCE_STATUS = 'T' and STAFF_ALLOWANCE_ALLOW_ID = @STAFF_DEFF_ID)				

						--select @amount amount
											
											if @amount_type != 'Fixed'
											begin
															if @amount_type = '% of Basic Salary'
															begin
															
																set @amount = (@amount * @basic_salary) / 100
															end
															
															else if @amount_type = '% of Per Day Salary'
															
															begin
																set @amount = (@amount * @per_day_salary) / 100
															end
																--select @amount, @basic_salary 
																--select @amount total ALLOWANCE amount													
																
											end
								
				end
				--select @amount 
				return @amount
				

end