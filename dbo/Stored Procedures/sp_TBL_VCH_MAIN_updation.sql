--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Updation  
--                             Creation Date:       5/12/2014 10:40:26 AM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE procedure  [dbo].[sp_TBL_VCH_MAIN_updation]
                                               
                                               
          @CMP_ID  nvarchar(50),
		  @BRC_ID nvarchar(50),
          @VCH_ID  nvarchar(50) ,
          @VCH_prefix  nvarchar(30) ,
          @VCH_date  datetime,
          @VCH_chequeNo  varchar(50) ,
          @VCH_paidTo  varchar(50) ,
          @VCH_referenceNo  nvarchar(50) ,
          @VCH_PO  nvarchar(50) ,	
		  @VCH_GRN nvarchar (50),
		  @VCH_isPosted bit,
		  @VCH_isFinancial bit,
          @VCH_narration  varchar(50) ,
		  @VCH_isDeleted bit
   
   
     as begin 
   
   
   
    delete from TBL_VCH_DEF 
	
	where 
			VCH_MAIN_ID =  @VCH_ID --@VCH_prefix  + '-' + @VCH_ID 
			and
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_VCH_DEF.VCH_DEF_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_DEF.VCH_DEF_isDeleted) 
    
   
     update TBL_VCH_MAIN
 
     set
          VCH_date =  @VCH_date,
          VCH_chequeNo =  @VCH_chequeNo,
          VCH_paidTo =  @VCH_paidTo,
          VCH_referenceNo =  @VCH_referenceNo,
          VCH_PO =  @VCH_PO,
	  	  VCH_GRN=@VCH_GRN ,
		  VCH_isPosted =@VCH_isPosted ,
		  VCH_isFinancial=@VCH_isFinancial ,
          VCH_narration =  @VCH_narration
 
     where 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_VCH_MAIN.VCH_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_MAIN.VCH_isDeleted) and 
			VCH_MID =  @VCH_ID and 
			VCH_prefix =  @VCH_prefix
 
      --select 'ok' , @VCH_prefix  + '-' + @VCH_ID  -- commebted for PI / SI
     select 'ok' , @VCH_ID 
   
end