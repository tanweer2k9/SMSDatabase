
CREATE FUNCTION [dbo].[Get_working_days](@statff_id numeric ,@staff_date date, @To_Date date  = '1900-01-01') RETURNS int
AS
BEGIN
--declare @statff_id int = 3
--declare @staff_date date = '2013-04-01'
declare @weekend_status char(1)		
		DECLARE @d1 DATETIME, @d2 DATETIME
		declare @days int = 0

		if @TO_Date = '1900-01-01'
		BEGIN
			SELECT @d1 = (SELECT DATEADD(mm, DATEDIFF(mm,0,@staff_date), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@staff_date)+1,0)) )
			set @TO_Date = @d2
			set @staff_date = @d1
		END
		ELSE
		BEGIN
			SELECT @d1 = (select DATEADD(dd, DATEDIFF(dd,0,@staff_date), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(dd, DATEDIFF(dd,0,@TO_Date)+1,0)) )
		END

	set @weekend_status = (select ISNULL (STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS,'T') from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @statff_id)
	if @weekend_status = 'T'
	begin
	set @days = DATEDIFF(d,@d1,@d2) +1
			
	end
	else
	begin
	set @days = ( SELECT COUNT( @d1+number)	 
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					--and (@d1 + number) in (select distinct ATTENDANCE_STAFF_DATE from ATTENDANCE_STAFF) 
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @statff_id and STAFF_WORKING_DAYS_DAY_STATUS = 'T')					
			)
	if @days = 0
	
	set @days = ( SELECT COUNT( @d1+number)	 
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number
					AND DATENAME(w,@d1+number) in (select WORKING_DAYS_NAME from WORKING_DAYS where WORKING_DAYS_VALUE = 1)					
			)
	end

	set @days = @days - (select COUNT(*) from ANNUAL_HOLIDAYS 
														where ANN_HOLI_DATE between @staff_date and @To_Date
														and ANN_HOLI_BR_ID = (select top(1) TECH_BR_ID from TEACHER_INFO where TECH_ID = @statff_id) and  ANN_HOLI_STATUS = 'T'
														and DATENAME(w,ANN_HOLI_DATE) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @statff_id and STAFF_WORKING_DAYS_DAY_STATUS = 'T')	)

														declare @days_minus_due_to_summer_winter int = 0

														--if DATEPART(MONTH,@staff_date) = 1
														--BEGIN
														--	if (select COUNT(*) from TEACHER_INFO where TECH_DESIGNATION like '%teacher%' and TECH_ID = @statff_id) = 1
														
														--	--set @days_minus_due_to_summer_winter = 3

														--	set @days = @days  (select COUNT(*) from ATTENDANCE_STAFF where ATTENDANCE_STAFF_TYPE_ID = @statff_id and ATTENDANCE_STAFF_DATE = '2017-01-04')
														--END
return @days

END