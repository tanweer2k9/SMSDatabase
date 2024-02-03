


CREATE PROC [dbo].[sp_FEE_MULTIPLE_CASH_RECEIVED_VOUCHERS_AND_INSERTION]

@dt_multiple_cash [type_Multiple_Cash] readonly,
@CHEQUE_INFO_FEE_IDS nvarchar(500),
@HD_ID numeric(18,0),
@BR_ID numeric(18,0)


AS

declare @Voucher_ID nvarchar(50) = ''
declare @Voucher_BR_ID numeric = 0

declare @tbl table (Voucher_ID nvarchar(50), Voucher_BR_ID numeric)


--FIrst check this deletable OR NOT 
--[Transfer To] = '' means NOT transfered in bank delete only those entries 
--Get Records that are to be deleted that are Multiple Cash Received
insert into @tbl
select MULTI_RECEIVE_VCH_MAIN_ID, MULTI_RECEIVE_BR_ID from FEE_MULTIPLE_RECEIVED_AMOUNT r
join TBL_VCH_DEF d on r.MULTI_RECEIVE_VCH_MAIN_ID = d.VCH_MAIN_ID and r.MULTI_RECEIVE_BR_ID = CAST(d.BRC_ID as numeric)
join TBL_VCH_MAIN m on m.VCH_MID = d.VCH_MAIN_ID and m.BRC_ID = d.BRC_ID 

where MULTI_RECEIVE_INVOICE_ID in (select val from dbo.split(@CHEQUE_INFO_FEE_IDS,',')) and MULTI_RECEIVE_ID not in (select ID from @dt_multiple_cash where [Transfer To] != '')
and VCH_chequeBankName = 'Multiple Cash Received'


delete d
From TBL_VCH_DEF d
join @tbl t on t.Voucher_ID = d.VCH_MAIN_ID and t.Voucher_BR_ID = CAST(d.BRC_ID as numeric)


delete m
From TBL_VCH_MAIN m
join @tbl t on t.Voucher_ID = m.VCH_MID and t.Voucher_BR_ID = CAST(m.BRC_ID as numeric)

delete from FEE_MULTIPLE_RECEIVED_AMOUNT
where MULTI_RECEIVE_INVOICE_ID in (select val from dbo.split(@CHEQUE_INFO_FEE_IDS,',')) and MULTI_RECEIVE_ID not in (select ID from @dt_multiple_cash where [Transfer To] != '')

----Delete from tbl_vch_Main and tbl_vch_Def In case of Multiple Cash Received
--delete from TBL_VCH_DEF where VCH_MAIN_ID in (select VCH_MID from TBL_VCH_MAIN m where CAST(@CHEQUE_INFO_FEE_IDS as nvarchar(50)) in (select val from dbo.split(VCH_referenceNo,',') ) and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and VCH_chequeBankName = 'Multiple Cash Received') and CMP_ID = @HD_ID and BRC_ID = @BR_ID 

--delete from TBL_VCH_MAIN where CAST(@CHEQUE_INFO_FEE_IDS as nvarchar(50)) in (select val from dbo.split(VCH_referenceNo,',') ) and CMP_ID = @HD_ID and BRC_ID = @BR_ID and VCH_chequeBankName = 'Multiple Cash Received'

----[Transfer To] = '' means NOT transfered in bank delete only those entries
--delete from FEE_MULTIPLE_RECEIVED_AMOUNT where MULTI_RECEIVE_INVOICE_ID in (select val from dbo.split(@CHEQUE_INFO_FEE_IDS,',')) and MULTI_RECEIVE_ID in (select ID from @dt_multiple_cash where [Transfer To] = '')
--END


declare @count int =0
declare @i int = 1

declare @FEE_COLLECT_DATE date = ''
declare @FEE_CASH_IN_HAND_AMOUNT float = 0
declare @FEE_CASH_IN_HAND_CODE nvarchar(50) = ''
declare @COMMENTS nvarchar(1000) = ''

set @count = (select COUNT(*) from @dt_multiple_cash where [Transfer To] = '' OR [Transfer To] IS NULL ) --Insert only that are not transfered in bank

declare @vch_main_id nvarchar(50) = ''

WHILE @i<= @count
BEGIN

select @FEE_COLLECT_DATE = [Date],@FEE_CASH_IN_HAND_CODE= [COA Account], @FEE_CASH_IN_HAND_AMOUNT = Amount, @COMMENTS = [Comment]  from (select ROW_NUMBER() over (order by (select 0)) as sr, * from @dt_multiple_cash where [Transfer To] = ''  OR [Transfer To] is null)A where sr = @i

EXEC sp_FE_COLLECT_MULTIPLE_CHEQUES_CASH_INSERTION_IN_ACCOUNTS_VOUCHER @FEE_COLLECT_DATE,@CHEQUE_INFO_FEE_IDS,@FEE_CASH_IN_HAND_AMOUNT, 'Multiple Cash Received',@FEE_CASH_IN_HAND_CODE,0,@vch_main_id output

insert into FEE_MULTIPLE_RECEIVED_AMOUNT VALUES (@HD_ID, @BR_ID,@FEE_COLLECT_DATE,@FEE_CASH_IN_HAND_CODE, @FEE_CASH_IN_HAND_AMOUNT, (select top(1) val from dbo.split(@CHEQUE_INFO_FEE_IDS,',')),@vch_main_id, @COMMENTS ) 


set @i = @i + 1
END