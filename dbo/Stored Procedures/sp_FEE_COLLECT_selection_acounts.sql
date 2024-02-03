
CREATE PROC [dbo].[sp_FEE_COLLECT_selection_acounts]

     @FEE_COLLECT_ID  numeric,
     @FEE_COLLECT_HD_ID  numeric,
     @FEE_COLLECT_BR_ID  numeric	 


	 AS


--	 declare @FEE_COLLECT_HD_ID numeric = 1
--declare @FEE_COLLECT_BR_ID numeric = 2
--declare @FEE_COLLECT_ID numeric = 173203
declare @cash_in_hand nvarchar(100) = ''
 select @cash_in_hand = COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_Name = 'Cash in Hand' and COA_isDeleted = 0

declare @cash_at_bank nvarchar(100) = ''
 select @cash_at_bank = COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_Name = 'Cash at Bank' and COA_isDeleted = 0


select distinct VCH_referenceNo as InvoiceID, VCH_DEF_COA as bank_code, VCH_DEF_credit as Cash_at_bank, 'Cash at Bank' [Cash Type] from 
TBL_VCH_MAIN vm
left join TBL_VCH_DEF vd on vd.VCH_MAIN_ID = vm.VCH_MID
join TBL_COA c on vd.VCH_DEF_COA in (select COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_PARENTID = @cash_at_bank) and vm.VCH_prefix = 'FE' and vm.VCH_chequeBankName not in( 'Multiple Cheques Received', 'Multiple Cash Received')

union all

select distinct VCH_referenceNo as InvoiceID, VCH_DEF_COA hand_code, VCH_DEF_credit as Cash_in_hand, 'Cash in Hand' [Cash Type] from 
TBL_VCH_MAIN vm
left join TBL_VCH_DEF vd on vd.VCH_MAIN_ID = vm.VCH_MID
join TBL_COA c on vd.VCH_DEF_COA in (select COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_PARENTID = @cash_in_hand
 ) and vm.VCH_prefix = 'FE' and vm.VCH_chequeBankName not in( 'Multiple Cheques Received', 'Multiple Cash Received')



----select * 
----from VFEE_COLLECT f
----left join

----(
--select tbl_cash.InvoiceID as [Invoice ID],ISNULL(hand_code, '')hand_code, ISNULL(Cash_in_hand,0) Cash_in_hand , ISNULL(bank_code, '') bank_code,ISNULL(Cash_at_bank,0) Cash_at_bank,
-- ISNULL(chequ_date,GETDATE())chequ_date, ISNULL(cheque_no, '')cheque_no
-- from
--(select distinct VCH_referenceNo as InvoiceID, VCH_DEF_COA hand_code, VCH_DEF_credit as Cash_in_hand from 
--TBL_VCH_MAIN vm
--left join TBL_VCH_DEF vd on vd.VCH_MAIN_ID = vm.VCH_MID
--join TBL_COA c on vd.VCH_DEF_COA in (select COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
--and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_PARENTID = @cash_in_hand
-- )) tbl_cash
-- left join 
-- (select distinct VCH_referenceNo as InvoiceID, VCH_DEF_COA as bank_code, VCH_DEF_credit as Cash_at_bank, VCH_chequeNo as cheque_no, VCH_date as chequ_date from 
--TBL_VCH_MAIN vm
--left join TBL_VCH_DEF vd on vd.VCH_MAIN_ID = vm.VCH_MID
--join TBL_COA c on vd.VCH_DEF_COA in (select COA_UID from TBL_COA where CMP_ID = CAST(@FEE_COLLECT_HD_ID as nvarchar(50))
--and BRC_ID = CAST(@FEE_COLLECT_BR_ID as nvarchar(50)) and COA_PARENTID = @cash_at_bank
-- ))tbl_bank
-- on tbl_cash.InvoiceID = tbl_bank.InvoiceID


-- --) A on A.[Invoice ID] = f.ID