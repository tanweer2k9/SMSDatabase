CREATE FUNCTION [dbo].[get_SUBJECT_GRADE_NAME] (@grade_id nvarchar(50))
returns nvarchar(50)
AS	BEGIN
	
	--declare @grade_id float = 3.1
	declare @grade_name nvarchar(50) = ''
	
		if 	@grade_id LIKE '%[0-9]%'
		begin
			select @grade_name = GRADE_NAME from GRADE_INFO where GRADE_ID = CAST(ROUND(CAST((@grade_id) as float), 0) AS int)
		end
		else
			set @grade_name =  '0'
		
	return @grade_name

END