CREATE proc [dbo].[sp_FEE_DAILY_RECIEVE] 

@daily_fee_start_date date,
@daily_fee_end_date date
AS





--declare @daily_fee_start_date date = ''
--declare @daily_fee_end_date date = ''


select * from
(select [Invoice ID], [Fee ID], CASE WHEN [Total Fee] > 0 THEN [Total Fee] ELSE [Total Fee backup]END as [Total Fee]  from 
 (select [Invoice ID], MAX([Fee ID]) as [Fee ID], SUM([Total Fee]) as [Total Fee], SUM([Total Fee backup]) as [Total Fee backup] from
 (
 select [His ID], [Invoice ID], [Total Fee], [Fee ID], [Total Fee] as [Total Fee backup] from 
 (select [His ID], [His PID] as [Invoice ID], [His Def Fee Received] + [His Def Arrears Received]  as [Total Fee], [His Def Fee ID] as [Fee ID],
DENSE_RANK() over (partition by [His PID] order by CAST(([His ID])  as numeric)DESC) as sra
 from VDAILY_FEE where [His Date] between @daily_fee_start_date and @daily_fee_end_date)Z where sra = 1
 union all
 select [His ID], [Invoice ID], -1 * [Total Fee], [Fee ID], 0 as [Total Fee backup] from
 (select [His ID],[His PID] as [Invoice ID], [His Def Fee Received] + [His Def Arrears Received]  as [Total Fee], [His Def Fee ID] as [Fee ID],
 DENSE_RANK() over (partition by [His PID] order by CAST(([His ID])  as numeric)DESC) as sra
 from VDAILY_FEE where [His Date] < @daily_fee_start_date)Y where sra = 1
 
 )X group by [Invoice ID], [Fee ID] 
 )W)U