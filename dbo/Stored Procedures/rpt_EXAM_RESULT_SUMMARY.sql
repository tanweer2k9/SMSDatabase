CREATE proc [dbo].[rpt_EXAM_RESULT_SUMMARY]
@SUBJECT type_EXAM_RESULT_SUMMARY READONLY,
@CLASS_ID int

AS 
BEGIN
--select 0	

	--select ID,Subject, [T Std], Appear,Pass,Fail,[first std], [second std],[third std],[%age], case when Grade = 'Y' then dbo.get_GRADE_NAME(@CLASS_ID, [%age]) else Grade END as Grade from @SUBJECT a
select ID,Subject, [T Std], Appear,Pass,Fail,[first std], [second std],[third std],[%age], Grade from @SUBJECT a
END