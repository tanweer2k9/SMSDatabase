CREATE PROC [dbo].[sp_EXAM_ATTENDANCE]

@SESSION_START_DATE date,
@SESSION_END_DATE date,
@HD_ID numeric,
@BR_ID numeric
--@STATUS char(2)

AS

--declare @SESSION_START_DATE date = '2013-01-01'
--declare @SESSION_END_DATE date = '2014-01-01'
--declare @HD_ID numeric = 2
--declare @BR_ID numeric = 1
--declare @STATUS char(2) = 'A'

declare @t table ([Std ID] int, term int, Present int, [Absent] int, Leave int, Late int, 
[Total Days] int, [Total Working Days] int)


declare @term_count int = (select COUNT(*) from TERM_INFO where TERM_STATUS = 'T' and TERM_SESSION_START_DATE = @SESSION_START_DATE and TERM_SESSION_END_DATE = @SESSION_END_DATE and TERM_HD_ID = @HD_ID and TERM_BR_ID = @BR_ID)
declare @i int = 1
declare @term int = 0
declare @session_duration int = (select DATEDIFF(DD, @SESSION_START_DATE, @SESSION_END_DATE) + 1)


while @i <= @term_count
begin
	set @term = ( select TERM_ID from (select ROW_NUMBER() over(order by (select 0)) as sr, TERM_ID from TERM_INFO where TERM_STATUS = 'T' and TERM_SESSION_START_DATE = @SESSION_START_DATE and TERM_SESSION_END_DATE = @SESSION_END_DATE and TERM_HD_ID = @HD_ID and TERM_BR_ID = @BR_ID)B where @i = sr)
	
	declare @term_start_date date = (select TERM_START_DATE from TERM_INFO where TERM_ID = @term and TERM_SESSION_START_DATE = @SESSION_START_DATE and TERM_SESSION_END_DATE = @SESSION_END_DATE and TERM_HD_ID = @HD_ID and TERM_BR_ID = @BR_ID)
	declare @term_end_date date = (select TERM_END_DATE from TERM_INFO where TERM_ID = @term and TERM_SESSION_START_DATE = @SESSION_START_DATE and TERM_SESSION_END_DATE = @SESSION_END_DATE and TERM_HD_ID = @HD_ID and TERM_BR_ID = @BR_ID)
	declare @total_days int = 0
	set @total_days = (select DATEDIFF(DD, @term_start_date, @term_end_date) + 1)

	insert into @t	
	select  [Std ID], @term as term, CASE when [Std ID] > 0 then (select COUNT(ATTENDANCE_REMARKS) from ATTENDANCE 
	where ATTENDANCE_DATE between @term_start_date and @term_end_date and ATTENDANCE_REMARKS = 'P' and 
	ATTENDANCE_TYPE_ID = [Std ID]) else 0 END as Present, CASE when [Std ID] > 0 then (select COUNT(ATTENDANCE_REMARKS)
	 from ATTENDANCE where ATTENDANCE_DATE between @term_start_date and @term_end_date and ATTENDANCE_REMARKS = 'A' 
	 and ATTENDANCE_TYPE_ID = [Std ID]) else 0 END as [Absent], CASE when [Std ID] > 0 then 
	 (select COUNT(ATTENDANCE_REMARKS) from ATTENDANCE where ATTENDANCE_DATE between @term_start_date and 
	 @term_end_date and ATTENDANCE_REMARKS = 'LE' and ATTENDANCE_TYPE_ID = [Std ID]) else 0 END as Leave,
	 CASE when [Std ID] > 0 then 
	 (select COUNT(ATTENDANCE_REMARKS) from ATTENDANCE where ATTENDANCE_DATE between @term_start_date and 
	 @term_end_date and ATTENDANCE_REMARKS = 'LA' and ATTENDANCE_TYPE_ID = [Std ID]) else 0 END as Late, @total_days as [Total Days],
	 count_remarks as [Total Working Days]

	 from
	(select  a.ATTENDANCE_TYPE_ID as [Std ID], COUNT(ATTENDANCE_REMARKS) as count_remarks from ATTENDANCE a where ATTENDANCE_DATE between @term_start_date 
	and @term_end_date group by a.ATTENDANCE_TYPE_ID)A
	set @i = @i + 1
end

--if @STATUS = 'A'
--select [Std ID], SUM(Present) as Present, SUM(Absent) as Absent,  SUM(Leave) as Leave,  SUM(Late) as Late,  
--@session_duration as [Total Days] ,SUM([Total Working Days]) as [Total Working Days]
-- from @t group by [Std ID]
--else
select * from @t