CREATE PROC [dbo].[rpt_MultiSubjectInfo]

 
@ClassId numeric, --= 20072,
@TermId numeric,-- = 41,
@Subjects nvarchar(500)--='1,2,3,4'
--select * from SCHOOL_PLANE

AS




select sp.CLASS_Name Class,s.SUB_ID SubjectId,s.SUB_NAME [Subject], t.TERM_NAME Term, si.SESSION_DESC Sesion,(
select COUNT(*) from tblStudentSubjectsParent p
join tblStudentSubjectsChild c on c.PId = p.Id
join STUDENT_INFO st on st.STDNT_ID = p.StudentId and st.STDNT_STATUS = 'T'
where ClassId = @ClassId and TermId = @TermId and SubjectId = spd.DEF_SUBJECT) TotalStudents

 from SCHOOL_PLANE_DEFINITION spd
join SCHOOL_PLANE sp on sp.CLASS_ID = spd.DEF_CLASS_ID
join SUBJECT_INFO s on s.SUB_ID = spd.DEF_SUBJECT
join SESSION_INFO si on si.SESSION_ID = sp.CLASS_SESSION_ID
join TERM_INFO t on t.TERM_ID = spd.DEF_TERM
where DEF_CLASS_ID = @ClassId and DEF_TERM = @TermId and DEF_STATUS = 'T' and DEF_SUBJECT in (select CAST(val as numeric) from dbo.split(@Subjects,';'))