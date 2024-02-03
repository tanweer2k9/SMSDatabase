CREATE FUNCTION [dbo].[CSTF] (@value nvarchar(50))
returns float

AS BEGIN

return CAST((@value) as float)

END