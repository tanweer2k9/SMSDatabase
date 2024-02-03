
CREATE FUNCTION [dbo].[GET_ALL_VACATION_DATES] (@HD_ID numeric, @BR_ID numeric, @FROM_DATE date, @TO_DATE date)

returns @tbl table (VacationDate date)

as begin



declare @tbl_vacation table (Date date)
declare @teacher_vacation_from_date date = ''
declare @teacher_vacation_to_date date = ''

declare @count_vacation int = 0
declare @i int = 1

set @count_vacation = (

select COUNT(*) from TEACHER_VACATION where TEACHER_VACATION_HD_ID = @HD_ID and TEACHER_VACATION_BR_ID = @BR_ID and  TEACHER_VACATION_FROM_DATE <= @TO_DATE AND TEACHER_VACATION_TO_DATE >= @FROM_DATE)


WHILE @i<=@count_vacation
BEGIN
	select @teacher_vacation_from_date = TEACHER_VACATION_FROM_DATE, @teacher_vacation_to_date = TEACHER_VACATION_TO_DATE from (select ROW_NUMBER() over (order by (select 0)) as sr, TEACHER_VACATION_FROM_DATE, TEACHER_VACATION_TO_DATE from TEACHER_VACATION where TEACHER_VACATION_HD_ID = @HD_ID and TEACHER_VACATION_BR_ID = @BR_ID and  TEACHER_VACATION_FROM_DATE <= @TO_DATE AND TEACHER_VACATION_TO_DATE >= @FROM_DATE)A where sr = 1


	insert into @tbl
	select * from
	(SELECT  TOP (DATEDIFF(DAY, @teacher_vacation_from_date, @teacher_vacation_to_date) + 1)
	Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @teacher_vacation_from_date)
	FROM    sys.all_objects a
    CROSS JOIN sys.all_objects b
	)A where A.Date between @FROM_Date AND @TO_DATE
	set @i = @i + 1
END



return
END