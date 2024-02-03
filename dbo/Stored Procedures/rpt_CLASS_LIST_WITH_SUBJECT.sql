﻿
CREATE PROC [dbo].[rpt_CLASS_LIST_WITH_SUBJECT]

@HD_ID numeric,
@BR_ID numeric,
@STATUS char(1),
@CLASS_ID numeric,
@SUBJECT_ID nvarchar(500),
@TERM_ID numeric

AS

--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1,
--@STATUS char(1) = 'A',
--@CLASS_ID numeric = 8,
--@SUBJECT_ID numeric = 22


--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1,
--@STATUS char(1) = 'A',
--@CLASS_ID numeric = 20071,
--@SUBJECT_ID nvarchar(100) = '22;23',
--@TERM_ID numeric = 42


select ROW_NUMBER() over (order by (select 0) ) as sr#,[Roll No],[Student Name], Class,SubjectId from
(
select distinct s.STDNT_SCHOOL_ID [Roll No],(s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) [Student Name],
sp.CLASS_Name [Class], s.STDNT_SCHOOL_ID  as [Sch ID], c.SubjectId from 
tblStudentSubjectsParent p
join tblStudentSubjectsChild c on c.PId = p.Id
join SCHOOL_PLANE sp on sp.CLASS_ID = p.ClassId
--STUDENT_ELECTIVE_SUBJECT se
--join ELECTIVE_SUBJECT_DEF esd on esd.ELE_SUB_DEF_ID = se.STD_ELE_SUB_SUBJECT_ID
--join ELECTIVE_SUBJECT es on es.ELE_SUB_ID = esd.ELE_SUB_DEF_PID
join STUDENT_INFO s on s.STDNT_ID = p.StudentId
--join SCHOOL_PLANE sp on sp.CLASS_ID = es.ELE_SUB_CLASS_ID
where s.STDNT_STATUS = 'T' and p.ClassId = @CLASS_ID and sp.CLASS_STATUS = 'T' and c.TermId = @TERM_ID 
and  c.SubjectId in (select CAST(val as numeric) from dbo.split( @SUBJECT_ID,';'))
)A

order by CAST([Sch ID] as numeric)

----declare @HD_ID numeric = 1
----declare @BR_ID numeric = 1,
----@STATUS char(1) = 'A',
----@CLASS_ID numeric = 8,
----@SUBJECT_ID numeric = 22


--select ROW_NUMBER() over (order by (select 0) ) as sr#,[Roll No],[Student Name], Class from
--(
--select s.STDNT_SCHOOL_ID [Roll No],(s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) [Student Name],
--sp.CLASS_Name [Class], CASE WHEN s.STDNT_SCHOOL_ID = '' THEN 50000 ELSE  CONVERT(numeric(18,0),STDNT_SCHOOL_ID) END as [Sch ID] from STUDENT_ELECTIVE_SUBJECT se
--join ELECTIVE_SUBJECT_DEF esd on esd.ELE_SUB_DEF_ID = se.STD_ELE_SUB_SUBJECT_ID
--join ELECTIVE_SUBJECT es on es.ELE_SUB_ID = esd.ELE_SUB_DEF_PID
--join STUDENT_INFO s on s.STDNT_ID = se.STD_ELE_SUB_STDNT_ID
--join SCHOOL_PLANE sp on sp.CLASS_ID = es.ELE_SUB_CLASS_ID
--where s.STDNT_STATUS = 'T' and esd.ELE_SUB_DEF_STATUS = 'T' and es.ELE_SUB_STATUS = 'T' and sp.CLASS_STATUS = 'T' and
-- es.ELE_SUB_CLASS_ID = @CLASS_ID and esd.ELE_SUB_DEF_SUB_ID = @SUBJECT_ID and es.ELE_SUB_HD_ID = @HD_ID and es.ELE_SUB_BR_ID = @BR_ID
--)A

--order by [Sch ID]