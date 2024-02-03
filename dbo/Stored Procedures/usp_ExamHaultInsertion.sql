
CREATE PROC [dbo].[usp_ExamHaultInsertion]

@BrId numeric,
@IsAssessmentExamShow bit,
@IsRegularExamShow bit

AS

declare @Id int = 0

select top(1) @Id = Id from Examhault where BrId = @BrId

set @Id = ISNULL(@Id,0)



if @Id = 0
BEGIN
      insert into Examhault 
	  select @BrId,@IsAssessmentExamShow,@IsRegularExamShow
END

ELSE
BEGIN
update Examhault set IsAssessmentExamShow = @IsAssessmentExamShow,IsRegularExamShow = @IsRegularExamShow  where BrId = @BrId 

END