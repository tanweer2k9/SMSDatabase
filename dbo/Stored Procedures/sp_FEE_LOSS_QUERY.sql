
CREATE PROC [dbo].[sp_FEE_LOSS_QUERY]

@HD_ID numeric,
@BR_ID numeric,
@START_DATE date,
@END_DATE date


AS
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1

--declare @START_DATE date = '2016-09-01'
--declare @END_DATE date = '2017-08-30'

select ROW_NUMBER() over (order by [Class_ID],[School ID]) as Sr,ID,[Std #],Name,Class, Period, Fee,[Total Fee],Received,[Amount Loss],[Fee Status] from 
(select ROW_NUMBER() over ( partition by f.FEE_COLLECT_STD_ID order by f.FEE_COLLECT_ID DESC) as nmbr,  [Class_ID],CAST(STDNT_SCHOOL_ID as int) [School ID] ,s.STDNT_ID ID, s.STDNT_SCHOOL_ID [Std #], s.STDNT_FIRST_NAME Name,sp.CLASS_Name [Class],dbo.get_month_name(f.FEE_COLLECT_FEE_FROM_DATE,f.FEE_COLLECT_FEE_TO_DATE) as Period,f.FEE_COLLECT_FEE Fee, f.FEE_COLLECT_ARREARS Arrears, f.FEE_COLLECT_NET_TOATAL [Total Fee], (f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_FEE_PAID) As Received,(f.FEE_COLLECT_FEE + f.FEE_COLLECT_ARREARS - (f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_FEE_PAID)) as [Amount Loss],f.FEE_COLLECT_FEE_STATUS [Fee Status]  from FEE_COLLECT f 
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID


where  FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID and s.STDNT_STATUS = 'F'
and f.FEE_COLLECT_FEE_STATUS in ('Partially Received','Receivable','Fully Received')
 and f.FEE_COLLECT_FEE_FROM_DATE between @START_DATE and @END_DATE
 )A where nmbr = 1

--and (f.FEE_COLLECT_FEE + f.FEE_COLLECT_ARREARS - (f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_FEE_PAID)) > 0