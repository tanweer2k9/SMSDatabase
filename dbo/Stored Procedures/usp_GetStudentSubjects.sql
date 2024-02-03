CREATE PROC usp_GetStudentSubjects

@StdId numeric,
@ClassId numeric,
@IsCompulsory bit,
@TermId numeric,
@BrId numeric

AS

declare @one int = 1

if @TermId = -1
BEGIN
	select top(@one) @TermId = TERM_ID from TERM_INFO where GETDATE() between TERM_START_DATE and TERM_END_DATE and TERM_BR_ID = @BrId and TERM_STATUS = 'T'
END

select distinct c.SubjectId SubjectId from tblStudentSubjectsParent p
join tblStudentSubjectsChild c on c.PId = p.Id
join (select * from dbo.tf_GetClassSubjects(@ClassId,@IsCompulsory,0))S on S.Id = c.SubjectId 
--Send TermId 0 in the function becuase if student takes all subjects and in class term it is inactive then it miss that subject
where ClassId = @ClassId and p.StudentId = @StdId and (@TermId = 0 OR c.TermId = @TermId)