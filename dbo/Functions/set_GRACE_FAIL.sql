CREATE FUNCTION [dbo].[set_GRACE_FAIL](@count int, @status char(1))
returns nvarchar(20)
AS BEGIN
--declare @count int = 3
--declare @status char(1)=''

declare @i int = 1
declare @chars nvarchar(10) = ''

	WHILE @i <= @count
	BEGIN
		if @status = 'G'
			set @chars = @chars + '*'
		else
			set @chars = @chars + '^'
		
		set @i = @i + 1
	END
return @chars

END