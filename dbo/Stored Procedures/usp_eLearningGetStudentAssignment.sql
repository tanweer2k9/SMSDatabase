

CREATE PROC [dbo].[usp_eLearningGetStudentAssignment]

@AssignmnetId numeric

AS

--declare @AssignmnetId numeric = 1




select  ROW_NUMBER() over( order by ISNULL(p.UpdatedDate,p.CreatedDate) ) as SerialNo,p.Id SubmitId ,s.STDNT_FIRST_NAME StudentName, s.STDNT_SCHOOL_ID StudentSchoolId, s.STDNT_IMG StudentImage ,p.Description, ISNULL(p.UpdatedDate,p.CreatedDate) DateTime, ISNULL(p.ObtainMarks,0) ObtainMarks, ISNULL(p.Remarks,'') Remarks from eLearningAssignmentsSubmitParent p
join STUDENT_INFO s on s.STDNT_ID = p.StudentId


where p.AssignmentId = @AssignmnetId