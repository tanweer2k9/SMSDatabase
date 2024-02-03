CREATE PROC usp_elearningAssessmentViewStudentTest

@TestInfoId numeric
AS
--declare @TestInfoId numeric = 0



select s.STDNT_FIRST_NAME StudentName, s.STDNT_ID StudentId,s.STDNT_SCHOOL_ID StudentNo,Format(p.StartTime, 'dd MMMM yyyy, hh:mm:ss tt') StartTime, t.TotalMarks, ISNULL(p.ObtainMarks,0) ObtainMarks from eLearningAssessmentStudentAnswerParent p
join STUDENT_INFO s on s.STDNT_ID = p.StudentId
join eLearningAssessmentTestInfo t on t.Id = p.TestInfoId

where TestInfoId =@TestInfoId