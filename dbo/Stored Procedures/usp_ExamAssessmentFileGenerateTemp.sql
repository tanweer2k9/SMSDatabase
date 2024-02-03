CREATE PROC [dbo].[usp_ExamAssessmentFileGenerateTemp]


AS



select EXAM_STD_CLASS_ID ClassId, EXAM_STD_INFO_STD_ID StdId, EXAM_STD_PID TitleId, p.Title, st.STDNT_SCHOOL_ID SchoolId, st.STDNT_FIRST_NAME StudentName
from EXAM_STD_INFO e
join EXAM_CRITERIA_KEY_Parent p on p.Id = e.EXAM_STD_PID
join STUDENT_INFO st on st.STDNT_ID = e.EXAM_STD_INFO_STD_ID

where EXAM_STD_PID >= 93 and BrId = 11