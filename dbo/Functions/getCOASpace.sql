CREATE FUNCTION [dbo].[getCOASpace] ( @pNoTimesLoop int ,  @space nvarchar(max))
RETURNS nvarchar(max) 
   
AS
BEGIN
   
 declare @count as int 
 
 declare @spaceTotal as nvarchar(200) 

 set @count = 1
 
 set @spaceTotal = ''



 while( @count < @pNoTimesLoop - 1 )
    set @spaceTotal = @spaceTotal + @space

   RETURN @spaceTotal
END