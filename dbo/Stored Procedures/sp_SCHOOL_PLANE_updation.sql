CREATE procedure  [dbo].[sp_SCHOOL_PLANE_updation]
                                               
          @CLASS_ID  numeric,         
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
   
   	declare @HD_ID nvarchar(50) = CAST((@CLASS_HD_ID) as nvarchar(50))
	declare @BR_ID nvarchar(50)= CAST((@CLASS_BR_ID) as nvarchar(50))
	declare @class_parent_code nvarchar(50) = ''
declare @coa_classs_type int = 0
declare @coa_classs int = 0
declare @class_nature nvarchar(50) = ''
select @class_parent_code = COA_UID, @coa_classs_type = COA_type, @class_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Class Plan Fees' and COA_isDeleted = 0
-- definition Plan ID of Fees in TBL_COA then get level from tbl_ACCOUNT_PLAN_DEF
declare @classs_def_plan_level_no int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_ID in (select COA_definationPlanID from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name = 'Class Plan Fees' and COA_isDeleted = 0 ))
declare @classs_categories_def_plan_id int = (select TBL_ACC_PLAN_DEF_levelNo from TBL_ACC_PLAN_DEF where TBL_ACC_PLAN_DEF_levelNo = (@classs_def_plan_level_no + 1) and CMP_ID = @HD_ID and BRC_ID = @BR_ID)

declare @classs_category_level_no int = @classs_def_plan_level_no + 1

   declare @old_class_name nvarchar(50) = ''
   set @old_class_name = (select top(1) CLASS_Name from SCHOOL_PLANE where CLASS_ID = @CLASS_ID and CLASS_HD_ID = @HD_ID and CLASS_BR_ID = @BR_ID)

   	declare @table table ([status] nvarchar(50), code nvarchar(50), id int)
	declare @coa_id int = 0 

   declare @count int = 0
	select @coa_id = COA_ID from TBL_COA where COA_Name = @CLASS_Name and CMP_ID = @HD_ID and BRC_ID = @BR_ID

	set @coa_id = ISNULL(@coa_id,0)

   if @coa_id = 0
   BEGIN
		insert into @table exec sp_TBL_COA_insertion @HD_ID, @BR_ID,@class_parent_code,'','',0,@classs_categories_def_plan_id,@CLASS_Name,@coa_classs_type,1,'',1,@classs_category_level_no,1,@class_nature,0,0,'I'
		   set @coa_id = (select top(1) id from @table )
   END
   ELSE
   BEGIN
		update TBL_COA set COA_Name = @CLASS_Name where COA_Name = @old_class_name and CMP_ID = @HD_ID and BRC_ID = @BR_ID
   END




   update SCHOOL_PLANE
	set
                
        CLASS_Name = @CLASS_Name,
        CLASS_CLASS =@CLASS_CLASS,       
        CLASS_SHIFT =@CLASS_SHIFT,
        CLASS_SECTION =@CLASS_SECTION,
        CLASS_DPRTMNT =@CLASS_DPRTMNT,
        CLASS_TEACHER =@CLASS_TEACHER,
        CLASS_PRICE =@CLASS_PRICE,
        CLASS_Min_VARIATION_PRCNT =@CLASS_Min_VARIATION_PRCNT,
        CLASS_Max_VARIATION_PRCNT =@CLASS_Max_VARIATION_PRCNT,
        CLASS_STATUS   = @CLASS_STATUS,        
     CLASS_SESSION_START_DATE = @CLASS_SESSION_START_DATE,
     CLASS_SESSION_END_DATE = @CLASS_SESSION_END_DATE,
	  CLASS_MIN_ELECTIVE_SUBJECTS = @CLASS_MIN_ELECTIVE_SUBJECTS,
		  CLASS_MAX_ELECTIVE_SUBJECTS= @CLASS_MAX_ELECTIVE_SUBJECTS,
		  CLASS_IS_MANDATORY = @CLASS_IS_MANDATORY,
		  CLASS_COA_ID = @coa_id,
		  CLASS_IS_SUBJECT_ATTENDANCE = @CLASS_IS_SUBJECT_ATTENDANCE,
		  CLASS_SESSION_ID = @CLASS_SESSION_ID,
		  CLASS_LEVEL_ID = @CLASS_LEVEL_ID
     
     where CLASS_ID = @CLASS_ID
   
   
    update STUDENT_FEE_NOTES
		set
			STD_FEE_NOTES_STATUS = @CLASS_STATUS
			
		where STD_FEE_NOTES_HD_ID = @CLASS_HD_ID
			and STD_FEE_NOTES_BR_ID = @CLASS_BR_ID
			and STD_FEE_NOTES_CLASS_ID = @CLASS_ID
         
   
     
end