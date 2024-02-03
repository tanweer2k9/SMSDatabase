

CREATE FUNCTION [dbo].[tf_Get_All_Working_Days] (@STAFF_ID numeric, @early_minutes int, @FROM_DATE datetime ,@TO_DATE datetime,@HD_ID numeric ,@BR_ID numeric , @is_vacation_allowed bit)
Returns @tbl table (Dates Date)

as 
BEGIN
--declare @STAFF_ID numeric = 70175, @early_minutes int = 10, @FROM_DATE datetime = '2018-04-01',@TO_DATE datetime= '2018-04-20',@HD_ID numeric = 1,@BR_ID numeric = 1, @is_vacation_allowed bit = 1


				insert into @tbl

				SELECT  TOP (DATEDIFF(DAY, @FROM_DATE, @TO_DATE) + 1)
					Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @FROM_DATE)
					FROM    sys.all_objects a
					CROSS JOIN sys.all_objects b
				
				except
				
				select ANN_HOLI_DATE from ANNUAL_HOLIDAYS where ANN_HOLI_DATE between @FROM_DATE and @TO_DATE and ANN_HOLI_BR_ID = @BR_ID
				
				except 

				select all_days from (SELECT  CONVERT(date,@FROM_DATE+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
				AND DATEDIFF(d,@FROM_DATE,@TO_DATE) >= number					 
				AND DATENAME(w,@FROM_DATE+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F'))A

				except

				select VacationDate from dbo.GET_ALL_VACATION_DATES (@HD_ID,@BR_ID,CAST(@FROM_DATE as date),CAST(@TO_DATE as date)) where VacationDate = CASE WHEN @is_vacation_allowed = 1 THEN VacationDate ELSE  '1900-01-01' END

				except

				select eh.DATE from EXTRA_HOLIDAYS eh
				join EXTRA_HOLIDAYS_PARENT p on p.ID = eh.PID and eh.STAFF_ID = @STAFF_ID and eh.DATE between @FROM_DATE and @TO_DATE and p.DAY_TYPE = 'Holiday'

				union

				select eh.DATE from EXTRA_HOLIDAYS eh
				join EXTRA_HOLIDAYS_PARENT p on p.ID = eh.PID and eh.STAFF_ID = @STAFF_ID and eh.DATE between @FROM_DATE and @TO_DATE and p.DAY_TYPE = 'WorkingDay'
	
	return
	END