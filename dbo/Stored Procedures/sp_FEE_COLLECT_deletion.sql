
CREATE PROC [dbo].[sp_FEE_COLLECT_deletion]

@INVOICE_ID numeric


AS




declare @FEE_COLLECT_FEE_FROM_DATE date = '2017-11-01'
declare @FEE_COLLECT_FEE_TO_DATE date = '2017-12-28',
@FEE_COLLECT_HD_ID numeric= 1,
@FEE_COLLECT_BR_ID numeric = 1,
@FEE_COLLECT_STD_ID  numeric = 50300



select @FEE_COLLECT_FEE_FROM_DATE = FEE_COLLECT_FEE_FROM_DATE, @FEE_COLLECT_FEE_TO_DATE = FEE_COLLECT_FEE_TO_DATE, @FEE_COLLECT_HD_ID = FEE_COLLECT_HD_ID, @FEE_COLLECT_BR_ID  = FEE_COLLECT_BR_ID, @FEE_COLLECT_STD_ID = FEE_COLLECT_STD_ID  from FEE_COLLECT where FEE_COLLECT_ID = @INVOICE_ID


declare @tbl_fee_ids_delete table (sr int identity(1,1), fee_id numeric)
		declare @count_advance_fee int = 0
		declare @n int = 1

		declare @advance_fee_adjust_amount float = 0
		declare @advance_fee_id numeric = 0

			insert into FEE_COLLECT_DELETED_HISTORY
						select * from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )

						insert into FEE_COLLECT_DELETED_HISTORY_DEF
						select * from FEE_COLLECT_DEF where FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_FROM_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0))) and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))


							   delete from TBL_VCH_DEF where VCH_MAIN_ID in
								(select VCH_MID from TBL_VCH_MAIN where TBL_VCH_MAIN.VCH_prefix = 'FE' and VCH_referenceNo in
							  ( select CAST((FEE_COLLECT_ID) as nvarchar(50)) from FEE_COLLECT 
							where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) 
							and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) 
							and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA'
							 and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )))

							 delete from TBL_VCH_MAIN where TBL_VCH_MAIN.VCH_prefix = 'FE' and VCH_referenceNo in
							  ( select CAST((FEE_COLLECT_ID) as nvarchar(50)) from FEE_COLLECT 
							where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) 
							and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) 
							and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA'
							 and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))
							 
							 										
												delete from SCHOLARSHIP_GENERATION where SCH_GEN_FEE_COLLECT_ID in (select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID ))
						
						--delete from multiple Fee Received AMount
						delete from FEE_MULTIPLE_RECEIVED_AMOUNT where MULTI_RECEIVE_INVOICE_ID = @INVOICE_ID
						
						--delete and adjust advance fee

						insert into @tbl_fee_ids_delete
						select FEE_COLLECT_ID from FEE_COLLECT where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )

						set @count_advance_fee = (select COUNT(*) from @tbl_fee_ids_delete)
						WHILE @n <= @count_advance_fee
						BEGIN
							set @advance_fee_adjust_amount = 0 
							select @advance_fee_adjust_amount = ADV_FEE_DEF_AMOUNT, @advance_fee_id = ADV_FEE_DEF_PID from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = (select top(1) fee_id from @tbl_fee_ids_delete where sr = @n)

							set @advance_fee_adjust_amount = ISNULL(@advance_fee_adjust_amount,0)
							if @advance_fee_adjust_amount > 0
							BEGIN
								update FEE_ADVANCE set ADV_FEE_AMOUNT_ADJUST = ADV_FEE_AMOUNT_ADJUST - @advance_fee_adjust_amount where ADV_FEE_ID = @advance_fee_id
									delete from FEE_ADVANCE_DEF where ADV_FEE_DEF_FEE_COLLECT_ID = (select top(1) fee_id from @tbl_fee_ids_delete where sr = @n)
							END
							set @n = @n + 1
						END

						
						delete from FEE_ADVANCE where ADV_FEE_COLLECT_ID = @INVOICE_ID
						----delete from CHEQUE_INFO where CHEQ_ID in (select * from CHEQ_FEE_INFO where CHEQ_FEE_COLLECT_ID = )
						delete from CHEQ_FEE_INFO where CHEQ_FEE_COLLECT_ID = @INVOICE_ID

						--Fee Type Once and Custom Once Deletion Invoice Issue
						--select * From FEE_COLLECT f
						--join FEE_COLLECT_DEF fd on f.FEE_COLLECT_ID = fd.FEE_COLLECT_DEF_PID and fd.FEE_COLLECT_DEF_FEE > 0
						--join FEE_INFO fi on fi.FEE_ID =  fd.FEE_COLLECT_DEF_FEE_NAME and fi.FEE_TYPE = 'Custom Once'
						--join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = fi.FEE_ID
						--where  fi.FEE_TYPE = 'Custom Once' and f.FEE_COLLECT_ID = @INVOICE_ID and select * from  fi.FEE_MONTHS
						delete from FEE_PRINT_HISTORY where FEE_PRINT_HISTORY_BILL_ID = @INVOICE_ID

						delete from FEE_COLLECT where ( FEE_COLLECT_FEE_TO_DATE between DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_FROM_DATE),0) and DATEADD(DD,-1,DATEADD(MM,1,DATEADD(MM, DATEDIFF(MM, 0,@FEE_COLLECT_FEE_TO_DATE),0))) and FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and  FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID and FEE_COLLECT_OPB = 'NA' and FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID )
						

update fee_Collect set FEE_COLLECT_FEE_STATUS = CASE WHEN (FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID) = 0 THEN   'Receivable' ELSE 'Partially Received' END
where fee_Collect.FEE_COLLECT_ID in
(select top(1) f.FEE_COLLECT_ID from FEE_COLLECT f where f.FEE_COLLECT_STD_ID = @FEE_COLLECT_STD_ID and f.FEE_COLLECT_HD_ID = @FEE_COLLECT_HD_ID and f.FEE_COLLECT_BR_ID = @FEE_COLLECT_BR_ID order by f.FEE_COLLECT_ID DESC)