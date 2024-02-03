CREATE PROC [dbo].[rpt_STUDENT_CARD]


@CLASS_ID numeric,
@STUDENT_ID numeric

AS

declare @std_id nvarchar(50)
declare @plan_id nvarchar(50)

if @CLASS_ID = 0
	set @plan_id = '%'
else
	set @plan_id = CONVERT(nvarchar(50), @CLASS_ID)

if @STUDENT_ID = 0
	set @std_id = '%'
else
	set @std_id = CONVERT(nvarchar(50), @STUDENT_ID)

select s.STDNT_ID as ID, s.STDNT_FIRST_NAME as [Student Name], p.PARNT_FIRST_NAME as [Parent Name],
ci.CLASS_NAME as Class, si.SECT_NAME as Section, CASE when s.STDNT_ID < 0 then 0 else (select top(1) 
STUDENT_ROLL_NUM_ROLL_NO from STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and 
r.STUDENT_ROLL_NUM_PLAN_ID = c.CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#, s.STDNT_IMG as std_image
from STUDENT_INFO s
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join SCHOOL_PLANE c on c.CLASS_ID = s.STDNT_CLASS_PLANE_ID
join CLASS_INFO ci on ci.CLASS_ID = c.CLASS_CLASS
join SECTION_INFO si on si.SECT_ID = c.CLASS_SECTION
where s.STDNT_STATUS = 'T' and c.CLASS_ID like @plan_id and s.STDNT_ID like @std_id order by c.CLASS_ID