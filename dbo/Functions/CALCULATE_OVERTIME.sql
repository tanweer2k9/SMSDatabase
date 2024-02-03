CREATE FUNCTION [dbo].[CALCULATE_OVERTIME] (@STAFF_ID int, @START_DATE date,@END_DATE date, @isdaywise_T_all_day_F char(1))
returns @t table (overtime float, early_time float, Remarks nvarchar(10), att_date date,staff_id int)

AS BEGIN

--declare @STAFF_ID int = 10011
--declare @START_DATE date = '2015-01-01'
--declare @END_DATE date = '2015-01-31'
--declare @isdaywise_T_all_day_F char(1) = 'T'
--declare @t table (overtime float, early_time float, Remarks nvarchar(10), att_date date,staff_id int)
--declare @t_date table (overtime float, early_time float,shorttime datetime, overtimedate datetime,date1 date)


declare @minutes_in_hour int = 0
declare @overtime_calulation_type nvarchar(50) = ''
declare @deduction_calulation_type nvarchar(50) = ''






declare @t_all_days table (overtime float, early_time float, Remarks nvarchar(10), att_date date,staff_id int)

declare @tbl_timing table (id int,time_in time, time_out time, current_time_in time, current_time_out time,remarks nvarchar(50))
declare @default_datetime datetime = '1900-01-01 00:00:00'
declare @days_count int = 0
--declare @timings_one_day_count int = 0
declare @i int = 1
--declare @j int = 1
--declare @staff_date date = ''
--declare @staff_time_in time = ''
--declare @staff_time_out time = '' 
--declare @staff_due_time_in time = ''
--declare @staff_due_time_out time = '' 
--declare @staff_day_name nvarchar(50)
--declare @total_minutes_overtime float = ''

declare @shorttime datetime = 0
declare @total_overtime_seconds float = 0
declare @total_shorttime_seconds float = 0
declare @overtime_seconds float = 0
declare @shorttime_seconds float = 0
declare @overtime datetime = ''
--declare @overtime_date date = ''
declare @remarks nvarchar(50)= ''
--declare @early_minutes float = 0
declare @time_in_nvarchar nvarchar(50) = ''
declare @time_out_nvarchar nvarchar(50) = ''
declare @time_in_due_nvarchar nvarchar(50) = ''
declare @time_out_due_nvarchar nvarchar(50) = ''
declare @time_in_time time = ''
declare @time_out_time time = ''
declare @time_in_due_datetime datetime = ''
declare @time_out_due_datetime datetime = ''
declare @short_leave_minutes float = 0
declare @short_leave_datetime datetime = ''
declare @date date
declare @overtime_calculate_after_time_out char(1) = ''
declare @overtime_calculation_type nvarchar(50) = ''
declare @hd_id int = 0
declare @br_id int = 0
declare @remaining_minutes float = 0
declare @late_minutes int = 0
declare @deduction_type nvarchar(50) = ''
declare @first_time_in datetime = @default_datetime
declare @last_time_out datetime = @default_datetime
declare @early_time_count int = 0
declare @overtime_before_time_in datetime = @default_datetime
declare @overtime_after_time_out datetime = @default_datetime
declare @short_time_in datetime = @default_datetime
declare @short_time_out datetime = @default_datetime
declare @remaining_datetime_after_short datetime = @default_datetime
declare @overtime_before_time_in_required int = 0
declare @shorttime_before_time_out_required int = 0


select @hd_id = TECH_HD_ID, @br_id = TECH_BR_ID from TEACHER_INFO where TECH_ID = @STAFF_ID 

--set hour in minuts from staff leaves if not set then take from branch if not set then consider 60 minutes
set @minutes_in_hour = ISNULL((select STAFF_LEAVES_PAYROLL_MINUTES_IN_HOUR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID),(select ISNULL(BR_ADM_PAYROLL_MINUTES_IN_HOUR,60)  from BR_ADMIN where BR_ADM_HD_ID =@br_id ))
select @overtime_calulation_type = BR_ADM_OVERTIME_CALCULATION_TYPE  from BR_ADMIN where BR_ADM_ID = @br_id
set @deduction_calulation_type = (select top(1) STAFF_LEAVES_LATE_DEDUCTION_TYPE from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID)

select @overtime_calculate_after_time_out = BR_ADM_OVERTIME_AFTER_TIMEOUT, @overtime_calculation_type = BR_ADM_OVERTIME_CALCULATION_TYPE, @late_minutes = BR_ADM_PAYROLL_LATE_MINUTES from BR_ADMIN where BR_ADM_HD_ID = @hd_id and BR_ADM_ID = @br_id
set @days_count = (Select COUNT(*) from (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and 
					ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE group by ATTENDANCE_STAFF_DATE)A)

--select ATTENDANCE_STAFF_TIME_IN TIME_IN, ATTENDANCE_STAFF_TIME_OUT TIME_OUT,ATTENDANCE_STAFF_CURRENT_TIME_IN CURRENT_TIME_IN,ATTENDANCE_STAFF_CURRENT_TIME_OUT CURRENT_TIME_OUT, ATTENDANCE_STAFF_DATE _DATE,ATTENDANCE_STAFF_REMARKS REMARKS from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE order by ATTENDANCE_STAFF_DATE
while @i<= @days_count
begin
	set @overtime = @default_datetime
	set @shorttime = @default_datetime
	set @overtime_seconds = 0
	set @shorttime_seconds = 0
	set @overtime_before_time_in = @default_datetime
	set @overtime_after_time_out = @default_datetime
	set @overtime = @default_datetime
	set @short_leave_datetime = @default_datetime
	set @first_time_in = @default_datetime
	set @last_time_out = @default_datetime
	set @short_time_in = @default_datetime
	set @short_time_out = @default_datetime
	--set @minutes = 0
	--set @remaining_minutes = 0
	select @date = ATTENDANCE_STAFF_DATE from 
	(select ROW_NUMBER() over(order by(select 0)) as sr, ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID 
	and ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE group by ATTENDANCE_STAFF_DATE)A where sr = @i

	
	--insert into temporary table
	insert into @tbl_timing 
	select ROW_NUMBER() over (order by (time_in)) as sr,* from 
	(select CAST((ATTENDANCE_STAFF_TIME_IN) as time)time_in , CAST((ATTENDANCE_STAFF_TIME_OUT) as time)time_out,
	CAST((ATTENDANCE_STAFF_CURRENT_TIME_IN) as time)curret_time_in , CAST((ATTENDANCE_STAFF_CURRENT_TIME_OUT) as time)current_time_out,
	ATTENDANCE_STAFF_REMARKS as remarks
	 from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE = @date)A 
	order by time_in
	
	set @remarks = (select top(1) remarks from @tbl_timing)

	if @remarks = 'P' or @remarks = 'LA'
	BEGIN
		-- set due time in and due time_out
		select @time_in_due_nvarchar = current_time_in, @time_out_due_nvarchar = current_time_out from (select * from @tbl_timing where id = 1)A
		set @time_in_due_nvarchar = (REPLACE(@time_in_due_nvarchar,'0000',''))
		set @time_out_due_nvarchar = (REPLACE(@time_out_due_nvarchar,'0000',''))
		set @time_in_due_datetime =  CAST(CAST(@time_in_due_nvarchar as time)as datetime)
		set @time_out_due_datetime =  CAST(CAST(@time_out_due_nvarchar as time)as datetime)
		
		select @overtime_before_time_in_required = ISNULL(STAFF_LEAVES_PAYROLL_OVERTIME_MINUTES_IN_HOUR_BEFORE_TIMEIN,0),
		@shorttime_before_time_out_required = ISNULL(STAFF_LEAVES_PAYROLL_EARLY_DEPARTURE_MINUTES,0) 
		from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID

					
		declare @time_in_count int = (select COUNT(*) from @tbl_timing where time_in < @time_in_due_nvarchar)
		declare @time_out_count int = (select COUNT(*) from @tbl_timing where time_out > @time_out_due_nvarchar)

		

		--3 situation suppose timing is 9 to 6 case 1. someone reaches 10 to 5, no overtime in morming case @time_in_count = 0
		--case 2. someone reaches 8 to 5, overtime in morming case @time_in_count = 0 then overtime will time_in_due minus time_in
		--case 3. someone reaches 7 to 8, then 8:30 to 5 then (overtime will last row time_in_due - time_in) + all rows time_out - time_in
		--all three situation will for time_out - timeout_due
	
		
				
		set @overtime_before_time_in = (CASE WHEN @time_in_count = 0 THEN  (@default_datetime)-- for overtime to be zero minutes
						ELSE 
						CASE WHEN @time_in_count = 1  
						THEN (SELECT CAST((@time_in_due_nvarchar)as datetime) - CAST((time_in)as datetime) from @tbl_timing where time_in < @time_in_due_nvarchar)
						 ELSE (
						 (SELECT CAST((@time_in_due_nvarchar)as datetime) - CAST((time_in)as datetime) from (select ROW_NUMBER() over(order by (select time_in)) as sr, * from @tbl_timing where time_in < @time_in_due_nvarchar)A
						 where sr = @time_in_count)
						 +
						 (select DATEADD(s, SUM((CONVERT(INT, DATEDIFF(SECOND, 0, overtime)))), '19000101') from
						 (select CAST((time_out)as datetime) - CAST((time_in)as datetime) as overtime from 
						 (select ROW_NUMBER() over(order by (select time_in)) as sr, * from @tbl_timing where time_in < @time_in_due_nvarchar)B
						  where sr != @time_in_count)C)
						 ) END END)

				 

	set @overtime_after_time_out = (CASE WHEN @time_out_count = 0 THEN  @default_datetime-- for overtime to be zero minutes
						ELSE 
						CASE WHEN @time_out_count = 1  
						THEN (SELECT CAST((time_out)as datetime) - CAST((@time_out_due_nvarchar)as datetime) from @tbl_timing where CAST((time_out)as datetime) > CAST((@time_out_due_nvarchar)as datetime))
						 ELSE (
						 (SELECT CAST((time_out)as datetime) - CAST((@time_out_due_nvarchar)as datetime) from (select ROW_NUMBER() over(order by (select time_out)) as sr, * from @tbl_timing where time_out > @time_out_due_nvarchar)A
						 where sr = 1)
						 +
						 (select DATEADD(s, SUM((CONVERT(INT, DATEDIFF(SECOND, 0, overtime)))), '19000101') from
						 (select CAST((time_out)as datetime) - CAST((time_in)as datetime) as overtime from 
						 (select ROW_NUMBER() over(order by (select time_in)) as sr, * from @tbl_timing where time_out > @time_out_due_nvarchar)B
						  where sr != 1)D)

						 ) END END)


						 set @overtime_before_time_in = ISNULL(@overtime_before_time_in,@default_datetime)
						 set @overtime_after_time_out = ISNULL(@overtime_after_time_out,@default_datetime)


						 if @overtime_calulation_type = 'Hours'
						 BEGIN	
							set @overtime_after_time_out = [dbo].[CHECK_TOTAL_HOURS] (@overtime_after_time_out, @minutes_in_hour)

							set @overtime_before_time_in = [dbo].[CHECK_TOTAL_HOURS] (@overtime_before_time_in, @overtime_before_time_in_required )


							--declare @overtime_after_time_out_hours float = CONVERT(float, DATEDIFF(SECOND, 0, @overtime_after_time_out)) /3600
							--declare @overtime_decimal_hours float = @overtime_after_time_out_hours - FLOOR(@overtime_after_time_out_hours)
							--if (@overtime_decimal_hours * 60) >= (@minutes_in_hour)
							--BEGIN
							--	set @overtime_after_time_out = DATEADD(s,((FLOOR(@overtime_after_time_out_hours) + 1)*3600),'1900-01-01')
							--END
							--ELSE
							--	set @overtime_after_time_out = DATEADD(s,((FLOOR(@overtime_after_time_out_hours))*3600),'1900-01-01')


							
							--if @overtime_before_time_in - (DATEADD(HH,DATEPART(HOUR, GETDATE()), '1900-01-01') >= @overtime_before_time_in_required
							--BEGIN
							--	set  @overtime_before_time_in = DATEADD(s,((FLOOR(@overtime_before_time_in) + 1)*3600),'1900-01-01')
							--END
							--else
							--BEGIN
							--	set  @overtime_before_time_in = Floor(@overtime_before_time_in)
							--END

						 END

						set @overtime = @overtime_before_time_in + @overtime_after_time_out


						set @early_time_count = (select COUNT(*) from @tbl_timing where CAST((time_in) as datetime) < CAST(@time_out_due_datetime as datetime) and CAST((time_out)as datetime) > CAST(@time_in_due_datetime as datetime))
						set @first_time_in = (select top(1) time_in from @tbl_timing where CAST((time_in) as datetime) < CAST(@time_out_due_datetime as datetime)  and CAST((time_out)as datetime) > CAST(@time_in_due_datetime as datetime))
						set @last_time_out = (select top(1) time_out from @tbl_timing where CAST((time_in) as datetime) < CAST(@time_out_due_datetime as datetime)  and CAST((time_out)as datetime) > CAST(@time_in_due_datetime as datetime) order by id DESC)

		-- calculate short hours 
				--3 possibilities to decution time
			--1.when time_in 09:45 is greater than due time 09:00 + 30 minutes relexation +
			--2 in between vanish +
			--3 timeout is less than time_out_due (05:30 < 06:00) +

						--select * from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @STAFF_ID and @first_time_in between SHORT_LEAVE_FROM_TIME and SHORT_LEAVE_TO_TIME
						--select @first_time_in
						declare @morning_early_minutes datetime = (SELECT ISNULL(CASE WHEN @first_time_in > DATEADD(MI,@late_minutes,CAST((@time_in_due_nvarchar)as datetime)) and (@remarks = 'P' or @remarks = 'LA')
																	THEN 											
																	(SELECT (ISNULL(@first_time_in, @default_datetime) - DATEADD(MI,@late_minutes,CAST((@time_in_due_nvarchar)as datetime))))
																	ELSE @default_datetime
																	END,@default_datetime))

												--3 conditions 
												--1. is hour means hour will be deduct 
												--2.is days 3 late one absent
												--3. is minutes means deduction on minutes dedcuted in rupees
											
	set @shorttime =	(SELECT ISNULL((select DATEADD(s, SUM(DATEDIFF(SECOND, 0, diff)), '19000101') as total_time from (select ROW_NUMBER() over(order by (select 0)) as sr, coalesce( (select CAST((b.time_in)as datetime) 
						from @tbl_timing b where b.id = a.id + 1 and  CAST((time_in) as datetime) < @time_out_due_datetime and CAST((time_out)as datetime) > @time_in_due_datetime ) - CAST((a.time_out)as datetime) 
						,CAST((a.time_out)as datetime) ) as diff
						from @tbl_timing a where CAST((time_in) as datetime) < @time_out_due_datetime and CAST((time_out)as datetime) > @time_in_due_datetime)B where B.sr != @early_time_count),'00:00:00'))
							+
							(select ISNULL(CASE WHEN CAST((@last_time_out)as datetime) < CAST((@time_out_due_nvarchar)as datetime) THEN
							(select CAST((@time_out_due_nvarchar)as datetime) - CAST((@last_time_out)as datetime)) ELSE '00:00:00' END,'00:00:00')
							)
	

							select @short_time_in = CAST((SHORT_LEAVE_FROM_TIME)as datetime), @short_time_out = CAST((SHORT_LEAVE_TO_TIME)as datetime) from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @STAFF_ID
							set @short_leave_datetime = ISNULL(@short_time_out - @short_time_in,@default_datetime)
						
							if @short_time_in < @first_time_in and @short_time_in != @default_datetime
							BEGIN							
								set @morning_early_minutes = @morning_early_minutes - @short_leave_datetime							
								set @short_leave_datetime = @default_datetime
							END
							
							

							if @deduction_calulation_type = 'Hour'
							BEGIN
								set @morning_early_minutes = DATEADD(hh,CEILING(CAST((CONVERT(float, DATEDIFF(SECOND, 0, @morning_early_minutes)))as numeric)/3600),'1900-01-01')
								
								set @shorttime = [dbo].[CHECK_TOTAL_HOURS] (@shorttime, @shorttime_before_time_out_required )
							END
						
										
					set @shorttime = @shorttime + @morning_early_minutes - @short_leave_datetime
					
					if CAST(@shorttime AS DATE) < '1900-01-01'
					BEGIN
						set @shorttime = @default_datetime
					END

					--set @overtime = CAST((@time_out_time) as datetime) - CAST((@time_in_time) as datetime) - CAST((@time_out_due_time) as datetime) + CAST((@time_in_due_time) as datetime)	
					----set @short_leave_datetime = (select CAST((CAST((SHORT_LEAVE_TO_TIME) as time)) as datetime) - CAST((CAST((SHORT_LEAVE_FROM_TIME) as time)) as datetime)
					--							--from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @STAFF_ID)
					----set @short_leave_datetime = ISNULL(@short_leave_datetime, @default_datetime)

		--if @overtime >= @short_leave_datetime
		--	set @overtime = @overtime + @short_leave_datetime

		--set @overtime_date = @overtime
		--if @overtime_date = '1900-01-01'
		--begin
		--	set @minutes = @minutes + (DATEPART(HOUR,@overtime) * 60)
		--	set @remaining_minutes = DATEPART(MINUTE,@overtime)
		--	if @remaining_minutes >= @minutes_in_hour
		--		begin
		--			if @overtime_calculation_type = 'Minutes'
		--			begin	
		--				set @minutes = @minutes + @remaining_minutes
		--			end
		--			else
		--				set @minutes = 60
		--		end
		--	else if @minutes > 0 and @overtime_calculation_type = 'Minutes' and @remaining_minutes >= @minutes_in_hour
		--			set @minutes = @minutes + @remaining_minutes

		--end
		--else if @overtime_date = '1899-12-31'
		--begin
		--	if @remarks = 'P' or @remarks = 'LA'			
			
		--		set @early_minutes += DATEDIFF(MI,@overtime,'1900-01-01')
		--end
 
		set @overtime_seconds = DATEDIFF(SECOND, 0, @overtime)
		--set @total_overtime_seconds = @total_overtime_seconds + @overtime_seconds

		set @shorttime_seconds = DATEDIFF(SECOND, 0, @shorttime)
		--set @total_shorttime_seconds = @total_shorttime_seconds + @shorttime_seconds

		insert into @t_all_days values (@overtime_seconds, @shorttime_seconds,@remarks,@date,@STAFF_ID)
		--insert into @t_all_days values (ROUND(@overtime_seconds/3600,2), ROUND(@shorttime_seconds/3600,2),@remarks,@date,@STAFF_ID)

	END
	--insert into @t values (@time_in_nvarchar, @time_out_nvarchar, @time_in_due_nvarchar, @time_out_due_nvarchar, @overtime, @hours)
	--set @staff_day_name = DATENAME(WEEKDAY,@staff_date)
	--insert into @t_date values (@overtime_seconds,@shorttime_seconds,@shorttime,@overtime, @date)
	delete from @tbl_timing
	set @i  = @i + 1
	
end

--declare @val nvarchar(50) = CAST((@total_hours) as nvarchar(50)) + ',' + CAST((@early_minutes) as nvarchar(50))
--declare @early_time float = @early_minutes / 60

--set @total_minutes_overtime = CAST((@total_minutes_overtime / 60) as float)




if @isdaywise_T_all_day_F = 'F'
BEGIN
	insert into @t
	select SUM(overtime) as overtime, SUM(early_time) as early_time, 'P' as Remarks, '1900-01-01' as att_date, @STAFF_ID from @t_all_days group by staff_id
END
ELSE 
BEGIN
	insert into @t 
		select * from @t_all_days
END
--select * from @t_date
--select * from @t


return

END