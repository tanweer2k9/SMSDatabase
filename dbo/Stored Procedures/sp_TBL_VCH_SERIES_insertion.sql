CREATE PROC [dbo].[sp_TBL_VCH_SERIES_insertion]

                                     
        @VCH_SERIES_HD_ID  numeric,
          @VCH_SERIES_BR_ID  numeric,
          @VCH_SERIES_VCH_MAIN_ID  nvarchar(50) ,
          @VCH_SERIES_VCH_PREFIX  nvarchar(50) ,
          @VCH_SERIES_BANK_CODE  nvarchar(50) ,
          @VCH_SERIES_DEF_COA  nvarchar(50) ,
          @VCH_SERIES_NUMBER  int,
          @VCH_SERIES_VOUCHER_SERIES  nvarchar(50) ,
          @VCH_SERIES_DATE  date
		 


AS


declare @count int = (select COUNT(*) from TBL_VCH_SERIES where VCH_SERIES_VCH_MAIN_ID = @VCH_SERIES_VCH_MAIN_ID and VCH_SERIES_BR_ID = @VCH_SERIES_BR_ID) 

if @count = 0
BEGIN
	declare @bank_name nvarchar(50)= '' 
	declare @date_count int = 0
	select @bank_name = COA_Name from TBL_COA where COA_UID = @VCH_SERIES_DEF_COA  and BRC_ID = @VCH_SERIES_BR_ID and COA_isDeleted = 0 and COA_PARENTID in (  select COA_UID from TBL_COA where COA_Name = 'Cash at Bank' and BRC_ID = @VCH_SERIES_BR_ID and COA_isDeleted = 0)

	set @bank_name = ISNULL(@bank_name, '')

	if @bank_name != ''
	BEGIN
	if @bank_name = 'Allied Bank Limited'
		set @VCH_SERIES_BANK_CODE = 'ABL'
	else if @bank_name = 'MCB Bank Limited'
		set @VCH_SERIES_BANK_CODE = 'MCB'
	else if @bank_name = 'Faysal Bank Limited'
		set @VCH_SERIES_BANK_CODE = 'FBL'
	else if @bank_name = 'Soneri Bank limited'
		set @VCH_SERIES_BANK_CODE = 'SBL'
		
	 
	 --set @date_count = (select COUNT(*) from TBL_VCH_SERIES where VCH_SERIES_DATE > @VCH_SERIES_DATE and VCH_SERIES_BR_ID = @VCH_SERIES_BR_ID and VCH_SERIES_BANK_CODE  = @VCH_SERIES_BANK_CODE and VCH_SERIES_VCH_PREFIX = @VCH_SERIES_VCH_PREFIX)

	 --if @date_count = 0
	 --BEGIN

		declare @max_no int = 0

		 set @max_no = (select MAX(VCH_SERIES_NUMBER) from TBL_VCH_SERIES where DATEPART(MM,VCH_SERIES_DATE) = DATEPART(MM,@VCH_SERIES_DATE) and VCH_SERIES_BR_ID = @VCH_SERIES_BR_ID and VCH_SERIES_BANK_CODE  = @VCH_SERIES_BANK_CODE and VCH_SERIES_VCH_PREFIX = @VCH_SERIES_VCH_PREFIX)

		 set @max_no = ISNULL(@max_no,0)

		 set @VCH_SERIES_NUMBER = @max_no + 1
		 set @VCH_SERIES_VOUCHER_SERIES = @VCH_SERIES_BANK_CODE + '-'+ CAST(@VCH_SERIES_NUMBER as nvarchar(10))

	 
			insert into TBL_VCH_SERIES
			 values
			 (
				@VCH_SERIES_HD_ID,
				@VCH_SERIES_BR_ID,
				@VCH_SERIES_VCH_MAIN_ID,
				@VCH_SERIES_VCH_PREFIX,
				@VCH_SERIES_BANK_CODE,
				@VCH_SERIES_DEF_COA,
				@VCH_SERIES_NUMBER,
				@VCH_SERIES_VOUCHER_SERIES,
				@VCH_SERIES_DATE
     
     
			 )
	--		 select 'ok'
	--END
	--ELSE
	--BEGIN
	--	select 'date of voucher can no tbe less than ' + CONVERT(VARCHAR(10),GETDATE(),110)+ ' date. Please select another date!!!!'
	--END
	END
END