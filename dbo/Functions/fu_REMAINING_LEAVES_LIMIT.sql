

CREATE FUNCTION [dbo].[fu_REMAINING_LEAVES_LIMIT] (@STAFF_ID numeric, @STAFF_SALLERY_DATE date,@STAFF_SALLERY_BR_ID numeric, @Status char )

returns float
AS BEGIN


declare @one int = 1

set @STAFF_SALLERY_DATE = (SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@STAFF_SALLERY_DATE)+1,0)))

declare @remaining_leaves_limit float = 0

declare @leaves_type nvarchar(50) = ''
set @leaves_type = (select TECH_LEAVES_TYPE from TEACHER_INFO where TECH_ID = @STAFF_ID)

if @Status = 'C'--Casusal Leaves
BEGIN
		declare @summer_leaves int = 0
		declare @winter_leaves int = 0
		declare @summer_start_date date = ''
		declare @summer_end_date date = ''
		declare @winter_start_date date = ''
		declare @winter_end_date date = ''
		declare @current_Session int = 0
		declare @count_summer_date int = 0
		declare @count_winter_date int = 0
		
		declare @year int = 0

		set @year = DATEPART(YYYY,@STAFF_SALLERY_DATE)

		

		set @current_Session = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)
		select @summer_leaves = STAFF_LEAVES_SUMMER_LEAVES, @winter_leaves = STAFF_LEAVES_WINTER_LEAVES from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID

		select @summer_start_date = SUM_WIN_SUMMER_START_DATE,@summer_end_date = SUM_WIN_SUMMER_END_DATE,
		@winter_start_date = SUM_WIN_WINTER_START_DATE,@winter_end_date = SUM_WIN_WINTER_END_DATE
		from SUMMER_WINTER_INFO where SUM_WIN_SESSION_ID = @current_Session and SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID

		set @count_summer_date = (select COUNT(*) from SUMMER_WINTER_INFO where @STAFF_SALLERY_DATE between SUM_WIN_SUMMER_START_DATE and SUM_WIN_SUMMER_END_DATE
		and SUM_WIN_SESSION_ID = @current_Session and SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID  )

		set @count_winter_date = (select COUNT(*) from SUMMER_WINTER_INFO where @STAFF_SALLERY_DATE between SUM_WIN_WINTER_START_DATE and SUM_WIN_WINTER_END_DATE
		and SUM_WIN_SESSION_ID = @current_Session and SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID )


		--if @leaves_type = 'Outstation'
		--BEGIN
		--set @remaining_leaves_limit = 
		--		(select STAFF_LEAVES_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID) + (select COUNT(*) from ANNUAL_HOLIDAYS where ANN_HOLI_BR_ID = @STAFF_SALLERY_BR_ID and DATEPART(YYYY,ANN_HOLI_DATE) = @year and ANN_HOLI_STATUS = 'T') - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND DATEPART(YYYY, STAFF_LEAVES_CALC_DATE) = @year )

		--END

		--ELSE
		--BEGIN
		if DATEPART(MM,@STAFF_SALLERY_DATE) = 12
		BEGIN
			set @remaining_leaves_limit = (select ISNULL(STAFF_LEAVES_YEAR,0) from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID )
		END
		ELSE
		BEGIN
			set @remaining_leaves_limit = (select ISNULL(STAFF_LEAVES_CALC_MONTHLY_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID and DATEADD(dd,-(DAY(STAFF_LEAVES_CALC_DATE)-1),STAFF_LEAVES_CALC_DATE) = DATEADD(dd,-(DAY(@STAFF_SALLERY_DATE)-1),@STAFF_SALLERY_DATE)  )
		END
			--if @summer_leaves + @winter_leaves = 0 and @count_summer_date = 0 and @count_winter_date = 0
			--BEGIN

			--set @remaining_leaves_limit = (select ISNULL(STAFF_LEAVES_CALC_MONTHLY_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID and DATEADD(dd,-(DAY(STAFF_LEAVES_CALC_DATE)-1),STAFF_LEAVES_CALC_DATE) = DATEADD(dd,-(DAY(@STAFF_SALLERY_DATE)-1),@STAFF_SALLERY_DATE)  )
			--	--set @remaining_leaves_limit = 
			--	--(select STAFF_LEAVES_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID) - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_DATE <= @STAFF_SALLERY_DATE and STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND STAFF_LEAVES_CALC_DATE between
			--	--(select CASE WHEN @STAFF_SALLERY_DATE< SUM_WIN_SEMESTER1_END_DATE THEN SUM_WIN_SEMESTER1_START_DATE ELSE SUM_WIN_SEMESTER2_START_DATE END from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID and SUM_WIN_SESSION_ID in ( select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID))
			--	--and (select CASE WHEN @STAFF_SALLERY_DATE< SUM_WIN_SEMESTER1_END_DATE THEN SUM_WIN_SEMESTER1_END_DATE ELSE SUM_WIN_SEMESTER2_END_DATE END from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID and SUM_WIN_SESSION_ID in ( select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)))

			--END
			--ELSE
			--BEGIN

			--	if @count_winter_date = 1
			--	BEGIN
			--	set @remaining_leaves_limit = 
			--		@winter_leaves - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_DATE <= @STAFF_SALLERY_DATE and STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND STAFF_LEAVES_CALC_DATE between
			--		@winter_start_date and @winter_end_date)
			--	END
			--	ELSE
			--	BEGIN			
			--		set @remaining_leaves_limit =(select ISNULL(STAFF_LEAVES_CALC_MONTHLY_LIMIT,(select STAFF_LEAVES_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID)) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID and DATEADD(dd,-(DAY(STAFF_LEAVES_CALC_DATE)-1),STAFF_LEAVES_CALC_DATE) = DATEADD(dd,-(DAY(@STAFF_SALLERY_DATE)-1),@STAFF_SALLERY_DATE)  )
			--	--(select STAFF_LEAVES_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID) - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_DATE <= @STAFF_SALLERY_DATE and  STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND STAFF_LEAVES_CALC_DATE between
			--	--(select CASE WHEN @STAFF_SALLERY_DATE< SUM_WIN_SEMESTER1_END_DATE THEN SUM_WIN_SEMESTER1_START_DATE ELSE SUM_WIN_SEMESTER2_START_DATE END from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID and SUM_WIN_SESSION_ID in ( select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID))
			--	--and (select CASE WHEN @STAFF_SALLERY_DATE< SUM_WIN_SEMESTER1_END_DATE THEN SUM_WIN_SEMESTER1_END_DATE ELSE SUM_WIN_SEMESTER2_END_DATE END from SUMMER_WINTER_INFO where SUM_WIN_BR_ID = @STAFF_SALLERY_BR_ID and SUM_WIN_SESSION_ID in ( select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @STAFF_SALLERY_BR_ID)))

			--		--set @remaining_leaves_limit = 
			--		--@winter_leaves + @summer_leaves - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND STAFF_LEAVES_CALC_DATE between
			--		--@winter_start_date and @winter_end_date) - (select ISNULL(SUM(STAFF_LEAVES_CALC_LEAVE + STAFF_LEAVES_CALC_ABSENT),0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID AND STAFF_LEAVES_CALC_DATE between
			--		--@summer_start_date and @summer_end_date)
			--	END
			--END
		--END

END
ELSE IF @Status = 'A'
BEGIN
	declare @deduct_from_next_year nvarchar(50) = ''

	select @deduct_from_next_year = STAFF_LEAVES_TRANSFER_YEAR from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID
	
	if @leaves_type = 'Outstation'
	 BEGIN
		if DATEPART(MM,@STAFF_SALLERY_DATE) = 12
		BEGIN
			if @deduct_from_next_year = 'T'
			BEGIN
			set @remaining_leaves_limit = (select top(@one) ISNULL(STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID order by STAFF_LEAVES_CALC_DATE DESC) + (select ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0) from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID )
			END
			ELSE
			BEGIN
				set @remaining_leaves_limit = (select ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0) from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID )
			END
		END 
		ELSE
		BEGIN
			set @remaining_leaves_limit = (select top(@one) ISNULL(STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID order by STAFF_LEAVES_CALC_DATE DESC)
		END
	 END
	 ELSE
	 if DATEPART(MM,@STAFF_SALLERY_DATE) = 12 --Always one month minus 6 means will be added in july
	 BEGIN
		if @deduct_from_next_year = 'T'
			BEGIN
				set @remaining_leaves_limit = (select top(@one) ISNULL(STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID order by STAFF_LEAVES_CALC_DATE DESC) + (select ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0) from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID )
			END
			ELSE
			BEGIN
				set @remaining_leaves_limit = (select ISNULL(STAFF_LEAVES_SUMMER_LEAVES,0) + ISNULL(STAFF_LEAVES_WINTER_LEAVES,0) from STAFF_LEAVES where STAFF_LEAVES_STAFF_ID = @STAFF_ID )
			END
		
	 END
	 ELSE
	 BEGIN
	 	set @remaining_leaves_limit = (select top(@one) ISNULL(STAFF_LEAVES_CALC_ANNUAL_LEAVES_LIMIT,0) from STAFF_LEAVES_CALC where STAFF_LEAVES_CALC_STAFF_ID = @STAFF_ID order by STAFF_LEAVES_CALC_DATE DESC)
	END
END

return @remaining_leaves_limit

END