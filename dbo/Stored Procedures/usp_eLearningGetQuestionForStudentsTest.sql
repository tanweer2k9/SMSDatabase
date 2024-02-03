CREATE PROC [dbo].[usp_eLearningGetQuestionForStudentsTest]

@TestInfoId numeric,
@StudentId numeric,
@Serial int


AS
declare @QuestionId numeric
declare @StudentAnswerOrderTempId numeric  



select @QuestionId = QuestionId, @StudentAnswerOrderTempId = Id from eLearningAssessmentStudentAnswerOrderTemp 
where TestInfoId = @TestInfoId and StudentId = @StudentId and Serial = @Serial + 1


select ISNULL(p.ParagraphText,'') ParagraphText, q.Question, ISNULL(o.OptionText,'') OptionText,ISNULL(o.FilePath,'') FilePath,ISNULL(o.Id,0) OptionId, t.Name QuestionType, t.Code QuestionCode,q.Marks, @Serial + 1 Serial,q.Id QuestionId, @StudentAnswerOrderTempId StudentAnswerOrderTempId  from eLearningAssessmentQuestions q
join eLearningAssessmentQuestionType t on t.Id = q.QuestionTypeId
left join eLearningAssessmentOptions o on q.Id = o.QuestionId and ISNULL(o.IsDeleted,0) = 0
left join eLearningAssessmentParagraph p on p.Id = q.ParagraphId

where q.Id = @QuestionId and ISNULL(q.IsDeleted,0) = 0 and ISNULL(o.IsDeleted,0) = 0 order by o.Id