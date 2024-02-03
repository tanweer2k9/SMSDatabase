CREATE FUNCTION [dbo].[CHECK_TOTAL_HOURS] (@time_consumed datetime, @minutes_to_compare int)
RETURNS datetime


AS 
BEGIN

--declare @time_consumed datetime = '1900-01-01 05:30:06'
--declare @minutes_to_compare int  = 40


if @minutes_to_compare	!= 0
BEGIN

declare @overtime_after_time_out_hours float = CONVERT(float, DATEDIFF(SECOND, 0, @time_consumed)) /3600
							declare @overtime_decimal_hours float = @overtime_after_time_out_hours - FLOOR(@overtime_after_time_out_hours)
							if (@overtime_decimal_hours * 60) >= @minutes_to_compare
							BEGIN
								set @time_consumed = DATEADD(s,((FLOOR(@overtime_after_time_out_hours) + 1)*3600),'1900-01-01')
							END
							ELSE
								set @time_consumed = DATEADD(s,((FLOOR(@overtime_after_time_out_hours))*3600),'1900-01-01')
END

return @time_consumed

END