CREATE PROC [dbo].[sp_FEE_INFO_ACCOUNT_insertion]


          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50),
		  @HEAD_NAME nvarchar(50)
AS



declare @HD_ID nvarchar(50) = CAST((@DEFINITION_HD_ID) as nvarchar(50))
declare @BR_ID nvarchar(50)= CAST((@DEFINITION_BR_ID) as nvarchar(50))


declare @fee_parent_code nvarchar(50) = ''
declare @coa_fees_type int = 0
declare @coa_fees int = 0
declare @fee_nature nvarchar(50) = ''
 select @fee_parent_code = COA_UID, @coa_fees_type = COA_type, @fee_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @HEAD_NAME and COA_isDeleted = 0
-- definition Plan ID of Fees in TBL_COA then get level from tbl_ACCOUNT_PLAN_DEF
declare @fees_def_plan_level_no int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_ID in (select COA_definationPlanID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = @HEAD_NAME ))
declare @fees_categories_def_plan_id int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_levelNo = (@fees_def_plan_level_no + 1) and CMP_ID = @HD_ID and BRC_ID = @BR_ID)

declare @fees_category_level_no int = @fees_def_plan_level_no + 1

	
	exec sp_TBL_COA_insertion @HD_ID, @BR_ID,@fee_parent_code,'','',0,@fees_categories_def_plan_id,@DEFINITION_NAME,@coa_fees_type,1,'',1,@fees_category_level_no,1,@fee_nature,0,0,'I'