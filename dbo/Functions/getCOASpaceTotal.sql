CREATE FUNCTION [dbo].[getCOASpaceTotal] ( @pNoTimesLoop int ,  @space nvarchar(max))
RETURNS nvarchar(max) 
   
AS
BEGIN
   
 declare @count as int 
 
 declare @spaceTotal as nvarchar(200) 

 set @count = 1
 
 set @spaceTotal = ''



 while( @count < @pNoTimesLoop  )
    begin

    set @spaceTotal = @spaceTotal + @space
	set @count = @count + 1
	end

   RETURN @spaceTotal
END