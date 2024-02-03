CREATE PROC [dbo].[rpt_STUDENT_FEE_HISTORY]

     @FEE_COLLECT_HD_ID  numeric,
     @FEE_COLLECT_BR_ID  numeric,
	 @FEE_COLLECT_DATE date

AS
select [Std ID], [Fee Month],Received,Receivable from (SELECT FEE_COLLECT_STD_ID as [Std ID], (FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID) as Received,
FEE_COLLECT_NET_TOATAL - (FEE_COLLECT_ARREARS_RECEIVED + FEE_COLLECT_FEE_PAID) as Receivable,
dbo.get_month_name ( FEE_COLLECT_FEE_FROM_DATE ,FEE_COLLECT_FEE_TO_DATE ) as [Fee Month],
Row_number()   OVER ( partition BY FEE_COLLECT_STD_ID ORDER BY Cast(Fee_collect_id AS INT) DESC) rn 
FROM  FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE < @FEE_COLLECT_DATE)A where rn <= 12 and [Std ID] in (select [Std ID] from rpt_V_FEE_SLIP where [Institute ID] = @FEE_COLLECT_HD_ID 
		    and [Branch ID] = @FEE_COLLECT_BR_ID
		    and [Status] = 'Receivable'
		    and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
		    and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))