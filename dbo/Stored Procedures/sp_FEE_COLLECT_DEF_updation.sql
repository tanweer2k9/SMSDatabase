CREATE procedure  [dbo].[sp_FEE_COLLECT_DEF_updation]
                                               
                                               
          @FEE_COLLECT_DEF_ID  numeric,
          @FEE_COLLECT_DEF_PID  numeric,
          @FEE_COLLECT_DEF_FEE_PAID  float,
          @FEE_COLLECT_DEF_ARREARS_RECEIVED float,
          @FEE_COLLECT_DEF_TOTAL float,
          @FEE_COLLECT_DEF_FEE float,
          @FEE_COLLECT_DEF_ARREARS float
		  
          
          
     as begin 
		  --declare @FEE_COLLECT_DEF_ID  numeric = 487049,
    --      @FEE_COLLECT_DEF_PID  numeric = 37943,
    --      @FEE_COLLECT_DEF_FEE_PAID  float = 1200,
    --      @FEE_COLLECT_DEF_ARREARS_RECEIVED float = 0,
    --      @FEE_COLLECT_DEF_TOTAL float = 1200,
    --      @FEE_COLLECT_DEF_FEE float = 1200,
    --      @FEE_COLLECT_DEF_ARREARS float = 0
		
		
		
		
		
		declare @FEE_COLLECT_STD_ID numeric = 0
		
		declare @idd numeric
		declare @stat nvarchar(30)
		declare @fee_history bit = (select top(1) BR_ADM_FEE_HISTORY from FEE_SETTING)
		declare @fee_name nvarchar(50) = ''

		declare @VCH_DEF_COA nvarchar(50) = ''
		declare @VCH_TYPE nvarchar(50) = ''
		declare @coa_nature nvarchar(50) = ''
		declare @debit_receive float = 0
		declare @credit_receive float = 0
		declare @debit_total float = 0
		declare @credit_total float = 0
		declare @VCH_reference_no nvarchar(50) = ''
		declare @datetime datetime = ''
		declare @HD_ID nvarchar(50) = ''
		declare @BR_ID nvarchar(50) = ''
		declare @VCH_MAIN_ID nvarchar(50) = ''
		declare @arears float = 0
		declare @fee_receieved float = 0
		Declare @def_name numeric
		declare @debit float = 0
		declare @credit float = 0
		declare @accRefNo nvarchar(100) = ''

		select @HD_ID = CAST((FEE_COLLECT_HD_ID) as nvarchar(50)), @BR_ID = CAST((FEE_COLLECT_BR_ID) as nvarchar(50)) from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_DEF_PID

		  select @def_name = FEE_COLLECT_DEF_FEE_NAME, @fee_receieved = FEE_COLLECT_DEF_FEE, 
					@arears = FEE_COLLECT_DEF_ARREARS, @VCH_reference_no = CAST((FEE_COLLECT_DEF_ID) as nvarchar(50))
					from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_DEF_PID

		set @FEE_COLLECT_STD_ID = (select FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_DEF_PID)
   set @stat = ( select [Status] from VFEE_COLLECT where ID = @FEE_COLLECT_DEF_PID )
		   if @stat = 'Fully Received'
				begin
					set	@stat = 'R'		
				end
				
			else if @stat = 'Closed'
				begin
					set	@stat = 'C'		
				end
		   
		   else
				begin
					set	@stat = 'T'		
				end
   
   declare @royalty_fee float = 0
   declare @royalty_paid float = 0
   
   set @royalty_fee = (select FEE_COLLECT_DEF_ROYALTY from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID =  @FEE_COLLECT_DEF_ID)

   if @FEE_COLLECT_DEF_FEE_PAID >= @royalty_fee
		set @royalty_paid = @royalty_fee
	ELSE
		set @royalty_paid = @FEE_COLLECT_DEF_FEE_PAID


     update FEE_COLLECT_DEF 
     set         
		FEE_COLLECT_DEF_FEE = @FEE_COLLECT_DEF_FEE,
          FEE_COLLECT_DEF_FEE_PAID =  @FEE_COLLECT_DEF_FEE_PAID,     
          FEE_COLLECT_DEF_ARREARS = @FEE_COLLECT_DEF_ARREARS,
          FEE_COLLECT_DEF_ARREARS_RECEIVED = @FEE_COLLECT_DEF_ARREARS_RECEIVED,
          FEE_COLLECT_DEF_TOTAL = @FEE_COLLECT_DEF_TOTAL,   
		  FEE_COLLECT_DEF_ROYALTY_PAID = @royalty_paid,
		  FEE_COLLECT_DEF_STATUS = @stat,
		  FEE_COLLECT_DEF_ROYALTY = (@FEE_COLLECT_DEF_FEE * FEE_COLLECT_DEF_ROYALTY_PERCENT) / 100
     where 
          FEE_COLLECT_DEF_ID =  @FEE_COLLECT_DEF_ID and 
          FEE_COLLECT_DEF_PID =  @FEE_COLLECT_DEF_PID 
	
	declare @royality_total float = 0
	set @royality_total = (select SUM(FEE_COLLECT_DEF_ROYALTY_PAID) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @FEE_COLLECT_DEF_PID)

	update FEE_COLLECT set FEE_COLLECT_ROYALTY_PAID = @royality_total where FEE_COLLECT_ID = @FEE_COLLECT_DEF_PID

	
	set @idd = (select isnull (max(FEE_HISTORY_ID),0 ) from FEE_HISTORY)
	declare @def_fee_id int = (select FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID =  @FEE_COLLECT_DEF_ID and 
           FEE_COLLECT_DEF_PID =  @FEE_COLLECT_DEF_PID)
	

	

	declare @count int = (select COUNT(*) from FEE_HISTORY_DEF where FEE_HISTORY_DEF_PID = @idd and FEE_HISTORY_DEF_NAME = @def_fee_id)
	if @count = 0
	begin
	if @fee_history = 1
	begin
		insert into FEE_HISTORY_DEF(FEE_HISTORY_DEF_HID,FEE_HISTORY_DEF_PID,FEE_HISTORY_DEF_NAME,FEE_HISTORY_DEF_FEE,FEE_HISTORY_DEF_PAID,FEE_HISTORY_DEF_MIN,FEE_HISTORY_DEF_MAX,FEE_HISTORY_DEF_OPERATION,FEE_HISTORY_DEF_ARREARS,FEE_HISTORY_DEF_ARREARS_RECEIVED,FEE_HISTORY_DEF_TOTAL)
		select FEE_COLLECT_DEF_PID,@idd,FEE_COLLECT_DEF_FEE_NAME,FEE_COLLECT_DEF_FEE,FEE_COLLECT_DEF_FEE_PAID,FEE_COLLECT_DEF_MIN,FEE_COLLECT_DEF_MAX,FEE_COLLECT_DEF_OPERATION,FEE_COLLECT_DEF_ARREARS,FEE_COLLECT_DEF_ARREARS_RECEIVED,FEE_COLLECT_DEF_TOTAL from FEE_COLLECT_DEF
		where FEE_COLLECT_DEF_ID =  @FEE_COLLECT_DEF_ID and 
           FEE_COLLECT_DEF_PID =  @FEE_COLLECT_DEF_PID 
 	
	end
	
	end
		
		-- This all is handeld in fee_collect_updation storeprocedure and that will be execute after this

		--if dbo.get_advance_accounting (@BR_ID) = 1		  
		--  BEGIN	

		----account reference is fee account name from TBL_COA
		--	select @accRefNo = COA_UID, @VCH_TYPE = COA_type,@coa_nature = COA_nature from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
		--		(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0

		--		--in actual accoutn refernence is from TBL_VCH_DEF from
		--	set @accRefNo = (select top(1) CAST(VCH_DEF_countID as nvarchar(100)) from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @accRefNo)
		--set @VCH_MAIN_ID = (select top(1) VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST((@FEE_COLLECT_DEF_PID) as nvarchar(50)))
		--set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_ID = (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @FEE_COLLECT_STD_ID ) )
		
		--declare @total_fee float = 0

		
		
		----delete from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @VCH_DEF_COA
		--	set @datetime = GETDATE()				
			


		--	      set @fee_name = (select FEE_NAME from FEE_INFO where FEE_ID = @def_fee_id)

				
		--		if  @fee_name = 'Discount'
		--		BEGIN
		--			set @debit = @FEE_COLLECT_DEF_FEE
		--			set @credit = 0
		--		END
		--		ELSE
		--		BEGIN
		--			set @credit= @FEE_COLLECT_DEF_FEE_PAID + @FEE_COLLECT_DEF_ARREARS_RECEIVED
		--			set @debit = 0
		--			--if @VCH_TYPE = 'Debit' 
		--			--	begin
		--			--		set @credit = @fee_receieved + @arears						
		--			--	end
		--			--ELSE 
		--			--	begin
		--			--		set @debit = @fee_receieved + @arears
		--			--	end
		--		END
				


		--		select @accRefNo = COA_UID, @VCH_TYPE = COA_type from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
		--		(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0
		--		--reference number as tbl voucher def countID that is auto identity
		--		set @VCH_reference_no = (select top(1) CAST(VCH_DEF_countID as nvarchar(50)) from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID  and VCH_DEF_COA = @accRefNo )

		--		set @datetime = GETDATE()
		--		declare @is_profit_loss bit = (select CAST(1 as bit))

		--		if @fee_name != 'Discount'
		--		BEGIN
		--			update TBL_VCH_DEF set VCH_DEF_credit = @FEE_COLLECT_DEF_FEE where VCH_DEF_countID = @VCH_reference_no
		--		END
		--		--ELSE
		--		--BEGIN
		--		--	update TBL_VCH_DEF set VCH_DEF_debit = @FEE_COLLECT_DEF_FEE where VCH_DEF_countID = @VCH_reference_no
		--		--END

		--		if @debit > 0 or @credit > 0
		--			BEGIN
		--				exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit,@credit,0,0,@VCH_reference_no,'U','',@datetime,'','','',@HD_ID, @BR_ID,0,@is_profit_loss,@accRefNo
		--			END
		 
		  
		--  END -- end if dbo.get_advance_accounting (@FEE_COLLECT_BR_ID) = 1		  
		  




















		  
			 --       select @def_name = FEE_COLLECT_DEF_FEE_NAME, @fee_receieved = FEE_COLLECT_DEF_FEE, 
				--	@arears = FEE_COLLECT_DEF_ARREARS, @VCH_reference_no = CAST((FEE_COLLECT_DEF_ID) as nvarchar(50))
				--	 from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ID = @FEE_COLLECT_DEF_ID
				--if @VCH_TYPE = 'Debit' 
				--	begin
				--		set @credit_receive = @FEE_COLLECT_DEF_FEE_PAID + @FEE_COLLECT_DEF_ARREARS_RECEIVED				
				--		set @debit_total = @FEE_COLLECT_DEF_FEE
				--	end
				--ELSE 
				--	begin
				--		set @debit_receive = @FEE_COLLECT_DEF_FEE_PAID + @FEE_COLLECT_DEF_ARREARS_RECEIVED
				--		set @credit_total = @FEE_COLLECT_DEF_FEE
				--	end
				
				--select @VCH_DEF_COA = COA_UID, @VCH_TYPE = COA_type from TBL_COA where CMP_ID = @HD_ID and BRC_ID = @BR_ID and COA_Name in 
				--(select Name from VFEE_INFO where ID = @def_name) and COA_isDeleted = 0
				--set @VCH_MAIN_ID = (select top(1) VCH_MID from TBL_VCH_MAIN where VCH_chequeNo = CAST((@FEE_COLLECT_DEF_PID) as nvarchar(50)))
				
				
				--update TBL_VCH_DEF set VCH_DEF_debit = @debit_total, VCH_DEF_credit = @credit_total 
				--	where 
				--		VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_remarks = 'I' and VCH_DEF_COA = @VCH_DEF_COA
				
				--delete from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA = @VCH_DEF_COA and VCH_DEF_remarks = 'U'
				--exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @VCH_DEF_COA,@debit_receive,@credit_receive,0,0,@VCH_reference_no,'U','',@datetime,'','','',@HD_ID, @BR_ID,0					








	--update FEE_HISTORY
	--	set 
	--		FEE_HISTORY_NET_TOTAL = ( select FEE_COLLECT_NET_TOATAL from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_DEF_PID )
	--		where FEE_HISTORY_ID = @idd
		
 select 'ok'
end