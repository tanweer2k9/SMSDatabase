
CREATE PROC [dbo].[rpt_VOUCHER_PRINT_MAIN]


@HD_ID nvarchar(50),
@BR_ID nvarchar(50) ,
@VOUCHER_ID nvarchar(MAX),
@From_Date date,
@To_Date date,
@Status nvarchar(50),
@COA_ACCOUNT_HEAD nvarchar(50)

AS

--declare @HD_ID nvarchar(50) = 1,
--@BR_ID nvarchar(50)  = 1,
--@From_Date date = '2018-08-01',
--@To_Date date = '2018-08-31',
--@COA_ACCOUNT_HEAD nvarchar(50) = '01-06-03-00000'




declare @tbl table (Prefix nvarchar(50), [Full Name] nvarchar(50))


insert into @tbl select 'CP', 'Cash Payment'
insert into @tbl select 'BP', 'Bank Payment'
insert into @tbl select 'CR', 'Cash Receipt'
insert into @tbl select 'BR', 'Bank Receipt'

if @Status = 'Voucher'
BEGIN
	select VCH_MID [Voucher No], t.[Full Name] [Prefix], VCH_date [Date], ROW_NUMBER() over ( order by m.VCH_date ASC,m.VCH_MID ) [Voucher Series]
	from TBL_VCH_MAIN  m
	left join @tbl t on m.VCH_prefix = t.Prefix
	left join TBL_VCH_SERIES s on m.VCH_MID = s.VCH_SERIES_VCH_MAIN_ID and s.VCH_SERIES_BR_ID = @BR_ID

	where CMP_ID = @HD_ID and BRC_ID = @BR_ID and VCH_MID  in (select val from dbo.split(@VOUCHER_ID,','))
	order by  m.VCH_date ASC,m.VCH_MID--s.VCH_SERIES_VCH_PREFIX, s.VCH_SERIES_BANK_CODE,s.VCH_SERIES_NUMBER

END


else if  @Status = 'Fee Voucher'
BEGIN
--This includes all three cases Cash at bank i.e VCH_DEF_ItemCOA = ,VCH_DEF_ItemCOA = Multiple cheque Received and VCH_DEF_ItemCOA = Transfer to means Cash transfer to bank 
	
	declare @tbl_fee_vouchers table (BrId nvarchar(10), [Voucher No]  nvarchar(100), Prefix nvarchar(100),[Date] date, VCH_SERIES_BANK_CODE nvarchar(100), VCH_SERIES_DATE Date )



--declare @BR_ID_local numeric = 0

--set @BR_ID_local = @BR_ID
declare @BANK_Name nvarchar(50)= ''

set @BANK_Name = (select COA_Name from TBL_COA where COA_isDeleted = 0 and COA_UID = @COA_ACCOUNT_HEAD and BRC_ID = @BR_ID)	


declare @count int = 0
declare @i int = 1

set @count= (select COUNT(*) from COMBINE_BRANCHES c where c.FROM_BRANCH_ID = @BR_ID)

WHILE @i <= @count
BEGIN
				select @BR_ID = COMBINE_BRANCHES_ID from  (select ROW_NUMBER() over (order by (select 0)) as sr,c.COMBINE_BRANCHES_ID from COMBINE_BRANCHES c where c.FROM_BRANCH_ID = @BR_ID)A where sr = @i
	
	select @HD_ID = BR_ADM_HD_ID  from BR_ADMIN where BR_ADM_ID = @BR_ID

	set @COA_ACCOUNT_HEAD = (select COA_UID from TBL_COA where COA_isDeleted = 0 and BRC_ID = @BR_ID and COA_Name = @BANK_Name)

	
	insert into @tbl_fee_vouchers

		select m.BRC_ID,VCH_MID [Voucher No], 'Bank Receipt' [Prefix], VCH_date [Date] ,b.BankCode VCH_SERIES_BANK_CODE,m.VCH_date
	from TBL_VCH_MAIN  m 
	
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID and m.BRC_ID = d.BRC_ID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
	join BankCode b on b.BankName = c.COA_Name
where VCH_DEF_COA = @COA_ACCOUNT_HEAD

--(select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and COA_Name ='Cash at Bank')) 
 and d.CMP_ID 
 =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA != 'Multiple Cheques' )  



	--left join TBL_VCH_SERIES s on m.VCH_MID = s.VCH_SERIES_VCH_MAIN_ID and s.VCH_SERIES_BR_ID = @BR_ID
	and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and CAST(m.VCH_date as date) between @From_Date and @To_Date 
	union all
	select m.BRC_ID,VCH_MID [Voucher No], 'Bank Payment' [Prefix], VCH_date [Date] ,b.BankCode VCH_SERIES_BANK_CODE,m.VCH_date
	from TBL_VCH_MAIN  m 
	
join TBL_VCH_DEF d on d.VCH_MAIN_ID = m.VCH_MID and m.BRC_ID = d.BRC_ID
join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
join BankCode b on b.BankName = c.COA_Name
where VCH_DEF_COA = @COA_ACCOUNT_HEAD and d.CMP_ID  =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'BR%' and m.CMP_ID = @HD_ID and m.BRC_ID = @BR_ID and CAST(m.VCH_date as date) between @From_Date and @To_Date 
	--and m.VCH_MID in
--	(select d.VCH_MAIN_ID
----d.VCH_DEF_countID, m.VCH_ID,m.VCH_referenceNo,d.VCH_DEF_debit,d.VCH_DEF_COA,c.COA_Name
--from TBL_VCH_DEF d
--join TBL_COA c on c.COA_UID = d.VCH_DEF_COA and c.CMP_ID = @HD_ID and c.BRC_ID = @BR_ID and c.COA_isDeleted = 0
	
--where VCH_DEF_COA = @COA_ACCOUNT_HEAD

----(select c1.COA_UID from TBL_COA c1 where c1.CMP_ID = @HD_ID and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0 and c1.COA_PARENTID in (select c2.COA_UID from TBL_COA c2 where c2.CMP_ID = @HD_ID and c2.BRC_ID = @BR_ID and c2.COA_isDeleted = 0 and COA_Name ='Cash at Bank')) 
-- and d.CMP_ID 
-- =@HD_ID and d.BRC_ID = @BR_ID and d.VCH_MAIN_ID like 'FE%' and (d.VCH_DEF_ItemCOA is null OR d.VCH_DEF_ItemCOA != 'Multiple Cheques' )  )

  
	set @i = @i + 1
END

	


   select BrId,[Voucher No], Prefix, [Date], (ISNULL(VCH_SERIES_BANK_CODE, '') + CAST([Voucher Serial] as nvarchar(10))) [Voucher Series] from
	(
	
	select *,  ROW_NUMBER() over ( order by  VCH_SERIES_DATE,Date ASC,[Voucher No] ) as [Voucher Serial]--s.VCH_SERIES_VOUCHER_SERIES [Voucher Series]
	from @tbl_fee_vouchers
	
 )B
 order by VCH_SERIES_DATE,Date ASC,[Voucher No]--s.VCH_SERIES_VCH_PREFIX, s.VCH_SERIES_BANK_CODE,s.VCH_SERIES_NUMBER
END