CREATE PROC usp_ExamAssessmentFilesDeletion


@ParentKeyId numeric,
@StdId numeric

AS



update ExamAssessmentFilesPath set IsDeleted = 1  where ParentKeyId = @ParentKeyId and StdId =@StdId