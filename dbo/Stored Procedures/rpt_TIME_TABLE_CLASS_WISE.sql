CREATE PROC [dbo].[rpt_TIME_TABLE_CLASS_WISE]
	
	@CLASS_ID nvarchar(300),
	@TERM_ID numeric,
	@SESSION_START_DATE date,
	@SESSION_END_DATE date,
	@HD_ID numeric,
	@BR_ID numeric

AS

--declare @CLASS_ID nvarchar(100) = '1,2,3'
--declare @TERM_ID numeric = 0
--declare @SESSION_START_DATE date = '2013-04-01'
--declare @SESSION_END_DATE date = '2014-03-31'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1

declare @term_like nvarchar(50) = dbo.set_where_like(@TERM_ID)
declare @hd nvarchar(10) = dbo.set_where_like(@HD_ID)
declare @br nvarchar(10) = dbo.set_where_like(@BR_ID)
--declare @class nvarchar(10) = dbo.set_where_like(@CLASS_ID)

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

select term_name, Branch,[Class ID], [Class Name],Section,SHFT_NAME,[Class Incharge],[Incharge ID],[Sesstion Start Date],[Session End Date] from
(select br.BR_ADM_NAME as Branch, p.CLASS_ID as [Class ID], p.CLASS_Name as [Class Name], s.SECT_NAME as Section, sh.SHFT_NAME, t.TECH_FIRST_NAME as [Class Incharge],
p.CLASS_TEACHER as [Incharge ID],p.CLASS_SESSION_START_DATE as [Sesstion Start Date], 
p.CLASS_SESSION_END_DATE as [Session End Date], tr.term_id, tr.term_name
from SCHOOL_PLANE p
join SECTION_INFO s on s.SECT_ID = p.CLASS_SECTION
join SHIFT_INFO sh on sh.SHFT_ID = p.CLASS_SHIFT
join TEACHER_INFO t on t.TECH_ID = p.CLASS_TEACHER
join BR_ADMIN br on br.BR_ADM_ID = p.CLASS_BR_ID
cross join @t tr

where p.CLASS_STATUS = 'T' and p.CLASS_HD_ID like @hd and p.CLASS_BR_ID like @br and tr.term_id like @term_like
and p.CLASS_ID in (select val from dbo.split(@CLASS_ID, ','))
)A group by term_name, Branch,[Class ID], [Class Name],Section,SHFT_NAME,[Class Incharge],[Incharge ID],[Sesstion Start Date],[Session End Date]
order by [Class ID], term_name