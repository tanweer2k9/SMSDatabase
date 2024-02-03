CREATE PROCEDURE [dbo].[rpt_PROFIT_LOSS]

	@START_DATE date,
	@END_DATE date,	
	@HD_ID numeric,
	@BR_ID numeric,
	@STATUS char(2)
AS 
BEGIN

	--declare @START_DATE date = '2013-05-24'
	--declare @END_DATE date = '2013-06-24'
	--declare @HD_ID numeric = 1
	--declare @BR_ID numeric = 0
	--declare @STATUS char(2) = 'L'


declare @total_fee numeric
declare @fee_recieved numeric
declare @fee_receivable numeric
declare @total_income numeric
declare @total_salary numeric
declare @salary_paid numeric
declare @salary_payable numeric
declare @total_expense numeric


--if @STATUS = 'L'

--BEGIN


select @total_fee =  (select sum([Total fee]) from (select SUM(FEE_COLLECT_FEE + FEE_COLLECT_ARREARS) as [Total fee]

from FEE_COLLECT where FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) and FEE_COLLECT_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and FEE_COLLECT_FEE_STATUS not in ('Fully Transfered', 'Partially Transfered')

union all

select SUM(FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED) as [Total fee]

from FEE_COLLECT where FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) and FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_DATE_FEE_GENERATED between @START_DATE and @END_DATE and FEE_COLLECT_FEE_STATUS = 'Partially Transfered'
)A)


set @total_fee = ISNULL(@total_fee,0)

select @fee_recieved = ISNULL(SUM(FEE_COLLECT_FEE_PAID + FEE_COLLECT_ARREARS_RECEIVED),0)
from FEE_COLLECT where FEE_COLLECT_BR_ID in ( select * from dbo.get_all_br_id(@BR_ID)) and FEE_COLLECT_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and FEE_COLLECT_DATE_FEE_RECEIVED between @START_DATE and @END_DATE and FEE_COLLECT_FEE_STATUS not in ('Fully Transfered')

set @fee_receivable = @total_fee - @fee_recieved

	 select @total_salary = ISNULL(SUM(STAFF_SALLERY_NET_TOLTAL), 0)	 
	 from STAFF_SALLERY	 where STAFF_SALLERY_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and STAFF_SALLERY_BR_ID in (select * from dbo.get_centralized_br_id('S',@BR_ID)) and STAFF_SALLERY_MONTH_DATE between @START_DATE and @END_DATE
	 
	 select @salary_paid = ISNULL(SUM(STAFF_SALLERY_NET_RECEIVED),0)
	 from STAFF_SALLERY where STAFF_SALLERY_HD_ID in ( select * from dbo.get_all_hd_id(@HD_ID)) and STAFF_SALLERY_BR_ID in (select * from dbo.get_centralized_br_id('S',@BR_ID)) and STAFF_SALLERY_RECEIVED_DATE between @START_DATE and @END_DATE

	 set @salary_payable = @total_salary - @salary_paid

	 select @total_income = ISNULL(SUM(Value),0) from vtrans 
	 where [Branch ID] in ( select * from dbo.get_all_br_id(@BR_ID)) and [Institute ID] in ( select * from dbo.get_all_hd_id(@HD_ID)) and [Status] = 'T' and [Type] = 'I' and [Date] between @START_DATE and @END_DATE
	 
	 
	 select @total_expense = ISNULL(SUM(Value),0) from vtrans 
	 where [Branch ID] in ( select * from dbo.get_all_br_id(@BR_ID)) and [Institute ID] in ( select * from dbo.get_all_hd_id(@HD_ID)) and [Status] = 'T' and [Type] = 'E'	 and [Date] between @START_DATE and @END_DATE

	select @total_fee as [Total Fee], @fee_recieved as [Fee received], @fee_receivable as [Fee Receivable], @total_income as [Total Income],
	@total_salary as [Total salary], @salary_paid as [Salary Paid], @salary_payable as [Salary Payable], @total_expense as [Total Expense], @START_DATE as [From Date], @END_DATE as [End Date]
--END

END