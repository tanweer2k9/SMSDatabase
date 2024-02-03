
CREATE PROC [dbo].[usp_GetExamHault]

@BrId numeric
AS


select * from Examhault where BrId = @BrId