CREATE FUNCTION [dbo].[F1] ( @pNoTimesLoop int)
RETURNS nvarchar(200) 
   
AS
BEGIN
   
 declare @space as nvarchar(200)

set @space = 'U'

   RETURN @space
END