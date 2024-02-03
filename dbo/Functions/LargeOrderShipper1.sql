CREATE FUNCTION [dbo].[LargeOrderShipper1] ( @pNoTimesLoop int)
RETURNS nvarchar 
   
AS
BEGIN
   
 declare @space as nvarchar(200)

set @space = 'U'

   RETURN @space
END