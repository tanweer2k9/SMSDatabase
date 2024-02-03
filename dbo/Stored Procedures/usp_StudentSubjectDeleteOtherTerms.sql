

CREATE PROC usp_StudentSubjectDeleteOtherTerms

--declare @ClassId numeric = 20062, @StudentId numeric = 130773

@ClassId numeric ,
@StudentId numeric 

AS

--Other Terms that are not linked with Student Class Terms include currently
delete from tblStudentSubjectsChild where PId in 
(select Id  from tblStudentSubjectsParent where ClassId = @ClassId and StudentId = @StudentId) and TermId not in (select distinct DEF_TERM from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID = @ClassId and DEF_STATUS = 'T')