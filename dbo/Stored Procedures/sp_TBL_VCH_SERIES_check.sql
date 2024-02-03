CREATE PROC [dbo].[sp_TBL_VCH_SERIES_check]

		 
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
		select @bank_name = COA_Name from TBL_COA where COA_UID = @VCH_SERIES_DEF_COA  and BRC_ID = @VCH_SERIES_BR_ID and COA_isDeleted = 0

		if @bank_name = 'Allied Bank Limited'
			set @VCH_SERIES_BANK_CODE = 'ABL'
		else if @bank_name = 'MCB Bank Limited'
			set @VCH_SERIES_BANK_CODE = 'MCB'
		else if @bank_name = 'Faysal Bank Limited'
			set @VCH_SERIES_BANK_CODE = 'FBL'
		else if @bank_name = 'Soneri Bank limited'
			set @VCH_SERIES_BANK_CODE = 'SBL'

	 set @date_count = (select COUNT(*) from TBL_VCH_SERIES where VCH_SERIES_DATE > @VCH_SERIES_DATE and VCH_SERIES_BR_ID = @VCH_SERIES_BR_ID and VCH_SERIES_BANK_CODE  = @VCH_SERIES_BANK_CODE and VCH_SERIES_VCH_PREFIX = @VCH_SERIES_VCH_PREFIX)

	 declare @date date = (select max (VCH_SERIES_DATE) from TBL_VCH_SERIES where VCH_SERIES_BR_ID = @VCH_SERIES_BR_ID and VCH_SERIES_BANK_CODE  = @VCH_SERIES_BANK_CODE and VCH_SERIES_VCH_PREFIX = @VCH_SERIES_VCH_PREFIX)
		
		set @date = ISNULL(@date,'2017-01-01')


	  if @date_count = 0
		 BEGIN
			select 'ok'
		 END
		 ELSE
		 BEGIN
			select 'date of voucher can no tbe less than ' + CONVERT(VARCHAR(10),@date,105)+ ' date. Please select another date!!!!'
		 END
END
ELSE
BEGIN
	select 'ok'
END