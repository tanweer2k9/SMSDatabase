CREATE FUNCTION [dbo].[CFTS] (@value float)
returns nvarchar(50)

AS BEGIN

return CAST((@value) as nvarchar(50))

END