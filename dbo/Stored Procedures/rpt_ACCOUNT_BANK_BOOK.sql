CREATE PROC rpt_ACCOUNT_BANK_BOOK


 @BR_ID nvarchar(50) ,
 @HD_ID nvarchar(50),
 @Bank_Account_Head nvarchar(50),
 @FROM_DATE date,
 @TO_DATE date


AS

--declare @BR_ID nvarchar(50) = '1'
--declare @HD_ID nvarchar(50) = '1'
--declare @Bank_Account_Head nvarchar(50) = '01-06-01-00000'
--declare @FROM_DATE date = '2017-01-01'
--declare @TO_DATE date = '2017-10-31'




declare @Accoun_Head_Name nvarchar(100) = '%'


if @Bank_Account_Head != '%'
BEGIN
	select  @Accoun_Head_Name = COA_Name from TBL_COA where COA_isDeleted = 0 and BRC_ID = @HD_ID and CMP_ID = @HD_ID and COA_UID = @Bank_Account_Head
END

declare @tbl table (ID int identity(1,1), [Vch ID] nvarchar(100) ,[From Date] date,[CreditAccount] nvarchar(100),Credit float, [CreditNarration] nvarchar(1000),[DebitAccount] nvarchar(100),Debit float, [DebitNarration] nvarchar(1000)  ,DebitAccountName nvarchar(100),CreditAccountName nvarchar(100))

declare @tbl_coa_banks table (COA_UID nvarchar(100), COA_Name nvarchar(100))

insert into @tbl_coa_banks
select COA_UID,COA_Name from TBL_COA where COA_isDeleted = 0 and BRC_ID = @BR_ID and CMP_ID = @HD_ID and COA_PARENTID in (select COA_UID from TBL_COA where COA_isDeleted = 0 and BRC_ID = @BR_ID and CMP_ID = @HD_ID  and COA_Name = 'Cash at Bank')


--Narration2 and From Date as To date is for Voucher Report
insert into @tbl

select * from
(
select A.VCH_MAIN_ID, CAST(A.VCH_DEF_date as date) as [Date] ,  A.VCH_DEF_COA [CreditAccount] , CASE WHEN A.VCH_DEF_COA in (select COA_UID from @tbl_coa_banks) THEN A.VCH_DEF_credit ELSE 0 END Credit,A.VCH_DEF_narration [CreditNarration] ,B.VCH_DEF_COA [DebitAccount], CASE WHEN B.VCH_DEF_COA in (select COA_UID from @tbl_coa_banks) THEN B.VCH_DEF_debit ELSE 0 END Debit,B.VCH_DEF_narration [DebitNarration],DebitAccountName,CreditAccountName from
(
select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_credit, VCH_DEF_narration,c.COA_Name [CreditAccountName] from TBL_VCH_DEF d
join TBL_COA c on c.COA_UID  = VCH_DEF_COA
where c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 and  LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and d.BRC_ID = @BR_ID and VCH_DEF_debit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE 
)A


join (
select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_debit, VCH_DEF_narration ,c.COA_Name [DebitAccountName] from TBL_VCH_DEF d 
join TBL_COA c on c.COA_UID  = VCH_DEF_COA
where c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 and LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and d.BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE
)B on B.VCH_MAIN_ID = A.VCH_MAIN_ID



--select * from
--(select VCH_MAIN_ID,D.Date,D.CreditNarration Narration,D.DebitNarration Narration2,c.COA_Name [COA Head],c1.COA_Name [Bank COA Head],D.Debit,D.Credit from
--(

--select A.VCH_MAIN_ID, CAST(A.VCH_DEF_date as date) as [Date] ,  A.VCH_DEF_COA [CreditAccount] , CASE WHEN A.VCH_DEF_COA in (select COA_UID from @tbl_coa_banks) THEN A.VCH_DEF_credit ELSE 0 END Credit,A.VCH_DEF_narration [CreditNarration] ,B.VCH_DEF_COA [DebitAccount], CASE WHEN B.VCH_DEF_COA in (select COA_UID from @tbl_coa_banks) THEN B.VCH_DEF_debit ELSE 0 END Debit,B.VCH_DEF_narration [DebitNarration] from
--(
--select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_credit, VCH_DEF_narration from TBL_VCH_DEF where LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and BRC_ID = @BR_ID and VCH_DEF_debit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE )A


--join (
--select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_debit, VCH_DEF_narration from TBL_VCH_DEF where LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE
--)B on B.VCH_MAIN_ID = A.VCH_MAIN_ID
----select CAST(A.VCH_DEF_date as date) [Date],A.VCH_MAIN_ID,A.VCH_DEF_COA [Bank COA Head],A.VCH_DEF_credit [Credit],A.VCH_DEF_narration [Narration],B.VCH_DEF_narration Narration2,B.VCH_DEF_COA [Expense Head] from 
----(select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_credit, VCH_DEF_narration from TBL_VCH_DEF where LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and BRC_ID = @BR_ID and VCH_DEF_debit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE )A

----join (select VCH_MAIN_ID,VCH_DEF_date, VCH_DEF_COA,VCH_DEF_credit, VCH_DEF_narration from TBL_VCH_DEF where LEFT(VCH_MAIN_ID,2) in ('CP','CR','BP','BR','G-') and BRC_ID = @BR_ID and VCH_DEF_credit = 0 and CAST(VCH_DEF_date as date) between @FROM_DATE and @TO_DATE)B on B.VCH_MAIN_ID = A.VCH_MAIN_ID
----where A.VCH_DEF_COA like @Bank_Account_Head OR  B.VCH_DEF_COA like @Bank_Account_Head
--)D
--join TBL_COA c on c.COA_UID  = D.CreditAccount
--join TBL_COA c1 on c.COA_UID  = D.DebitAccount
--where c.BRC_ID = @BR_ID and c.COA_isDeleted = 0 and c1.BRC_ID = @BR_ID and c1.COA_isDeleted = 0


union 

--Student Name is Credit Narration
select a.[Voucher No],Date, 'std Credit Act Head', Credit,a.[Std Name],'std Debit Act Head',Debit,'St. # '+a.[Std #] + '  Class: '+ a.Class,[COA Account],'Std Account' from dbo.[GET_FEE_VOUCHERS] (@BR_ID, @HD_ID, @FROM_DATE ,@TO_DATE ) a 
where [COA Account] like @Accoun_Head_Name and Credit = 0)A order by Date



select *,[From Date] as [To Date],(Credit + Debit) Amount, CASE WHEN CreditAccountName = 'Std Account' THEN DebitNarration  WHEN Debit != 0 and CreditAccountName != 'Std Account' THEN CreditAccountName ELSE DebitAccountName END as NarrationBankBook
,  (SELECT SUM(CASE WHEN debit =0 THEN -1 * Credit ELSE Debit END) FROM @tbl b WHERE b.id <= a.id) Balance --SUM(Credit) OVER (ORDER BY ID) --SUM(CASE WHEN debit =0 THEN -1 * Credit ELSE Debit END ) OVER (ORDER BY [Date]) Balance 
from @tbl a