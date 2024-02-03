CREATE FUNCTION [dbo].[CALCULATE_OVERTIME_aa] (@STAFF_ID int, @START_DATE date,@END_DATE date, @minutes_in_hour int)
returns nvarchar(50)


AS
BEGIN

--declare @STAFF_ID int = 1
--declare @START_DATE date = '2014-02-12'
--declare @END_DATE date = '2014-02-12'
--declare @minutes_in_hour int = 50




declare @days_count int = 0
declare @i int = 1
declare @staff_date date = ''
declare @staff_time_in time = ''
declare @staff_time_out time = '' 
declare @staff_due_time_in time = ''
declare @staff_due_time_out time = '' 
declare @staff_day_name nvarchar(50)
declare @total_hours int = ''
declare @overtime datetime = ''
declare @hours int = 0
declare @overtime_date date = ''

declare @remarks nvarchar(50)= ''
declare @early_minutes float = 0

declare @time_in_nvarchar nvarchar(50) = ''
declare @time_out_nvarchar nvarchar(50) = ''
declare @time_in_due_nvarchar nvarchar(50) = ''
declare @time_out_due_nvarchar nvarchar(50) = ''
declare @time_in_time time = ''
declare @time_out_time time = ''
declare @time_in_due_time time = ''
declare @time_out_due_time time = ''

declare @short_leave_minutes float = 0
declare @short_leave_datetime datetime = ''
declare @date date

set @days_count = (select COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE)


--declare @t table (time_in nvarchar(50), time_out nvarchar(50),time_in_due nvarchar(50), time_out_due nvarchar(50), overtime datetime, total_hours int)


while @i<= @days_count
begin
	set @hours = 0
	select @time_in_nvarchar = ATTENDANCE_STAFF_TIME_IN, @time_out_nvarchar = ATTENDANCE_STAFF_TIME_OUT, @time_in_due_nvarchar = ATTENDANCE_STAFF_CURRENT_TIME_IN,
	@time_out_due_nvarchar = ATTENDANCE_STAFF_CURRENT_TIME_OUT, @remarks = ATTENDANCE_STAFF_REMARKS, @date = ATTENDANCE_STAFF_DATE from 
	(select ROW_NUMBER() over(order by(select 0)) as sr, * from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID 
	and ATTENDANCE_STAFF_DATE between @START_DATE and @END_DATE)A where sr = @i

	set @time_in_time = CAST((@time_in_nvarchar) as time)
	set @time_out_time = CAST((@time_out_nvarchar) as time)
	set @time_in_due_time = CAST((@time_in_due_nvarchar) as time)
	set @time_out_due_time = CAST((@time_out_due_nvarchar) as time)

	set @overtime = CAST((@time_out_time) as datetime) - CAST((@time_in_time) as datetime) - CAST((@time_out_due_time) as datetime) + CAST((@time_in_due_time) as datetime)
	
	set @short_leave_datetime = (select CAST((CAST((SHORT_LEAVE_TO_TIME) as time)) as datetime) - CAST((CAST((SHORT_LEAVE_FROM_TIME) as time)) as datetime)
										from SHORT_LEAVE where SHORT_LEAVE_DATE = @date and SHORT_LEAVE_STAFF_ID = @STAFF_ID)
			
	set @overtime = @overtime + @short_leave_datetime

	set @overtime_date = @overtime
	if @overtime_date = '1900-01-01'
	begin
		if DATEPART(MINUTE,@overtime) >= @minutes_in_hour
		begin
			set @hours = 1
		end

		 set @hours = @hours + DATEPART(HOUR,@overtime) 

	end
	else if @overtime_date = '1899-12-31'
	begin
		if @remarks = 'P' or @remarks = 'LA'			
			
			set @early_minutes += DATEPART(MINUTE,@overtime)
	end
 

	set @total_hours = @total_hours + @hours

	--insert into @t values (@time_in_nvarchar, @time_out_nvarchar, @time_in_due_nvarchar, @time_out_due_nvarchar, @overtime, @hours)
	--set @staff_day_name = DATENAME(WEEKDAY,@staff_date)

	set @i  = @i + 1
	
end

declare @val nvarchar(50) = CAST((@total_hours) as nvarchar(50)) + ',' + CAST((@early_minutes) as nvarchar(50))

return @val

END