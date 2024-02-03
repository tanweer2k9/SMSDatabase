CREATE procedure  [dbo].[sp_ROYALTY_TRANSACTION_insertion]
                                               
                                               
		  @ROYALTY_TRAN_ID numeric,
          @ROYALTY_TRAN_BR_ID  numeric,
          @ROYALTY_TRAN_AMOUNT  float,
          @ROYALTY_TRAN_FROM_DATE  date,
          @ROYALTY_TRAN_TO_DATE  date,
          @ROYALTY_TRAN_BANK_NAME  nvarchar(100) ,
          @ROYALTY_TRAN_CHEQUE_NO  nvarchar(100) ,
          @ROYALTY_TRAN_COMMENTS  nvarchar(1000) ,
		  @ROYALTY_TRAN_CREATED_BY nvarchar(50),
		  @ROYALTY_TRAN_DATETIME datetime,
		  @ROYALTY_TRAN_PAYMENTS_TO nvarchar(50)
   
   
     as  begin

	 	 declare @tbl table ([status] nvarchar(50), ID nvarchar(50))
	 declare @from_hd_id nvarchar(50) = 0
	 declare @to_hd_id nvarchar(50) = 0
	  declare @to_branch nvarchar(50)
	 declare @from_branch nvarchar(50) = 0--To Means head office and from means franchise @ROYALTY_TRAN_BR_ID is franchise br id
	 select  @to_branch = CAST(BR_ADM_ROYALTY_TO_BRANCH as nvarchar(50)), @from_hd_id = CAST(BR_ADM_HD_ID as nvarchar(50)) from BR_ADMIN where BR_ADM_ID = @ROYALTY_TRAN_BR_ID
	 select  @to_hd_id = CAST(BR_ADM_HD_ID as nvarchar(50)) from BR_ADMIN where BR_ADM_ID = @to_branch
	 set @from_branch = CAST(@ROYALTY_TRAN_BR_ID as nvarchar(50))

	 if @ROYALTY_TRAN_ID != 0
	 BEGIN

		delete from TBL_VCH_DEF where  TBL_VCH_DEF.CMP_ID = @from_hd_id and TBL_VCH_DEF.BRC_ID = @from_branch  and TBL_VCH_DEF.VCH_MAIN_ID in (select TBL_VCH_MAIN.VCH_MID  from TBL_VCH_MAIN where TBL_VCH_MAIN.CMP_ID = @from_hd_id and TBL_VCH_MAIN.BRC_ID = @from_branch and TBL_VCH_MAIN.VCH_prefix = 'RO' and TBL_VCH_MAIN.VCH_referenceNo = CAST(@ROYALTY_TRAN_ID as nvarchar(50)))
		delete from TBL_VCH_MAIN where CMP_ID = @from_hd_id and BRC_ID = @from_branch and VCH_prefix = 'RO' and VCH_referenceNo = CAST(@ROYALTY_TRAN_ID as nvarchar(50))

		delete from TBL_VCH_DEF where  TBL_VCH_DEF.CMP_ID = @to_hd_id and TBL_VCH_DEF.BRC_ID = @to_branch  and TBL_VCH_DEF.VCH_MAIN_ID in (select TBL_VCH_MAIN.VCH_MID  from TBL_VCH_MAIN where TBL_VCH_MAIN.CMP_ID = @to_hd_id and TBL_VCH_MAIN.BRC_ID = @to_branch and TBL_VCH_MAIN.VCH_prefix = 'RO' and TBL_VCH_MAIN.VCH_referenceNo = CAST(@ROYALTY_TRAN_ID as nvarchar(50)))
		delete from TBL_VCH_MAIN where CMP_ID = @to_hd_id and BRC_ID = @to_branch and VCH_prefix = 'RO' and VCH_referenceNo = CAST(@ROYALTY_TRAN_ID as nvarchar(50))

		delete from ROYALTY_TRANSACTION where ROYALTY_TRAN_ID = @ROYALTY_TRAN_ID
	 END




	 declare @count int = 0
	 set @count = (select COUNT(*) from VROYALTY_TRANSACTION where [BR ID] = @ROYALTY_TRAN_BR_ID)

	 if @count = 0
	 BEGIN
		set @ROYALTY_TRAN_FROM_DATE = '1900-01-01'
	 END
	 ELSE
	 BEGIN
		set @ROYALTY_TRAN_FROM_DATE = (select top(1) @ROYALTY_TRAN_TO_DATE from VROYALTY_TRANSACTION where [BR ID] = @ROYALTY_TRAN_BR_ID ORDER BY ID DESC)

		if @ROYALTY_TRAN_FROM_DATE != @ROYALTY_TRAN_TO_DATE
		BEGIN
			set @ROYALTY_TRAN_FROM_DATE = DATEADD(DD,1,@ROYALTY_TRAN_FROM_DATE)
		END
	 END

	 insert into ROYALTY_TRANSACTION
     values
     (

        @ROYALTY_TRAN_BR_ID,
        @ROYALTY_TRAN_AMOUNT,
        @ROYALTY_TRAN_FROM_DATE,
        @ROYALTY_TRAN_TO_DATE,
        @ROYALTY_TRAN_BANK_NAME,
        @ROYALTY_TRAN_CHEQUE_NO,
        @ROYALTY_TRAN_COMMENTS,		
		@ROYALTY_TRAN_CREATED_BY,
		@ROYALTY_TRAN_DATETIME 
     
     
     )

	 declare @ID nvarchar(50) = 0

	 set @ID = CAST(SCOPE_IDENTITY() as nvarchar(50))







	


	 declare @from_branch_royality_account nvarchar(50) =  (select COA_UID from TBL_COA where COA_isDeleted = 0 and COA_isActive = 1 and BRC_ID =@from_branch and CMP_ID = @from_hd_id and COA_Name = 'Royalty')
	 declare @to_branch_royality_account nvarchar(50) =  (select COA_UID from TBL_COA where COA_isDeleted = 0 and COA_isActive = 1 and BRC_ID =@to_branch and CMP_ID = @to_hd_id and COA_Name = 'Royalty') 
	

   insert into @tbl
   exec sp_TBL_VCH_MAIN_insertion 'RO',@ROYALTY_TRAN_DATETIME,'','',@ID,'','',0,0,'',@from_hd_id,@from_branch,0

   declare @main_id nvarchar(50) = ''
   set @main_id = (select top(1) ID from @tbl)

   exec sp_TBL_VCH_DEF_insertion @main_id, @from_branch_royality_account,@ROYALTY_TRAN_AMOUNT,0,0,0,@ID,'I','',@ROYALTY_TRAN_DATETIME,'','','',@from_hd_id, @from_branch,0,0,''

   

   delete from @tbl
   insert into @tbl
    exec sp_TBL_VCH_MAIN_insertion 'RO',@ROYALTY_TRAN_DATETIME,'','',@ID,'','',0,0,'',@to_hd_id,@to_branch,0
     set @main_id = (select top(1) ID from @tbl)
	 exec sp_TBL_VCH_DEF_insertion @main_id, @to_branch_royality_account,0,@ROYALTY_TRAN_AMOUNT,0,0,@ID,'I','',@ROYALTY_TRAN_DATETIME,'','','',@to_hd_id, @to_branch,0,0,''
	 exec sp_TBL_VCH_DEF_insertion @main_id, @ROYALTY_TRAN_PAYMENTS_TO,0,@ROYALTY_TRAN_AMOUNT,0,0,@ID,'I','',@ROYALTY_TRAN_DATETIME,'','','',@to_hd_id, @to_branch,0,0,''
end