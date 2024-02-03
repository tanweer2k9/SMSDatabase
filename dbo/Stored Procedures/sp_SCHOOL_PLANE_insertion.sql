

CREATE procedure  [dbo].[sp_SCHOOL_PLANE_insertion]
                                               
                                               
          @CLASS_HD_ID  numeric,
          @CLASS_BR_ID numeric,
          @CLASS_Name nvarchar(50),
          @CLASS_SHIFT  numeric,          
          @CLASS_CLASS  numeric ,
          @CLASS_DPRTMNT  numeric ,
          @CLASS_SECTION  numeric ,
          @CLASS_TEACHER  numeric ,
          @CLASS_Min_VARIATION_PRCNT  float ,
          @CLASS_Max_VARIATION_PRCNT float,
          @CLASS_PRICE  float,          
          @CLASS_STATUS  char(2),
          @CLASS_SESSION_START_DATE date,
          @CLASS_SESSION_END_DATE date,
		  @CLASS_MIN_ELECTIVE_SUBJECTS int,
		  @CLASS_MAX_ELECTIVE_SUBJECTS int,
		  @CLASS_IS_MANDATORY bit,
		  @CLASS_IS_SUBJECT_ATTENDANCE bit,
		  @CLASS_SESSION_ID numeric,
		  @CLASS_LEVEL_ID numeric
         
   
     as  begin
   
	


	declare @table table ([status] nvarchar(50), code nvarchar(50), id int)

	declare @HD_ID nvarchar(50) = CAST((@CLASS_HD_ID) as nvarchar(50))
	declare @BR_ID nvarchar(50)= CAST((@CLASS_BR_ID) as nvarchar(50))


declare @class_parent_code nvarchar(50) = ''
declare @coa_classs_type int = 0
declare @coa_classs int = 0
declare @class_nature nvarchar(50) = ''
select @class_parent_code = COA_UID, @coa_classs_type = COA_type, @class_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Class Plan Fees' and COA_isDeleted = 0
-- definition Plan ID of Fees in TBL_COA then get level from tbl_ACCOUNT_PLAN_DEF
declare @classs_def_plan_level_no int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_ID in (select COA_definationPlanID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Class Plan Fees' and COA_isDeleted = 0) )
declare @classs_categories_def_plan_id int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_levelNo = (@classs_def_plan_level_no + 1) and CMP_ID = @HD_ID and BRC_ID = @BR_ID)

declare @classs_category_level_no int = @classs_def_plan_level_no + 1
	
insert into @table exec sp_TBL_COA_insertion @HD_ID, @BR_ID,@class_parent_code,'','',0,@classs_categories_def_plan_id,@CLASS_Name,@coa_classs_type,1,'',1,@classs_category_level_no,1,@class_nature,0,0,'I'
    



	declare @class_coa_id numeric = 0

	set @class_coa_id = (select top(1)id from @table )


	

	
   
     insert into SCHOOL_PLANE
     values
     (     
        @CLASS_HD_ID,
        @CLASS_BR_ID,
        @CLASS_Name,
        @CLASS_CLASS,       
        @CLASS_SHIFT,
        @CLASS_SECTION,
        @CLASS_DPRTMNT,
        @CLASS_TEACHER,
        @CLASS_PRICE,
        @CLASS_Min_VARIATION_PRCNT,
        @CLASS_Max_VARIATION_PRCNT,
        @CLASS_STATUS,
        @CLASS_SESSION_START_DATE,
        @CLASS_SESSION_END_DATE,
		@CLASS_MIN_ELECTIVE_SUBJECTS,
		@CLASS_MAX_ELECTIVE_SUBJECTS,
		@CLASS_IS_MANDATORY,
		@class_coa_id,
		0,
		@CLASS_IS_SUBJECT_ATTENDANCE,
		@CLASS_SESSION_ID,
		@CLASS_LEVEL_ID,
		NULL

        
     )
     declare @id int = 0
	 set @id = (select SCOPE_IDENTITY())
     
     insert into STUDENT_FEE_NOTES
     values
     (
        @CLASS_HD_ID,
        @CLASS_BR_ID,
        @id,
        '',
        @CLASS_STATUS
     )
     select @id
     
     
end