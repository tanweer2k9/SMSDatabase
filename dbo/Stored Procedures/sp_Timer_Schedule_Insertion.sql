
CREATE PROC [dbo].[sp_Timer_Schedule_Insertion]

@Type nvarchar(50),
@BrId numeric
AS


insert into Timer_Schedule values (GETDATE(),@Type,@BrId)