CREATE PROC [dbo].[rpt_Trail_Balance]

@BR_ID nvarchar(50),
@from_date date,
@to_date date
AS


--declare @BR_ID nvarchar(50) = '1' 

--declare @from_date date = '2016-07-01'
--declare @to_date date = '2017-06-30'






declare @total_fee_generate float = 0
declare @total_fee_received float = 0
--Fees

select @total_fee_generate = (SUM(VCH_DEF_credit) - SUM(VCH_DEF_debit)) from TBL_VCH_DEF where BRC_ID =@BR_ID and VCH_DEF_COA in (select COA_UID from TBL_COA where BRC_ID = @BR_ID and  COA_isDeleted = 0 and COA_PARENTID in (select COA_UID  from TBL_COA where BRC_ID = @BR_ID and COA_isDeleted = 0 and COA_Name = 'Fees')) and  VCH_DEF_date between @from_date and @to_date 

--Fee Received Cash at Bank
select @total_fee_received = 
(select SUM(VCH_DEF_debit)  from TBL_VCH_DEF where BRC_ID = @BR_ID and  VCH_DEF_date between @from_date and @to_date and VCH_DEF_ItemCOA in ('Multiple Cheques Received','Transfered To','Multiple Cash Received','') and VCH_MAIN_ID like 'FE%' and VCH_DEF_COA in (select COA_UID from TBL_COA where BRC_ID = @BR_ID and  COA_isDeleted = 0 and COA_PARENTID in (select COA_UID  from TBL_COA where BRC_ID = @BR_ID and COA_isDeleted = 0 and COA_Name = 'Cash at Bank')) ) 
+


--Fee Received Cash at hand
(select SUM(VCH_DEF_debit) as Debit  from TBL_VCH_DEF where BRC_ID = @BR_ID and VCH_DEF_ItemCOA in ('','Multiple Cash Received') and VCH_DEF_prefix != 'Transfered From' and VCH_MAIN_ID like 'FE%' and VCH_DEF_COA in (select COA_UID from TBL_COA where BRC_ID = @BR_ID and  COA_isDeleted = 0 and COA_PARENTID in (select COA_UID  from TBL_COA where BRC_ID = @BR_ID and COA_isDeleted = 0 and COA_Name = 'Cash in Hand')) )



declare @tbl_expense table ([Head of Accounts] nvarchar(2000), Debit float,Credit float)



declare @cash_equivalant float = 0



--Expenses
insert into @tbl_expense
select c.COA_Name [Head of Accounts], Debit,Credit from
(select VCH_DEF_COA,SUM(VCH_DEF_debit) Debit, SUM(VCH_DEF_credit) Credit from
(select * from TBL_VCH_DEF where BRC_ID =@BR_ID and VCH_DEF_COA in (select COA_UID from TBL_COA where BRC_ID = @BR_ID and  COA_isDeleted = 0 and COA_PARENTID in (select COA_UID  from TBL_COA where BRC_ID = @BR_ID and COA_isDeleted = 0 and COA_Name = 'Expenses')) and  VCH_DEF_date between @from_date and @to_date and VCH_MAIN_ID not like '%SA%')A group by VCH_DEF_COA
)B
join TBL_COA c on c.COA_UID = B.VCH_DEF_COA
where c.BRC_ID = @BR_ID and c.COA_isDeleted =0 

set @cash_equivalant = @total_fee_received - (select SUM(Debit - Credit) from @tbl_expense)

--select SUM(Debit), SUM(Credit) from
--(
select * from @tbl_expense where (debit > 0 OR Credit > 0)
union

select 'Fee', 0, @total_fee_generate 
union
select 'Fee Receivable', (@total_fee_generate - @total_fee_received),0
union 
select 'Cash and Equivalent', (select CASE WHEN @cash_equivalant > 0 THEN @cash_equivalant ELSE 0 END),(select CASE WHEN @cash_equivalant < 0 THEN -1 * @cash_equivalant ELSE 0 END)

--)A
--