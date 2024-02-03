CREATE PROC [dbo].[rpt_TIME_TABLE_TEACHER_WISE]
	@TEACHER_ID numeric,
	@TERM_ID numeric,
	@SESSION_START_DATE date,
	@SESSION_END_DATE date,
	@HD_ID numeric,
	@BR_ID numeric
	
AS
BEGIN

--declare @TEACHER_ID numeric = 0
--declare @TERM_ID numeric = 0
--declare @SESSION_START_DATE date = '2013-04-01'
--declare @SESSION_END_DATE date = '2014-03-31'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 0


declare @teacher nvarchar(50) = dbo.set_where_like(@TEACHER_ID)
declare @term_like nvarchar(50) = dbo.set_where_like(@TERM_ID)
	

declare @hd nvarchar(10) = dbo.set_where_like(@HD_ID)
declare @br nvarchar(10) = dbo.set_where_like(@BR_ID)

declare @t table (term_id numeric(18,0),term_name nvarchar(100), [session start date] date, [session end date] date)

declare @t_terms table (term_id int)
 insert into @t_terms
 select distinct DEF_TERM as term_id from SCHOOL_PLANE_DEFINITION 


declare @term int = 0
declare @term_name nvarchar(50) = ''
declare @session_start date = ''
declare @session_end date = ''

declare @i int = 1
declare @count int = 0
set @count = (select count(*) from  (select * from @t_terms)A)

while  @i <= @count
BEGIN
	select @term = term_id from (select term_id, ROW_NUMBER() over(order by (select 0)) as sr from @t_terms)A where sr = @i
	
	select @term_name = TERM_NAME, @session_start = TERM_SESSION_START_DATE, @session_end = TERM_SESSION_END_DATE
	from TERM_INFO where TERM_ID = @term
	insert into @t values (@term, @term_name, @session_start, @session_end)
	set @i = @i + 1	
END

--select * from @t
--select @term_like, @teacher

select [Teacher ID],[Teacher Name],term_name,[session start date],[session end date] from
 (select TECH_ID as [Teacher ID],TECH_FIRST_NAME as [Teacher Name], t.term_id, t.term_name, t.[session start date], t.[session end date]
 
from TEACHER_INFO s
cross join @t t

where TECH_STATUS != 'D' and t.[session start date] = @SESSION_START_DATE and t.[session end date] = @SESSION_END_DATE
and term_id like @term_like and s.TECH_ID like @teacher and s.TECH_HD_ID like @hd and s.TECH_BR_ID like @br
)A group by term_name, [Teacher ID],[Teacher Name],[session start date],[session end date]
order by [Teacher ID]
END