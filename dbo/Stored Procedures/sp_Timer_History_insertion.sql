CREATE PROC [dbo].[sp_Timer_History_insertion]


AS


insert into TimerHistory values (GETDATE())