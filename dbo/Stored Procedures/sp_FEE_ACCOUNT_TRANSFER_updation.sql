CREATE PROC [dbo].[sp_FEE_ACCOUNT_TRANSFER_updation]

@IDS nvarchar(1000),
@FEE_IDS nvarchar(1000),
@HD_ID nvarchar(50),
@BR_ID nvarchar(50),
@BANK_DEPOSITE_DATE date,
@BANK_HEAD nvarchar(50)

AS


declare @tbl table (Sr int,VCH_DEF_Count_ID numeric)

insert into @tbl
select  id ,CAST(val as numeric) from dbo.split(@IDS,',')


declare @tbl_vch table (sr int identity(1,1),[status] nvarchar(50), ID nvarchar(50))

--@HD_ID nvarchar(50) = 1,
--@BR_ID nvarchar(50) = 1



declare @count int = 0
declare @i int = 1
set @count = (select COUNT(*) from @tbl)

declare @vch_Def_Count_ID numeric
declare 
 @VCH_MAIN_ID  nvarchar(37) ,
          @VCH_DEF_COA  nvarchar(30) ,
          @VCH_DEF_debit  float,
          @VCH_DEF_credit  float,
          @VCH_DEF_debit1  float,
          @VCH_DEF_credit1  float,
          @VCH_DEF_referenceNo  varchar(50) ,
          @VCH_DEF_remarks  varchar(100) ,
          @VCH_DEF_GRDNo  nvarchar(50) ,
          @VCH_DEF_date  datetime = getdate(),
          @VCH_DEF_ItemCOA  nvarchar(50) ='',
          @VCH_DEF_narration  nvarchar(50) ,
          @VCH_DEF_prefix  nvarchar(50) ,
		  @CMP_ID  nvarchar(50),
		  @BRC_ID  nvarchar(50),
		  @VCH_DEF_isDeleted bit,
		  @VCH_DEF_isEffectOnProfitLoss bit = 1,
		  @VCH_DEF_accRefNo nvarchar(50)

		  declare @vch_Reference_No nvarchar(1000) = ''

		  set @vch_Reference_No = @FEE_IDS

--Set Vch_Cheque_Bank_Name to Transfer TO
 insert into @tbl_vch
exec sp_TBL_VCH_MAIN_insertion 'FE', @BANK_DEPOSITE_DATE, '','',@vch_Reference_No,'','',0,0,'',@HD_ID,@br_id,0,'Transfered To'


declare @VCH_MID nvarchar(50) = ''

 set @VCH_MID = (select top(1) ID from @tbl_vch order by sr DESC )


 declare @total_debit_amount float = 0

WHILE @i<= @count

BEGIN

set @vch_Def_Count_ID = (select VCH_DEF_Count_ID from @tbl where Sr = @i)

select @CMP_ID = [CMP_ID],@BRC_ID = [BRC_ID],  @VCH_DEF_COA = [VCH_DEF_COA], @VCH_DEF_debit=[VCH_DEF_debit], @VCH_DEF_referenceNo = [VCH_DEF_referenceNo],@VCH_MAIN_ID = VCH_MAIN_ID
from
TBL_VCH_DEF where VCH_DEF_countID = @vch_Def_Count_ID

update TBL_VCH_DEF set VCH_DEF_prefix = 'Transfered From' where VCH_DEF_countID = @vch_Def_Count_ID

--Set Vch_Cheque_Bank_Name Main Table Transfered From
update TBL_VCH_MAIN set VCH_chequeBankName = 'Transfered From' where CMP_ID =@HD_ID and  BRC_ID = @BR_ID and  VCH_MID in (select VCH_MAIN_ID from TBL_VCH_DEF where VCH_DEF_countID = @vch_Def_Count_ID)

--Because we are going to transfer cash amount in the bank So now Cash amount will be Credit and in last Bank head will be Debit
set @VCH_DEF_credit = @VCH_DEF_debit

set @VCH_DEF_ItemCOA = 'Transfered To'

if @VCH_DEF_referenceNo = ''
	set @VCH_DEF_referenceNo = (select top(1) VCH_referenceNo from TBL_VCH_MAIN where VCH_MID = @VCH_MAIN_ID and CMP_ID =@HD_ID and  BRC_ID = @BR_ID)

exec sp_TBL_VCH_DEF_insertion @VCH_MID, @VCH_DEF_COA,0,@VCH_DEF_credit,0,0,@VCH_DEF_referenceNo,'I',@vch_Def_Count_ID,@VCH_DEF_date,'Transfered To','','',@HD_ID, @BR_ID,0,@VCH_DEF_isEffectOnProfitLoss,''

set @total_debit_amount = @total_debit_amount + @VCH_DEF_credit



set @i = @i + 1
END

exec sp_TBL_VCH_DEF_insertion @VCH_MID, @BANK_HEAD,@total_debit_amount,0,0,0,'','I','',@VCH_DEF_date,@VCH_DEF_ItemCOA,'','Transfered To',@HD_ID, @BR_ID,0,@VCH_DEF_isEffectOnProfitLoss,''

select 'ok' status, @VCH_MID [Vch Main ID]