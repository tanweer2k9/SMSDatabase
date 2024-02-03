CREATE PROC [dbo].[rpt_TIME_TABLE_TEACHER_WISE_deff]

AS
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
--declare @teacher nvarchar(10) = dbo.set_where_like(@TEACHER_ID)
--declare @hd nvarchar(10) = dbo.set_where_like(@HD_ID)
--declare @br nvarchar(10) = dbo.set_where_like(@BR_ID)

select Teacher, Term_Name,[Class name],Section,Shift,Subject,[Start Time],[End Time],Branch from
(
select Teacher, Term,[Class name], Term_Name,
--case when (Class > 0) then (select CLASS_Name from CLASS_INFO where CLASS_ID = Class) else 'no thing' END as Class, 
case when (Section > 0) then (select SECT_NAME from SECTION_INFO where SECT_ID = Section) else 'no thing' END as Section,
case when (Shift > 0) then (select SHFT_NAME from SHIFT_INFO where SHFT_ID = Shift) else 'no thing' END as Shift, 
Subject, [Start Time], [End Time], CASE WHEN [BR ID] > 0 then (select BR_ADM_NAME from BR_ADMIN where BR_ADM_ID = [BR ID]) ELSE 'no branch' END as Branch
 from (select distinct(pd.DEF_ID), p.CLASS_ID as [Class ID],p.CLASS_HD_ID as [HD ID], p.CLASS_BR_ID as [BR ID], 
 p.CLASS_Name as [Class name], s.SUB_NAME as [Subject], pd.DEF_START_TIME as [Start Time], pd.DEF_END_TIME as [End Time], 
DEF_TEACHER as Teacher, p.CLASS_SECTION as Section, p.CLASS_SHIFT as Shift, pd.DEF_TERM as Term, TERM_NAME as Term_Name from 
SCHOOL_PLANE_DEFINITION pd
join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
join TERM_INFO t on pd.DEF_TERM = t.TERM_ID
where 
p.CLASS_STATUS = 'T' 
)A 
)B group by Term_Name,[Class name],Section,Shift,Subject,Teacher,[Start Time],[End Time],Branch

order by Teacher, [Start Time]