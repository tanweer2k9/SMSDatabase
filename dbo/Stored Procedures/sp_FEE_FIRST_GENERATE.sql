CREATE PROC [dbo].[sp_FEE_FIRST_GENERATE]

@STATUS nvarchar(50),
@STD_ID numeric


AS
	declare @DEFINITION_HD_ID  numeric
    declare @DEFINITION_BR_ID  numeric
    declare @HD_ID nvarchar(50) = ''
    declare @BR_ID nvarchar(50) = ''
    select @DEFINITION_HD_ID = STDNT_HD_ID , @DEFINITION_BR_ID= STDNT_BR_ID from STUDENT_INFO where STDNT_ID = @STD_ID      
   set @HD_ID = CAST((@DEFINITION_HD_ID) as nvarchar(50))
   set @BR_ID = CAST((@DEFINITION_BR_ID) as nvarchar(50))

	if @STATUS = 'Fee Plan'
	BEGIN		
		 select * from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID		 
	END
	else if @STATUS = 'Fee Generate'
	BEGIN
		 select * from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID
		 select * from TBL_DEFAULT_ACCT where DEFAULT_ACCT_KEY = 'Fees' and CMP_ID = @HD_ID and BRC_ID = @BR_ID
		 --declare @account_code nvarchar(50) = ''
		 --declare @coa_fee_count int = 0
		 --declare @fee_count int = 0
		 --select @account_code = COA_UID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Fees' and COA_isDeleted = 0
		 --select @coa_fee_count = COUNT(*) from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_PARENTID = @account_code and COA_isDeleted = 0
		 --select @fee_count = COUNT(*) from VFEE_INFO where [Institute ID] = @DEFINITION_HD_ID and [Branch ID] = @DEFINITION_BR_ID and [Status] = 'T'
		 --if @coa_fee_count = @fee
	END

	else if @STATUS = 'Fee Collect'
	BEGIN
		 select * from FEE_COLLECT where FEE_COLLECT_STD_ID = @STD_ID
	END