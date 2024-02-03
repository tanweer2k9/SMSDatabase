
     CREATE procedure  [dbo].[sp_TBL_VCH_DEF_insertion]
                                               
                                               
          @VCH_MAIN_ID  nvarchar(37) ,
          @VCH_DEF_COA  nvarchar(30) ,
          @VCH_DEF_debit  float,
          @VCH_DEF_credit  float,
          @VCH_DEF_debit1  float,
          @VCH_DEF_credit1  float,
          @VCH_DEF_referenceNo  varchar(50) ,
          @VCH_DEF_remarks  varchar(100) ,
          @VCH_DEF_GRDNo  nvarchar(50) ,
          @VCH_DEF_date  datetime,
          @VCH_DEF_ItemCOA  nvarchar(50) ,
          @VCH_DEF_narration  nvarchar(MAX) ,
          @VCH_DEF_prefix  nvarchar(50) ,
		  @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
		  @VCH_DEF_isDeleted bit,
		  @VCH_DEF_isEffectOnProfitLoss bit,
		  @VCH_DEF_accRefNo nvarchar(50)
   
   
     as  begin
   
      declare @id int 
   

     set @id = ( select  isnull( (max(cast( VCH_DEF_ID as int ))),0) + 1 from  TBL_VCH_DEF 
	 where 
			isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_VCH_DEF.VCH_DEF_isDeleted = isnull((@VCH_DEF_isDeleted) , TBL_VCH_DEF.VCH_DEF_isDeleted) 
    
	 )  

     insert into TBL_VCH_DEF
     values
     (
		@CMP_ID,
		@BRC_ID,
        @id,
        @VCH_MAIN_ID,
        @VCH_DEF_COA,
        @VCH_DEF_debit,
        @VCH_DEF_credit,
        @VCH_DEF_debit1,
        @VCH_DEF_credit1,
        @VCH_DEF_referenceNo,
        @VCH_DEF_remarks,
        @VCH_DEF_GRDNo,
        @VCH_DEF_date,
        @VCH_DEF_ItemCOA,
        @VCH_DEF_narration,
        @VCH_DEF_prefix,
		@VCH_DEF_isDeleted,
		@VCH_DEF_isEffectOnProfitLoss ,
		@VCH_DEF_accRefNo 
     
     )
     
end