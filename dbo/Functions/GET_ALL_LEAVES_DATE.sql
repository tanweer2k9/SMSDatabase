
CREATE FUNCTION [dbo].[GET_ALL_LEAVES_DATE] (@STAFF_SALLERY_STAFF_ID numeric, @STAFF_SALLERY_DATE date)
returns @tbl table (Dates date)

AS
BEGIN

declare @tbl_dates table (Sr int identity(1,1),FromDate date, ToDate date)

insert into @tbl_dates
select CASE WHEN NOT (DATEPART(MM, LEAVES_RECORD_FROM_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, LEAVES_RECORD_FROM_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)) THEN DATEADD(m, DATEDIFF(m, 0, @STAFF_SALLERY_DATE), 0) ELSE LEAVES_RECORD_FROM_DATE END LEAVES_RECORD_FROM_DATE ,
CASE WHEN NOT (DATEPART(MM, LEAVES_RECORD_TO_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, LEAVES_RECORD_TO_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)) THEN dateadd(s,-1,dateadd(mm,datediff(m,0,@STAFF_SALLERY_DATE)+1,0)) ELSE LEAVES_RECORD_TO_DATE END LEAVES_RECORD_TO_DATE from LEAVES_RECORD where LEAVES_RECORD_STAFF_ID = @STAFF_SALLERY_STAFF_ID and ((DATEPART(MM, LEAVES_RECORD_FROM_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, LEAVES_RECORD_FROM_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)) OR 
								(DATEPART(MM, LEAVES_RECORD_TO_DATE) = DATEPART(MM, @STAFF_SALLERY_DATE) and DATEPART(YYYY, LEAVES_RECORD_TO_DATE) = DATEPART(YYYY, @STAFF_SALLERY_DATE)))



declare @count int = 0
declare @i int = 0
set @count = (select COUNT(*) from @tbl_dates)

declare @from_date date, @to_date date

WHILE @i <= @count
BEGIN
	select @from_date = FromDate,@to_date = ToDate from @tbl_dates where sr = @i

	insert into @tbl
	SELECT
	DATEADD(day, [v].[number], @from_date)
	FROM
	[master].[dbo].[spt_values] [v]
	WHERE
	[v].[type] = 'P' AND
	DATEADD(day, [v].[number], @from_date) <= @to_date

	set @i = @i + 1
END	


return
END