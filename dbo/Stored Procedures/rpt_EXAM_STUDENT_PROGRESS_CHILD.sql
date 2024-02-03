CREATE PROC [dbo].[rpt_EXAM_STUDENT_PROGRESS_CHILD]
@dt_child dbo.[type_EXAM_PROGRESS_REPORT_CHILD_TABLE] readonly
AS

--select 0
select * from @dt_child