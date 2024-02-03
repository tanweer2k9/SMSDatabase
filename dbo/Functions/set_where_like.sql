CREATE function [dbo].[set_where_like]( @id numeric)
returns nvarchar(50)

as
	begin
	declare @name nvarchar(50) = ''

	if @id = 0
		begin
			set @name = '%'
		end
		
	else
		begin
			set @name = CONVERT(nvarchar(50), @id)
		end
			
			return(@name);
	end