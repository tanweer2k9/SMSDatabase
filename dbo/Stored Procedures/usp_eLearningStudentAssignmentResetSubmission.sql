
CREATE PROC usp_eLearningStudentAssignmentResetSubmission

@SubmitId numeric

AS
--declare @SubmitId numeric = 14148


select * from eLearningAssignmentsSubmitChild where PId = @SubmitId

delete from eLearningAssignmentsSubmitChild where PId = @SubmitId
delete from eLearningAssignmentsSubmitParent where Id = @SubmitId