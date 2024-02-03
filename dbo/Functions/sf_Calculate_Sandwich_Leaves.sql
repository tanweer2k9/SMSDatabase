

CREATE FUNCTION [dbo].[sf_Calculate_Sandwich_Leaves]( 

 @STAFF_SALLERY_ABSENT int,
 @STAFF_SALLERY_STAFF_ID numeric,
 @STAFF_SALLERY_DATE date,
 @d1 datetime,
 @d2 datetime ,
 @STAFF_SALLERY_BR_ID numeric)

 returns int
AS
BEGIN


--declare  @STAFF_SALLERY_ABSENT int = 3,
-- @STAFF_SALLERY_STAFF_ID numeric = 80179,
-- @STAFF_SALLERY_DATE date = '2018-01-01',
-- @d1 datetime = '2018-01-01 00:00:00.000',
-- @d2 datetime ='2018-01-31 23:59:59.000',
-- @STAFF_SALLERY_BR_ID numeric = 1

declare @consecutive_absent_status char(1) = ''
declare @consecutive_leave_status char(1) = ''
declare @is_vacation_allowed bit = 0
declare @summer_start_date date = '1900-01-01'
declare @summer_end_date date = '1900-01-01'
declare @winter_start_date date = '1900-01-01'
declare @winter_end_date date = '1900-01-01'
declare @consecutive_before_weekends int= 0
declare @consecutive_after_weekends int= 0
declare @weekend_days_status char(1) ='F' 
Declare @weekend_days int = 0
declare @months_weekend int = 0
declare @week_day int = 0
declare @weekend_pair_count int = 0
declare @deduct_days int = 0
declare @t table ([Day Name] nvarchar(20), [Day] int, [Type] char, [date] date)



set @consecutive_absent_status =(select STAFF_LEAVES_CONSECUTIVE_ABSENT_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
set @consecutive_leave_status =(select STAFF_LEAVES_CONSECUTIVE_LEAVES_STATUS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
select @is_vacation_allowed = ISNULL([Is Vacation Allowed],0) from VTEACHER_INFO where ID = @STAFF_SALLERY_STAFF_ID
select @summer_start_date = SUM_WIN_SUMMER_START_DATE, @summer_end_date = SUM_WIN_SUMMER_END_DATE,@winter_start_date = SUM_WIN_WINTER_START_DATE,@winter_end_date = SUM_WIN_WINTER_END_DATE  from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID
set @consecutive_before_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_BEFORE_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID), 0)
set @consecutive_after_weekends = ISNULL((select STAFF_LEAVES_CONSECUTIVE_AFTER_WEEKENDS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID),0)
set @weekend_days_status = (select STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_SALLERY_STAFF_ID)
set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')

if  @STAFF_SALLERY_ABSENT > 1
								begin
									if @consecutive_absent_status = 'T'
										begin
											if @consecutive_leave_status = 'T'
												begin
													 
													 
													 Insert into @t
															select * from
															(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
																'A' as [Type],ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

															union all
															select * from
															(
															SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type],(@d1+number) as Date  
															FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
															(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
															)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
																'A' as [Type] from ATTENDANCE_STAFF where (ATTENDANCE_STAFF_REMARKS = 'LE' or ATTENDANCE_STAFF_REMARKS = 'A') and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
																	--This is union for un attendance marks days count as Absent
																	union all

											select DATENAME(DW,all_days) as [Day Name], DATEPART(dd,all_days) as [Day], 'A' as [Type],all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'T'))A where A.all_days not in (select ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID union select ANN_HOLI_DATE from ANNUAL_HOLIDAYS where ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_STATUS = 'T' and ANN_HOLI_DATE between CAST(@d1 as date) and CAST(@d2 as date))
																union all--Annual Holiday Addition
															select DATENAME(WEEKDAY,ANN_HOLI_DATE), DATEPART(DAY,ANN_HOLI_DATE),'E',ANN_HOLI_DATE from ANNUAL_HOLIDAYS where ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and ANN_HOLI_STATUS = 'T' and ANN_HOLI_DATE between CAST(@d1 as date) and CAST(@d2 as date)
															)A order by A.[Day]

															
															delete from @t where date <= (select TECH_JOINING_DATE from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
															delete from @t where date >= (select CASE WHEN TECH_LEFT_DATE = '1900-01-01' THEN '9999-01-01' ELSE TECH_LEFT_DATE END from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
															
															declare @i int = 1
															declare @count int = 0
															declare @tbl table (sr int ,Leaves int, FromDate date,ToDate date, [Is Causal Leaves] bit, [Is Annual Leaves] bit)
															declare @FromDate date = ''
															declare @ToDate date = ''
															insert into @tbl
															select * from dbo.sf_GET_LEAVES_RECORD (@STAFF_SALLERY_DATE, @STAFF_SALLERY_STAFF_ID)
															
															set @count = (select COUNT(*) from @tbl)
															WHILE @i <=@count
															BEGIN
																select @FromDate = FromDate, @ToDate = ToDate from @tbl where Sr = @i
																delete from @t where date between @FromDate and @ToDate
															set @i =@i + 1
															END
															
															if @is_vacation_allowed = 1
															BEGIN
															delete from @t where date between @summer_start_date and @summer_end_date and [Type] = 'A'
															delete from @t where date between @winter_start_date and @winter_end_date and [Type] = 'A'
															END
															
															
												end
											else
												begin
													Insert into @t
															select * from
															(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day],
																'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

															union all
															select * from
															(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type] ,( @d1+number) as Date
															FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
															(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															
															)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
																'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'A' and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
																)A order by A.[Day]
												end
										end
									else
										begin
											if @consecutive_leave_status = 'T'
												begin
													Insert into @t
															select * from
															(select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
																'A' as [Type],ATTENDANCE_STAFF_DATE as Date from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)

															union all
															select * from
															(SELECT DATENAME(DW,( @d1+number)) as [Day Name], DATEPART(dd,(@d1+number)) as [Day], 'W' as [Type],( @d1+number) as Date
															FROM master..spt_values WHERE TYPE ='p' AND DATEDIFF(d,@d1,@d2) >= number AND DATENAME(w,@d1+number) in 
															(select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															)B where B.Day not in (select Day from ( select DATENAME(DW, ATTENDANCE_STAFF_DATE) as [Day Name], DATEPART(DAY, ATTENDANCE_STAFF_DATE) as [Day], 
																'A' as [Type] from ATTENDANCE_STAFF where ATTENDANCE_STAFF_REMARKS = 'LE'  and 
																	ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and DATEPART(MM, ATTENDANCE_STAFF_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) )D)
															)A order by A.[Day]
												end
										end
										
									if (@consecutive_before_weekends > 0 or @consecutive_after_weekends > 0) and @weekend_days_status = 'T'
										begin
											set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')

											if @weekend_days != 0
												begin
													--set @months_weekend = (select COUNT(*) from #temp2 where [Type] = 'W') / @weekend_days
													set @months_weekend = 0
													set @week_day = (select top(1) [Day] from @t where [Type] = 'W')
													
													while @week_day < 32
														begin	
															--set @week_row = (select row from #temp where row = @week_row)
															
															if (select COUNT(*) from @t where [Day] between (@week_day -1) and (@week_day + @weekend_days + 1 -1) and Type != 'E') = @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends
															begin
				
																set @deduct_days = @deduct_days + @weekend_days 
																set @weekend_pair_count = @weekend_pair_count + @weekend_days
															end		
															
															set @week_day = @week_day + 7 - @months_weekend
										-- month weekend variable is used if the saturday is on and weekend holidays are 2 then add one in month weekend					 
															 set @months_weekend = 0
															 set @weekend_days =  (select COUNT(*) from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
															 while (select top(1) [Type] from @t where Day = @week_day) != 'W'	
															begin
																set @weekend_days = @weekend_days -1
																set @week_day = @week_day +1
																set @months_weekend = @months_weekend + 1
															end
												
															
															--select COUNT(*) from #temp2 where [Day] between (@week_day -@consecutive_before_weekends) and (@week_day + @weekend_days + @consecutive_after_weekends -1)
															--select @weekend_days + @consecutive_before_weekends + @consecutive_after_weekends											
														end
												end
										end
								end	

declare @total int = 0
set @total = (select (@weekend_pair_count) + ISNULL((select SUM(A.cnt) from (
																	select CASE WHEN Type = 'E' AND (LAG(Day) over (order by Day)) + 1 = Day  AND  Day = (LEAD(Day) over (order by Day)) - 1  AND Type = 'A' THEN 1 ELSE 0 END cnt  from @t 
																	)A),0))


																

return @total
END