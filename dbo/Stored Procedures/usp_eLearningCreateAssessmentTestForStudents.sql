
CREATE PROC [dbo].[usp_eLearningCreateAssessmentTestForStudents]


@TestInfoId numeric,
@StudentId numeric

AS

if @StudentId = -1
BEGIN
	delete from eLearningAssessmentStudentAnswerOrderTemp where TestInfoId = @TestInfoId and StudentId = @StudentId
END


declare @Id numeric = 0

select @Id = ISNULL(Id,0) from  eLearningAssessmentStudentAnswerOrderTemp where TestInfoId = @TestInfoId and StudentId = @StudentId

if @Id = 0
BEGIN
	insert into eLearningAssessmentStudentAnswerOrderTemp
 
	select @StudentId, @TestInfoId, q.Id, ROW_NUMBER() over(order by q.QuestionTypeId), 0, 0
	from eLearningAssessmentQuestions q
	where AssesmentTestInfoId = @TestInfoId and q.IsDeleted = 0 and QuestionTypeId != 0
END