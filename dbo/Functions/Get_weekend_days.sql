CREATE FUNCTION [dbo].[Get_weekend_days](@statff_id numeric ,@staff_date date) RETURNS int
AS
BEGIN
--declare @statff_id int = 3
--declare @staff_date date = '2013-04-01'
declare @weekend_status char(1)		
		DECLARE @d1 DATETIME, @d2 DATETIME
		declare @days int = 0
		SELECT @d1 = (SELECT DATEADD(mm, DATEDIFF(mm,0,@staff_date), 0) ) , @d2= ( SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@staff_date)+1,0)) )

	set @weekend_status = (select ISNULL (STAFF_LEAVES_ADD_WEEKEND_HOLIDAYS,'T') from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @statff_id)
	if @weekend_status = 'T'
	begin
		set @days = ( SELECT COUNT( @d1+number)	 
				FROM master..spt_values 
				WHERE TYPE ='p'
					AND DATEDIFF(d,@d1,@d2) >= number					
					AND DATENAME(w,@d1+number) in (select STAFF_WORKING_DAYS_NAME from STAFF_WORKING_DAYS where STAFF_WORKING_DAYS_STAFF_ID = @statff_id and STAFF_WORKING_DAYS_DAY_STATUS = 'F')
			)
	end

return @days

END