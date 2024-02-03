
CREATE PROC [dbo].[sp_FE_COLLECT_MULTIPLE_CHEQUES_CASH_INSERTION_IN_ACCOUNTS_VOUCHER]


 @acc_datetime date,
 @Fee_IDS nvarchar(500),-- This will include all students
 @amount float,
 @VCH_DEF_ItemCOA nvarchar(100),
 @COA_Account nvarchar(100),
 @CHEQUE_ID numeric,
 @acc_vch_main_id nvarchar(50) output

AS




declare @acc_prefix nvarchar(50) = 'FE'

declare @acc_hd_id nvarchar(100) = ''
declare @acc_br_id nvarchar(100) = ''
declare @tbl_vch table (sr int identity(1,1),[status] nvarchar(50), ID nvarchar(50))
--declare @acc_vch_main_id nvarchar(50) = ''
declare @VCH_DEF_COA nvarchar(100) = ''
declare @debit float = 0
declare @credit float = 0
declare @datetime datetime = getdate()
declare @invoice_id numeric = 0
declare @tbl_fee_ids table ([Fee ID] numeric)
declare @std_id numeric = 0

declare @vch_Reference_No nvarchar(50) = ''

insert into @tbl_fee_ids
select val from dbo.split(@Fee_IDS,',')

set @invoice_id = (select top(1) [Fee ID] from @tbl_fee_ids)

		select @acc_hd_id = CAST((FEE_COLLECT_HD_ID) as nvarchar(50)), @acc_br_id = CAST((FEE_COLLECT_BR_ID) as nvarchar(50)),@std_id = FEE_COLLECT_STD_ID from FEE_COLLECT where FEE_COLLECT_ID = @invoice_id


if @VCH_DEF_ItemCOA = 'Multiple Cash Received'
BEGIN
	set @vch_Reference_No = @Fee_IDS --Cheque No is Fee IDS Due to deletion of this record otherwise No any method to fetch this record
END
ELSE
BEGIN
	set @vch_Reference_No = CAST(@CHEQUE_ID as numeric) ---Checque ID From Cheque_Info table
END


 insert into @tbl_vch
exec sp_TBL_VCH_MAIN_insertion @acc_prefix, @acc_datetime, '','',@vch_Reference_No,'','',0,0,'',@acc_hd_id,@acc_br_id,0,@VCH_DEF_ItemCOA

 set @acc_vch_main_id = (select top(1) ID from @tbl_vch order by sr DESC )


 set @VCH_DEF_COA = (select top(1) COA_UID from TBL_COA where COA_ID = (select STDNT_COA_ID from STUDENT_INFO where STDNT_ID = @std_id ) )





 --Studnet Head So Amount will be credit
 set @credit = @amount
 exec sp_TBL_VCH_DEF_insertion @acc_vch_main_id, @VCH_DEF_COA,@debit,@credit,0,0,@Fee_IDS,'I','',@datetime,@VCH_DEF_ItemCOA,'','',@acc_hd_id, @acc_br_id,0,1,''


 set @VCH_DEF_COA = @COA_Account
 set @credit = 0
 set @debit = @amount
 exec sp_TBL_VCH_DEF_insertion @acc_vch_main_id, @VCH_DEF_COA,@debit,@credit,0,0,@Fee_IDS,'I','',@datetime,@VCH_DEF_ItemCOA,'','',@acc_hd_id, @acc_br_id,0,1,''