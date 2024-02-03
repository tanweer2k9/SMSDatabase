
CREATE procedure  [dbo].[sp_FEE_HISTORY_selection]
     
     @FEE_HISTORY_ID  numeric,
     @status char(1)
     
     AS
     
     if(@status = 'A')
     
      BEGIN 
     
		declare @BR_ID int = 0
		select @BR_ID = FEE_COLLECT_BR_ID from FEE_COLLECT where FEE_COLLECT_ID = @FEE_HISTORY_ID

		;with cte as 
		(SELECT FEE_HISTORY_ID as [ID],FEE_HISTORY_PID InvoiceID,(select CASE WHEN FEE_COLLECT_INSTALLMENT_NAME is NULL THEN dbo.get_month_name(FEE_COLLECT_FEE_FROM_DATE,FEE_COLLECT_FEE_TO_DATE) ELSE FEE_COLLECT_INSTALLMENT_NAME END from FEE_COLLECT where FEE_COLLECT_ID = FEE_HISTORY_PID) as [Month],FEE_HISTORY_FEE as [Current Fee],FEE_HISTORY_ARREARS as Arrears,  FEE_HISTORY_NET_TOTAL as [Total Fee],ISNULL(((f3.FEE_HISTORY_PAID + f3.FEE_HISTORY_ARREARS_RECEIVED) - (SELECT  top(1) (b.FEE_HISTORY_PAID + b.FEE_HISTORY_ARREARS_RECEIVED)
                       FROM FEE_HISTORY b
                       WHERE b.FEE_HISTORY_ID < f3.FEE_HISTORY_ID and f3.FEE_HISTORY_PID = b.FEE_HISTORY_PID order by b.FEE_HISTORY_ID DESC)),0) [Partially Received], 
		
		FEE_HISTORY_PAID + FEE_HISTORY_ARREARS_RECEIVED as[Total Received], (FEE_HISTORY_FEE + FEE_HISTORY_ARREARS - FEE_HISTORY_PAID - FEE_HISTORY_ARREARS_RECEIVED) Remaining ,FEE_HISTORY_DATE as [Date],a.[COA Account] Bank

  
,FEE_HISTORY_STATUS as [Status], FEE_HISTORY_PREVIOUS_DATE as [Previous Dates]
FROM FEE_HISTORY f3
left join (select * from dbo.FEE_COLLECT_QUERY_SELECTION_GET_ACCOUNTS(@BR_ID)) a on a.[Fee Collect ID] = f3.FEE_HISTORY_PID
		 WHERE     
		FEE_HISTORY_PID in (select f1.FEE_COLLECT_ID from FEE_COLLECT f1 where f1.FEE_COLLECT_STD_ID in (select f2.FEE_COLLECT_STD_ID from FEE_COLLECT f2 where f2.FEE_COLLECT_ID = @FEE_HISTORY_ID))
		)


			,final_tbl1 as
(
select InvoiceID ID,MAX([Month])[Month], MAX([Current Fee]) [Current Fee], MAX(Arrears) Arrears, MAX([Total Fee])[Total Fee],SUM([Partially Received])[Partially Received],MAX([Total Received])[Total Received],0 Remaining,
STUFF(
(SELECT ',  ' + CONVERT(nvarchar(50), c2.[Date],103) 
FROM cte c2
WHERE c1.InvoiceID = c2.InvoiceID and [Status] like ( CASE WHEN COUNT(c1.InvoiceID) = 1 THEN '%Receivable%' ELSE '%Received%' END)

FOR XML PATH('')),1,1,'') AS [Date],max(Bank)Bank, min(Status)Status,max([Previous Dates])[Previous Dates]


from  cte c1 group by c1.InvoiceID
)
select ID,Month,[Current Fee],Arrears,[Total Fee],(f.FEE_COLLECT_FEE_PAID + f.FEE_COLLECT_ARREARS_RECEIVED - f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) [Partially Received], (f.FEE_COLLECT_FEE_PAID + f.FEE_COLLECT_ARREARS_RECEIVED - f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) [Total Received],(f.FEE_COLLECT_NET_TOATAL -f.FEE_COLLECT_FEE_PAID - f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) Remaining, Date,Bank,CASE WHEN (f.FEE_COLLECT_NET_TOATAL -f.FEE_COLLECT_FEE_PAID - f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) =0 THEN 'Fully Received' WHEN (f.FEE_COLLECT_FEE_PAID + f.FEE_COLLECT_ARREARS_RECEIVED - f.FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) = 0 THEN 'Receivable' ELSE 'Partially Received'END Status,[Previous Dates]  from final_tbl1		
join FEE_COLLECT f on f.FEE_COLLECT_ID = final_tbl1.ID
		END
		
		
	else if(@status = 'B')
		Begin
	
	 
		select FEE_HISTORY_DEF_ID as [ID],FEE_NAME as [Fee Name],FEE_HISTORY_DEF_FEE as [Fee],FEE_HISTORY_DEF_PAID as [Fee Received],FEE_HISTORY_DEF_MIN as [Min Fee Variation %],FEE_HISTORY_DEF_MAX as [Max Fee Variation %],FEE_HISTORY_DEF_OPERATION AS Operation,FEE_HISTORY_DEF_ARREARS as Arrears,FEE_HISTORY_DEF_ARREARS_RECEIVED as [Arrears Received],FEE_HISTORY_DEF_TOTAL as [Net Total]  FROM FEE_HISTORY_DEF 
		 join FEE_INFO on FEE_ID = FEE_HISTORY_DEF_NAME
		 WHERE  FEE_HISTORY_DEF_PID = @FEE_HISTORY_ID
		 
		 
		END