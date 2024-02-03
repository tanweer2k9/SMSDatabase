CREATE FUNCTION [dbo].[fn_Get_Bill_No] (@StartDate date,@EndDate date, @SchoolID nvarchar(10))

returns nvarchar(10)

AS
BEGIN
declare @BillNo nvarchar(10) = ''
	select @BillNo =  (CASE WHEN DATEPART(MONTH,@StartDate) = DATEPART(MONTH,@EndDate) THEN right('00' + CAST(DATEPART(MONTH,@StartDate) as nvarchar(2)),2) + '00'+ CAST(RIGHT(@SchoolID, 3) as nvarchar(10)) ELSE right('00' +CAST(DATEPART(MONTH,@StartDate) as nvarchar(2)),2) + right('00' +CAST(DATEPART(MONTH,@EndDate) as nvarchar(2)),2) + CAST(RIGHT(@SchoolID, 3) as nvarchar(10)) END)



return @BillNo

END