CREATE FUNCTION [dbo].[LATE_TIME_DEDUCTION_CALCULATION] (@STAFF_ID numeric, @DATE date,	@PER_DAY_SALARY float)
returns float

AS BEGIN


--declare @STAFF_ID numeric = 1
--declare @DATE date = '2014-07-01'
--declare @PER_DAY_SALARY float = 1000

declare @count_days int = 0
declare @i int = 1
declare @attemdance_date date = ''
declare @attendance_time_in nvarchar(50) = ''
declare @attendance_time_out nvarchar(50) = ''
declare @tbl table (from_time nvarchar(50), to_time nvarchar(50), percent_salary float)
declare @count_late_times_records int = 0
declare @late_deduction_from_time nvarchar(50) = ''
declare @late_deduction_to_time nvarchar(50) = ''
declare @late_deduction_percent_Salary float = 0
declare @total_deduction_price float = 0
declare @per_minute_salary float = 0
declare @date_time datetime = ''
declare @total_minutes float = 0

declare @j int = 1 

set @count_days = (select COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and  DATEPART(MM,ATTENDANCE_STAFF_DATE) = DATEPART(MM, @DATE) AND DATEPART(YYYY,ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @DATE) and ATTENDANCE_STAFF_REMARKS in ('P','LA'))
	
	insert into @tbl 
	select DEDUCTION_FROM_TIME, DEDUCTION_TO_TIME, DEDUCTION_PERCENT_SALARY from STAFF_LATE_TIME_DEDUCTION where DEDUCTION_STAFF_ID = @STAFF_ID 
	declare @grace_time datetime = '00:00'
	set @grace_time = DATEADD(MI,(select BR_ADM_PAYROLL_LATE_MINUTES from BR_ADMIN where BR_ADM_ID = (select top(1) TECH_BR_ID from TEACHER_INFO where TECH_ID = @STAFF_ID)),'1900-01-01')

while @i <= @count_days
begin
	select @attemdance_date = ATTENDANCE_STAFF_DATE, @attendance_time_in = ATTENDANCE_STAFF_TIME_IN, 
	@attendance_time_out = ATTENDANCE_STAFF_TIME_OUT from ( select ROW_NUMBER() over (order by (select 0)) as sr, 
	ATTENDANCE_STAFF_DATE, ATTENDANCE_STAFF_TIME_IN, ATTENDANCE_STAFF_TIME_OUT from ATTENDANCE_STAFF 
	where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and DATEPART(MM,ATTENDANCE_STAFF_DATE) = DATEPART(MM, @DATE) AND DATEPART(YYYY,ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @DATE) 
	and ATTENDANCE_STAFF_REMARKS in ('P','LA'))A where sr = @i


	-- for late time in
	set @count_late_times_records = 0
	set @count_late_times_records = (select count(*) from @tbl where CAST((from_time) as time) < CAST((@attendance_time_in) as time))
	set @j = 1
	while @j <= @count_late_times_records
	begin
		select @late_deduction_from_time = from_time, @late_deduction_to_time = to_time, @late_deduction_percent_Salary = percent_salary  from (select ROW_NUMBER() over (order by (select 0)) as sr, from_time,to_time,percent_salary from @tbl where CAST((from_time) as time) < CAST((@attendance_time_in) as time))B where sr = @j
		
		if CAST((@late_deduction_from_time) as time) < CAST((@attendance_time_in) as time) and CAST((@late_deduction_to_time) as time) > CAST((@attendance_time_in) as time)
		begin
			set @date_time = ''
			set @per_minute_salary = 0
			declare @from_time datetime = ''
			declare @to_time datetime = ''

			set @from_time =  CAST((@late_deduction_from_time) as datetime)
			set @to_time =  CAST((@late_deduction_to_time) as datetime)

			set @date_time =@to_time - @from_time
			--set @date_time = CAST((@late_deduction_to_time) as datetime) - CAST((@late_deduction_from_time) as datetime)
			set @per_minute_salary =  (@PER_DAY_SALARY * @late_deduction_percent_Salary * 0.01) / (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))
			set @date_time = ''
			set @total_minutes = 0
			set @date_time = CAST((@attendance_time_in) as datetime) - @grace_time -CAST((@late_deduction_from_time) as datetime)
			set @total_minutes = (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))

			if CAST(@date_time as date) = '1900-01-01'
			BEGIN
				set @total_deduction_price = @total_deduction_price + ( @total_minutes * @per_minute_salary)
			END

		end

		--else
		--begin 
		--	--declare @t_minutes int = 0
		--	--set @date_time = ''
		--	--set @per_minute_salary = 0
		--	--set @date_time = CAST((@late_deduction_to_time) as datetime) - CAST((@late_deduction_from_time) as datetime)
		--	--set @t_minutes = (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))
		--	set @total_deduction_price = @total_deduction_price + ((@PER_DAY_SALARY * @late_deduction_percent_Salary * 0.01))
		--end

		set @j = @j +1
	end

	--for early time out
	set @count_late_times_records = 0
	set @count_late_times_records = (select count(*) from @tbl where CAST((to_time) as time) > CAST((@attendance_time_out) as time))
	set @j = 1
	while @j <= @count_late_times_records
	begin
		select @late_deduction_from_time = from_time, @late_deduction_to_time = to_time, @late_deduction_percent_Salary = percent_salary  from (select ROW_NUMBER() over (order by (select 0)) as sr, from_time,to_time,percent_salary from @tbl where CAST((to_time) as time) > CAST((@attendance_time_out) as time))B where sr = @j
		
		if CAST((@late_deduction_to_time) as time) > CAST((@attendance_time_out) as time) and CAST((@late_deduction_from_time) as time) < CAST((@attendance_time_out) as time)
		begin
			set @date_time = ''
			set @per_minute_salary = 0
			set @date_time = CAST((@late_deduction_to_time) as datetime) - CAST((@late_deduction_from_time) as datetime)
			set @per_minute_salary =  (@PER_DAY_SALARY * @late_deduction_percent_Salary * 0.01) / (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))
			set @date_time = ''
			set @total_minutes = 0
			set @date_time = CAST((@attendance_time_in) as datetime) - @grace_time - CAST((@late_deduction_from_time) as datetime)
			set @total_minutes = (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))

			if CAST(@date_time as date) = '1900-01-01'
			BEGIN
				set @total_deduction_price = @total_deduction_price + ( @total_minutes * @per_minute_salary)
			END
		end

		--else
		--begin 
		--	--declare @t_minutes int = 0
		--	--set @date_time = ''
		--	--set @per_minute_salary = 0
		--	--set @date_time = CAST((@late_deduction_to_time) as datetime) - CAST((@late_deduction_from_time) as datetime)
		--	--set @t_minutes = (DATEDIFF(MINUTE, DATEADD(DAY, DATEDIFF(DAY, 0, @date_time), 0), @date_time))
		--	set @total_deduction_price = @total_deduction_price + ((@PER_DAY_SALARY * @late_deduction_percent_Salary * 0.01))
		--end

		set @j = @j +1
	end
	
	set @i = @i + 1
end

--select @total_deduction_price
return @total_deduction_price


END