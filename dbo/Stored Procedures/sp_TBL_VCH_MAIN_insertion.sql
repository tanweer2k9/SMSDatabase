   
     CREATE procedure  [dbo].[sp_TBL_VCH_MAIN_insertion]
                                               
                                               
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
		  @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
		  @VCH_isDeleted bit,
		  @VCH_Bank_Name nvarchar(50) = ''     
   
   
   
     as  begin
   
   
   
     begin
   
   
    declare @id nvarchar(50) 
    
	 set @id = cast((select  isnull( (max(cast( VCH_ID as int ))),0) + 1 from  TBL_VCH_MAIN 
	  where 
		    isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
			isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
			TBL_VCH_MAIN.VCH_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_MAIN.VCH_isDeleted) and
    		VCH_prefix = @VCH_prefix)  as nvarchar) 
		

  
   
    if  LEN( @id) = 1
      set  @id = '000' + @id
   else if  LEN( @id) = 2
      set  @id = '00' + @id
   else if  LEN( @id) = 3
      set  @id = '0' + @id
   


   delete from TBL_VCH_DEF 
   where 
		VCH_MAIN_ID = @VCH_prefix  + '-' + @id and
		isnull(CMP_ID , '') =ISNULL( @CMP_ID,ISNULL(CMP_ID,'')) and
		isnull(BRC_ID , '') =ISNULL( @BRC_ID,ISNULL(BRC_ID,'')) and
		TBL_VCH_DEF.VCH_DEF_isDeleted = isnull((@VCH_isDeleted) , TBL_VCH_DEF.VCH_DEF_isDeleted)

     insert into TBL_VCH_MAIN
     values
     (
        @CMP_ID,
		@BRC_ID,
		@VCH_prefix  + '-' + @id,
        @id,
        @VCH_prefix,
        @VCH_date,
        @VCH_chequeNo,
        @VCH_paidTo,
        @VCH_referenceNo,
        @VCH_PO,
		@VCH_GRN,
		@VCH_isPosted,
		@VCH_isFinancial,
        @VCH_narration,
		@VCH_isDeleted,
		GETDATE(),
		@VCH_Bank_Name
     
     )
      select 'ok'  as [status], @VCH_prefix  + '-' + @id as ID -- commented for PI / SI
      --select 'ok' , @id
     
      end
     
 
     
end