CREATE FUNCTION [dbo].[get_SUBJECT_GRADE_ID] (@grade_name nvarchar(50), @std_id int)
returns int
AS	BEGIN
	--declare @grade_name nvarchar(10) = 'A+'
	--declare @std_id int = 27
	declare @grade_id int
	
	if @grade_name = 'Not Entered'
		set @grade_id = 0
	else if @grade_name = 'Not Taken'
		set @grade_id = 0
	else if @grade_name = 'Absent'
		set @grade_id = 0
	else 
	begin
		select @grade_id = GRADE_ID from GRADE_INFO where GRADE_NAME = @grade_name 
		and GRADE_HD_ID = (select STDNT_HD_ID from STUDENT_INFO where STDNT_ID = @std_id)
		and GRADE_BR_ID = (select STDNT_BR_ID from STUDENT_INFO where STDNT_ID = @std_id)
	end
	return @grade_id

END