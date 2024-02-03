


     CREATE procedure  [dbo].[sp_MANUAL_SALARY_insertion]
                                               
                                               
          @MANUAL_SALARY_HD_ID  numeric,
          @MANUAL_SALARY_BR_ID  numeric,
          @MANUL_SALARY_MONTH_YEAR  date,
          @EMPLOYEE_IDS nvarchar(max)
   
   
     as  begin

		
	delete from MANUAL_SALARY  where DATEPART(MM,MANUL_SALARY_MONTH_YEAR) = DATEPART(MM,@MANUL_SALARY_MONTH_YEAR) and DATEPART(YYYY,MANUL_SALARY_MONTH_YEAR) = DATEPART(YYYY,@MANUL_SALARY_MONTH_YEAR) and MANUAL_SALARY_BR_ID = @MANUAL_SALARY_BR_ID

	 declare @table table (sr int, [values] nvarchar(50))
   
   insert into @table
   select id,val from dbo.split(@EMPLOYEE_IDS,',') where val != ''

  declare @count int = 0
	declare @i int = 1
	declare @val nvarchar(50) = ''
	declare @IEntry nvarchar(200) = ''
	declare @staff_days float = 0, @staff_id numeric = 0

	set @count = (select COUNT(*) from @table)
	WHILE @i<= @count
	BEGIN
		select @IEntry = [values] from @table where sr = @i
		
		set @staff_days = CAST(SUBSTRING(@IEntry,CHARINDEX(':',@IEntry) + 1, LEN(@IEntry) )as float)
		set @staff_id = CAST(SUBSTRING(@IEntry,1,CHARINDEX(':',@IEntry) - 1) as numeric)


	
		 insert into MANUAL_SALARY
     values
     (
        @MANUAL_SALARY_HD_ID,
        @MANUAL_SALARY_BR_ID,
        @MANUL_SALARY_MONTH_YEAR,
        @staff_id,
        @staff_days,
        NULL   
     
     )
	set @i = @i + 1
	END
   
	 --WHILE LEN(@EMPLOYEE_IDS) >0
	 --BEGIN
		--declare @IEntry nvarchar(200) = ''
		--IF CHARINDEX(',', @EMPLOYEE_IDS) > 0
		--BEGIN
		--	set @IEntry = SUBSTRING(@EMPLOYEE_IDS,0,CHARINDEX(',',@EMPLOYEE_IDS))
		--END
		--ELSE
		--BEGIN
		--	set @IEntry = @EMPLOYEE_IDS
		--	set @EMPLOYEE_IDS = ''
		--END

		--declare @hold_days nvarchar(100) = ''
		--set @hold_days = SUBSTRING(@IEntry,CHARINDEX(':',@IEntry) + 1, LEN(@IEntry) )
		--if @hold_days <> '' OR LEN(@hold_days) > 0
		--BEGIN
		--	declare @staff_days float = 0, @staff_id numeric = 0, @staff_is_paid bit = 0
		--	set @staff_days = CAST(@hold_days as float)
		--	set @staff_id = CAST(SUBSTRING(@IEntry,1,CHARINDEX(':',@IEntry) - 1) as numeric)
		--	--set @staff_is_paid = CAST(SUBSTRING(@IEntry,CHARINDEX('~',@IEntry) +1,LEN(@IEntry) - 1)  as bit)
			
			

		--	 insert into MANUAL_SALARY
  --   values
  --   (
  --      @MANUAL_SALARY_HD_ID,
  --      @MANUAL_SALARY_BR_ID,
  --      @MANUL_SALARY_MONTH_YEAR,
  --      @staff_id,
  --      @staff_days,
  --      NULL   
     
  --   )
			

		--END
		--set @EMPLOYEE_IDS = REPLACE(@EMPLOYEE_IDS,@IEntry + ',','')
		--END

   
    
     
end