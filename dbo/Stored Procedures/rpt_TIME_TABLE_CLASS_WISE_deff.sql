CREATE PROC [dbo].[rpt_TIME_TABLE_CLASS_WISE_deff]

As

select term_name, [Class ID],[Class Name],Subject,[Teacher ID],Teacher, [Start Time], [End Time] from 
(
select p.CLASS_ID as [Class ID], p.CLASS_Name as [Class Name], pd.DEF_TERM as [Term ID],s.SUB_NAME as Subject, tr.TERM_NAME as term_name,
pd.DEF_TEACHER as [Teacher ID],t.TECH_FIRST_NAME as Teacher, pd.DEF_START_TIME as [Start Time], pd.DEF_END_TIME as [End Time]

from SCHOOL_PLANE p
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_CLASS_ID = p.CLASS_ID
join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
join TEACHER_INFO t on t.TECH_ID = pd.DEF_TEACHER
join TERM_INFO tr on tr.TERM_ID = pd.DEF_TERM
)A group by term_name, [Class ID],[Class Name],Subject,[Teacher ID],Teacher, [Start Time], [End Time]
order by [Start Time]