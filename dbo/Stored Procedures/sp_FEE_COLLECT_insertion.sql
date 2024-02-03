

CREATE PROC [dbo].[sp_FEE_COLLECT_insertion]
	  --@FEE_COLLECT_HD_ID numeric,
   --   @FEE_COLLECT_BR_ID numeric,
   --   @FEE_COLLECT_STD_ID numeric,
	  --@FEE_COLLECT_FEE_ID numeric,
	  --@FEE_COLLECT_FEE_FROM_DATE date,
	  --@FEE_COLLECT_VALID_DATE date,
	  --@FEE_COLLECT_USER_ID numeric


	    @FEE_COLLECT_HD_ID numeric,
      @FEE_COLLECT_BR_ID numeric,
      @FEE_COLLECT_STD_ID numeric,
      @FEE_COLLECT_PLAN_ID numeric,
      @FEE_COLLECT_FEE_ID numeric,
      @FEE_COLLECT_FEE float,
      @FEE_COLLECT_FEE_PAID float,
      @FEE_COLLECT_FEE_FROM_DATE date,
      @FEE_COLLECT_FEE_TO_DATE date,      
      @FEE_COLLECT_DUE_DATE date,
      @FEE_COLLECT_FEE_STATUS nvarchar(20),
      @FEE_COLLECT_OPB nvarchar(20),
      @status char(1),
      @send_sms char(1),
      @FEE_COLLECT_USER_ID numeric,
      @FEE_COLLECT_ATTENDANCE_FROM_DATE date,
      @FEE_COLLECT_ATTENDANCE_TO_DATE date,
	  @FEE_COLLECT_MONTHS float,
	  @IS_DELETE_PREVIOUS bit,
	  @IS_COMBINE_BRANCHES bit,
	  @IS_CONTINUE bit,
	  @FEE_COLLECT_VALID_DATE date

AS 


--declare @one int = 1, @FEE_COLLECT_FEE_TO_DATE date,@meesage nvarchar(MAX), @count_advance_fee int =0, @n int = 1,@advance_fee_adjust_amount float,@advance_fee_id numeric,@mounth_diff int,@FEE_COLLECT_PLAN_ID numeric, @Installment_Name nvarchar(100), @fee_formula_fee_plan float, @is_fee_generate bit,@is_formula_apply bit, @old_colect numeric,@fee_collect_status nvarchar(100),@due_from_date date, @previous float, @BillNo nvarchar(15), @BillNoCount bigint, @idd_def numeric,@is_rejoin int = 0



declare @one int = 1, @meesage nvarchar(MAX), @count_advance_fee int =0, @n int = 1,@advance_fee_adjust_amount float,@advance_fee_id numeric,@mounth_diff int, @Installment_Name nvarchar(100), @fee_formula_fee_plan float, @is_fee_generate bit,@is_formula_apply bit, @old_colect numeric,@fee_collect_status nvarchar(100),@due_from_date date, @previous float, @BillNo nvarchar(15), @BillNoCount bigint, @idd_def numeric,@is_rejoin int = 0

	declare @tbl_fee_ids_delete table (sr int identity(1,1), fee_id numeric)
	declare @tbl_BillNo table (BillNo nvarchar(15), BillNoCount bigint)
	declare @tbl_vch table (sr int identity(1,1),[status] nvarchar(50), ID nvarchar(50))

							select top(@one) @FEE_COLLECT_FEE_TO_DATE = EOMONTH(DATEFROMPARTS(DATEPART(YYYY,@FEE_COLLECT_FEE_FROM_DATE),ToMonth,1)),@FEE_COLLECT_PLAN_ID = STDNT_CLASS_PLANE_ID, @Installment_Name = INSTALLMENT_NAME  ,@is_fee_generate = PLAN_FEE_IS_FEE_GENERATE, @is_formula_apply = PLAN_FEE_IS_FORMULA_APPLY,@fee_formula_fee_plan = FeeFormula,@is_rejoin = STDNT_IS_REJOIN from STUDENT_INFO  s join PLAN_FEE f on f.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID join FeeYearlyPlanDef yd on yd.PId = f.PLAN_FEE_YEARLY_PLAN_ID and IsDeleted = 0 and FromMonth = DATEPART(MM, @FEE_COLLECT_FEE_FROM_DATE) join INSTALLMENT_INFO i on i.INSTALLMENT_ID = yd.InstallmentId where  STDNT_ID = @FEE_COLLECT_STD_ID and STDNT_STATUS = 'T'  and f.PLAN_FEE_IS_FEE_GENERATE = 1


						if DATEADD(DD,1,@FEE_COLLECT_FEE_TO_DATE) != @FEE_COLLECT_FEE_FROM_DATE AND @is_rejoin = 1 
						begin
							set @meesage = @meesage + CONVERT(nvarchar(100), @FEE_COLLECT_STD_ID) + ' '
						end

						else

						begin

							   delete from TBL_VCH_DEF where VCH_MAIN_ID in
								(select VCH_MID from TBL_VCH_MAIN where TBL_VCH_MAIN.VCH_prefix = 'FE' and VCH_referenceNo in
							  ( select CAST((FEE_COLLECT_ID) as nvarchar(50)) from FEE_COLLECT 
							where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) 
							and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) 
							and   FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA'
							 and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )))

							 delete from TBL_VCH_MAIN where TBL_VCH_MAIN.VCH_prefix = 'FE' and VCH_referenceNo in
							  ( select CAST((FEE_COLLECT_ID) as nvarchar(50)) from FEE_COLLECT 
							where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) 
							and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) 
							and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA'
							 and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))										

						delete from SCHOLARSHIP_GENERATION where SCH_GEN_FEE_COLLECT_ID in (select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))
						
						
						
						--delete and adjust advance fee

						insert into @tbl_fee_ids_delete
						select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) and   FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )

						set @count_advance_fee = (select COUNT(*) from @tbl_fee_ids_delete)
						WHILE @n <= @count_advance_fee
						BEGIN
							set @advance_fee_adjust_amount = 0 
							select @advance_fee_adjust_amount = ADV_FEE_DEF_AMOUNT, @advance_fee_id = ADV_FEE_DEF_PID from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = (select top(@one) fee_id from @tbl_fee_ids_delete where sr = @n)

							set @advance_fee_adjust_amount = ISNULL(@advance_fee_adjust_amount,0)
							if @advance_fee_adjust_amount > 0
							BEGIN
								update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST - @advance_fee_adjust_amount where ADV_FEE_ID = @advance_fee_id
									delete from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = (select top(@one) fee_id from @tbl_fee_ids_delete where sr = @n)
							END
							set @n = @n + 1
						END

						insert into FEE_COLLECT_DELETED_HISTORY
						select * from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) and   FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )

						insert into FEE_COLLECT_DELETED_HISTORY_DEF
						select * from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0)))  and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))

						delete from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )
						

						declare @feeStdCount int = (select COUNT(*) from FEE_COLLECT f where f.FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID)

						if @feeStdCount= 0
						BEGIN
							update fd set fd.PLAN_FEE_IS_ONCE_PAID = 'F' from PLAN_FEE_DEF fd join FEE_INFO fi on fi.FEE_ID = fd.PLAN_FEE_DEF_FEE_NAME where PLAN_FEE_DEF_PLAN_ID = @FEE_COLLECT_FEE_ID and fi.FEE_TYPE = 'Once'
						END
						
						SET @mounth_diff = ( select DATEDIFF(MM, @FEE_COLLECT_FEE_FROM_DATE, @FEE_COLLECT_FEE_TO_DATE )) + 1
						SET @mounth_diff = (select ISNULL (@mounth_diff,0) )

						
						select @FEE_COLLECT_PLAN_ID = ISNULL(@FEE_COLLECT_PLAN_ID,0),@FEE_COLLECT_FEE_ID = ISNULL(@FEE_COLLECT_FEE_ID,0)
						
						
						
						
						select top(@one)  @old_colect = FEE_COLLECT_ID ,@fee_collect_status = FEE_COLLECT_FEE_STATUS ,@due_from_date = FEE_COLLECT_FEE_FROM_DATE,@previous =  isnull (FEE_COLLECT_FEE,0) - isnull (FEE_COLLECT_FEE_PAID,0) + isnull (FEE_COLLECT_ARREARS,0) - isnull (FEE_COLLECT_ARREARS_RECEIVED,0) from FEE_COLLECT
						where FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID  order by FEE_COLLECT_ID desc
						
						select @old_colect = isnull(@old_colect,0),@previous = isnull(@previous,0)
								
						if @fee_collect_status = 'Receivable'
						begin
							update FEE_COLLECT set FEE_COLLECT_FEE_STATUS = 'Fully Transfered' where FEE_COLLECT_ID = @old_colect
						end
						else if @fee_collect_status = 'Partially Received'
						begin
							update FEE_COLLECT set FEE_COLLECT_FEE_STATUS = 'Partially Transfered' where FEE_COLLECT_ID = @old_colect
						end

								--Move to Up because of Setting Fee To Date
							select top(@one) @Installment_Name = INSTALLMENT_NAME  ,@is_fee_generate = PLAN_FEE_IS_FEE_GENERATE, @is_formula_apply = PLAN_FEE_IS_FORMULA_APPLY,@fee_formula_fee_plan =									FeeFormula from PLAN_FEE pf
							join FeeYearlyPlanDef yd on yd.PId = pf.PLAN_FEE_YEARLY_PLAN_ID and IsDeleted = 0 and FromMonth = DATEPART(MM, @FEE_COLLECT_FEE_FROM_DATE)
							join INSTALLMENT_INFO i on i.INSTALLMENT_ID = yd.InstallmentId where PLAN_FEE_ID = @FEE_COLLECT_FEE_ID

							delete from @tbl_BillNo
							insert into @tbl_BillNo
							exec dbo.usp_GetBillNo @FEE_COLLECT_BR_ID
							select top(@one) @BillNo = BillNo, @BillNoCount = BillNoCount from @tbl_BillNo

								 insert into FEE_COLLECT
								 values
								 (
									@FEE_COLLECT_HD_ID,
									@FEE_COLLECT_BR_ID,
									@FEE_COLLECT_STD_ID,
									@FEE_COLLECT_PLAN_ID,
									@FEE_COLLECT_FEE_ID,
									0,
									0,
									@previous,
									0,
									0,
									@FEE_COLLECT_FEE_FROM_DATE,
									@FEE_COLLECT_FEE_TO_DATE,									
									GETDATE(),
									GETDATE(),
									@FEE_COLLECT_DUE_DATE,
									'Receivable',
									'NA',
									'F',
									GETDATE(),
									GETDATE(),
									@mounth_diff,
									0,0,0,0,'',
									@Installment_Name,
									@fee_formula_fee_plan,
									@BillNo, 
									@BillNoCount,
									Next Value For SqFeeChallanNo,
									@FEE_COLLECT_VALID_DATE,

									GETDATE(),
									@FEE_COLLECT_USER_ID
								 )							
								
								
							 declare @id numeric = 0		set @id = SCOPE_IDENTITY()		set @id = (select ISNULL (@id,0) )							 
							 declare @i numeric = 1
							 
							 declare @acc_datetime datetime = getdate(), @acc_prefix nvarchar(30)='FE', @acc_invoice_id  nvarchar(50), @acc_hd_id  nvarchar(50),@acc_br_id nvarchar(50), @acc_vch_main_id  nvarchar(50), @count int
							
							 set @acc_invoice_id  = CAST((@id) as nvarchar(50))
							 set @acc_hd_id = CAST((@FEE_COLLECT_HD_ID) as nvarchar(50))
							 set @acc_br_id = CAST((@FEE_COLLECT_BR_ID) as nvarchar(50))
						
								 insert into @tbl_vch exec sp_TBL_VCH_MAIN_insertion @acc_prefix, @acc_datetime, '','',@acc_invoice_id,'','',0,0,'',@acc_hd_id,@acc_br_id,0
								 set @acc_vch_main_id = (select top(@one) ID from @tbl_vch order by sr DESC )
							

							insert into FEE_COLLECT_DEF
							select PID, FeeName, Fee,FeePaid,FeeMin,FeeMax, FeeDefStatus, Operation,ISNULL(IIF(@is_rejoin = 1,0, Arrears),0)Arrears ,ArrearsReceived, Fee + ISNULL(IIF(@is_rejoin = 1,0, Arrears),0),ISNULL(Fee* (RoyaltyPercentage/ 100),0) Royalty, RoyaltyPaid, ISNULL(RoyaltyPercentage ,0), MonthlyFee
							from
							(select 
							
							@id PID, IIF(pd.PLAN_FEE_DEF_FEE_NAME is not null,pd.PLAN_FEE_DEF_FEE_NAME , FEE_COLLECT_DEF_FEE_NAME) as FeeName, 
							ROUND(IIF(fi.FEE_TYPE = 'Custom' OR fi.FEE_TYPE = 'Custom Once' OR fi.FEE_TYPE = 'Yearly', dbo.sf_GetFeeMonthCustom(fi.FEE_MONTHS, @FEE_COLLECT_FEE_FROM_DATE,@FEE_COLLECT_FEE_TO_DATE )*ISNULL(pd.PLAN_FEE_DEF_FEE,0), 
							
							IIF (fi.FEE_TYPE = 'Once',IIF(pd.PLAN_FEE_IS_ONCE_PAID = 'F', ISNULL(pd.PLAN_FEE_DEF_FEE,0),0) ,
							IIF (fi.FEE_TYPE = 'Custom Once',IIF(pd.PLAN_FEE_IS_ONCE_PAID = 'F', dbo.sf_GetFeeMonthCustom(fi.FEE_MONTHS, @FEE_COLLECT_FEE_FROM_DATE,@FEE_COLLECT_FEE_TO_DATE)*ISNULL(pd.PLAN_FEE_DEF_FEE,0),0) ,@mounth_diff * @fee_formula_fee_plan * ISNULL(pd.PLAN_FEE_DEF_FEE,0)) 
							
							)
							),0) Fee,
							
							0 FeePaid,pd.PLAN_FEE_DEF_FEE_MIN FeeMin, pd.PLAN_FEE_DEF_FEE_MAX FeeMax,'R' FeeDefStatus, IIF(pd.PLAN_FEE_DEF_FEE_NAME is not null,pd.PLAN_FEE_OPERATION , FEE_COLLECT_DEF_OPERATION) Operation, fd.FEE_COLLECT_DEF_FEE - FEE_COLLECT_DEF_FEE_PAID + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_ARREARS_RECEIVED Arrears, 0 ArrearsReceived, pd.PLAN_FEE_DEF_FEE + (fd.FEE_COLLECT_DEF_FEE - FEE_COLLECT_DEF_FEE_PAID + FEE_COLLECT_DEF_ARREARS - FEE_COLLECT_DEF_ARREARS_RECEIVED) Total , 0 Royalty,0 RoyaltyPaid,rf.ROYALTY_PERCENTAGE RoyaltyPercentage , pd.PLAN_FEE_DEF_FEE MonthlyFee

							from FEE_INFO fi
							full outer join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = fi.FEE_ID
							left join FEE_COLLECT_DEF fd  on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME  and fd.FEE_COLLECT_DEF_PID = @old_colect
							left join RoyalityClassesAllowed rc on rc.ClassId = @FEE_COLLECT_PLAN_ID
							left join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = pd.PLAN_FEE_DEF_FEE_NAME
							where  pd.PLAN_FEE_DEF_PLAN_ID = @FEE_COLLECT_FEE_ID and pd.PLAN_FEE_DEF_STATUS = 'T'
							)A

							update fd set fd.PLAN_FEE_IS_ONCE_PAID = 'T' from PLAN_FEE_DEF fd join FEE_INFO fi on fi.FEE_ID = fd.PLAN_FEE_DEF_FEE_NAME where PLAN_FEE_DEF_PLAN_ID = @FEE_COLLECT_FEE_ID and (fi.FEE_TYPE = 'Once' OR  fi.FEE_TYPE = 'Custom Once')
							

							update STUDENT_INFO set STDNT_IS_REJOIN = 0 where STDNT_ID = @FEE_COLLECT_STD_ID

							declare @TotalFee float = (select SUM(FEE_COLLECT_DEF_FEE)from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @id)
							declare @TotalArrears float = (select SUM(FEE_COLLECT_DEF_ARREARS * IIF(FEE_COLLECT_DEF_OPERATION = '+',1, -1)) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @id)
							declare @TotalRoyalty float = (select SUM(FEE_COLLECT_DEF_ROYALTY) from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @id)

							update FEE_COLLECT set FEE_COLLECT_FEE = @TotalFee, FEE_COLLECT_ARREARS = @TotalArrears, FEE_COLLECT_NET_TOATAL = @TotalFee + @TotalArrears, FEE_COLLECT_ROYALTY_FEE = @TotalRoyalty where FEE_COLLECT_ID = @id

								EXECUTE sp_Fee_Adjust_Discount @id
								 
						   EXECUTE sp_FEE_ADVANCE_CALCULATION @FEE_COLLECT_STD_ID, @FEE_COLLECT_FEE_FROM_DATE, @FEE_COLLECT_FEE_TO_DATE

							
																
								insert into FEE_HISTORY
								select FEE_COLLECT_ID,FEE_COLLECT_FEE,0,FEE_COLLECT_DATE_FEE_GENERATED,FEE_COLLECT_FEE_STATUS,FEE_COLLECT_ARREARS,FEE_COLLECT_NET_TOATAL,0,'' from FEE_COLLECT where FEE_COLLECT_ID = @id								
								
								
								insert into FEE_HISTORY_DEF
								select @id, SCOPE_IDENTITY(),FEE_COLLECT_DEF_FEE_NAME,FEE_COLLECT_DEF_FEE,0,FEE_COLLECT_DEF_MIN,FEE_COLLECT_DEF_MAX,FEE_COLLECT_DEF_OPERATION,FEE_COLLECT_DEF_ARREARS,0,FEE_COLLECT_DEF_TOTAL  from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID = @id
								
							
								

							set @meesage = 'ok'

					
					end -- when class plan and fee plan is zero

					select @meesage
					select @acc_invoice_id