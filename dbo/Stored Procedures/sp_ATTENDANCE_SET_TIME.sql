

CREATE PROC [dbo].[sp_ATTENDANCE_SET_TIME]

@STATUS char(1),
 @HD_ID numeric,
 @BR_ID numeric ,
 @STAFF_ID numeric ,
 @FROM_DATE date ,
 @TO_DATE date


AS
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @STAFF_ID numeric = 30
--declare @FROM_DATE date = '2015-10-01'
--declare @TO_DATE date= '2015-10-30'


declare @tbl table ([Date] date)

declare @i int = 0
declare @count int = 0
set @count = DATEDIFF(dd,@from_date,@to_date) + 1



declare @STAFF_SALLERY_PRESENT numeric = 0
declare @STAFF_SALLERY_ABSENT numeric  =0 
declare @STAFF_SALLERY_LEAVE numeric =0 
declare @STAFF_SALLERY_LATE numeric =0 
declare @STAFF_SALLERY_EARLY_DEPARTURE numeric =0 
declare @STAFF_SALLERY_HALF_DAY numeric =0 
declare @STAFF_SALLERY_WH numeric = 0
declare @Leaves_Limit float = 0

declare @early_minutes int = 0
declare @half_day_minutes int = 0
declare @unattendance_mark_days int = 0
declare @weekend_days int = 0
declare @tbl_sandwhich table (sandwich int)
declare @staff_joining_date date = ''
declare @is_vacation_allowed bit = 0
select @staff_joining_date = TECH_JOINING_DATE, @is_vacation_allowed = TECH_IS_VACATION_ALLOWED from TEACHER_INFO where TECH_ID = @STAFF_ID

DECLARE @d1 DATETIME, @d2 DATETIME

if @STAFF_ID > 0
BEGIN
	while @i < @count
	BEGIN
		insert into @tbl VALUES(DATEADD(dd,@i,@from_date))

		set @i = @i + 1
	END
END


declare @max_date date = ''
select @max_date = GETDATE()--MAX (ATTENDANCE_STAFF_DATE) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_HD_ID = @HD_ID and ATTENDANCE_STAFF_BR_ID = @BR_ID






--select ROW_NUMBER() over(order by ID) as sr, * from VTEACHER_INFO 
--where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Leaves Type] not in ('No Deduction', 'Not Generate Salary')  and ID in 
--(
--select distinct StaffId from EmailHistory where CAST(FromDate as date) = '2019-01-28' and Status = 'FAiled' and EmailModule = 'Attendance Weekly' and StaffId not in (

--select StaffId from EmailHistory where CAST(FromDate as date) = '2019-01-28' and Status = 'sent' and EmailModule = 'Attendance Weekly')
--)

select ROW_NUMBER() over(order by ID) as sr, * from VTEACHER_INFO 
where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Leaves Type] not in ('No Deduction', 'Not Generate Salary') --and [Employee Code] in ('2008409')


set @early_minutes = (select BR_ADM_EARLY_MINUTES_ALLOWED from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)
					set @early_minutes = ISNULL(@early_minutes, 0)

select *,CONVERT(varchar(50),Date,103) as [Date varchar], @early_minutes [Early Minutes] from
(select ATTENDANCE_STAFF_ID ID, 'U' status, ATTENDANCE_STAFF_DATE Date, DATENAME(WEEKDAY,ATTENDANCE_STAFF_DATE) as [Day],ATTENDANCE_STAFF_REMARKS Remarks,ATTENDANCE_STAFF_TIME_IN [Time In],ATTENDANCE_STAFF_TIME_OUT [Time Out],ATTENDANCE_STAFF_CURRENT_TIME_IN [Current Time In],ATTENDANCE_STAFF_CURRENT_TIME_OUT [Current Time Out],ISNULL(er.EarlyType,'') EarlyType, case when s.SHORT_LEAVE_ID is null THEN 0 ELSE 1 END [Is Half Day], CASE WHEN w.Dates is NULL THEN 'F' ELSE 'T' END  IsDueDay, 
--Chechking half day if it is half day from time betweeen -10 minutes currentTImeIn and 10 minutes Current Time in then it is to be TimeIn Half day and if it is half day Totime betweeen -60 minutes currentTImeOut and 30 minutes Current Time out then it is to be TimeOut Half day
CASE WHEN s.SHORT_LEAVE_ID is not null AND CAST(s.SHORT_LEAVE_FROM_TIME as datetime) between DATEADD(MI,-10,CAST(a.ATTENDANCE_STAFF_CURRENT_TIME_IN as datetime)) and  DATEADD(MI,10,CAST(a.ATTENDANCE_STAFF_CURRENT_TIME_IN as datetime)) THEN 'TimeIn' WHEN s.SHORT_LEAVE_ID is not null AND CAST(s.SHORT_LEAVE_TO_TIME as datetime) between DATEADD(MI,-60,CAST(a.ATTENDANCE_STAFF_CURRENT_TIME_OUT as datetime)) and  DATEADD(MI,30,CAST(a.ATTENDANCE_STAFF_CURRENT_TIME_OUT as datetime)) THEN 'TimeOut' ELSE '' END HalfDayType   

from ATTENDANCE_STAFF a 
left join (select * from dbo.tf_Get_Early_Departure (@STAFF_ID, @early_minutes,@FROM_DATE,@TO_DATE)) er on er.Dates = a.ATTENDANCE_STAFF_DATE
left join SHORT_LEAVE s on DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and a.ATTENDANCE_STAFF_DATE = s.SHORT_LEAVE_DATE and SHORT_LEAVE_STAFF_ID = @STAFF_ID 
left join (select * from tf_GET_ALL_WEEKENDS_DATES(@STAFF_ID, @FROM_DATE, @TO_DATE))D on D.AllDates = a.ATTENDANCE_STAFF_DATE
left join STAFF_WORKING_DAYS s1 on s1.STAFF_WORKING_DAYS_NAME = DATENAME (WEEKDAY,A.ATTENDANCE_STAFF_DATE)  and s1.STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID and s1.STAFF_WORKING_DAYS_STATUS = 'T' 
left join (select * from dbo.tf_Get_All_Working_Days(@STAFF_ID,@early_minutes,@FROM_DATE,@TO_DATE,@HD_ID,@BR_ID,@is_vacation_allowed))w on w.Dates = a.ATTENDANCE_STAFF_DATE
where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @FROM_DATE and @TO_DATE
union

select ROW_NUMBER() over(order by (select 0)) as ID, 'I',Date,[Day Name],'A',s.STAFF_WORKING_DAYS_TIME_IN, s.STAFF_WORKING_DAYS_TIME_OUT,s.STAFF_WORKING_DAYS_TIME_IN, s.STAFF_WORKING_DAYS_TIME_OUT,''EarlyType, 0 [Is Half Day], 'T' IsDueDay,'' HalfDayType from
(select [Date],DATENAME(WEEKDAY,[Date]) [Day Name]
from @tbl )A
left join STAFF_WORKING_DAYS s on s.STAFF_WORKING_DAYS_NAME = A.[Day Name] and s.STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID 

where s.STAFF_WORKING_DAYS_DAY_STATUS = 'T' and date not in (select ANN_HOLI_DATE from ANNUAL_HOLIDAYS where ANN_HOLI_HD_ID = @HD_ID and ANN_HOLI_BR_ID = @BR_ID and ANN_HOLI_STATUS = 'T') and  Date <= @max_date and  [Date] not in (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @FROM_DATE and @TO_DATE
)

union
select ROW_NUMBER() over(order by (select 0)) as ID, 'I',eh.DATE, DATENAME(WEEKDAY,eh.DATE) as [Day],'A',eh.TIME_IN,eh.TIME_OUT,eh.TIME_IN,eh.TIME_OUT,''EarlyType,0,'T', ''HalfDayType
from EXTRA_HOLIDAYS eh
join EXTRA_HOLIDAYS_PARENT ehp on ehp.ID = eh.PID
where ehp.DAY_TYPE = 'WorkingDay' and eh.DATE between @FROM_DATE and @TO_DATE and eh.STAFF_ID = @STAFF_ID  and  eh.Date <= @max_date and  [Date] not in (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_ID and ATTENDANCE_STAFF_DATE between @FROM_DATE and @TO_DATE
)
)B 
where Date >= @staff_joining_date AND
Date not in (
select eh.DATE
from EXTRA_HOLIDAYS eh
join EXTRA_HOLIDAYS_PARENT ehp on ehp.ID = eh.PID
where ehp.DAY_TYPE = 'Holiday' and eh.DATE between @FROM_DATE and @TO_DATE and eh.STAFF_ID = @STAFF_ID )

order by Date


set @early_minutes = (select BR_ADM_EARLY_MINUTES_ALLOWED from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)
set @early_minutes = ISNULL(@early_minutes, 0)

set @half_day_minutes = (select BR_ADM_HALF_DAY_MINUTES from BR_ADMIN where BR_ADM_HD_ID = @HD_ID and BR_ADM_ID = @BR_ID)
set @half_day_minutes = ISNULL(@half_day_minutes, 0)

SELECT @d1 = (select DATEADD(dd, DATEDIFF(dd,0,@FROM_DATE), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(dd, DATEDIFF(dd,0,@TO_Date)+1,0)) )

									set @STAFF_SALLERY_ABSENT =	dbo.GET_ATTENDANCE_COUNT('A',@STAFF_ID, @FROM_DATE, @HD_ID, @BR_ID,@TO_DATE)
									set @STAFF_SALLERY_LATE = dbo.GET_ATTENDANCE_COUNT('LA',@STAFF_ID, @FROM_DATE, @HD_ID, @BR_ID,@TO_DATE)		
									set @STAFF_SALLERY_LEAVE = dbo.GET_ATTENDANCE_COUNT('LE',@STAFF_ID, @FROM_DATE, @HD_ID, @BR_ID,@TO_DATE) + (select COUNT(*) from dbo.GET_ALL_LEAVES_DATE(@STAFF_ID,@FROM_DATE))
									set @STAFF_SALLERY_PRESENT = dbo.GET_ATTENDANCE_COUNT('P',@STAFF_ID, @FROM_DATE, @HD_ID, @BR_ID,@TO_DATE)
									set @STAFF_SALLERY_WH = dbo.GET_ATTENDANCE_COUNT('WH',@STAFF_ID, @FROM_DATE, @HD_ID, @BR_ID,@TO_DATE)
									set @STAFF_SALLERY_EARLY_DEPARTURE = (select dbo.GET_EARLY_DEPARTURE(@STAFF_ID,@early_minutes,@FROM_DATE,@TO_DATE))
									set @STAFF_SALLERY_HALF_DAY = (select COUNT(*) from SHORT_LEAVE where  DATEDIFF(MI,CONVERT(time, SHORT_LEAVE_FROM_TIME),CONVERT(time, SHORT_LEAVE_TO_TIME)) >= @half_day_minutes and DATEPART(MM, SHORT_LEAVE_DATE) = DATEPART(MM, @FROM_DATE) and DATEPART(YYYY, SHORT_LEAVE_DATE)  = DATEPART(YYYY, @FROM_DATE) and SHORT_LEAVE_STAFF_ID = @STAFF_ID )
									--set @remaining_leaves_limit = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_ID,@FROM_DATE,@BR_ID)
													--select @STAFF_SALLERY_ABSENT [absent],@STAFF_SALLERY_LATE [late],@STAFF_SALLERY_LEAVE [leave],@STAFF_SALLERY_PRESENT [present],@STAFF_SALLERY_WH [work_holiday]								
													
													set @unattendance_mark_days = [dbo].GET_UNATTENDANCE_MARKS_DAYS(@STAFF_ID, @FROM_DATE,@TO_DATE,@HD_ID,@BR_ID)
--									set @unattendance_mark_days = [dbo].[Get_working_days](@STAFF_ID, @FROM_DATE,@TO_DATE) - (@STAFF_SALLERY_PRESENT + @STAFF_SALLERY_ABSENT + @STAFF_SALLERY_LEAVE + 
--									@STAFF_SALLERY_LATE + @STAFF_SALLERY_WH + @STAFF_SALLERY_HALF_DAY ) -
--									--calculate the week days of the staff
--									(select COUNT(*) from
--(SELECT (@d1 + number) as date1 FROM master..spt_values WHERE TYPE ='p'AND DATEDIFF(d,@d1,@d2) >= number
--AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_DAY_STATUS = 'F' and STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID))A)

									--set @STAFF_SALLERY_ABSENT = @STAFF_SALLERY_ABSENT + @unattendance_mark_days

									set @Leaves_Limit = dbo.fu_REMAINING_LEAVES_LIMIT(@STAFF_ID,DateAdd(mm,-1,@FROM_DATE),@BR_ID,'C')
									set @weekend_days = dbo.[Get_weekend_days] (@STAFF_ID,@FROM_DATE)

									declare @total_Absent int = 0
									set @total_Absent =  @STAFF_SALLERY_ABSENT + @unattendance_mark_days + @STAFF_SALLERY_LEAVE

									
									
									select @STAFF_SALLERY_PRESENT + @STAFF_SALLERY_LATE [Present], @STAFF_SALLERY_ABSENT [Absent], @STAFF_SALLERY_LEAVE [Leave], @STAFF_SALLERY_LATE [Late],@STAFF_SALLERY_EARLY_DEPARTURE [Early Departure], @STAFF_SALLERY_HALF_DAY [Half Day], @unattendance_mark_days [Unattendance],@Leaves_Limit [Leaves Limit],@weekend_days [Weekend Days], (select dbo.sf_Calculate_Sandwich_Leaves (@total_Absent,@STAFF_ID,@FROM_DATE,@d1,@d2,@BR_ID)) as [Sandwich], (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_BR_ID = @BR_ID and ANN_HOLI_STATUS = 'T' and ANN_HOLI_DATE between CAST(@d1 as date) and CAST(@d2 as date) ) as [Exceptional Holidays]

									select top(1) * from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @BR_ID order by SUM_WIN_ID desc
									select * from dbo.GET_ALL_VACATION_DATES (@HD_ID,@BR_ID,@FROM_DATE,@TO_DATE)