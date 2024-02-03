CREATE PROC [dbo].[sp_FEE_COLLECTION_updation_ACCOUNTS_INSERTION]
							 @FEE_COLLECT_ID  numeric,
							 @FEE_CASH_IN_HAND_AMOUNT float,
							@FEE_CASH_AT_BANK_AMOUNT float,
							@FEE_CASH_IN_HAND_CODE nvarchar(50),
							@FEE_CASH_AT_BANK_CODE nvarchar(50),
							@VCH_DEF_ItemCOA nvarchar(50) = ''
         
							AS
							
							
							
							
							
							
							
							
							declare @acc_total_fee float = 0
							declare @FEE_COLLECT_PLAN_ID numeric = 0
							declare @acc_fee_invoice_periods nvarchar(100)= 'Fee Invoice Months'
							declare @fee_months_coa_name nvarchar(100)= ''
							declare @FEE_COLLECT_FEE_FROM_DATE date = ''
							declare @FEE_COLLECT_FEE_TO_DATE date = ''							      
							declare @VCH_DEF_COA nvarchar(50) = ''
							declare @VCH_TYPE nvarchar(50) = ''
							declare @debit float = 0
							declare @credit float = 0
							declare @VCH_reference_no nvarchar(50) = ''
							declare @datetime datetime = ''
							declare @HD_ID nvarchar(50) = ''
							declare @BR_ID nvarchar(50) = ''
							declare @VCH_MAIN_ID nvarchar(50) = ''
							declare @arears float = 0
							declare @fee_receieved float = 0
							declare @accRefNo nvarchar(100) = ''
							
							

								set @VCH_MAIN_ID = (select top(1) VCH_MID from TBL_VCH_MAIN where VCH_referenceNo = CAST((@FEE_COLLECT_ID) as nvarchar(50)))
								
								select @datetime = FEE_COLLECT_DATE_FEE_RECEIVED,  @acc_total_fee = (FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED), @FEE_COLLECT_FEE_FROM_DATE = FEE_COLLECT_FEE_FROM_DATE,
								@FEE_COLLECT_FEE_TO_DATE = FEE_COLLECT_FEE_TO_DATE, @FEE_COLLECT_PLAN_ID = FEE_COLLECT_PLAN_ID,
								 @HD_ID = CAST((FEE_COLLECT_HD_ID) as nvarchar(50)), @BR_ID = CAST((FEE_COLLECT_BR_ID) as nvarchar(50))
								 from FEE_COLLECT where FEE_COLLECT_ID = @FEE_COLLECT_ID
							
							
								declare @cash_in_hand_account nvarchar(100) =''
								select @cash_in_hand_account =  COA_UID from TBL_COA where COA_Name = 'Cash in Hand' and CMP_ID = @HD_ID and BRC_ID = @BR_ID 


								declare @cash_at_bank_account nvarchar(100) =''
								select @cash_at_bank_account =  COA_UID from TBL_COA where COA_Name = 'Cash at Bank' and CMP_ID = @HD_ID and BRC_ID = @BR_ID 

								--select COA_UID from TBL_COA where COA_PARENTID = @cash_in_hand_account

								delete from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA in (select COA_UID from TBL_COA where COA_PARENTID = @cash_in_hand_account)


								declare @is_profit_loss bit = (select CAST(1 as bit))

									if @VCH_DEF_ItemCOA = 'Multiple Cheques'
										set @is_profit_loss = (select CAST(0 as bit))

								--cash in hand acccount insertion
								if @FEE_CASH_IN_HAND_AMOUNT != 0
								BEGIN
									--set @credit = @FEE_CASH_IN_HAND_AMOUNT --This will be in debit
									set @debit = @FEE_CASH_IN_HAND_AMOUNT
									
									exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @FEE_CASH_IN_HAND_CODE,@debit,@credit,0,0,'','I','',@datetime,@VCH_DEF_ItemCOA,'','',@HD_ID, @BR_ID,0,@is_profit_loss, '' --Last Parameter is optional Passing Value 'Multiple Cheques' 
								END

								delete from TBL_VCH_DEF where VCH_MAIN_ID = @VCH_MAIN_ID and VCH_DEF_COA in (select COA_UID from TBL_COA where COA_PARENTID = @cash_at_bank_account)
								if @FEE_CASH_AT_BANK_AMOUNT != 0
								BEGIN
									--cash at bank account insertion
									--set @credit = @FEE_CASH_AT_BANK_AMOUNT
									set @debit = @FEE_CASH_AT_BANK_AMOUNT

									
								
									
									
									exec sp_TBL_VCH_DEF_insertion @VCH_MAIN_ID, @FEE_CASH_AT_BANK_CODE,@debit,@credit,0,0,'','I','',@datetime,@VCH_DEF_ItemCOA,'','',@HD_ID, @BR_ID,0,@is_profit_loss,''
								END