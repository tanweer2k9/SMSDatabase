CREATE procedure  [dbo].[sp_GET_MAX]
                       
				                           
          @STATUS nvarchar(50),
		  @CMP_ID nvarchar(50),	
		  @BRC_ID nvarchar(50),										   
          @Dependent_C1  int ,
          @Dependent_C2  int ,
          @Dependent_C3  int ,
          @Dependent_S1  nvarchar(50) ,
          @Dependent_S2  nvarchar(50) ,
          @Dependent_S3  nvarchar(50) ,
		  @isDeleted bit
         

   
     as  
   
   
    if @STATUS  = 'PerLevel' -- will select max for given level
		begin
	
		select (isnull( (max(cast( TBL_COA.COA_levelID as int ))),0) + 1) from TBL_COA 
			where 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_COA.COA_isDeleted = isnull((@isDeleted) , TBL_COA.COA_isDeleted) and
    
			TBL_COA.COA_PARENTID =@Dependent_S1 
			
	
		end

		
    if @STATUS  = 'TBL_VCH_MAIN' -- will select max for given level
		begin
	
		select (isnull( (max(cast( TBL_VCH_MAIN.VCH_ID as int ))),0) + 1) from TBL_VCH_MAIN 
			where 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
		    TBL_VCH_MAIN.VCH_isDeleted = isnull((@isDeleted) , TBL_VCH_MAIN.VCH_isDeleted) and
    		TBL_VCH_MAIN.VCH_prefix =@Dependent_S1 
			
	
		end