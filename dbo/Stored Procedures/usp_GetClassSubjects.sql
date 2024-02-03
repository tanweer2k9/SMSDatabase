CREATE PROC [dbo].[usp_GetClassSubjects]

@ClassId numeric,
@IsCompulsory bit,
@TermId numeric

AS


select * from dbo.tf_GetClassSubjects(@ClassId,@IsCompulsory,@TermId)