CREATE PROC [dbo].[rpt_REPORTS_HEADER_PRINT]



@CLASS_NAME nvarchar(50),
@TERM_NAME nvarchar(50),
@SESSION nvarchar(50)

AS

select @CLASS_NAME Class, @TERM_NAME Term, @SESSION [Session]