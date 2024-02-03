


CREATE function [dbo].[GET_UNATTENDANCE_MARKS_DAYS](@STAFF_ID numeric, @FROM_DATE date, @TO_DATE date, @HD_ID numeric, @BR_ID numeric)
returns int

BEGIN
declare @tbl table ([Date] date, [dayName] nvarchar(50))

declare @i int = 0
declare @count int = 0
set @count = DATEDIFF(dd,@from_date,@to_date) + 1



if @STAFF_ID > 0
BEGIN
	while @i < @count
	BEGIN
		insert into @tbl VALUES(DATEADD(dd,@i,@from_date),DATENAME(dw,DATEADD(dd,@i,@from_date)))

		set @i = @i + 1
	END
END

declare @is_vacation_allowed bit = 0
	select @is_vacation_allowed = TECH_IS_VACATION_ALLOWED from TEACHER_INFO where TECH_ID  = @STAFF_ID and TECH_STATUS = 'T'
	set @is_vacation_allowed = ISNULL(@is_vacation_allowed, CAST(0 as bit))

declare @summer_start_date date = '1900-01-01'
declare @summer_end_date date = '1900-01-01'
declare @winter_start_date date = '1900-01-01'
declare @winter_end_date date = '1900-01-01'

select @summer_start_date = SUM_WIN_SUMMER_START_DATE, @summer_end_date = SUM_WIN_SUMMER_END_DATE,@winter_start_date = SUM_WIN_WINTER_START_DATE,@winter_end_date = SUM_WIN_WINTER_END_DATE  from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @BR_ID





if @is_vacation_allowed = 1
	BEGIN
	delete from @tbl where date  between @summer_start_date and @summer_end_date
	delete from @tbl where date  between @winter_start_date and @winter_end_date
	delete from @tbl where Date in (select VacationDate from dbo.[GET_ALL_VACATION_DATES] (@HD_ID,@BR_ID,@from_Date,@TO_DATE))
	END



--select * from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = 18
select @count = COUNT(*) from
(
select t.Date from @tbl t
join STAFF_WORKING_DAYS s on s.STAFF_WORKING_DAYS_NAME = t.dayName and s.STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID 
join TEACHER_INFO te on te.TECH_ID = @STAFF_ID

where  s.STAFF_WORKING_DAYS_DAY_STATUS = 'T' and t.Date >= te.TECH_JOINING_DATE and t.Date <= CASE WHEN te.TECH_LEFT_DATE = '1900-01-01' THEN '9999-01-01' ELSE te.TECH_LEFT_DATE END
union 
select Date from VEXTRA_HOLIDAYS where [Date] between @FROM_DATE and @TO_DATE and [Date Type] = 'WorkingDay' and [Staff ID] = @STAFF_ID
EXCEPT 
select ANN_HOLI_DATE from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @HD_ID and ANN_HOLI_BR_ID = @BR_ID
EXCEPT
select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @FROM_DATE and @TO_DATE --and ATTENDANCE_STAFF_DATE not in ( CASE WHEN @is_vacation_allowed = 0 THEN NULL ELSE select * from atte END)
EXCEPT
select Dates from dbo.GET_ALL_LEAVES_DATE (@STAFF_ID,@FROM_DATE)
EXCEPT
select Date from VEXTRA_HOLIDAYS where [Date] between @FROM_DATE and @TO_DATE and [Date Type] = 'Holiday' and [Staff ID] = @STAFF_ID
)A




return @count

END