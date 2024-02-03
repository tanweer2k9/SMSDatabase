
CREATE PROC [dbo].[rpt_StudentMultiSubjectInfo]


@ClassId numeric, --= 20072,
@TermId numeric,-- = 41,
@Subjects nvarchar(500)--='1,2,3,4'


AS

select st.STDNT_SCHOOL_ID StudentSchoolId, STDNT_FIRST_NAME + ' ' +STDNT_LAST_NAME as Name,SubjectId from tblStudentSubjectsParent p
join tblStudentSubjectsChild c on c.PId = p.Id
join STUDENT_INFO st on st.STDNT_ID = p.StudentId 
where ClassId = @ClassId and TermId = @TermId and st.STDNT_STATUS = 'T' and SubjectId in (select CAST(val as numeric) from dbo.split(@Subjects,';')) order by CAST(STDNT_SCHOOL_ID as numeric)