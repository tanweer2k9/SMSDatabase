
CREATE Function [dbo].[GET_ATTENDANCE_COUNT](@remarks char(2), @STAFF_SALLERY_STAFF_ID int, @STAFF_SALLERY_DATE date,@STAFF_SALLERY_HD_ID int, @STAFF_SALLERY_BR_ID int,@TO_Date date = '1900-01-01')
returns numeric

AS
BEGIN


--declare @remarks char(2) = 'A'
--declare @STAFF_SALLERY_STAFF_ID int = 7
--declare @STAFF_SALLERY_DATE date = '2013-09-30'
--declare @STAFF_SALLERY_HD_ID int  = 1
--declare @STAFF_SALLERY_BR_ID int = 1
--declare @staff_left_date date = '2013-09-15'
--declare @staff_joining_date date = '2013-09-23'


declare @staff_left_date date = '1900-01-01'
declare @staff_joining_date date = '1900-01-01'


declare @summer_start_date date = '1900-01-01'
declare @summer_end_date date = '1900-01-01'
declare @winter_start_date date = '1900-01-01'
declare @winter_end_date date = '1900-01-01'

select @summer_start_date = SUM_WIN_SUMMER_START_DATE, @summer_end_date = SUM_WIN_SUMMER_END_DATE,@winter_start_date = SUM_WIN_WINTER_START_DATE,@winter_end_date = SUM_WIN_WINTER_END_DATE  from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = 1

declare @is_vacation_allowed bit = 0

select @is_vacation_allowed =  TECH_IS_VACATION_ALLOWED from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID


DECLARE @d1 DATETIME, @d2 DATETIME

		if @TO_Date = '1900-01-01'
		BEGIN
			SELECT @d1 = (SELECT DATEADD(mm, DATEDIFF(mm,0,@STAFF_SALLERY_DATE), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@STAFF_SALLERY_DATE)+1,0)) )
			set @TO_Date = @d2
			set @STAFF_SALLERY_DATE = @d1
		END
		ELSE
		BEGIN
			SELECT @d1 = (select DATEADD(dd, DATEDIFF(dd,0,@STAFF_SALLERY_DATE), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(dd, DATEDIFF(dd,0,@TO_Date)+1,0)) )
		END

		--set @TO_Date = @d2

set @staff_left_date = (select TECH_LEFT_DATE from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)
set @staff_joining_date = (select TECH_JOINING_DATE from TEACHER_INFO where TECH_ID = @STAFF_SALLERY_STAFF_ID)

declare @STAFF_SALLERY_ABSENT int = 0

	if DATEPART(MM, @STAFF_SALLERY_DATE) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @STAFF_SALLERY_DATE) = DATEPART(YYYY, @staff_joining_date)  and DATEPART(MM, @STAFF_SALLERY_DATE) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @STAFF_SALLERY_DATE) = DATEPART(YYYY, @staff_left_date)
					begin
						set @STAFF_SALLERY_ABSENT = (select Count(*) from (select ROW_NUMBER() OVER (PARTITION BY ATTENDANCE_STAFF_DATE ORDER BY CAST(ATTENDANCE_STAFF_TIME_IN as datetime), ATTENDANCE_STAFF_DATE) AS rnk,* from (select ATTENDANCE_STAFF_TIME_IN,ATTENDANCE_STAFF_REMARKS, ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF
						where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
						ATTENDANCE_STAFF_DATE between @STAFF_SALLERY_DATE and @TO_Date and
						--DATEPART(mm, ATTENDANCE_STAFF_DATE) = DATEPART(mm, @STAFF_SALLERY_DATE) and 
						--DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and
						ATTENDANCE_STAFF_HD_ID = @STAFF_SALLERY_HD_ID 
						and ATTENDANCE_STAFF_DATE <= @staff_left_date																
						 union 
						select ATTENDANCE_STAFF_TIME_IN,ATTENDANCE_STAFF_REMARKS ,ATTENDANCE_STAFF_DATE 
						from ATTENDANCE_STAFF
						where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
						ATTENDANCE_STAFF_DATE between @STAFF_SALLERY_DATE and @TO_Date and
						--DATEPART(mm, ATTENDANCE_STAFF_DATE) = DATEPART(mm, @STAFF_SALLERY_DATE) and 
						--DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and
						ATTENDANCE_STAFF_HD_ID = @STAFF_SALLERY_HD_ID 
						and ATTENDANCE_STAFF_DATE >=@staff_joining_date)A )B where ATTENDANCE_STAFF_REMARKS = @remarks and rnk = 1
						and ATTENDANCE_STAFF_DATE not in (	select all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F'))A )
						)
					end				
				else if DATEPART(MM, @STAFF_SALLERY_DATE) = DATEPART(MM, @staff_joining_date) and DATEPART(YYYY, @STAFF_SALLERY_DATE) = DATEPART(YYYY, @staff_joining_date)
						begin			
					
					set @STAFF_SALLERY_ABSENT = (select Count(*) from (select ROW_NUMBER() OVER (PARTITION BY ATTENDANCE_STAFF_DATE ORDER BY CAST(ATTENDANCE_STAFF_TIME_IN as datetime), ATTENDANCE_STAFF_DATE) AS rnk,ATTENDANCE_STAFF_REMARKS, ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF
						where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
						ATTENDANCE_STAFF_DATE between @STAFF_SALLERY_DATE and @TO_Date and
						--DATEPART(mm, ATTENDANCE_STAFF_DATE) = DATEPART(mm, @STAFF_SALLERY_DATE) and 
						--DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and
						ATTENDANCE_STAFF_HD_ID = @STAFF_SALLERY_HD_ID 
						and ATTENDANCE_STAFF_DATE >= @staff_joining_date)A where ATTENDANCE_STAFF_REMARKS = @remarks and rnk = 1
						and ATTENDANCE_STAFF_DATE not in (	select all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F'))A )
						)
						end	
					else if DATEPART(MM, @STAFF_SALLERY_DATE) = DATEPART(MM, @staff_left_date) and DATEPART(YYYY, @STAFF_SALLERY_DATE) = DATEPART(YYYY, @staff_left_date)
					begin
						set @STAFF_SALLERY_ABSENT = (select Count(*) from (select ROW_NUMBER() OVER (PARTITION BY ATTENDANCE_STAFF_DATE ORDER BY CAST(ATTENDANCE_STAFF_TIME_IN as datetime), ATTENDANCE_STAFF_DATE) AS rnk,ATTENDANCE_STAFF_REMARKS, ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF
						where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
						ATTENDANCE_STAFF_DATE between @STAFF_SALLERY_DATE and @TO_Date and
						--DATEPART(mm, ATTENDANCE_STAFF_DATE) = DATEPART(mm, @STAFF_SALLERY_DATE) and 
						--DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and
						ATTENDANCE_STAFF_HD_ID = @STAFF_SALLERY_HD_ID and ATTENDANCE_STAFF_REMARKS = @remarks
						and ATTENDANCE_STAFF_DATE <= @staff_left_date)A where ATTENDANCE_STAFF_REMARKS = @remarks and rnk = 1
						and ATTENDANCE_STAFF_DATE not in (	select all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F'))A )
						)
					end
					else
						set @STAFF_SALLERY_ABSENT = (select COUNT(*) from
(select * from (select ROW_NUMBER() OVER (PARTITION BY ATTENDANCE_STAFF_DATE ORDER BY CAST(ATTENDANCE_STAFF_TIME_IN as datetime), ATTENDANCE_STAFF_DATE) AS rnk,ATTENDANCE_STAFF_REMARKS, ATTENDANCE_STAFF_DATE,ATTENDANCE_STAFF_TIME_IN, ATTENDANCE_STAFF_TYPE_ID,ATTENDANCE_STAFF_TIME_OUT from ATTENDANCE_STAFF B
						where ATTENDANCE_STAFF_TYPE_ID = @STAFF_SALLERY_STAFF_ID and
						ATTENDANCE_STAFF_DATE between @STAFF_SALLERY_DATE and @TO_Date and
						--DATEPART(mm, ATTENDANCE_STAFF_DATE) = DATEPART(mm, @STAFF_SALLERY_DATE) and 
						--DATEPART(YYYY, ATTENDANCE_STAFF_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE) and
						ATTENDANCE_STAFF_BR_ID in (select * from [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID))  and
						ATTENDANCE_STAFF_HD_ID = @STAFF_SALLERY_HD_ID )A where ATTENDANCE_STAFF_REMARKS = @remarks and rnk = 1
						and ATTENDANCE_STAFF_DATE not in (	select all_days from (SELECT  CONVERT(date,@d1+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_SALLERY_STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F'))A )
						and ATTENDANCE_STAFF_DATE not in (select dates from dbo.GET_ALL_LEAVES_DATE (@STAFF_SALLERY_STAFF_ID,@STAFF_SALLERY_DATE))
						--and ATTENDANCE_STAFF_DATE != '2017-01-04'
						and (@remarks != 'LA' OR not exists
(
select SHORT_LEAVE_DATE from SHORT_LEAVE s where 

CAST(a.ATTENDANCE_STAFF_TIME_OUT as time) >= DATEADD(MINUTE,5,CAST(s.SHORT_LEAVE_FROM_TIME as time))
and s.SHORT_LEAVE_STAFF_ID = a.ATTENDANCE_STAFF_TYPE_ID and a.ATTENDANCE_STAFF_DATE = s.SHORT_LEAVE_DATE
union
select VacationDate from dbo.GET_ALL_VACATION_DATES (@STAFF_SALLERY_HD_ID,@STAFF_SALLERY_BR_ID,CAST(@STAFF_SALLERY_DATE as date),CAST(@TO_Date as date)) where A.ATTENDANCE_STAFF_DATE = CASE WHEN @is_vacation_allowed = 1 THEN VacationDate ELSE  '1900-01-01' END
)) and ((@remarks != 'LA' OR not @is_vacation_allowed=1 )OR (a.ATTENDANCE_STAFF_DATE  not between  @winter_start_date and @winter_end_date))


union
select 1,at.ATTENDANCE_STAFF_REMARKS,at.ATTENDANCE_STAFF_DATE,at.ATTENDANCE_STAFF_TIME_IN,at.ATTENDANCE_STAFF_TYPE_ID,at.ATTENDANCE_STAFF_TIME_OUT from ATTENDANCE_STAFF at 
join EXTRA_HOLIDAYS eh on eh.DATE = at.ATTENDANCE_STAFF_DATE and eh.STAFF_ID = at.ATTENDANCE_STAFF_TYPE_ID  where eh.DATE between @STAFF_SALLERY_DATE and @TO_Date and eh.STAFF_ID = @STAFF_SALLERY_STAFF_ID and at.ATTENDANCE_STAFF_REMARKS = @remarks

)B)
	return @STAFF_SALLERY_ABSENT
END