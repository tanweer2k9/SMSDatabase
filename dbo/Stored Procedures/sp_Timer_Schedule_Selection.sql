

CREATE PROC [dbo].[sp_Timer_Schedule_Selection]

@Type nvarchar(50),
@BrId numeric
AS


if @Type = 'Daily'
BEGIN
	select * from  Timer_Schedule where CAST(DateTimer as date) = CAST(GETDATE() as date) and [Type] = @Type and BrId = @BrId
END 
ELSE IF @Type = 'Weekly'
BEGIN
	select * from  Timer_Schedule where CAST(DateTimer as date) = CAST(GETDATE() as date) and DATENAME(DW, GETDATE()) = 'Wednesday' and [Type] = @Type and BrId = @BrId
END
ELSE IF @Type = 'Monthly'
BEGIN
		select * from  Timer_Schedule where DATEPART(MM,CAST(DateTimer as date)) =  DATEPART(MM,CAST(GETDATE() as date))  and DATEPART(YYYY,CAST(DateTimer as date)) =   DATEPART(YYYY,CAST(GETDATE() as date)) 
	--and DATEpart(D, GETDATE()) = 1 
	and 
	[Type] = @Type
END