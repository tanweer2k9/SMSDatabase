CREATE FUNCTION [dbo].[get_advance_accounting] (@BR_ID numeric)
returns  bit

AS BEGIN

declare @is_advance_accounting bit = 0

if (select COUNT(*) from BR_ADMIN where BR_ADM_ID = @BR_ID and BR_ADM_IS_ADVANCE_ACCOUNTING = 1) > 0
BEGIN
	set @is_advance_accounting = 1
END






return @is_advance_accounting


END