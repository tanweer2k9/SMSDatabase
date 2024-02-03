CREATE PROC usp_elearningQuizStudentAttempDeletion

@StdId numeric,
@TestId numeric

AS

delete From eLearningAssessmentStudentAnswerParent where TestInfoId = @TestId and StudentId = @StdId
delete from eLearningAssessmentStudentAnswerOrderTemp where StudentId = @StdId and TestInfoId = @TestId

delete from eLearningAssessmentStudentAnswerChild where PId in (select Id From eLearningAssessmentStudentAnswerParent where TestInfoId = @TestId	   and StudentId = @StdId)