CREATE PROC usp_GetAssessmentTestQuestion

@TestInfoId numeric

as


select q.Id, q.Question, q.Marks, t.Name QuestionType  from eLearningAssessmentQuestions q
join eLearningAssessmentQuestionType t on q.QuestionTypeId = t.Id
where q.AssesmentTestInfoId = @TestInfoId and ISNULL(IsDeleted,0) = 0