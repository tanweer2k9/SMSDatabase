--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For selection
--                             Creation Date:       4/28/2014 9:41:16 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_TBL_TYPE_PLAN_MAIN_selection]
                                               
                                               
     @STATUS char(10),
     @TYPE_PLAN_MAIN_ID  int,
	 @CMP_ID  nvarchar(50),
	 @BRC_ID  nvarchar(50),
     @TYPE_PLAN_MAIN_isDeleted bit     
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
    select * from TBL_TYPE_PLAN_MAIN 
		where  
			
			TBL_TYPE_PLAN_MAIN.TYPE_PLAN_MAIN_isActive = 1 and 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_TYPE_PLAN_MAIN.TYPE_PLAN_MAIN_isDeleted = isnull((@TYPE_PLAN_MAIN_isDeleted) , TBL_TYPE_PLAN_MAIN.TYPE_PLAN_MAIN_isDeleted) 
    
	
    select TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_ID , TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_name from TBL_TYPE_PLAN_DEF 
		where  
			TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_isActive = 1 and
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_isDeleted = isnull((@TYPE_PLAN_MAIN_isDeleted) , TBL_TYPE_PLAN_DEF.TYPE_PLAN_DEF_isDeleted) 
    
     END
End