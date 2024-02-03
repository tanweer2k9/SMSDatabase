CREATE procedure [dbo].[sp_TBL_ACC_PLAN_selection] 


@STATUS char,
@CMP_ID  nvarchar(50),
@BRC_ID nvarchar(50),										   
@TBL_ACC_PLAN_MAIN_isDeleted bit

as
	begin
		if @STATUS = 'A'
			begin
			
				
				select  *    from TBL_ACC_PLAN   
			  where 

			
			TBL_ACC_PLAN.TBL_ACC_PLAN_MAIN_isActive = 1 and 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_ACC_PLAN.TBL_ACC_PLAN_MAIN_isDeleted = isnull((@TBL_ACC_PLAN_MAIN_isDeleted) , TBL_ACC_PLAN.TBL_ACC_PLAN_MAIN_isDeleted)
    
				select *  from TBL_ACC_PLAN_DEF    
				where 
				
				TBL_ACC_PLAN_DEF.TBL_ACC_PLAN_DEF_isActive = 1 and
				isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
				isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
				TBL_ACC_PLAN_DEF.TBL_ACC_PLAN_DEF_isDeleted = isnull((@TBL_ACC_PLAN_MAIN_isDeleted) , TBL_ACC_PLAN_DEF.TBL_ACC_PLAN_DEF_isDeleted)
    
				order by 
					TBL_ACC_PLAN_DEF.TBL_ACC_PLAN_DEF_levelNo 
				asc
				
			end 

	end