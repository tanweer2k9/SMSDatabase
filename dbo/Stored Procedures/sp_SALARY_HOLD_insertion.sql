


CREATE PROC [dbo].[sp_SALARY_HOLD_insertion]

		@HD_ID  numeric,
          @BR_ID  numeric,
          @DATE  date,
          @EMPLOYEE_IDS  nvarchar(MAX),
		  @DAYS  nvarchar(MAX)


		  AS

	declare @id numeric = 0

	select @id = s.ID from SALARY_HOLD s where s.HD_ID = @HD_ID
and s.BR_ID in ( select [BR ID] from [dbo].[get_centralized_br_id]('S', @BR_ID)) and DATEPART(MM,[DATE]) = DATEPART(MM,@DATE) and DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@DATE)

	set @id = ISNULL(@id,0)

	if @id = 0
	BEGIN
		insert into SALARY_HOLD
		 values
		 (
			@HD_ID,
			@BR_ID,
			@DATE,
			@EMPLOYEE_IDS
		 )

	 END

	 ELSE
	 BEGIN
		
		update SALARY_HOLD 
     set
         
          EMPLOYEE_IDS =  @EMPLOYEE_IDS
 
     where 
          ID =  @id

	 END

	 delete from SALARY_HOLD_DAYS where DATEPART(MM,[DATE]) = DATEPART(MM,@DATE) AND DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@DATE)


	 ---Inserting Days
	 WHILE LEN(@DAYS) >0
	 BEGIN
		declare @IEntry nvarchar(200) = ''
		IF CHARINDEX(',', @DAYS) > 0
		BEGIN
			set @IEntry = SUBSTRING(@DAYS,0,CHARINDEX(',',@DAYS))
		END
		ELSE
		BEGIN
			set @IEntry = @DAYS
			set @DAYS = ''
		END

		declare @hold_days nvarchar(100) = ''
		set @hold_days = SUBSTRING(@IEntry,CHARINDEX(':',@IEntry) + 1, CHARINDEX('~',@IEntry) - CHARINDEX(':',@IEntry) - 1 )
		if @hold_days <> '' OR LEN(@hold_days) > 0
		BEGIN
			declare @staff_days numeric = 0, @staff_id numeric = 0, @staff_is_paid bit = 0
			set @staff_days = CAST(@hold_days as numeric)
			set @staff_id = CAST(SUBSTRING(@IEntry,1,CHARINDEX(':',@IEntry) - 1) as numeric)
			set @staff_is_paid = CAST(SUBSTRING(@IEntry,CHARINDEX('~',@IEntry) +1,LEN(@IEntry) - 1)  as bit)
			declare @salary_hold_days_id numeric = 0
			--set @salary_hold_days_id = (select ID from Salary_Hold_DAYS where DATEPART(MM,[DATE]) = DATEPART(MM,@DATE) AND DATEPART(YYYY,[DATE]) = DATEPART(YYYY,@DATE) and STAFF_ID = @staff_id)

			--set @salary_hold_days_id = ISNULL(@salary_hold_days_id,0)

			insert into SALARY_HOLD_DAYS VALUES (@staff_id,@DATE,@staff_days,@staff_is_paid)
			--if @salary_hold_days_id = 0
			--BEGIN
			--	insert into SALARY_HOLD_DAYS VALUES (@staff_id,@DATE,@staff_days,@staff_is_paid)
			--END
			--ELSE
			--BEGIN
			--	update SALARY_HOLD_DAYS set DAYS = @staff_days, IS_PAID = @staff_is_paid where  ID = @salary_hold_days_id
			--END

		END
		set @DAYS = REPLACE(@DAYS,@IEntry + ',','')
	 END