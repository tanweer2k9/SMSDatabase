CREATE FUNCTION [dbo].[tf_GET_ALL_WEEKENDS_DATES] (@STAFF_ID numeric, @FROM_DATE datetime, @TO_DATE  datetime)
returns @tbl table (AllDates Datetime)

AS
BEGIN
insert into @tbl
	select all_days from (SELECT  CONVERT(date,@FROM_DATE+number) as all_days
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@FROM_DATE,@TO_DATE) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@FROM_DATE+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @STAFF_ID and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
					)A

return

END