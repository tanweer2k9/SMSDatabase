CREATE PROC [dbo].[sp_FEE_DEFINATION_ACCOUNT_insertion]

@HD_ID numeric,
@BR_ID numeric



AS



declare @count int = (select COUNT(*) from VFEE_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID)
declare @fee_name nvarchar(50) = ''
declare @i int = 1
declare @fee_parent_code nvarchar(50) = ''
declare @coa_fees_type int = 0
declare @coa_fees int = 0
declare @fee_nature nvarchar(50) = ''
 select @fee_parent_code = COA_UID, @coa_fees_type = COA_type, @fee_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Fees' and COA_isDeleted = 0
-- definition Plan ID of Fees in TBL_COA then get level from tbl_ACCOUNT_PLAN_DEF
declare @fees_def_plan_level_no int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_ID in (select COA_definationPlanID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Fees' ))
declare @fees_categories_def_plan_id int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_levelNo = (@fees_def_plan_level_no + 1) and CMP_ID = @HD_ID and BRC_ID = @BR_ID)
declare @count_fee_name int = 0
declare @fees_category_level_no int = @fees_def_plan_level_no + 1

while @i <= @count
	begin
		select @fee_name = Name from (select ROW_NUMBER() over (order by (select 0)) as sr, Name from VFEE_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID)A where sr = @i
		set @count_fee_name = (select COUNT(*) from TBL_COA where COA_Name = @fee_name and CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_isDeleted = 0 )
		
		if @count_fee_name = 0
		BEGIN
			exec sp_TBL_COA_insertion @HD_ID, @BR_ID,@fee_parent_code,'','',0,@fees_categories_def_plan_id,@fee_name,@coa_fees_type,1,'',1,@fees_category_level_no,1,@fee_nature,0,0,'I'
		END
		set @i = @i + 1
	end