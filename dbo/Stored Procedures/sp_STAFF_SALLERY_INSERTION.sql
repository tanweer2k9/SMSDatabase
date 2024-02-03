

 
 
CREATE procedure [dbo].[sp_STAFF_SALLERY_INSERTION]
				
				@STAFF_SALLERY_STAFF_ID numeric,
				@STAFF_SALLERY_DATE date,
				@STAFF_SALLERY_BR_ID numeric,
				@STAFF_SALLERY_HD_ID numeric,
				@STATUS  char(1),
				@send_sms char(1),
				@STAFF_SALLERY_USER_ID numeric
as 
begin


--declare @STAFF_SALLERY_STAFF_ID numeric = 60
--declare @STAFF_SALLERY_DATE date = '2016-05-01' --getdate()
--declare @STAFF_SALLERY_BR_ID numeric = 1
--declare @STAFF_SALLERY_HD_ID numeric = 1
--declare @STATUS  char = 'B'
--declare @send_sms char(1) = 'F'
--declare @STAFF_SALLERY_USER_ID numeric = 1


declare @t_sms table (mobile_no nvarchar(20), msg nvarchar(1000), screen_id int)
declare @earnings char(1) = 'E'
declare @deductions char(1) = 'D'
Declare @loan char(1) = 'L' 
declare @loan_amount float = 0
declare @toatal_staff int = 0
declare @count int = 0
declare @j int = 1
declare @i int = 1
declare @crrnt_month int = ( select DATEPART(MM,@STAFF_SALLERY_DATE) )
declare @crrnt_year int = ( select DATEPART(YYYY,@STAFF_SALLERY_DATE) )


declare @STAFF_SALLERY_PRESENT numeric = 0
declare @STAFF_SALLERY_ABSENT numeric  =0 
declare @STAFF_SALLERY_LEAVE numeric =0 
declare @STAFF_SALLERY_LATE numeric =0 
declare @STAFF_SALLERY_EARLY_DEPARTURE numeric =0 
declare @STAFF_SALLERY_HALF_DAY numeric =0 
declare @STAFF_SALLERY_HALF_DAY_Annual numeric =0 
declare @STAFF_SALLERY_HALF_DAY_Total numeric =0 
declare @STAFF_SALLERY_WH numeric =0 
declare @STAFF_STATUS char = 'F'
declare @working_days numeric = 0
declare @STAFF_SALLERY_MAX numeric =0 
declare @STAFF_SALLERY_DEFF_MAX numeric=0 
declare @STAFF_DEFF_ID numeric =0 
declare @STAFF_DESIGNATION nvarchar(50) = ''
declare @earning_deff_amount numeric = 0					
											
declare @except_days_status char(1) = 'F'
declare @weekend_days_status char(1) ='F' 

declare @decuct_status char(2) = 'F'
declare @allowance_status char(2) = 'F'
declare @loan_status char(2) = 'F'

declare @leaves_status char(2) = 'F'
declare @absent_status char(2) = 'F'
declare @deduct_leaves_status char(2) = 'F'
declare @deduct_absent_status char(2)= 'F'
declare @basic_salary float = 0
declare @net_salary float= 0
declare @staff_leaves_calc float = 0
declare @staff_absent_calc float = 0 


declare @STAFF_SALLERY_MONTH_SALARY float = 0
declare @calc_deduct float = 0
declare @calc_allow float = 0
declare @calc_loan float = 0
declare @deduct_days float = 0
declare @set_deduct_days float = 0
declare @late_per_absent int = 0
declare @early_per_absent int = 0

declare @old_month_leaves_limit int= 0
declare @old_month_leaves_status  char(2)= 'F'
declare @new_month_leaves_limit int= 0
declare @new_month_leaves_status  char(2)= 'F'
declare @new_year_leaves_status char(2)= 'F'
declare @per_day_salary float= 0
declare @deducted_salary float= 0
declare @staff_salary_count int= 0
declare @consecutive_absent_status char(2)= 'F'
declare @consecutive_leave_status char(2)= 'F'
declare @consecutive_before_weekends int= 0
declare @consecutive_after_weekends int= 0
declare @days int = 0
declare @d1 DATETIME 
declare @d2 DATETIME
declare @months_weekend int = 0
Declare @weekend_days int = 0
Declare @total_weekend_days int = 0
declare @week_day int = 0
declare @weekend_pair_count int = 0
declare @current_leaves_limit int = 0
declare @decuct_absent_count float = 0
declare @decuct_leave_count float = 0
declare @staff_joining_date date = ''
declare @staff_left_date date =''
declare @staff_joining_date_time datetime = ''
declare @staff_left_date_time datetime = ''
declare @joining_date_days int = 0
declare @weekend_days_joining_based int = 0
declare @exceptional_days_joining_based int = 0
declare @t table ([Day Name] nvarchar(20), [Day] int, [Type] char, [date] date)
declare @is_continue char = ''
declare @unattendance_mark_days int = 0
declare @leave_type nvarchar(50) = ''
declare @annual_leaves_limit_old int = 0
declare @annual_leaves_limit_new int = 0

declare @total_units int = 0
declare @total_staff int = 0
declare @commision float = 0
declare @commision_general float = 0
declare @commission_formula nvarchar(100) = ''
declare @commission_defintion_count int = 0
declare @allownc_commission_id int = 0
declare @allownc_overtime_id int = 0
declare @deduction_late_time_count int = 0
declare @deduction_late_time_id int = 0
declare @deduction_late_time_status nvarchar(50) = ''
declare @deducution_late_time_amount float = 0
declare @early_minutes int = 0
declare @half_day_minutes int = 0


declare @is_commission char(1) = 'F'
declare @is_overtime char(1) = 'F'
declare @overtime_minutes_in_hour int = 0
declare @overtime_hours_in_day float = 0
declare @per_hour_salary float = 0
declare @overtime_salary float = 0
declare @overtime_hours float = 0
declare @per_day_salary_type nvarchar(50) = ''
declare @is_overtime_payslip char(1)=''

declare @time_in time = ''
declare @time_out time = ''
declare @total_time datetime = ''
declare @hours int = 0
declare @minutes int = 0
declare @remaining_leaves_limit_causal float = 0 
declare @remaining_leaves_limit_annual float = 0 
declare @annual_leaves_From_Next_Year char(1) = 'F'

--Causal and annual leaves
declare @tbl_leaves table (sr int ,Leaves int, FromDate date,ToDate date, [Is Causal Leaves] bit, [Is Annual Leaves] bit)
declare @total_leaves_record int = 0

declare @m int = 1
declare @count_total_leaves_record int = 0
declare @is_causul_leaves bit = 0
declare @is_annual_leaves bit = 0
declare @total_causul_leaves float = 0
declare @total_annual_leaves float = 0
declare @leaves_record float = 0
declare @is_annual_leave_deduct bit = 0
declare @sandwich_days int = 0
--is advance accuounting variables

declare @summer_start_date date = '1900-01-01'
declare @summer_end_date date = '1900-01-01'
declare @winter_start_date date = '1900-01-01'
declare @winter_end_date date = '1900-01-01'
declare @is_vacation_allowed bit = 0
declare @is_advance_Accounting bit = 0
declare @VCH_DEF_COA nvarchar(100) = ''
declare @fee_months_coa_name nvarchar(100) = ''
		declare @tbl_vch table (sr int identity(1,1),[status] nvarchar(50), ID nvarchar(50))
		declare @tbl_coa table ([status] nvarchar(50), coa_UID nvarchar(50), coa_id int)
				declare @HD_ID nvarchar(50) = ''
		declare @BR_ID nvarchar(50) = ''
		declare @acc_salary_months nvarchar(100)= 'Salary Months'
		declare @acc_vch_main_id nvarchar(50) = ''
		declare @acc_prefix nvarchar(50) = 'SA'
		declare @acc_datetime datetime = getdate()
          --@STAFF_SALLERY_HD_ID  numeric,
          --@STAFF_SALLERY_BR_ID  numeric,
          --@STAFF_SALLERY_STAFF_ID  numeric,
          --@STAFF_SALLERY_WORKING_DAYS  int,
          --@STAFF_SALLERY_PRESENT  int,
          --@STAFF_SALLERY_ABSENTS  int,
          --@STAFF_SALLERY_LATE  int,
          --@STAFF_SALLERY_LEAVES  int,
          --@STAFF_SALLERY_DATE  date,
          --@STAFF_SALLERY_GROSS_EARN  float,
          --@STAFF_SALLERY_GROSS_DEDUCT  float,
          --@STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT  float,
          --@STAFF_SALLERY_MONTH_SALARY  float,
          --@STAFF_SALLERY_NET_STATUS  nvarchar(50) 							
					select @summer_start_date = SUM_WIN_SUMMER_START_DATE, @summer_end_date = SUM_WIN_SUMMER_END_DATE,@winter_start_date = SUM_WIN_WINTER_START_DATE,@winter_end_date = SUM_WIN_WINTER_END_DATE  from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID and @STAFF_SALLERY_DATE between SUM_WIN_SEMESTER1_START_DATE and SUM_WIN_SUMMER_END_DATE

					set @is_overtime_payslip = (select BR_ADM_PAYROLL_IS_OVERTIME_MONTHLY_SLIP_GENERATE from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID)
					set @is_overtime_payslip = ISNULL(@is_overtime_payslip, 'T')

					set @early_minutes = (select BR_ADM_EARLY_MINUTES_ALLOWED from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID)
					set @early_minutes = ISNULL(@early_minutes, 0)

					set @half_day_minutes = (select BR_ADM_HALF_DAY_MINUTES from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID)
					set @half_day_minutes = ISNULL(@half_day_minutes, 0)
					

		set @HD_ID = CAST(@STAFF_SALLERY_HD_ID as nvarchar(50))
		set @BR_ID = CAST(@STAFF_SALLERY_BR_ID as nvarchar(50))
	set @is_advance_Accounting = ( select BR_ADM_IS_ADVANCE_ACCOUNTING from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)

		if @is_advance_Accounting = 1
		BEGIN
			set @fee_months_coa_name = 'Salary ' + (SELECT LEFT(DATENAME(month, @STAFF_SALLERY_DATE),3)) + ' '+ (SELECT RIGHT(DATENAME(YEAR, @STAFF_SALLERY_DATE),2))
			set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_Name = @fee_months_coa_name and CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_isDeleted = 0)
			if @VCH_DEF_COA iS NULL
			BEGIN
				--insertion of fees invoice months
				
					declare @fee_parent_code nvarchar(50) = ''
					declare @coa_fees_type int = 0
					declare @coa_fees int = 0
					declare @fee_nature nvarchar(50) = ''
					select @fee_parent_code = COA_UID, @coa_fees_type = COA_type, @fee_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @acc_salary_months and COA_isDeleted = 0
					declare @fees_def_plan_level_no int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_ID in (select COA_definationPlanID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @acc_salary_months ))
					declare @fees_categories_def_plan_id int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_levelNo = (@fees_def_plan_level_no + 1) and CMP_ID = @HD_ID and BRC_ID = @BR_ID)
					declare @fees_category_level_no int = @fees_def_plan_level_no + 1
					insert into @tbl_coa exec sp_TBL_COA_insertion @HD_ID, @BR_ID,@fee_parent_code,'','',0,@fees_categories_def_plan_id,@fee_months_coa_name,@coa_fees_type,1,'',1,@fees_category_level_no,1,@fee_nature,0,0,'I'   
					set @VCH_DEF_COA = ( select top(1) coa_UID from @tbl_coa)
			END
			ELSE
			BEGIN
				insert into @tbl_coa values ('ok', @VCH_DEF_COA,1)
			END
		END

		SELECT @d1 = (SELECT DATEADD(mm, DATEDIFF(mm,0,@STAFF_SALLERY_DATE), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@STAFF_SALLERY_DATE)+1,0)) )				

IF @STATUS = 'M'
BEGIN
				 set @i = 1 --( select ISNULL( min(ID),0) from VTEACHER_INFO where [Institute ID] = @STAFF_SALLERY_HD_ID and [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) ) --and [Status] = 'T'
				 set @toatal_staff = ( select ISNULL( COUNT(ID),0) from VTEACHER_INFO where [Status] !='D' and [Institute ID] = @STAFF_SALLERY_HD_ID and [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) and [Joining Date] <= @d2 ) --and [Status] = 'T'
				 
			set @staff_salary_count = (select COUNT(*) from STAFF_SALLERY where DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
				DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and	STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
				STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) )
				
				if @staff_salary_count > 0
				begin
					delete from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID in
					(select STAFF_SALLERY_ID from STAFF_SALLERY 
					where  
						DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) )

					delete from STAFF_SALLERY 
					where  
						DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) 
						update LOAN_TYPE set LOAN_TYPE_INSTALLEMENT_STATUS = 'F' where CONVERT(int, LOAN_TYPE_MONTH) = DATEPART(MM,@STAFF_SALLERY_DATE) and CONVERT(int, LOAN_TYPE_YEAR) = DATEPART(YYYY,@STAFF_SALLERY_DATE)

						delete from STAFF_LEAVES_CALC 
						where 
						DATEPART(MM,STAFF_LEAVES_CALC_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_LEAVES_CALC_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) 
					
						if @is_advance_Accounting = 1
						BEGIN
							   delete from TBL_VCH_DEF where VCH_MAIN_ID in
								(select VCH_MID from TBL_VCH_MAIN where VCH_referenceNo in
							  ( select CAST((STAFF_SALLERY_ID) as nvarchar(50)) from STAFF_SALLERY 
							where DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)))) 

							 delete from TBL_VCH_MAIN where VCH_referenceNo in
							  ( select CAST((STAFF_SALLERY_ID) as nvarchar(50)) from STAFF_SALLERY 
							where DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)))									
						END


				end


				--set @total_units = (select COM_UNITS_TOTAL_UNITS from PYRL_COMMSN_UNITS where DATEPART(MM,@STAFF_SALLERY_DATE) = DATEPART(MM,COM_UNITS_DATE) and  DATEPART(YYYY,@STAFF_SALLERY_DATE) = DATEPART(YYYY,COM_UNITS_DATE) )
				--set @total_staff = (select COUNT(*) from TEACHER_INFO where TECH_IS_COMMISION = 'T' and TECH_STATUS = 'T')
				----commission defintion
				--set @commission_defintion_count =  (select count(*) from ALLOWANCE where ALLOWANCE_NAME = 'Commission')
					
				--	if @commission_defintion_count = 0
				--	begin
				--		insert into ALLOWANCE values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Commission','NA', @STAFF_SALLERY_DATE, 'T')
				--		set @allownc_commission_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @allownc_commission_id = (select ALLOWANCE_ID from ALLOWANCE where ALLOWANCE_NAME = 'Commission')
				--	end
					

				--	set @commission_formula = (select top(1) BR_ADM_PAYROLL_COMMSSION_FORMULA from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)
				--if @total_staff !=0
				--	BEGIN
				--	set @commision_general = (CAST(((select val from dbo.split(@commission_formula, ',') where id = 1)) as float) * CAST(((select val from dbo.split(@commission_formula, ',') where id = 2)) as float) / @total_staff)
				--	END


				--	--Overtime defintion

				--	set @commission_defintion_count = 0
				--	set @commission_defintion_count =  (select count(*) from ALLOWANCE where ALLOWANCE_NAME = 'Overtime')
					
				--	if @commission_defintion_count = 0
				--	begin
				--		insert into ALLOWANCE values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Overtime','NA', @STAFF_SALLERY_DATE, 'T')
				--		set @allownc_overtime_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @allownc_overtime_id = (select ALLOWANCE_ID from ALLOWANCE where ALLOWANCE_NAME = 'Overtime')
				--	end
					

				--	--deduction late time definition
				--	set @deduction_late_time_count = 0
				--	set @deduction_late_time_count = (select count(*) from DEDUCTION where DEDUCTION_NAME = 'Late Time Deduction')
				--	if @deduction_late_time_count = 0
				--	begin
				--		insert into DEDUCTION values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Late Time Deduction','NA', @STAFF_SALLERY_DATE, 'T')						
				--		set @deduction_late_time_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @deduction_late_time_id = (select DEDUCTION_ID from DEDUCTION where DEDUCTION_NAME = 'Late Time Deduction')
				--	end

					
					


				 while @i <= @toatal_staff 			 	
				 				begin				 				
				 				set @deducted_salary = 0
								set @net_salary = 0
								set @deduct_days = 0 	
								set @weekend_pair_count = 0
								set @current_leaves_limit = 0
								set @staff_joining_date = ''
								set @joining_date_days = 0
								set @STAFF_STATUS = ''
								set @is_continue = ''
								set @staff_left_date = ''
								set @except_days_status = ''
								set @weekend_days_status = ''
								set @weekend_days_joining_based = 0
								set @overtime_hours = 0
								set @per_hour_salary = 0
								set @deduction_late_time_status = ''
								set @deducution_late_time_amount = 0
								set @total_weekend_days = 0
								set @unattendance_mark_days = 0
								set @STAFF_SALLERY_HALF_DAY = 0
								set @STAFF_SALLERY_HALF_DAY_Annual = 0
								set @STAFF_SALLERY_HALF_DAY_Total = 0
								set @annual_leaves_From_Next_Year = 'F'
								set @set_deduct_days = 0
				 				select @STAFF_SALLERY_STAFF_ID = ID, @leave_type = ISNULL([Leaves Type],'None'),@STAFF_STATUS = [Status], @staff_joining_date = [Joining Date], @staff_left_date = [Left Date], @is_commission = ISNULL([Is Commission],'F'), @is_overtime = ISNULL([Is Overtime],'F'),@is_vacation_allowed = ISNULL([Is Vacation Allowed],0), @STAFF_DESIGNATION = Designation from (select ROW_NUMBER() over (order by (Ranking)) as sr, * from VTEACHER_INFO where status != 'D' and [Institute ID] = @STAFF_SALLERY_HD_ID and [Branch ID] in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) and [Joining Date] <= @d2)A where sr = @i	--and [Status] = 'T'								
								select @overtime_minutes_in_hour = STAFF_LEAVES_PAYROLL_MINUTES_IN_HOUR, @overtime_hours_in_day = STAFF_LEAVES_PAYROLL_HOURS_IN_DAY from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID
							
							
							if @leave_type != 'Not Generate Salary'
							BEGIN
								if @overtime_minutes_in_hour is null
									begin
										select @overtime_minutes_in_hour = ISNULL(BR_ADM_PAYROLL_MINUTES_IN_HOUR,60) from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID
									end

								if @overtime_hours_in_day is null
								begin
									select @overtime_hours_in_day = BR_ADM_PAYROLL_HOURS_IN_DAY from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID 									
									if @overtime_hours_in_day is null
									begin
										select @time_in =  CAST((WORKING_HOURS_TIME_IN) as time) , @time_out =  CAST((WORKING_HOURS_TIME_OUT) as time) from WORKING_HOURS where WORKING_HOURS_HD_ID = @STAFF_SALLERY_HD_ID and WORKING_HOURS_BR_ID = @STAFF_SALLERY_BR_ID
										set @total_time = CAST((@time_out) as datetime) - CAST((@time_out) as datetime)
										set @minutes = DATEPART(MINUTE, @total_time)
										set @hours = DATEPART(HOUR, @total_time)
										set @overtime_hours_in_day = @hours + (@minutes / 60)
									end
								end

								if @STAFF_STATUS = 'F'
								begin
									if DATEPART(MM,@STAFF_SALLERY_DATE) = DATEPART(MM, @staff_left_date) and DATEPART(yyyy,@STAFF_SALLERY_DATE) = DATEPART(yyyy, @staff_left_date)
									begin
										set @is_continue = 'T'
									end
									else if @STAFF_SALLERY_DATE >@staff_left_date
									begin
										set @is_continue = 'F'
									end	
									else
									begin
										set @is_continue = 'T'
									end
								end
								
								else
								begin
									set @is_continue = 'T'
								end
									
								
								if @STAFF_SALLERY_STAFF_ID is not null	and @STAFF_SALLERY_STAFF_ID != 0 and @is_continue = 'T'
											 begin				
											 					 			 				 							 
													--set @working_days = [dbo].[Get_working_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE) 
													set @working_days = 30 -- Hard Code 30 days
													set @except_days_status = (select STAFF_LEAVES_ADD_EXCEPTIONAL_HOLIDAYS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
													set @weekend_days_status = (select STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
													 if @except_days_status = 'F'
													 begin
														set @working_days = @working_days - (select COUNT(*) from ANNUAL_HOLIDAYS 
														where DATEPART(MM, ANN_HOLI_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(yyyy, ANN_HOLI_DATE) = DATEPART(yyyy, @STAFF_SALLERY_DATE)
														and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_STATUS = 'T' and ANN_HOLI_DATE
														not in ( SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) + 1 >= number
														AND DATENAME(w,@d1+number) in (select WORKING_DAYS_NAME from WORKING_DAYS where WORKING_DAYS_VALUE = 0))														
														)
														-- sub query not in calculate the exceptional holidays not be in weekend holiday for each staff											
													end
													
													--if (select DATEDIFF(DD, @d1, @d2) + 1) != @working_days
													----if @except_days_status = 'T'
													--begin
													--		set @working_days = @working_days + (select COUNT(*) from 
													--		(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
													--		AND DATENAME(w,@d1+number) in (select WORKING_DAYS_NAME from WORKING_DAYS where WORKING_DAYS_VALUE = 0))A
													--		where A.date1 in ( select date2 from (select distinct ATTENDANCE_STAFF_DATE  as date2 from ATTENDANCE_STAFF 
													--		where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
													--		DATEPART(MM,ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and 
													--		DATEPART(yyyy,ATTENDANCE_STAFF_DATE) = DATEPART(yyyy, @STAFF_SALLERY_DATE))B))
													--		--add weekend holidays attenedance in the working days if working days is not eqaul the total days of that month
													--end
													
													
											
											
											--select @working_days working days

									set @STAFF_SALLERY_ABSENT =	dbo.GET_ATTENDANCE_COUNT('A',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_LATE = dbo.GET_ATTENDANCE_COUNT('LA',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)		
									set @STAFF_SALLERY_LEAVE = dbo.GET_ATTENDANCE_COUNT('LE',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_PRESENT = dbo.GET_ATTENDANCE_COUNT('P',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_WH = dbo.GET_ATTENDANCE_COUNT('WH',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_EARLY_DEPARTURE = (select dbo.GET_EARLY_DEPARTURE(@STAFF_SALLERY_STAFF_ID, @early_minutes,@d1,@d2))
									--(select COUNT(*) from ( select ROW_NUMBER() over(partition by ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_TYPE_ID order by CONVERT(time, ATTENDANCE_STAFF_TIME_OUT) DESC) as sr ,ATTENDANCE_STAFF_TYPE_ID, ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_REMARKS ,ATTENDANCE_STAFF_TIME_IN,ATTENDANCE_STAFF_TIME_OUT,ATTENDANCE_STAFF_CURRENT_TIME_IN, ATTENDANCE_STAFF_CURRENT_TIME_OUT from ATTENDANCE_STAFF where DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID)A where sr = 1 and ATTENDANCE_STAFF_REMARKS not in ('LE', 'A') and DATEADD(Mi, @early_minutes,CONVERT(time, ATTENDANCE_STAFF_TIME_OUT)) <  CONVERT(time, ATTENDANCE_STAFF_CURRENT_TIME_OUT) and ATTENDANCE_STAFF_DATE not in (select dates from dbo.GET_ALL_LEAVES_DATE (@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE)))
									set @STAFF_SALLERY_HALF_DAY = (select COUNT(*) from SHORT_LEAVE where  DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and DATEPART(MM, SHORT_LEAVE_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, SHORT_LEAVE_DATE)  = DATEPART(YYYY, @STAFF_SALLERY_DATE) and SHORT_LEAVE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and ISNULL(SHORT_LEAVE_IS_ANNUAL,CAST(0 as bit)) = CAST(0 as bit))
									set @STAFF_SALLERY_HALF_DAY_Annual = (select COUNT(*) from SHORT_LEAVE where  DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and DATEPART(MM, SHORT_LEAVE_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, SHORT_LEAVE_DATE)  = DATEPART(YYYY, @STAFF_SALLERY_DATE) and SHORT_LEAVE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and ISNULL(SHORT_LEAVE_IS_ANNUAL,CAST(0 as bit)) = CAST(1 as bit))

									set @STAFF_SALLERY_HALF_DAY_Total = @STAFF_SALLERY_HALF_DAY + @STAFF_SALLERY_HALF_DAY_Annual
									set @remaining_leaves_limit_causal = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_SALLERY_STAFF_ID,DATEADD(M,-1,@STAFF_SALLERY_DATE),@STAFF_SALLERY_BR_ID,'C')
													--select @STAFF_SALLERY_ABSENT [absent],@STAFF_SALLERY_LATE [late],@STAFF_SALLERY_LEAVE [leave],@STAFF_SALLERY_PRESENT [present],@STAFF_SALLERY_WH [work_holiday]								
													set @unattendance_mark_days = (select [dbo].GET_UNATTENDANCE_MARKS_DAYS(@STAFF_SALLERY_STAFF_ID, @d1,@d2,@HD_ID,@BR_ID))
--									set @unattendance_mark_days = [dbo].[Get_working_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE,default) - (@STAFF_SALLERY_PRESENT + @STAFF_SALLERY_ABSENT + @STAFF_SALLERY_LEAVE + 
--									@STAFF_SALLERY_LATE + @STAFF_SALLERY_WH + @STAFF_SALLERY_HALF_DAY ) -
--									--calculate the week days of the staff
--									(select COUNT(*) from
--(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
--AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_DAY_STATUS = 'F' and STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID))A)

									set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT + @unattendance_mark_days
								set @commision = @commision_general * @STAFF_SALLERY_PRESENT			
										 insert into STAFF_SALLERY
										 values
										 (
											@STAFF_SALLERY_HD_ID,
											@STAFF_SALLERY_BR_ID,
											@STAFF_SALLERY_STAFF_ID,
											@working_days,
											@STAFF_SALLERY_PRESENT,
											@STAFF_SALLERY_ABSENT,
											@STAFF_SALLERY_LATE,
											@STAFF_SALLERY_LEAVE,
											GETDATE(),
											0,
											0,
											0,
											0,
											'Payable',
											0,
											0,
											0,
											0,
											GETDATE(),
											@STAFF_SALLERY_DATE,
											0,
											0,
											0, 
											@STAFF_SALLERY_EARLY_DEPARTURE,
											@STAFF_SALLERY_HALF_DAY_Total,
											(select STAFF_LEAVES_LATE_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID ),
											(select STAFF_LEAVES_EARLY_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID )
										 )
								
										set @STAFF_SALLERY_MAX = SCOPE_IDENTITY()

							--
							if @is_advance_Accounting = 1
							 BEGIN
								 insert into @tbl_vch exec sp_TBL_VCH_MAIN_insertion @acc_prefix, @acc_datetime, '','',@STAFF_SALLERY_MAX,'','',0,0,'',@HD_ID,@BR_ID,0
								 set @acc_vch_main_id = (select top(1) ID from @tbl_vch order by sr DESC )
							 END
							
														

											--select STAFF_SALLERY_GROSS_EARN earnings,STAFF_SALLERY_GROSS_DEDUCT deductions from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									set @per_day_salary_type = (select ISNULL(STAFF_LEAVES_PER_DAY_SALARY_TYPE,'Monthly') from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @per_day_salary_type = ISNULL(@per_day_salary_type,'Monthly')
									set @decuct_status = (select STAFF_LEAVES_ADD_DEDUCTION from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @allowance_status = (select STAFF_LEAVES_ADD_ALLOWANCES from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @loan_status = (select STAFF_LEAVES_ADD_LOAN from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @basic_salary = (select TECH_SALLERY from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
									set @staff_joining_date = (select TECH_JOINING_DATE from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
									set @basic_salary = (select ISNULL(@basic_salary ,0))
									set @staff_joining_date = (select ISNULL(@staff_joining_date, '2013-01-01'))
									set @STAFF_SALLERY_MONTH_SALARY = @basic_salary
										--set @STAFF_SALLERY_MONTH_SALARY = ( select ISNULL( @STAFF_SALLERY_MONTH_SALARY,0) )
									
									if @per_day_salary_type = 'Monthly'
									BEGIN	
										if @decuct_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_deduct										
										End
										else if @decuct_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_deduct										
										End
											
										if @allowance_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_allow										
										End
										else if @allowance_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_allow										
										End		
															
										if @loan_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_loan										
										End
										else if @loan_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_loan										
										End										
										set @per_day_salary = @STAFF_SALLERY_MONTH_SALARY / @working_days		
									END
									ELSE
									BEGIN
									
										set @per_day_salary = (@basic_salary * CAST(((select val from dbo.split(@per_day_salary_type,',') where id = 1)) as int)) / CAST(((select val from dbo.split(@per_day_salary_type,',') where id = 2)) as int)
									END
									
								if DATEPART(MM,@STAFF_SALLERY_DATE) = 1 and DATEPART(YYYY,@STAFF_SALLERY_DATE) = 2018
								BEGIN
									if @STAFF_SALLERY_STAFF_ID = 80176
									BEGIN
										set @per_day_salary = 1350
									END
								END

								set @absent_status = (select STAFF_LEAVES_ABSENT_DEDUCTION from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @leaves_status = (select STAFF_LEAVES_DEDUCTION_LEAVES from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @late_per_absent = (select STAFF_LEAVES_LATE_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @early_per_absent = (select STAFF_LEAVES_EARLY_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @deduct_leaves_status = (select STAFF_LEAVES_DEDUCT_LEAVES_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @deduct_absent_status = (select STAFF_LEAVES_DEDUCT_ABSENT_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @consecutive_absent_status =(select STAFF_LEAVES_CONSECUTIVE_ABSENT_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @consecutive_leave_status =(select STAFF_LEAVES_CONSECUTIVE_LEAVES_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @consecutive_before_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_BEFORE_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID), 0)
								set @consecutive_after_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_AFTER_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0)
								set @decuct_absent_count = ISNULL((select STAFF_LEAVES_DEDUCT_ABSENT_COUNT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0) 
								set @decuct_leave_count = ISNULL((select STAFF_LEAVES_DEDUCT_LEAVES_COUNT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0) 
								set @annual_leaves_From_Next_Year = (select STAFF_LEAVES_TRANSFER_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)

								select top(1) @old_month_leaves_limit = STAFF_LEAVES_CALC_MONTHLY_LIMIT,@old_month_leaves_status = STAFF_LEAVES_CALC_MONTH_STATUS,@annual_leaves_limit_new = STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT from STAFF_LEAVES_CALC
										where  STAFF_LEAVES_CALC_STAFF_ID = @STAFF_SALLERY_STAFF_ID	and
										datepart(MM, STAFF_LEAVES_CALC_DATE ) = datepart(MM,@STAFF_SALLERY_DATE)-1  and
										datepart(yyyy, STAFF_LEAVES_CALC_DATE ) = datepart(yyyy,@STAFF_SALLERY_DATE) 
										order by STAFF_LEAVES_CALC_DATE desc 
										select @old_month_leaves_limit = ISNULL( @old_month_leaves_limit,0), @old_month_leaves_status = ISNULL(@old_month_leaves_status,'F') 
										
										

											
										select top(1) @new_month_leaves_limit =  STAFF_LEAVES_YEAR,@new_month_leaves_status = 'F', @new_year_leaves_status = 'F', @annual_leaves_limit_old = (ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0))  from STAFF_LEAVES
										where  STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID										
										select @new_month_leaves_limit = ISNULL( @new_month_leaves_limit,0), @old_month_leaves_status = ISNULL(@old_month_leaves_status,'F') 
										
										--set @annual_leaves_limit_new = ISNULL(@annual_leaves_limit_new,@annual_leaves_limit_old)
										
										----If Date is first month then renew the limit
										--if 	DATEPART(M,@STAFF_SALLERY_DATE) = 1
										--BEGIN
										--	set @annual_leaves_limit_new = @annual_leaves_limit_old
										--END

										--set @remaining_leaves_limit_annual = @annual_leaves_limit_new
										set @remaining_leaves_limit_annual = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@STAFF_SALLERY_BR_ID,'A')

										update STAFF_SALLERY
										set STAFF_SALLERY_LEAVES_LIMIT = @old_month_leaves_limit
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
										
									if @old_month_leaves_status = 'T'
										begin											
											set @new_month_leaves_limit =  @new_month_leaves_limit + @old_month_leaves_limit
										end
									set @current_leaves_limit = @new_month_leaves_limit
								update STAFF_SALLERY
								set STAFF_SALLERY_LEAVES_LIMIT = @new_month_leaves_limit
								where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
								
								if @absent_status = 'T'
									begin 
										set @deduct_days = @deduct_days + (CAST(@STAFF_SALLERY_ABSENT as float) * @decuct_absent_count)
									end	
									
								if @leaves_status = 'T'
									--if @STAFF_SALLERY_LEAVE > @new_month_leaves_limit
									--begin
										begin 
											set @deduct_days = @deduct_days + (CAST(@STAFF_SALLERY_LEAVE as float)  * @decuct_leave_count)-- -@new_month_leaves_limit
										end	
									--end
								if @late_per_absent > 0 
									begin
										set @deduct_days =  @deduct_days + CONVERT(int,(@STAFF_SALLERY_LATE /@late_per_absent))
									end

									if @early_per_absent > 0 
									begin
										set @deduct_days =  @deduct_days + CONVERT(int,(@STAFF_SALLERY_EARLY_DEPARTURE /@early_per_absent))
									end

									set @deduct_days  = @deduct_days + (@STAFF_SALLERY_HALF_DAY_Total / 2)
								
								--if @deduct_leaves_status = 'T'
								--	begin
								--		set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_LEAVE
								--		if @current_leaves_limit > 0
								--			begin
								--				if @current_leaves_limit > @STAFF_SALLERY_LEAVE
								--					begin
								--						set @deduct_days = @deduct_days - @STAFF_SALLERY_LEAVE
								--						set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_LEAVE
								--					end
								--				else
								--					begin
								--						set @deduct_days = @deduct_days - @current_leaves_limit
								--						set @current_leaves_limit = 0
								--					end
								--			end
										
								--	end									
									
									
								--if @deduct_absent_status = 'T'
								--	begin
								--		--if @late_per_absent > 0
								--		--	begin
								--		--	set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--		--	if @current_leaves_limit > (@STAFF_SALLERY_ABSENT + (@STAFF_SALLERY_LATE /@late_per_absent))
								--		--			begin														
								--		--				set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--		--				set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--		--			end
								--		--		else
								--		--			begin
								--		--				set @deduct_days = @deduct_days - @current_leaves_limit
								--		--				set @current_leaves_limit = 0
								--		--			end
												
								--		--	end
								--		--else
								--		--	begin																						
								--				set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_ABSENT
								--				if @current_leaves_limit > @STAFF_SALLERY_ABSENT
								--					begin														
								--						set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT
								--						set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_ABSENT
								--					end
								--				else
								--					begin
								--						set @deduct_days = @deduct_days - @current_leaves_limit
								--						set @current_leaves_limit = 0
								--					end
								--			--end										
											
								--	end
									
								--	if @new_month_leaves_limit <0
								--	begin
								--		set @new_month_leaves_limit = 0
								--	end
									
									
								
								
								--if @STAFF_SALLERY_LEAVE + @STAFF_SALLERY_ABSENT > 1
								--begin
				--					if @consecutive_absent_status = 'T'
				--						begin
				--							if @consecutive_leave_status = 'T'
				--								begin
													 
													 
				--									 Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type],ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(
				--											SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type],(@d1+number) as Date  
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
				--													--This is union for un attendance marks days count as Absent
				--													union all

				--							select DATENAME(DW,all_days) as [Day Name], DATEPART(dd,all_days) as [Day], 'A' as [Type],all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				--FROM master..spt_values 
				--WHERE TYPE ='p'
				--	AND DATEDIFF(d,@d1,@d2) >= number
				--	--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
				--	AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'T'))A where A.all_days not in (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID)
															
				--											)A order by A.[Day]

				--											if @is_vacation_allowed = 1
				--											BEGIN
				--											delete from @t where date not between @summer_start_date and @summer_end_date and [Type] = 'A'
				--											delete from @t where date not between @winter_start_date and @winter_end_date and [Type] = 'A'
				--											END
				--								end
				--							else
				--								begin
				--									Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day],
				--												'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type] ,( @d1+number) as Date
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
				--												)A order by A.[Day]
				--								end
				--						end
				--					else
				--						begin
				--							if @consecutive_leave_status = 'T'
				--								begin
				--									Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type],( @d1+number) as Date
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
				--											)A order by A.[Day]
				--								end
				--						end
										
				--					if (@consecutive_before_weekends > 0 or @consecutive_after_weekends > 0) and @weekend_days_status = 'T'
				--						begin
				--							set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')

				--							if @weekend_days != 0
				--								begin
				--									--set @months_weekend = (select COUNT(*) from #temp2 where [Type] = 'W') / @weekend_days
				--									set @months_weekend = 0
				--									set @week_day = (select top(1) [Day] from @t where [Type] = 'W')

				--									while @week_day < 32
				--										begin	
				--											--set @week_row = (select row from #temp where row = @week_row)
															
				--											if (select COUNT(*) from @t where [Day] between (@week_day -@weekend_days) and (@week_day + @weekend_days + @weekend_days -1)) = @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends
				--											begin
				
				--												set @deduct_days = @deduct_days + @weekend_days 
				--												set @weekend_pair_count = @weekend_pair_count + @weekend_days
				--											end		
															
				--											set @week_day = @week_day + 7 - @months_weekend
				--						-- month weekend variable is used if the saturday is on and weekend holidays are 2 then add one in month weekend					 
				--											 set @months_weekend = 0
				--											 set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
				--											 while (select [Type] from @t where Day = @week_day) != 'W'	
				--											begin
				--												set @weekend_days = @weekend_days -1
				--												set @week_day = @week_day +1
				--												set @months_weekend = @months_weekend + 1
				--											end
												
															
				--											--select COUNT(*) from #temp2 where [Day] between (@week_day -@consecutive_before_weekends) and (@week_day + @weekend_days + @consecutive_after_weekends -1)
				--											--select @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends											
				--										end
				--								end
				--						END
								--end								
													
								--if @d1 <= @staff_joining_date and @STAFF_STATUS = 'T'
								--	begin
								--		if @STAFF_STATUS = 'T'
								--		begin
	--escaped for a while		--			set @staff_joining_date = @staff_left_date	
								--		end
								--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date)
								--	end								
								--else if @STAFF_STATUS = 'F'
								--begin
								--	 set @joining_date_days = DATEDIFF(DD, @staff_left_date, @d2)									 
								--end
								
								--set @deduct_days = @deduct_days + (@weekend_days * @weekend_pair_count)	+ @joining_date_days
								
								
								
				--if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)  and DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
				--	begin
				--		set @staff_joining_date_time = @staff_joining_date
				--		set @staff_left_date_time = @staff_left_date
						
				--		--for joining
				--		set @weekend_days_joining_based = (select COUNT(*) from 
				--			(SELECT (@staff_joining_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--			AND DATEDIFF(d,@staff_joining_date_time,@d2) >= number 
				--			and (@staff_joining_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--			)A)						
						
				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) - @weekend_days_joining_based
						
				--		set @staff_left_date_time = @staff_left_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--				(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--				AND DATEDIFF(d,@d1,@staff_left_date_time) >= number 
				--				and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--				)A)

				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_left_date) - @weekend_days_joining_based
						
				--	end				
				--else
				--	if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)
				--		begin
				--			set @staff_joining_date_time = @staff_joining_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--			(SELECT (@staff_joining_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--			AND DATEDIFF(d,@staff_joining_date_time,@d2) >= number 
				--			and (@staff_joining_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--			)A)	
														
				--	set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) - @weekend_days_joining_based
										
										
				--		end	
				--	else if DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
				--	begin
				--		set @staff_left_date_time = @staff_left_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--				(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--				AND DATEDIFF(d,@d1,@staff_left_date_time) >= number 
				--				and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--				)A)

				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_left_date) - @weekend_days_joining_based
				--	end
				
				--Sandwich leaves Calculation
				
				
				set @sandwich_days = ISNULL((select dbo.sf_Calculate_Sandwich_Leaves (@STAFF_SALLERY_ABSENT,@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@d1,@d2,@BR_ID)),0)
				set @deduct_days = @deduct_days + @sandwich_days

				set @weekend_days_joining_based = 0
				set @exceptional_days_joining_based = 0
				set @staff_joining_date_time = @staff_joining_date
				set @staff_left_date_time = @staff_left_date
			if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)  and DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
					begin

									if @staff_joining_date >= @staff_left_date
									begin
										if @staff_joining_date = @staff_left_date
										begin										
											set @joining_date_days = DATEDIFF(DD, @staff_left_date,@staff_joining_date)
										end
										else 
										begin
											set @joining_date_days = DATEDIFF(DD, @staff_left_date,@staff_joining_date) -1
										end
										set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@staff_left_date_time,@staff_joining_date_time) >= number 
															and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)
															
										set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @staff_joining_date and ANN_HOLI_STATUS = 'T')		
									end
									else
									begin
										set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) + DATEDIFF(DD, @staff_left_date,@d2)
										
										
										set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@d1,@staff_joining_date_time) >= number 
															and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)
															+
															(select COUNT(*) from 
															(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@staff_left_date_time, @d2) >= number 
															and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)B)
															
										set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @d1 and @staff_joining_date and ANN_HOLI_STATUS = 'T') + 
																			(select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @d2 and ANN_HOLI_STATUS = 'T')		

									end
						
						
					end				
				else
					if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)
						begin
														
							set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date)
							set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@d1,@staff_joining_date_time) >= number 
															and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)	
															
															
							set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @d1 and @staff_joining_date and ANN_HOLI_STATUS = 'T')		
										
						end	
					else if DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
					begin
						set @joining_date_days = DATEDIFF(DD, @staff_left_date,@d2)
						set @weekend_days_joining_based = (select COUNT(*) from 
														(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
														AND DATEDIFF(d,@staff_left_date_time,@d2) >= number 
														and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
														)A)	
					set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @d2 and ANN_HOLI_STATUS = 'T')		
					end
				
				--Comment due to salary will deduct on weekend holidays before start joining
					--if @weekend_days_status = 'F'
					--begin
					--	--set @joining_date_days = @joining_date_days - @weekend_days_joining_based - @weekend_pair_count
					--	set @joining_date_days = @joining_date_days -- @weekend_days_joining_based - @weekend_pair_count
					--end
					
					--if @except_days_status = 'F'
					--begin
					--	set @joining_date_days = @joining_date_days - @exceptional_days_joining_based
					--end
								set @deduct_days = @deduct_days + @joining_date_days								
								
								

								delete from @t
									
								delete from @tbl_leaves

								insert into @tbl_leaves
								select * from dbo.sf_GET_LEAVES_RECORD (@STAFF_SALLERY_DATE, @STAFF_SALLERY_STAFF_ID)
								
								set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT + @weekend_pair_count
								update STAFF_SALLERY set STAFF_SALLERY_ABSENTS = STAFF_SALLERY_ABSENTS + @weekend_pair_count where STAFF_SALLERY_ID =  @STAFF_SALLERY_MAX

								set @total_leaves_record = 0
								set @total_leaves_record = (select SUM(Leaves) from @tbl_leaves)
								--if @total_leaves_record > 0
								--BEGIN
								--	set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT - @total_leaves_record
								--END

									set @staff_absent_calc = 0
									set @staff_leaves_calc = 0
									--In case of absent
									if @remaining_leaves_limit_causal > 0 and @deduct_absent_status = 'T'
									BEGIN
										if @remaining_leaves_limit_causal >= @STAFF_SALLERY_ABSENT + @sandwich_days --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_absent_calc = @STAFF_SALLERY_ABSENT
											set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @STAFF_SALLERY_ABSENT
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN
											set @staff_absent_calc = @remaining_leaves_limit_causal
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END

									END


									if @remaining_leaves_limit_causal > 0 and @deduct_leaves_status = 'T'
									BEGIN
										if @remaining_leaves_limit_causal >= @STAFF_SALLERY_LEAVE --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = @STAFF_SALLERY_LEAVE
											set @deduct_days = @deduct_days - @STAFF_SALLERY_LEAVE
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @STAFF_SALLERY_LEAVE
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN
											set @staff_leaves_calc = @remaining_leaves_limit_causal
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END

									END
									
									--Short Leaves From Limit Causal
									if @remaining_leaves_limit_causal > 0
									BEGIN
										if @remaining_leaves_limit_causal >= (@STAFF_SALLERY_HALF_DAY / 2) --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = (@STAFF_SALLERY_HALF_DAY / 2)
											set @deduct_days = @deduct_days - (@STAFF_SALLERY_HALF_DAY / 2)
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - (@STAFF_SALLERY_HALF_DAY / 2)
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN											
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END
									END

									--Short Leaves From Limit Annual
									if @remaining_leaves_limit_annual > 0
									BEGIN
										if @remaining_leaves_limit_annual >= (@STAFF_SALLERY_HALF_DAY_Annual / 2) --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = (@STAFF_SALLERY_HALF_DAY_Annual / 2)
											set @deduct_days = @deduct_days - (@STAFF_SALLERY_HALF_DAY_Annual / 2)
											set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - (@STAFF_SALLERY_HALF_DAY_Annual / 2)
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN											
											set @deduct_days = @deduct_days - @remaining_leaves_limit_annual
											set @remaining_leaves_limit_annual = 0
										END
									END


								
									set @m = 1
								
								set @count_total_leaves_record = (select COUNT(*) from @tbl_leaves)
								set @is_causul_leaves  = 0
								set @is_annual_leaves  = 0
								set @total_causul_leaves  = 0
								set @total_annual_leaves  = 0
								set @leaves_record  = 0
								--set @is_annual_leave_deduct  = 0
								WHILE @m <= @count_total_leaves_record
								BEGIN
									select @is_annual_leaves = [Is Annual Leaves], @is_causul_leaves = [Is Causal Leaves],@leaves_record = Leaves from @tbl_leaves where sr = @m
									set @deduct_days = @deduct_days + @leaves_record
									set @STAFF_SALLERY_LEAVE = @STAFF_SALLERY_LEAVE + @leaves_record
									set @is_annual_leave_deduct = 0
									if @is_causul_leaves = 1
									BEGIN
										if @remaining_leaves_limit_causal > 0
										BEGIN
											if @remaining_leaves_limit_causal >= @leaves_record
											BEGIN
												set @total_causul_leaves = @total_causul_leaves + @leaves_record
												set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @leaves_record
												set @deduct_days = @deduct_days - @leaves_record
												set @leaves_record = 0
											END
											else
											BEGIN
												set @total_causul_leaves = @total_causul_leaves + @remaining_leaves_limit_causal
												set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
												set @leaves_record = @leaves_record - @remaining_leaves_limit_causal
												set @remaining_leaves_limit_causal = 0
												--if @is_annual_leaves = 1
												--BEGIN
												--	set @total_annual_leaves = @total_annual_leaves + @leaves_record - @remaining_leaves_limit_causal
												--END
												--ELSE
												--BEGIN
												--	set @deduct_days = @deduct_days + @leaves_record - @remaining_leaves_limit_causal
												--END
												--set @is_annual_leave_deduct = 1
												--set @remaining_leaves_limit_causal = 0
											END
										END
									END


									if @leaves_record > 0 --AND @is_annual_leave_deduct = 0
									BEGIN
										if @is_annual_leaves = 1
										BEGIN
											if @remaining_leaves_limit_annual > 0 OR @annual_leaves_From_Next_Year = 'T'
											BEGIN
												if @remaining_leaves_limit_annual >= @leaves_record
												BEGIN
													set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - @leaves_record
													set @deduct_days = @deduct_days - @leaves_record
													set @total_annual_leaves = @total_annual_leaves + @leaves_record
													set @leaves_record = 0
												END
												ELSE
												BEGIN
													if (@annual_leaves_From_Next_Year = 'T')
													BEGIN
														set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - @leaves_record
														set @deduct_days = @deduct_days - @leaves_record
														set @total_annual_leaves = @total_annual_leaves + @leaves_record
														set @leaves_record = 0
													END
													ELSE
													BEGIN
														set @total_annual_leaves = @total_annual_leaves + @remaining_leaves_limit_annual
														set @deduct_days = @deduct_days - @remaining_leaves_limit_annual
														set @leaves_record = @leaves_record - @remaining_leaves_limit_annual
														set @remaining_leaves_limit_annual = 0
													END
												END
											END
										END
										--set @total_annual_leaves = @total_annual_leaves + @leaves_record
									END
									set @m = @m + 1
								END

								--if @annual_leaves_limit_new >= @total_annual_leaves
								--BEGIN
								--	set @deduct_days = @deduct_days - @total_annual_leaves
								--	set @annual_leaves_limit_new = @annual_leaves_limit_new - @total_annual_leaves
								--END
								--ELSE
								--BEGIN
								--	set @deduct_days = @deduct_days + @total_annual_leaves - @annual_leaves_limit_new
								--	set @annual_leaves_limit_new = 0
								--END

									--Insertion in Staff Leaves Calculation only those absent and leaves that are minus from limit

									if @leave_type != 'No Deduction'
									BEGIN
										if @STAFF_SALLERY_PRESENT = 0
										BEGIN
											set @deduct_days = 30
										END
									END
									ELSE
									BEGIN
										set @deduct_days = 0
									END
									


									EXEC sp_GET_MANUAL_DEDUCTION_DAYS @STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@deduct_days,@set_deduct_days output

									if @set_deduct_days != -1
										set @deduct_days = 30 - @set_deduct_days

									

								--	if DATEPART(MM,@STAFF_SALLERY_DATE) = 1 and DATEPART(YYYY,@STAFF_SALLERY_DATE) = 2018
								--BEGIN
								--	if @STAFF_SALLERY_STAFF_ID = 80177  OR @STAFF_SALLERY_STAFF_ID = 80178 
								--		set @deduct_days = @deduct_days - 1

								--		if @STAFF_SALLERY_STAFF_ID = 80176
								--			set @deduct_days = 9

								--		if @STAFF_SALLERY_STAFF_ID = 80179
								--			set @deduct_days = 24

								--		if @STAFF_SALLERY_STAFF_ID  = 70133
								--			set @deduct_days = 28

								--		if @STAFF_SALLERY_STAFF_ID  = 70122
								--			set @deduct_days = 0

								--		if @STAFF_SALLERY_STAFF_ID  = 70156
								--			set @deduct_days = 0
										
								--END

								if @deduct_days > 30
									BEGIN
										set @deduct_days = 30
									END
									insert into STAFF_LEAVES_CALC
									VALUES
									(
										@STAFF_SALLERY_STAFF_ID,
										@STAFF_SALLERY_DATE,
										@remaining_leaves_limit_causal,
										@staff_leaves_calc,
										@staff_absent_calc,
										@STAFF_SALLERY_PRESENT,
										@STAFF_SALLERY_LATE,
										@new_month_leaves_status,
										@new_year_leaves_status,
										@late_per_absent,
										@total_causul_leaves,
										@total_annual_leaves,
										@remaining_leaves_limit_annual,
										@sandwich_days
									)
																		
																
									
									--STAFF deduction														
														set @count = 0
														set @j = 1
														
														set @count = ( select COUNT( STAFF_DEDUCTION_ID) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_DEDUCTION_STATUS = 'T')
														while @j <= @count

															BEGIN																																																																
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_DEDUCTION_ID) ROW,STAFF_DEDUCTION_DED_ID ID from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_DEDUCTION_STATUS = 'T'
																		)
																		
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, ID ,  dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'D',@per_day_salary),@deductions,'T',0,'F','Not Refunded' from TBL where ROW = @j 
																		
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j
																		set @STAFF_SALLERY_DEFF_MAX = SCOPE_IDENTITY()
																		set @STAFF_DEFF_ID = (select STAFF_SALLERY_DEFF_NAME from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX )
																																				
																		--select  @STAFF_SALLERY_STAFF_ID staff_id, @STAFF_SALLERY_DEFF_MAX deff_if_max,@STAFF_DEFF_ID ded_deff_id,@STAFF_SALLERY_DATE [date] 																		
																		
																		exec [sp_func_get_complete_deduction_amount] @STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DEFF_MAX,@STAFF_DEFF_ID,@STAFF_SALLERY_DATE,@per_day_salary, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, @STAFF_SALLERY_DEFF_MAX, @acc_vch_main_id
																		set @j = @j + 1	
															END;
															
														-- STAFF allownce
														set @count = 0
														set @j = 1
														declare @allowance_id int =0 
														set @count = ( select COUNT( STAFF_ALLOWANCE_ID) from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_ALLOWANCE_STATUS = 'T')
														while @j <= @count

															BEGIN		
																																													
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_ALLOWANCE_ID) ROW,STAFF_ALLOWANCE_ALLOW_ID ID from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_ALLOWANCE_STATUS = 'T'
																		)
																		select @allowance_id = ID from TBL where ROW = @j 
																		declare @allowance_amount float = 0
																		--set @earning_deff_amount = dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'A')
																		set @allowance_amount = dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,@allowance_id,@STAFF_SALLERY_DATE,'A',@per_day_salary)
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, @allowance_id, @allowance_amount,@earnings,'T',0,'F','Not Refunded' 
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j
																		declare @idd_def numeric = 0
																		set @idd_def = SCOPE_IDENTITY()
																		-- advance accountings
																		if dbo.get_advance_accounting(@STAFF_SALLERY_BR_ID) = 1
																		BEGIN
																		
																		set @HD_ID = CAST((@STAFF_SALLERY_HD_ID) as nvarchar(50))
																		set @BR_ID = CAST((@STAFF_SALLERY_BR_ID) as nvarchar(50))
																			select @VCH_DEF_COA = COA_UID from TBL_COA where  CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
																			(select DEDUCTION_NAME from DEDUCTION where DEDUCTION_ID = @STAFF_DEFF_ID) and COA_isDeleted = 0
																			declare @VCH_reference_no nvarchar(50)= CAST((@idd_def) as nvarchar(50))
																			
																		declare @datetime datetime = getdate()																		
																		declare @debit float = @allowance_amount
																		declare @credit float = 0

																			exec sp_TBL_VCH_DEF_insertion @acc_vch_main_id, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID, @BR_ID,0,1,''
																		END
																	set @j = @j + 1																																				
															END;
														
														--STAFF loan
															set @loan_amount = 0
															set @count = 0
															set @j = 1
															set @count = ( select COUNT( STAFF_LOAN_ID) from STAFF_LOAN where STAFF_LOAN_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_LOAN_STATUS = 'T')

															--If Not Loan just Entry to shown in Payslip
															if @count = 0
															BEGIN
																insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, -1 , 0 ,@loan,'T',0,'F','Not Refunded' 
															END
														while @j <= @count

															BEGIN																													
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_LOAN_ID) ROW,STAFF_LOAN_ID ID from STAFF_LOAN where STAFF_LOAN_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_LOAN_STATUS = 'T'
																		)																		

																		--select @loan_amount = @loan_amount + ( select dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'L') from TBL where ROW = @j )
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, ID , dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'L',@per_day_salary),@loan,'T',0,'F','Not Refunded' from TBL where ROW = @j 																		
																		
																		set @STAFF_SALLERY_DEFF_MAX = SCOPE_IDENTITY()
																		set @STAFF_DEFF_ID = (select STAFF_SALLERY_DEFF_NAME from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX )
																		EXEC sp_LOAN_TYPE_INSTALLEMENT_UPDATION @STAFF_DEFF_ID, @crrnt_month, @crrnt_year
																		
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j

																	set @j = @j + 1
																		
															END
												
												--Commission
												 if @is_commission = 'T'
													begin
														insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @allownc_commission_id, @commision, 'E','T',0,'F','Not applicable')
													end
												
												
												--Overtime
												if @is_overtime = 'T' and @is_overtime_payslip = 'T'
												begin
													set @per_hour_salary = @per_day_salary / @overtime_hours_in_day
													 set @overtime_hours =  (select overtime from dbo.CALCULATE_OVERTIME(@STAFF_SALLERY_STAFF_ID, DATEADD(month, DATEDIFF(month, 0, @STAFF_SALLERY_DATE), 0),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @STAFF_SALLERY_DATE) + 1, 0)), @overtime_minutes_in_hour))
													 set @overtime_salary = @overtime_hours * @per_hour_salary 
													 insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @allownc_overtime_id, @overtime_salary, 'E','T',0,'F','Not applicable')
												end
												
												--late time deduction calculation
											set @deduction_late_time_status = (select STAFF_LEAVES_LATE_DEDUCTION_TYPE from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	

											if @deduction_late_time_status = 'Minute'
											begin
												set @deducution_late_time_amount = dbo.LATE_TIME_DEDUCTION_CALCULATION (@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @per_day_salary)
												insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @deduction_late_time_id, @deducution_late_time_amount, 'D','T',0,'F','Not applicable')
											end
															
															--insert into STAFF_SALLERY_DEFF
															--select @STAFF_SALLERY_MAX, 0 , @loan_amount ,@loan,'T'														
															--select @loan_amount loan_amount
															
										set @calc_allow = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @earnings and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										set @calc_deduct = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @deductions and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										set @calc_loan = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @loan and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										update STAFF_SALLERY
										set
										STAFF_SALLERY_GROSS_EARN = @calc_allow,										
										STAFF_SALLERY_GROSS_DEDUCT = @calc_deduct + @calc_loan,
										STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT = 0	,
										STAFF_SALLERY_PER_DAY_SALARY = @per_day_salary,
										STAFF_SALLERY_OVERTIME_TOTAL_HOURS = @overtime_hours,
										STAFF_SALLERY_OVERTIME_PER_HOUR = @per_hour_salary,
										STAFF_SALLERY_LEAVES =  @STAFF_SALLERY_LEAVE			
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									
									-- Days that are in vacation only for teachers
									--if charindex('Teacher',@STAFF_DESIGNATION) > 0 AND @STAFF_DESIGNATION != 'Visiting Teacher'
									--BEGIN
									--	set @deduct_days = 0
										
									--	--Need to see logic working days calculation to be exact. June 2017 working days are 27 because 3 days are eidulfitar holiday but this in logic it shows 30 days and it calculates wrong calculation
									--	--set @deduct_days = @deduct_days - (select COUNT(*) from (SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'  and (@d1 + number) <=@d2 and ((NOT ((@d1 + number) between @summer_start_date and @summer_end_date)) OR (NOT ((@d1 + number) between @winter_start_date and @winter_end_date))))A)
									--END
									
									--if @leave_type = 'No Deduction'
									--BEGIN										
										set @deducted_salary = @per_day_salary * @deduct_days
									--END

									set @deducted_salary = (select ISNULL(@deducted_salary, 0))


									if DATEPART(MM,@STAFF_SALLERY_DATE) = 1 and DATEPART(YYYY,@STAFF_SALLERY_DATE) = 2018
									BEGIN
										if @STAFF_SALLERY_STAFF_ID = 80176
										BEGIN
											set @deducted_salary = 6750
										END
									END

									
									set @total_weekend_days = 0
									if @weekend_days_status = 'F' 
									BEGIN
										set @total_weekend_days = (select [dbo].[Get_weekend_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE))
										select * from STAFF_SALLERY
									END
									--set @deducted_salary = @basic_salary - (@working_days * @per_day_salary) + @deducted_salary-- @deducted_salary + (@total_weekend_days	* @per_day_salary)
									set @net_salary = @basic_salary + @calc_allow -@calc_deduct - @calc_loan - @deducted_salary
									
									


									--select @basic_salary as bs, @calc_allow as al, @calc_deduct as ded, @calc_loan as lon, @deducted_salary as ds, @per_day_salary as pds 
									update STAFF_SALLERY
										set
										STAFF_SALLERY_NET_TOLTAL = CONVERT(decimal(18,0), @net_salary),
										STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY,
										STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT = CONVERT(decimal(18,0), @deducted_salary),
										--STAFF_SALLERY_LATE_LIMIT = @late_per_absent,
										STAFF_SALLERY_DEDUCT_DAYS = @deduct_days
										
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									
									update STAFF_SALLERY_DEFF set STAFF_SALLERY_DEFF_REFUND_STATUS = 'Not applicable'
										where STAFF_SALLERY_DEFF_REFUND = 'F' and STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX
									--select STAFF_SALLERY_NET_TOLTAL net_total from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
											
									
								 end
								
								if @send_sms = 'T'
								BEGIN
									insert into @t_sms exec dbo.[sp_SMS_INSERT] @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,@STAFF_SALLERY_MAX, @STAFF_SALLERY_USER_ID, 'S'
								END
								END--Leave Type is Not Generate Salary					
							set @i = @i + 1
						end			
				
					
					
			select * from STAFF_SALLERY where STAFF_SALLERY_DATE = @STAFF_SALLERY_DATE			
			select * from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID in ( select STAFF_SALLERY_ID from STAFF_SALLERY where STAFF_SALLERY_DATE = @STAFF_SALLERY_DATE	 )
			select * from @t_sms							

END
					
					
ELSE IF @STATUS = 'B'
BEGIN

			set @staff_salary_count = (select COUNT(*) from STAFF_SALLERY where DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
				DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and	STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
				STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) and STAFF_SALLERY_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
				
				if @staff_salary_count > 0
				begin

					delete from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID in
					(select STAFF_SALLERY_ID from STAFF_SALLERY 
					where  
						DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))and 
						STAFF_SALLERY_STAFF_ID = @STAFF_SALLERY_STAFF_ID )


					delete from STAFF_SALLERY 
					where  
						DATEPART(MM,STAFF_SALLERY_MONTH_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_SALLERY_MONTH_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						STAFF_SALLERY_HD_ID =  @STAFF_SALLERY_HD_ID and 
						STAFF_SALLERY_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)) and
						STAFF_SALLERY_STAFF_ID = @STAFF_SALLERY_STAFF_ID

						delete from STAFF_LEAVES_CALC 
						where 
						DATEPART(MM,STAFF_LEAVES_CALC_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and       
						DATEPART(YYYY,STAFF_LEAVES_CALC_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and						
						STAFF_LEAVES_CALC_STAFF_ID = @STAFF_SALLERY_STAFF_ID
						
						update LOAN_TYPE set LOAN_TYPE_INSTALLEMENT_STATUS = 'F' where CONVERT(int, LOAN_TYPE_MONTH) = DATEPART(MM,@STAFF_SALLERY_DATE) and CONVERT(int, LOAN_TYPE_YEAR) = DATEPART(YYYY,@STAFF_SALLERY_DATE)
				end
				
				--set @total_units = (select COM_UNITS_TOTAL_UNITS from PYRL_COMMSN_UNITS where DATEPART(MM,@STAFF_SALLERY_DATE) = DATEPART(MM,COM_UNITS_DATE) and  DATEPART(YYYY,@STAFF_SALLERY_DATE) = DATEPART(YYYY,COM_UNITS_DATE) )
				--set @total_staff = (select COUNT(*) from TEACHER_INFO where TECH_IS_COMMISION = 'T' and TECH_STATUS = 'T')
				--set @commission_defintion_count =  (select count(*) from ALLOWANCE where ALLOWANCE_NAME = 'Commission')
					
				--	if @commission_defintion_count = 0
				--	begin
				--		insert into ALLOWANCE values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Commission','NA', @STAFF_SALLERY_DATE, 'T')
				--		set @allownc_commission_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @allownc_commission_id = (select ALLOWANCE_ID from ALLOWANCE where ALLOWANCE_NAME = 'Commission')
				--	end
					
				--	set @commission_formula = (select top(1) BR_ADM_PAYROLL_COMMSSION_FORMULA from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)
				--	if @total_staff !=0
				--	BEGIN
				--	set @commision_general = (CAST(((select val from dbo.split(@commission_formula, ',') where id = 1)) as float) * CAST(((select val from dbo.split(@commission_formula, ',') where id = 2)) as float) / @total_staff)
				--	END


				--	--Overtime defintion

				--	set @commission_defintion_count = 0
				--	set @commission_defintion_count =  (select count(*) from ALLOWANCE where ALLOWANCE_NAME = 'Overtime')
					
				--	if @commission_defintion_count = 0
				--	begin
				--		insert into ALLOWANCE values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Overtime','NA', @STAFF_SALLERY_DATE, 'T')
				--		set @allownc_overtime_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @allownc_overtime_id = (select ALLOWANCE_ID from ALLOWANCE where ALLOWANCE_NAME = 'Overtime')
				--	end
					
				--	--deduction late time definition
				--	set @deduction_late_time_count = 0
				--	set @deduction_late_time_count = (select count(*) from DEDUCTION where DEDUCTION_NAME = 'Late Time Deduction')
				--	if @deduction_late_time_count = 0
				--	begin
				--		insert into DEDUCTION values (@STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, 'Late Time Deduction','NA', @STAFF_SALLERY_DATE, 'T')						
				--		set @deduction_late_time_id = SCOPE_IDENTITY()
				--	end
				--	else
				--	begin
				--		set @deduction_late_time_id = (select DEDUCTION_ID from DEDUCTION where DEDUCTION_NAME = 'Late Time Deduction')
				--	end
				select   @leave_type = ISNULL([Leaves Type],'None'),@STAFF_STATUS = [Status], @staff_joining_date = [Joining Date], @staff_left_date = [Left Date], @is_commission = ISNULL([Is Commission],'F'), @is_overtime = ISNULL([Is Overtime],'F'),@is_vacation_allowed = ISNULL([Is Vacation Allowed],0),@STAFF_DESIGNATION = Designation from VTEACHER_INFO where ID = @STAFF_SALLERY_STAFF_ID

					if @leave_type != 'Not Generate Salary'
					BEGIN
					if @overtime_minutes_in_hour is null
						begin
							select @overtime_minutes_in_hour = ISNULL(BR_ADM_PAYROLL_MINUTES_IN_HOUR,60) from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID
						end

					if @overtime_hours_in_day is null
					begin
						select @overtime_hours_in_day = BR_ADM_PAYROLL_HOURS_IN_DAY from BR_ADMIN where BR_ADM_HD_ID = @STAFF_SALLERY_HD_ID and BR_ADM_ID = @STAFF_SALLERY_BR_ID 									
						if @overtime_hours_in_day is null
						begin
							select @time_in =  CAST((WORKING_HOURS_TIME_IN) as time) , @time_out =  CAST((WORKING_HOURS_TIME_OUT) as time) from WORKING_HOURS where WORKING_HOURS_HD_ID = @STAFF_SALLERY_HD_ID and WORKING_HOURS_BR_ID = @STAFF_SALLERY_BR_ID
							set @total_time = CAST((@time_out) as datetime) - CAST((@time_out) as datetime)
							set @minutes = DATEPART(MINUTE, @total_time)
							set @hours = DATEPART(HOUR, @total_time)
							set @overtime_hours_in_day = @hours + (@minutes / 60)
						end
					end


					--and [Status] = 'T'
								
								if @STAFF_STATUS = 'F'
								begin
									if DATEPART(MM,@STAFF_SALLERY_DATE) = DATEPART(MM, @staff_left_date) and DATEPART(yyyy,@STAFF_SALLERY_DATE) = DATEPART(yyyy, @staff_left_date)
									begin
										set @is_continue = 'T'
									end
									else if @STAFF_SALLERY_DATE >@staff_left_date
									begin
										set @is_continue = 'F'
									end	
									else
									begin
										set @is_continue = 'T'
									end
								end
								
								else
								begin
									set @is_continue = 'T'
								end
									
								
								if @STAFF_SALLERY_STAFF_ID is not null	and @STAFF_SALLERY_STAFF_ID != 0 and @is_continue = 'T'
											 begin				
											 SELECT @d1 = (SELECT DATEADD(mm, DATEDIFF(mm,0,@STAFF_SALLERY_DATE), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@STAFF_SALLERY_DATE)+1,0)) )									 			 				 							 
													--set @working_days = [dbo].[Get_working_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE) - 
													set @working_days = 30
													set @except_days_status = (select STAFF_LEAVES_ADD_EXCEPTIONAL_HOLIDAYS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
													set @weekend_days_status = (select STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
													 if @except_days_status = 'F'
													 begin
														set @working_days = @working_days - (select COUNT(*) from ANNUAL_HOLIDAYS 
														where DATEPART(MM, ANN_HOLI_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(yyyy, ANN_HOLI_DATE) = DATEPART(yyyy, @STAFF_SALLERY_DATE)
														and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_STATUS = 'T' and ANN_HOLI_DATE
														not in ( SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
														AND DATENAME(w,@d1+number) in (select WORKING_DAYS_NAME from WORKING_DAYS where WORKING_DAYS_VALUE = 0))														
														)
														-- sub query not in calculate the exceptional holidays not be in weekend holiday for each staff											
													end
													
													--if (select DATEDIFF(DD, @d1, @d2) + 1) != @working_days
													----if @except_days_status = 'T'
													--begin
													--		set @working_days = @working_days + (select COUNT(*) from 
													--		(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
													--		AND DATENAME(w,@d1+number) in (select WORKING_DAYS_NAME from WORKING_DAYS where WORKING_DAYS_VALUE = 0))A
													--		where A.date1 in ( select date2 from (select distinct ATTENDANCE_STAFF_DATE  as date2 from ATTENDANCE_STAFF 
													--		where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
													--		DATEPART(MM,ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and 
													--		DATEPART(yyyy,ATTENDANCE_STAFF_DATE) = DATEPART(yyyy, @STAFF_SALLERY_DATE))B))
													--		--add weekend holidays attenedance in the working days if working days is not eqaul the total days of that month
													--end
													
													
											
											
											--select @working_days working days

									set @STAFF_SALLERY_ABSENT =	dbo.GET_ATTENDANCE_COUNT('A',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_LATE = dbo.GET_ATTENDANCE_COUNT('LA',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)		
									set @STAFF_SALLERY_LEAVE = dbo.GET_ATTENDANCE_COUNT('LE',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_PRESENT = dbo.GET_ATTENDANCE_COUNT('P',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_WH = dbo.GET_ATTENDANCE_COUNT('WH',@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,default)
									set @STAFF_SALLERY_EARLY_DEPARTURE = (select dbo.GET_EARLY_DEPARTURE(@STAFF_SALLERY_STAFF_ID, @early_minutes,@d1,@d2))
									--(select COUNT(*) from ( select ROW_NUMBER() over(partition by ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_TYPE_ID order by CONVERT(time, ATTENDANCE_STAFF_TIME_OUT) DESC) as sr ,ATTENDANCE_STAFF_TYPE_ID, ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_REMARKS ,ATTENDANCE_STAFF_TIME_IN,ATTENDANCE_STAFF_TIME_OUT,ATTENDANCE_STAFF_CURRENT_TIME_IN, ATTENDANCE_STAFF_CURRENT_TIME_OUT from ATTENDANCE_STAFF where DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID)A where sr = 1 and ATTENDANCE_STAFF_REMARKS not in ('LE', 'A') and DATEADD(Mi, @early_minutes,CONVERT(time, ATTENDANCE_STAFF_TIME_OUT)) <  CONVERT(time, ATTENDANCE_STAFF_CURRENT_TIME_OUT) and ATTENDANCE_STAFF_DATE not in (select dates from dbo.GET_ALL_LEAVES_DATE (@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE)))
									set @STAFF_SALLERY_HALF_DAY = (select COUNT(*) from SHORT_LEAVE where  DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and DATEPART(MM, SHORT_LEAVE_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, SHORT_LEAVE_DATE)  = DATEPART(YYYY, @STAFF_SALLERY_DATE) and SHORT_LEAVE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and ISNULL(SHORT_LEAVE_IS_ANNUAL,CAST(0 as bit)) = CAST(0 as bit))
									set @STAFF_SALLERY_HALF_DAY_Annual = (select COUNT(*) from SHORT_LEAVE where  DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and DATEPART(MM, SHORT_LEAVE_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, SHORT_LEAVE_DATE)  = DATEPART(YYYY, @STAFF_SALLERY_DATE) and SHORT_LEAVE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and ISNULL(SHORT_LEAVE_IS_ANNUAL,CAST(0 as bit)) = CAST(1 as bit))

									set @STAFF_SALLERY_HALF_DAY_Total = @STAFF_SALLERY_HALF_DAY + @STAFF_SALLERY_HALF_DAY_Annual
									set @remaining_leaves_limit_causal = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_SALLERY_STAFF_ID,DATEADD(M,-1,@STAFF_SALLERY_DATE),@STAFF_SALLERY_BR_ID,'C')
									
													--select @STAFF_SALLERY_ABSENT [absent],@STAFF_SALLERY_LATE [late],@STAFF_SALLERY_LEAVE [leave],@STAFF_SALLERY_PRESENT [present],@STAFF_SALLERY_WH [work_holiday]								
									set @unattendance_mark_days = (select [dbo].GET_UNATTENDANCE_MARKS_DAYS(@STAFF_SALLERY_STAFF_ID, @d1,@d2,@HD_ID,@BR_ID))
--									set @unattendance_mark_days = [dbo].[Get_working_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE,default) - (@STAFF_SALLERY_PRESENT + @STAFF_SALLERY_ABSENT + @STAFF_SALLERY_LEAVE + 
--									@STAFF_SALLERY_LATE + @STAFF_SALLERY_WH + @STAFF_SALLERY_HALF_DAY ) -
--									--calculate the week days of the staff
--									(select COUNT(*) from
--(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
--AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_DAY_STATUS = 'F' and STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID))A)

									set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT + @unattendance_mark_days

									set @commision = @commision_general * @STAFF_SALLERY_PRESENT
											
										 insert into STAFF_SALLERY
										 values
										 (
											@STAFF_SALLERY_HD_ID,
											@STAFF_SALLERY_BR_ID,
											@STAFF_SALLERY_STAFF_ID,
											@working_days,
											@STAFF_SALLERY_PRESENT,
											@STAFF_SALLERY_ABSENT,
											@STAFF_SALLERY_LATE,
											@STAFF_SALLERY_LEAVE,
											GETDATE(),
											0,
											0,
											0,
											0,
											'Payable',
											0,
											0,
											0,
											0,
											GETDATE(),
											@STAFF_SALLERY_DATE,
											0,
											0,
											0, 
											@STAFF_SALLERY_EARLY_DEPARTURE,
											@STAFF_SALLERY_HALF_DAY_Total,
											(select STAFF_LEAVES_LATE_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID ),
											(select STAFF_LEAVES_EARLY_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID )
										 )
								
										set @STAFF_SALLERY_MAX = SCOPE_IDENTITY()

							if @is_advance_Accounting = 1
							 BEGIN
								 insert into @tbl_vch exec sp_TBL_VCH_MAIN_insertion @acc_prefix, @acc_datetime, '','',@STAFF_SALLERY_MAX,'','',0,0,'',@HD_ID,@BR_ID,0
								 set @acc_vch_main_id = (select top(1) ID from @tbl_vch order by sr DESC )
							 END			

											--select STAFF_SALLERY_GROSS_EARN earnings,STAFF_SALLERY_GROSS_DEDUCT deductions from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									set @per_day_salary_type = (select ISNULL(STAFF_LEAVES_PER_DAY_SALARY_TYPE,'Monthly') from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @per_day_salary_type = ISNULL(@per_day_salary_type,'Monthly')
									set @decuct_status = (select STAFF_LEAVES_ADD_DEDUCTION from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @allowance_status = (select STAFF_LEAVES_ADD_ALLOWANCES from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @loan_status = (select STAFF_LEAVES_ADD_LOAN from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
									set @basic_salary = (select TECH_SALLERY from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
									set @staff_joining_date = (select TECH_JOINING_DATE from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
									set @basic_salary = (select ISNULL(@basic_salary ,0))
									set @staff_joining_date = (select ISNULL(@staff_joining_date, '2013-01-01'))
									set @STAFF_SALLERY_MONTH_SALARY = @basic_salary
										--set @STAFF_SALLERY_MONTH_SALARY = ( select ISNULL( @STAFF_SALLERY_MONTH_SALARY,0) )
									
									if @per_day_salary_type = 'Monthly'
									BEGIN	
										if @decuct_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_deduct										
										End
										else if @decuct_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_deduct										
										End
											
										if @allowance_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_allow										
										End
										else if @allowance_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_allow										
										End		
															
										if @loan_status = 'T0' 										
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY + @calc_loan										
										End
										else if @loan_status = 'T1'
										begin																				
											set @STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY - @calc_loan										
										End										
										set @per_day_salary = @STAFF_SALLERY_MONTH_SALARY / @working_days		
									END
									ELSE
									BEGIN
										set @per_day_salary = (@basic_salary * CAST(((select val from dbo.split(@per_day_salary_type,',') where id = 1)) as int)) / CAST(((select val from dbo.split(@per_day_salary_type,',') where id = 2)) as int)
									END

									if DATEPART(MM,@STAFF_SALLERY_DATE) = 1 and DATEPART(YYYY,@STAFF_SALLERY_DATE) = 2018
								BEGIN
									if @STAFF_SALLERY_STAFF_ID = 80176
									BEGIN
										set @per_day_salary = 1350
									END
								END

								set @absent_status = (select STAFF_LEAVES_ABSENT_DEDUCTION from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @leaves_status = (select STAFF_LEAVES_DEDUCTION_LEAVES from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @late_per_absent = (select STAFF_LEAVES_LATE_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @early_per_absent = (select STAFF_LEAVES_EARLY_PER_ABSENT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @deduct_leaves_status = (select STAFF_LEAVES_DEDUCT_LEAVES_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @deduct_absent_status = (select STAFF_LEAVES_DEDUCT_ABSENT_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	
								set @consecutive_absent_status =(select STAFF_LEAVES_CONSECUTIVE_ABSENT_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @consecutive_leave_status =(select STAFF_LEAVES_CONSECUTIVE_LEAVES_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
								set @consecutive_before_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_BEFORE_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID), 0)
								set @consecutive_after_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_AFTER_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0)
								set @decuct_absent_count = ISNULL((select STAFF_LEAVES_DEDUCT_ABSENT_COUNT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0) 
								set @decuct_leave_count = ISNULL((select STAFF_LEAVES_DEDUCT_LEAVES_COUNT from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0) 
								set @annual_leaves_From_Next_Year = (select STAFF_LEAVES_TRANSFER_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)

								select top(1) @old_month_leaves_limit = STAFF_LEAVES_CALC_MONTHLY_LIMIT,@old_month_leaves_status = STAFF_LEAVES_CALC_MONTH_STATUS,@annual_leaves_limit_new = STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT from STAFF_LEAVES_CALC
										where  STAFF_LEAVES_CALC_STAFF_ID = @STAFF_SALLERY_STAFF_ID	and
										datepart(MM, STAFF_LEAVES_CALC_DATE ) = datepart(MM,@STAFF_SALLERY_DATE)-1  and
										datepart(yyyy, STAFF_LEAVES_CALC_DATE ) = datepart(yyyy,@STAFF_SALLERY_DATE) 
										order by STAFF_LEAVES_CALC_DATE desc 
										select @old_month_leaves_limit = ISNULL( @old_month_leaves_limit,0), @old_month_leaves_status = ISNULL(@old_month_leaves_status,'F') 
										
									
											
										select top(1) @new_month_leaves_limit =  STAFF_LEAVES_YEAR,@new_month_leaves_status = 'F', @new_year_leaves_status = 'F', @annual_leaves_limit_old = (ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0))  from STAFF_LEAVES
										where  STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID										
										select @new_month_leaves_limit = ISNULL( @new_month_leaves_limit,0), @old_month_leaves_status = ISNULL(@old_month_leaves_status,'F') 
										
										--	set @annual_leaves_limit_new = ISNULL(@annual_leaves_limit_new,@annual_leaves_limit_old)

										----If Date is first month then renew the limit
										--if 	DATEPART(M,@STAFF_SALLERY_DATE) = 1
										--BEGIN
										--	set @annual_leaves_limit_new = @annual_leaves_limit_old
										--END

										--set @remaining_leaves_limit_annual = @annual_leaves_limit_new
										set @remaining_leaves_limit_annual = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@STAFF_SALLERY_BR_ID,'A')

										update STAFF_SALLERY
										set STAFF_SALLERY_LEAVES_LIMIT = @old_month_leaves_limit
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
										
									if @old_month_leaves_status = 'T'
										begin											
											set @new_month_leaves_limit =  @new_month_leaves_limit + @old_month_leaves_limit
										end
									set @current_leaves_limit = @new_month_leaves_limit
								update STAFF_SALLERY
								set STAFF_SALLERY_LEAVES_LIMIT = @new_month_leaves_limit
								where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
								
								if @absent_status = 'T'
									begin 
										set @deduct_days = @deduct_days + (CAST(@STAFF_SALLERY_ABSENT as float) * @decuct_absent_count)
									end	
									
								if @leaves_status = 'T'
									--if @STAFF_SALLERY_LEAVE > @new_month_leaves_limit
									--begin
										begin 
											set @deduct_days = @deduct_days + (CAST(@STAFF_SALLERY_LEAVE as float)  * @decuct_leave_count)-- -@new_month_leaves_limit
										end	
									--end

								if @late_per_absent > 0 
									begin
										set @deduct_days =  @deduct_days + CONVERT(int,(@STAFF_SALLERY_LATE /@late_per_absent))
									end

									if @early_per_absent > 0 
									begin
										set @deduct_days =  @deduct_days + CONVERT(int,(@STAFF_SALLERY_EARLY_DEPARTURE /@early_per_absent))
									end

									set @deduct_days  = @deduct_days + (@STAFF_SALLERY_HALF_DAY_Total / 2)
								
								
								--if @deduct_leaves_status = 'T'
								--	begin
								--		set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_LEAVE
								--		if @current_leaves_limit > 0
								--			begin
								--				if @current_leaves_limit > @STAFF_SALLERY_LEAVE
								--					begin
								--						set @deduct_days = @deduct_days - @STAFF_SALLERY_LEAVE
								--						set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_LEAVE
								--					end
								--				else
								--					begin
								--						set @deduct_days = @deduct_days - @current_leaves_limit
								--						set @current_leaves_limit = 0
								--					end
								--			end
										
								--	end									
									
									
								--if @deduct_absent_status = 'T'
								--	begin
								--		if @late_per_absent > 0
								--			begin
								--			set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--			if @current_leaves_limit > (@STAFF_SALLERY_ABSENT + (@STAFF_SALLERY_LATE /@late_per_absent))
								--					begin														
								--						set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--						set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_ABSENT - (@STAFF_SALLERY_LATE /@late_per_absent)
								--					end
								--				else
								--					begin
								--						set @deduct_days = @deduct_days - @current_leaves_limit
								--						set @current_leaves_limit = 0
								--					end
												
								--			end
								--		else
								--			begin																						
								--				set @new_month_leaves_limit = @new_month_leaves_limit - @STAFF_SALLERY_ABSENT
								--				if @current_leaves_limit > @STAFF_SALLERY_ABSENT
								--					begin														
								--						set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT
								--						set @current_leaves_limit = @current_leaves_limit - @STAFF_SALLERY_ABSENT
								--					end
								--				else
								--					begin
								--						set @deduct_days = @deduct_days - @current_leaves_limit
								--						set @current_leaves_limit = 0
								--					end
								--			end										
											
								--	end
									
								--	if @new_month_leaves_limit <0
								--	begin
								--		set @new_month_leaves_limit = 0
								--	end
									
									
								
								
								--if @STAFF_SALLERY_LEAVE + @STAFF_SALLERY_ABSENT > 1
								--begin
				--					if @consecutive_absent_status = 'T'
				--						begin
				--							if @consecutive_leave_status = 'T'
				--								begin
													 
													 
				--									 Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(
				--											SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type], ( @d1+number) as Date
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE))D)


				--													--This is union for un attendance marks days count as Absent
				--													union all

				--							select DATENAME(DW,all_days) as [Day Name], DATEPART(dd,all_days) as [Day], 'A' as [Type],all_days as Date from (SELECT  CONVERT(date,@d1+number) as all_days
				--FROM master..spt_values 
				--WHERE TYPE ='p'
				--	AND DATEDIFF(d,@d1,@d2) >= number
				--	--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
				--	AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'T'))A where A.all_days not in (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID)


															
				--											)A order by A.[Day]

				--											if @is_vacation_allowed = 1
				--											BEGIN
				--												delete from @t where date not between @summer_start_date and @summer_end_date and [Type] = 'A'
				--												delete from @t where date not between @winter_start_date and @winter_end_date and [Type] = 'A'
				--											END
				--								end
				--							else
				--								begin
				--									Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type],(@d1+number) as Date
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE))D)
				--												)A order by A.[Day]
				--								end
				--						end
				--					else
				--						begin
				--							if @consecutive_leave_status = 'T'
				--								begin
				--									Insert into @t
				--											select * from
				--											(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

				--											union all
				--											select * from
				--											(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type] ,(@d1+number) as Date
				--											FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
				--											(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
				--											)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
				--												'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
				--													ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
				--											)A order by A.[Day]
				--								end
				--						end
										
				--					if (@consecutive_before_weekends > 0 or @consecutive_after_weekends > 0) and @weekend_days_status = 'T'
				--						begin
				--							set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')

				--							if @weekend_days != 0
				--								begin
				--									--set @months_weekend = (select COUNT(*) from #temp2 where [Type] = 'W') / @weekend_days
				--									set @months_weekend = 0
				--									set @week_day = (select top(1) [Day] from @t where [Type] = 'W')

				--									while @week_day < 32
				--										begin	
				--											--set @week_row = (select row from #temp where row = @week_row)
															
				--											if (select COUNT(*) from @t where [Day] between (@week_day -@weekend_days) and (@week_day + @weekend_days + @weekend_days -1)) = @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends
				--											begin
				
				--												set @deduct_days = @deduct_days + @weekend_days 
				--												set @weekend_pair_count = @weekend_pair_count + @weekend_days
				--											end		
															
				--											set @week_day = @week_day + 7 - @months_weekend
				--						-- month weekend variable is used if the saturday is on and weekend holidays are 2 then add one in month weekend					 
				--											 set @months_weekend = 0
				--											 set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
				--											 while (select [Type] from @t where Day = @week_day) != 'W'	
				--											begin
				--												set @weekend_days = @weekend_days -1
				--												set @week_day = @week_day +1
				--												set @months_weekend = @months_weekend + 1
				--											end
												
															
				--											--select COUNT(*) from #temp2 where [Day] between (@week_day -@consecutive_before_weekends) and (@week_day + @weekend_days + @consecutive_after_weekends -1)
				--											--select @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends											
				--										end
				--								end
				--						end
								--end								
													
								--if @d1 <= @staff_joining_date and @STAFF_STATUS = 'T'
								--	begin
								--		if @STAFF_STATUS = 'T'
								--		begin
	--escaped for a while		--			set @staff_joining_date = @staff_left_date	
								--		end
								--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date)
								--	end								
								--else if @STAFF_STATUS = 'F'
								--begin
								--	 set @joining_date_days = DATEDIFF(DD, @staff_left_date, @d2)									 
								--end
								
								--set @deduct_days = @deduct_days + (@weekend_days * @weekend_pair_count)	+ @joining_date_days
								
								
								
				--if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)  and DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
				--	begin
				--		set @staff_joining_date_time = @staff_joining_date
				--		set @staff_left_date_time = @staff_left_date
						
				--		--for joining
				--		set @weekend_days_joining_based = (select COUNT(*) from 
				--			(SELECT (@staff_joining_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--			AND DATEDIFF(d,@staff_joining_date_time,@d2) >= number 
				--			and (@staff_joining_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--			)A)						
						
				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) - @weekend_days_joining_based
						
				--		set @staff_left_date_time = @staff_left_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--				(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--				AND DATEDIFF(d,@d1,@staff_left_date_time) >= number 
				--				and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--				)A)

				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_left_date) - @weekend_days_joining_based
						
				--	end				
				--else
				--	if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)
				--		begin
				--			set @staff_joining_date_time = @staff_joining_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--			(SELECT (@staff_joining_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--			AND DATEDIFF(d,@staff_joining_date_time,@d2) >= number 
				--			and (@staff_joining_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--			)A)	
														
				--	set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) - @weekend_days_joining_based
										
										
				--		end	
				--	else if DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
				--	begin
				--		set @staff_left_date_time = @staff_left_date
				--			set @weekend_days_joining_based = (select COUNT(*) from 
				--				(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
				--				AND DATEDIFF(d,@d1,@staff_left_date_time) >= number 
				--				and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
				--				)A)

				--		set @joining_date_days = DATEDIFF(DD, @d1,@staff_left_date) - @weekend_days_joining_based
				--	end
				
				
				set @sandwich_days = ISNULL((select dbo.sf_Calculate_Sandwich_Leaves (@STAFF_SALLERY_ABSENT,@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@d1,@d2,@BR_ID)),0)

				set @deduct_days = @deduct_days + @sandwich_days
				
				set @weekend_days_joining_based = 0
				set @exceptional_days_joining_based = 0
				set @staff_joining_date_time = @staff_joining_date
				set @staff_left_date_time = @staff_left_date
			if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)  and DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
					begin
						
						
									if @staff_joining_date >= @staff_left_date
									begin
										if @staff_joining_date = @staff_left_date
										begin										
											set @joining_date_days = DATEDIFF(DD, @staff_left_date,@staff_joining_date)
										end
										else 
										begin
											set @joining_date_days = DATEDIFF(DD, @staff_left_date,@staff_joining_date) -1
										end
										set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@staff_left_date_time,@staff_joining_date_time) >= number 
															and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)
															
										set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @staff_joining_date and ANN_HOLI_STATUS = 'T')		
									end
									else
									begin
										set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date) + DATEDIFF(DD, @staff_left_date,@d2)
										
										
										set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@d1,@staff_joining_date_time) >= number 
															and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)
															+
															(select COUNT(*) from 
															(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@staff_left_date_time, @d2) >= number 
															and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)B)
															
										set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @d1 and @staff_joining_date and ANN_HOLI_STATUS = 'T') + 
																			(select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @d2 and ANN_HOLI_STATUS = 'T')		

									end
						
						
					end				
				else
					if DATEPART(MM, @d1) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_joining_date)
						begin
														
							set @joining_date_days = DATEDIFF(DD, @d1,@staff_joining_date)
							set @weekend_days_joining_based = (select COUNT(*) from 
															(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'
															AND DATEDIFF(d,@d1,@staff_joining_date_time) >= number 
															and (@d1 + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
															)A)	
															
															
							set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @d1 and @staff_joining_date and ANN_HOLI_STATUS = 'T')		
										
						end	
					else if DATEPART(MM, @d1) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @d1) = DATEPART(YYYY, @staff_left_date)
					begin
						set @joining_date_days = DATEDIFF(DD, @staff_left_date,@d2)
						set @weekend_days_joining_based = (select COUNT(*) from 
														(SELECT (@staff_left_date_time + number) as date1 FROM master..spt_values WHERE TYPE ='p'
														AND DATEDIFF(d,@staff_left_date_time,@d2) >= number 
														and (@staff_left_date_time + number) not in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF)
														)A)	
					set @exceptional_days_joining_based = (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @STAFF_SALLERY_HD_ID and ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_DATE between @staff_left_date and @d2 and ANN_HOLI_STATUS = 'T')		
					end
				
					--if @weekend_days_status = 'F'
					--begin
					--	set @joining_date_days = @joining_date_days - @weekend_days_joining_based - @weekend_pair_count
					--end
					
					--if @except_days_status = 'F'
					--begin
					--	set @joining_date_days = @joining_date_days - @exceptional_days_joining_based
					--end
								set @deduct_days = @deduct_days + @joining_date_days								
								
								delete from @t
								
								
								delete from @tbl_leaves
								insert into @tbl_leaves
								select * from dbo.sf_GET_LEAVES_RECORD (@STAFF_SALLERY_DATE, @STAFF_SALLERY_STAFF_ID)
								set @total_leaves_record = (select SUM(Leaves) from @tbl_leaves)
								--if @total_leaves_record > 0
								--BEGIN
								--	set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT - @total_leaves_record 
								--END
									
									set @staff_absent_calc = 0
									set @staff_leaves_calc = 0
									--In case of absent
									if @remaining_leaves_limit_causal > 0 and @deduct_absent_status = 'T'
									BEGIN
										if @remaining_leaves_limit_causal >= @STAFF_SALLERY_ABSENT + @sandwich_days  --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_absent_calc = @STAFF_SALLERY_ABSENT
											set @deduct_days = @deduct_days - @STAFF_SALLERY_ABSENT
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @STAFF_SALLERY_ABSENT
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN
											set @staff_absent_calc = @remaining_leaves_limit_causal
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END

									END


									if @remaining_leaves_limit_causal > 0 and @deduct_leaves_status = 'T'
									BEGIN
										if @remaining_leaves_limit_causal >= @STAFF_SALLERY_LEAVE --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = @STAFF_SALLERY_LEAVE
											set @deduct_days = @deduct_days - @STAFF_SALLERY_LEAVE
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @STAFF_SALLERY_LEAVE
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN
											set @staff_leaves_calc = @remaining_leaves_limit_causal
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END

									END
									
									--Short Leaves From Limit
									if @remaining_leaves_limit_causal > 0
									BEGIN
										if @remaining_leaves_limit_causal >= (@STAFF_SALLERY_HALF_DAY / 2) --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = (@STAFF_SALLERY_HALF_DAY / 2)
											set @deduct_days = @deduct_days - (@STAFF_SALLERY_HALF_DAY / 2)
											set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - (@STAFF_SALLERY_HALF_DAY / 2)
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN											
											set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
											set @remaining_leaves_limit_causal = 0
										END
									END

									--Short Leaves From Limit Annual
									if @remaining_leaves_limit_annual > 0
									BEGIN
										if @remaining_leaves_limit_annual >= (@STAFF_SALLERY_HALF_DAY_Annual / 2) --if leaves limit is 2 and absent is 1
										BEGIN									 
											set @staff_leaves_calc = (@STAFF_SALLERY_HALF_DAY_Annual / 2)
											set @deduct_days = @deduct_days - (@STAFF_SALLERY_HALF_DAY_Annual / 2)
											set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - (@STAFF_SALLERY_HALF_DAY_Annual / 2)
										END
										ELSE--if leaves limit is 1 and absent is 2
										BEGIN											
											set @deduct_days = @deduct_days - @remaining_leaves_limit_annual
											set @remaining_leaves_limit_annual = 0
										END
									END
								
								--set @remaining_leaves_limit_annual = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@STAFF_SALLERY_BR_ID,'A')
									set @m = 1
								
								set @count_total_leaves_record = (select COUNT(*) from @tbl_leaves)
								set @is_causul_leaves  = 0
								set @is_annual_leaves  = 0
								set @total_causul_leaves  = 0
								set @total_annual_leaves  = 0
								set @leaves_record  = 0
								--set @is_annual_leave_deduct  = 0
								WHILE @m <= @count_total_leaves_record
								BEGIN
									select @is_annual_leaves = [Is Annual Leaves], @is_causul_leaves = [Is Causal Leaves],@leaves_record = Leaves from @tbl_leaves where sr = @m
									set @deduct_days = @deduct_days + @leaves_record
									set @STAFF_SALLERY_LEAVE = @STAFF_SALLERY_LEAVE + @leaves_record
									set @is_annual_leave_deduct = 0
									if @is_causul_leaves = 1
									BEGIN
										if @remaining_leaves_limit_causal > 0
										BEGIN
											if @remaining_leaves_limit_causal >= @leaves_record
											BEGIN
												set @total_causul_leaves = @total_causul_leaves + @leaves_record
												set @remaining_leaves_limit_causal = @remaining_leaves_limit_causal - @leaves_record
												set @deduct_days = @deduct_days - @leaves_record
												set @leaves_record = 0
											END
											else
											BEGIN
												set @total_causul_leaves = @total_causul_leaves + @remaining_leaves_limit_causal
												set @deduct_days = @deduct_days - @remaining_leaves_limit_causal
												set @leaves_record = @leaves_record - @remaining_leaves_limit_causal
												set @remaining_leaves_limit_causal = 0
												--if @is_annual_leaves = 1
												--BEGIN
												--	set @total_annual_leaves = @total_annual_leaves + @leaves_record - @remaining_leaves_limit_causal
												--END
												--ELSE
												--BEGIN
												--	set @deduct_days = @deduct_days + @leaves_record - @remaining_leaves_limit_causal
												--END
												--set @is_annual_leave_deduct = 1
												--set @remaining_leaves_limit_causal = 0
											END
										END
									END


																		if @leaves_record > 0 --AND @is_annual_leave_deduct = 0
									BEGIN
										if @is_annual_leaves = 1
										BEGIN
											if @remaining_leaves_limit_annual > 0 OR @annual_leaves_From_Next_Year = 'T'
											BEGIN
												if @remaining_leaves_limit_annual >= @leaves_record
												BEGIN
													set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - @leaves_record
													set @deduct_days = @deduct_days - @leaves_record
													set @total_annual_leaves = @total_annual_leaves + @leaves_record
													set @leaves_record = 0
												END
												ELSE
												BEGIN
													if (@annual_leaves_From_Next_Year = 'T')
													BEGIN
														set @remaining_leaves_limit_annual = @remaining_leaves_limit_annual - @leaves_record
														set @deduct_days = @deduct_days - @leaves_record
														set @total_annual_leaves = @total_annual_leaves + @leaves_record
														set @leaves_record = 0
													END
													ELSE
													BEGIN
														set @total_annual_leaves = @total_annual_leaves + @remaining_leaves_limit_annual		
														set @deduct_days = @deduct_days - @remaining_leaves_limit_annual
														set @leaves_record = @leaves_record - @remaining_leaves_limit_annual
														set @remaining_leaves_limit_annual = 0
													END
												END
											END
										END
										--set @total_annual_leaves = @total_annual_leaves + @leaves_record
									END
									set @m = @m + 1
								END

								--if @annual_leaves_limit_new >= @total_annual_leaves
								--BEGIN
								--	set @deduct_days = @deduct_days - @total_annual_leaves
								--	set @annual_leaves_limit_new = @annual_leaves_limit_new - @total_annual_leaves
								--END
								--ELSE
								--BEGIN
								--	set @deduct_days = @deduct_days + @total_annual_leaves - @annual_leaves_limit_new
								--	set @annual_leaves_limit_new = 0
								--END

								if @leave_type != 'No Deduction'
									BEGIN
										if @STAFF_SALLERY_PRESENT = 0
										BEGIN
											set @deduct_days = 30
										END
									END
								ELSE
									BEGIN
										set @deduct_days = 0
									END



									--Insertion in Staff Leaves Calculation only those absent and leaves that are minus from limit
								EXEC sp_GET_MANUAL_DEDUCTION_DAYS @STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE,@deduct_days,@set_deduct_days output

									if @set_deduct_days != -1
										set @deduct_days = 30 - @set_deduct_days
							

								

								if @deduct_days > 30
								BEGIN
									set @deduct_days = 30
								END
								
									insert into STAFF_LEAVES_CALC
									VALUES
									(
										@STAFF_SALLERY_STAFF_ID,
										@STAFF_SALLERY_DATE,
										@remaining_leaves_limit_causal,
										@staff_leaves_calc,
										@staff_absent_calc,
										@STAFF_SALLERY_PRESENT,
										@STAFF_SALLERY_LATE,
										@new_month_leaves_status,
										@new_year_leaves_status,
										@late_per_absent,
										@total_causul_leaves,
										@total_annual_leaves,
										@remaining_leaves_limit_annual,
										@sandwich_days
									)
																		
																
									
									--STAFF deduction														
														set @count = 0
														set @j = 1
														
														set @count = ( select COUNT( STAFF_DEDUCTION_ID) from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_DEDUCTION_STATUS = 'T')
														while @j <= @count

															BEGIN																																																																
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_DEDUCTION_ID) ROW,STAFF_DEDUCTION_DED_ID ID from STAFF_DEDUCTION where STAFF_DEDUCTION_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_DEDUCTION_STATUS = 'T'
																		)
																		
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, ID ,  dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'D',@per_day_salary),@deductions,'T',0,'F','Not Refunded' from TBL where ROW = @j 
																		
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j
																		set @STAFF_SALLERY_DEFF_MAX = SCOPE_IDENTITY()
																		set @STAFF_DEFF_ID = (select STAFF_SALLERY_DEFF_NAME from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX )
																																				
																		--select  @STAFF_SALLERY_STAFF_ID staff_id, @STAFF_SALLERY_DEFF_MAX deff_if_max,@STAFF_DEFF_ID ded_deff_id,@STAFF_SALLERY_DATE [date] 																		
																		
																		exec [sp_func_get_complete_deduction_amount] @STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DEFF_MAX,@STAFF_DEFF_ID,@STAFF_SALLERY_DATE,@per_day_salary, @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID, @STAFF_SALLERY_DEFF_MAX, @acc_vch_main_id
																		set @j = @j + 1	
															END;
															
														-- STAFF allownce
														set @count = 0
														set @j = 1
														
														set @count = ( select COUNT( STAFF_ALLOWANCE_ID) from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_ALLOWANCE_STATUS = 'T')
														while @j <= @count

															BEGIN																													
																																													
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_ALLOWANCE_ID) ROW,STAFF_ALLOWANCE_ALLOW_ID ID from STAFF_ALLOWANCE where STAFF_ALLOWANCE_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_ALLOWANCE_STATUS = 'T'
																		)
																		
																		select @allowance_id = ID from TBL where ROW = @j 
																		set @allowance_amount = 0
																		--set @earning_deff_amount = dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'A')
																		set @allowance_amount = dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,@allowance_id,@STAFF_SALLERY_DATE,'A',@per_day_salary)
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, @allowance_id, @allowance_amount,@earnings,'T',0,'F','Not Refunded' 
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j
																		set @idd_def = 0
																		set @idd_def = SCOPE_IDENTITY()
																		-- advance accountings
																		if dbo.get_advance_accounting(@STAFF_SALLERY_BR_ID) = 1
																		BEGIN
																		
																		set @HD_ID = CAST((@STAFF_SALLERY_HD_ID) as nvarchar(50))
																		set @BR_ID = CAST((@STAFF_SALLERY_BR_ID) as nvarchar(50))
																			select @VCH_DEF_COA = COA_UID from TBL_COA where  CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
																			(select DEDUCTION_NAME from DEDUCTION where DEDUCTION_ID = @STAFF_DEFF_ID) and COA_isDeleted = 0
																			 set @VCH_reference_no = CAST((@idd_def) as nvarchar(50))
																			
																		 set @datetime = getdate()																		
																		 set @debit  = @allowance_amount
																		 set @credit  = 0

																			exec sp_TBL_VCH_DEF_insertion @acc_vch_main_id, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'I','',@datetime,'','','',@HD_ID, @BR_ID,0,1,''
																		END
																	set @j = @j + 1																																					
															END;
														
														--STAFF loan
															set @loan_amount = 0
															set @count = 0
															set @j = 1
															set @count = ( select COUNT( STAFF_LOAN_ID) from STAFF_LOAN where STAFF_LOAN_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_LOAN_STATUS = 'T')
															--If Not Loan just Entry to shown in Payslip
															if @count = 0
															BEGIN
																insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, -1 , 0 ,@loan,'T',0,'F','Not Refunded' 
															END

														while @j <= @count

															BEGIN																													
																		with	
																		 TBL(ROW,ID)
																		as
																		(																								
																			select ROW_NUMBER() OVER(ORDER BY STAFF_LOAN_ID) ROW,STAFF_LOAN_ID ID from STAFF_LOAN where STAFF_LOAN_STAFF_ID = @STAFF_SALLERY_STAFF_ID and  STAFF_LOAN_STATUS = 'T'
																		)																		

																		--select @loan_amount = @loan_amount + ( select dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'L') from TBL where ROW = @j )
																		insert into STAFF_SALLERY_DEFF												
																		select @STAFF_SALLERY_MAX, ID , dbo.get_deduction_amount(@STAFF_SALLERY_STAFF_ID,ID,@STAFF_SALLERY_DATE,'L',@per_day_salary),@loan,'T',0,'F','Not Refunded' from TBL where ROW = @j 																		
																		
																		set @STAFF_SALLERY_DEFF_MAX = SCOPE_IDENTITY()
																		set @STAFF_DEFF_ID = (select STAFF_SALLERY_DEFF_NAME from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_ID = @STAFF_SALLERY_DEFF_MAX )
																		EXEC sp_LOAN_TYPE_INSTALLEMENT_UPDATION @STAFF_DEFF_ID, @crrnt_month, @crrnt_year
																		
																		--select @count ROW,@j  FROM TBL WHERE ROW = @j

																	set @j = @j + 1
																		
															END
												
												--Commission
												 if @is_commission = 'T'
													begin
														insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @allownc_commission_id, @commision, 'E','T',0,'F','Not applicable')
													end
												--Overtime
												if @is_overtime = 'T' and @is_overtime_payslip = 'T'
												begin
													set @per_hour_salary = @per_day_salary / @overtime_hours_in_day
													 set @overtime_hours =  (select overtime from dbo.CALCULATE_OVERTIME(@STAFF_SALLERY_STAFF_ID, DATEADD(month, DATEDIFF(month, 0, @STAFF_SALLERY_DATE), 0),DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @STAFF_SALLERY_DATE) + 1, 0)), @overtime_minutes_in_hour))
													 set @overtime_salary = @overtime_hours * @per_hour_salary 
													 insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @allownc_overtime_id, @overtime_salary, 'E','T',0,'F','Not applicable')
												end
												
												
												--late time deduction calculation
											set @deduction_late_time_status = (select STAFF_LEAVES_LATE_DEDUCTION_TYPE from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)	

											if @deduction_late_time_status = 'Minute'
											begin
												set @deducution_late_time_amount = dbo.LATE_TIME_DEDUCTION_CALCULATION (@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE, @per_day_salary)
												insert into STAFF_SALLERY_DEFF values (@STAFF_SALLERY_MAX, @deduction_late_time_id, @deducution_late_time_amount, 'D','T',0,'F','Not applicable')
											end
												
															
															--insert into STAFF_SALLERY_DEFF
															--select @STAFF_SALLERY_MAX, 0 , @loan_amount ,@loan,'T'														
															--select @loan_amount loan_amount
															
										set @calc_allow = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @earnings and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										set @calc_deduct = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @deductions and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										set @calc_loan = (select ISNULL( SUM(STAFF_SALLERY_DEFF_AMOUNT),0) from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX and STAFF_SALLERY_DEFF_AMOUNT_TYPE = @loan and STAFF_SALLERY_DEFF_AMOUNT_STATUS = 'T' )
										update STAFF_SALLERY
										set
										STAFF_SALLERY_GROSS_EARN = @calc_allow,										
										STAFF_SALLERY_GROSS_DEDUCT = @calc_deduct + @calc_loan,
										STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT = 0,
										STAFF_SALLERY_PER_DAY_SALARY = @per_day_salary,
										STAFF_SALLERY_OVERTIME_TOTAL_HOURS = @overtime_hours,
										STAFF_SALLERY_OVERTIME_PER_HOUR = @per_hour_salary,
										STAFF_SALLERY_LEAVES = @STAFF_SALLERY_LEAVE		
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									
									-- Days that are in vacation only for teachers
									--if charindex('Teacher',@STAFF_DESIGNATION) > 0 AND @STAFF_DESIGNATION != 'Visiting Teacher'
									--BEGIN
									--	set @deduct_days = 0
										
									--	--Need to see logic working days calculation to be exact. June 2017 working days are 27 because 3 days are eidulfitar holiday but this in logic it shows 30 days and it calculates wrong calculation
									--	--set @deduct_days = @deduct_days - (select COUNT(*) from (SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'  and (@d1 + number) <=@d2 and ((NOT ((@d1 + number) between @summer_start_date and @summer_end_date)) OR (NOT ((@d1 + number) between @winter_start_date and @winter_end_date))))A)
									--END
									

									--if @leave_type != 'No Deduction'
									--BEGIN
										set @deducted_salary = @per_day_salary * @deduct_days
									--END
									
									
									set @deducted_salary = (select ISNULL(@deducted_salary, 0))

										if DATEPART(MM,@STAFF_SALLERY_DATE) = 1 and DATEPART(YYYY,@STAFF_SALLERY_DATE) = 2018
										BEGIN
											if @STAFF_SALLERY_STAFF_ID = 80176
											BEGIN
												set @deducted_salary = 6750
											END
										END	

									set @total_weekend_days = 0
									if @weekend_days_status = 'F' 
									BEGIN
										set @total_weekend_days = (select [dbo].[Get_weekend_days](@STAFF_SALLERY_STAFF_ID, @STAFF_SALLERY_DATE))
									END
									--set @deducted_salary = @basic_salary - (@working_days * @per_day_salary) + @deducted_salary-- @deducted_salary + (@total_weekend_days	* @per_day_salary)
									set @net_salary = @basic_salary + @calc_allow -@calc_deduct - @calc_loan - @deducted_salary
									

									-- Days that are in vacation only for teachers
									--if charindex('Teacher',@STAFF_DESIGNATION) > 0
									--BEGIN
									--	set @deduct_days = 0
										
									--	--Need to see logic working days calculation to be exact. June 2017 working days are 27 because 3 days are eidulfitar holiday but this in logic it shows 30 days and it calculates wrong calculation
									--	--set @deduct_days = @deduct_days - (select COUNT(*) from (SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'  and (@d1 + number) <=@d2 and ((NOT ((@d1 + number) between @summer_start_date and @summer_end_date)) OR (NOT ((@d1 + number) between @winter_start_date and @winter_end_date))))A)
									--END

									--select @basic_salary as bs, @calc_allow as al, @calc_deduct as ded, @calc_loan as lon, @deducted_salary as ds, @per_day_salary as pds 
									update STAFF_SALLERY
										set
										STAFF_SALLERY_NET_TOLTAL = CONVERT(decimal(18,0), @net_salary),
										STAFF_SALLERY_MONTH_SALARY = @STAFF_SALLERY_MONTH_SALARY,
										STAFF_SALLERY_ABSENET_DEDUCT_AMOUNT = CONVERT(decimal(18,0), @deducted_salary),
										--STAFF_SALLERY_LATE_LIMIT = @late_per_absent,
										STAFF_SALLERY_DEDUCT_DAYS = @deduct_days
										where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
									
									update STAFF_SALLERY_DEFF set STAFF_SALLERY_DEFF_REFUND_STATUS = 'Not applicable'
										where STAFF_SALLERY_DEFF_REFUND = 'F' and STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX
									--select STAFF_SALLERY_NET_TOLTAL net_total from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
											
									
								 end
								
								if @send_sms = 'T'
								BEGIN
									insert into @t_sms exec dbo.[sp_SMS_INSERT] @STAFF_SALLERY_HD_ID, @STAFF_SALLERY_BR_ID,@STAFF_SALLERY_MAX, @STAFF_SALLERY_USER_ID, 'S'
								END
									
									--select STAFF_SALLERY_NET_TOLTAL net_total from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
								
							
			select * from STAFF_SALLERY where STAFF_SALLERY_ID = @STAFF_SALLERY_MAX
			select * from STAFF_SALLERY_DEFF where STAFF_SALLERY_DEFF_PID = @STAFF_SALLERY_MAX				
			select * from @t_sms

			END --Leaves Type is Not Generate Salary
END		
end