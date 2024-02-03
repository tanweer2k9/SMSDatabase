CREATE procedure [dbo].[sp_deletion_generic]
	 @ID  numeric ,
	 @HD_ID numeric ,
	 @BR_ID numeric,
	 @TBL_NAME NVARCHAR(50)

as


IF @TBL_NAME = 'SCHOOL'

BEGIN

--delete from SCHOOL_PLANE 
--     where 
--          CLASS_ID = @ID and
--          CLASS_HD_ID =  @HD_ID and 
--          CLASS_BR_ID =  @BR_ID
          
update SCHOOL_PLANE_DEFINITION set DEF_STATUS = 'D'
		 where 
          DEF_CLASS_ID = @ID
END

ELSE IF @TBL_NAME = 'FEE'

BEGIN
		update PLAN_FEE_DEF
		set PLAN_FEE_DEF_STATUS = 'D'
		where PLAN_FEE_DEF_PLAN_ID = @ID
		--delete from PLAN_FEE_DEF
		-- where 
        --  PLAN_FEE_DEF_PLAN_ID = @ID
          
END

ELSE IF @TBL_NAME = 'EXAM'
BEGIN
	--delete from EXAM where EXAM_ID = @ID
	update EXAM_DEF
	set EXAM_DEF_STATUS = 'D'
	where EXAM_DEF_PID = @ID
	
	update PLAN_ASSESSMENT
	set PLAN_ASSESSMENT_STATUS = 'D'
	where PLAN_ASSESSMENT_PID = @ID
 END

ELSE IF @TBL_NAME = 'BRANCH'
BEGIN
	update ANNUAL_HOLIDAYS
	set ANN_HOLI_STATUS = 'D'
	where ANN_HOLI_BR_ID = @BR_ID
	and ANN_HOLI_HD_ID = @HD_ID	
 END



ELSE IF @TBL_NAME = 'GRADE'
BEGIN
	update PLAN_GRADE_DEF
	set DEF_GRADE_STATUS = 'D'
	where DEF_P_ID = @ID
	
 END
 
 ELSE IF @TBL_NAME = 'ADVANCE FEE'
BEGIN
	delete from FEE_ADVANCE_DEF where ADV_FEE_DEF_PID = @ID	
	
 END

  ELSE IF @TBL_NAME = 'HOUR PACKAGE'
BEGIN
	delete from WORKING_HOURS_PACKAGES_DEF where WORK_PACK_DEF_PID = @ID	
	
 END

 else if @TBL_NAME = 'DISCOUNT_RULE'
 begin
	delete from DISCOUNT_RULES_DEF where DIS_RUL_DEF_PID = @ID
 end


 else if @TBL_NAME = 'MARKET_TRACKING'
 BEGIN
 delete from MARKET_TRACKING_DEF where TRACK_DEF_PID = @ID
  END
  else if @TBL_NAME = 'ExtraHolidays'
 begin
	delete from EXTRA_HOLIDAYS where PID = @ID
 end


  else if @TBL_NAME = 'FeeYearlyPlanDef'
 begin
	update FeeYearlyPlanDef set IsDeleted = 1 where PId = @ID
 end



-- ELSE IF @TBL_NAME = 'RIGHTS'
--BEGIN

--	--delete from RIGHTS_PACKAGES_CHILD where PACKAGES_DEF_PID = @ID
	
-- END