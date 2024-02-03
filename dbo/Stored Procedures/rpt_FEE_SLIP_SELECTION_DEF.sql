

CREATE PROCEDURE [dbo].[rpt_FEE_SLIP_SELECTION_DEF]


@BR_ID numeric,
@FROMDATE date

as begin


declare @P_BR_ID numeric = 0,
@P_FROMDATE date = ''

select @P_BR_ID = @BR_ID ,@P_FROMDATE = @FROMDATE 


if @P_FROMDATE = '1987-01-27' --THis is registration fee challan if date is27th jan 1987 then it is registration
BEGIN

 	select d.Id ID, d.PId PID, f.FEE_NAME [Fee Name], d.Fee, 'T' Status, f.FEE_OPERATION Operation, 0 Arrears, 0 [Fee Paid], f.FEE_DISCOUNT_PRIORITY print_order from StdRegFeeGenerationDetail d
join FEE_INFO f on f.FEE_ID = d.FeeId
where d.PId = @P_BR_ID

END
ELSE
BEGIN
--declare @FromDate date = '2019-01-01'

declare @one int = 1

declare @IsTotalFeeOnFeeChallan bit = 0

select @IsTotalFeeOnFeeChallan = IsTotalFeeOnFeeChallan from FeeChallanBankDetail where BrId = @P_BR_ID

set @IsTotalFeeOnFeeChallan = ISNULL(@IsTotalFeeOnFeeChallan,CAST(0 as bit))



if @IsTotalFeeOnFeeChallan = 1 
BEGIN	
	select 1 ID, PID,'Total Fee' [Fee Name],  CAST(SUM(Fee) as nvarchar(10)) Fee,'T' Status,'+' Operation,SUM(Arrears) Arrears, SUM([Fee Paid]) [Fee Paid], MAX(print_order) print_order From (select ID,PID,[Fee Name],Operation,[Fee Paid],CASE WHEN Operation = '+' THEN Fee ELSE Fee * -1 END Fee,CASE WHEN Operation = '+' THEN Arrears ELSE Arrears * -1 END Arrears,print_order from rpt_V_FEE_SLIP_DEF with (nolock) where FeeFromDate between  DATEADD(MM,-1,DATEADD(DD,1,EOMONTH(@P_FROMDATE))) and EOMONTH (@P_FROMDATE))A group by PID
END

ELSE
BEGIN
 
		declare @date date = ''

		select @date = SUPL_DUE_DATE from SUPLEMENTARY_PARENT with (nolock)  order by SUPL_DUE_DATE DESC


select v.[ID],v.[PID], CASE WHEN [Fee Name] = 'Discount' and Fee > 0 THEN 'Discount '+ (select ISNULL(FEE_COLLECT_INSTALLMENT_NAME,'') + ' (' + CAST(Fee as nvarchar(10))+ ')' from
(select ROW_NUMBER() over(partition by FEE_COLLECT_STD_ID order by FEE_COLLECT_FEE_FROM_DATE DESC) as sr,FEE_COLLECT_INSTALLMENT_NAME from FEE_COLLECT with (nolock) where FEE_COLLECT_STD_ID in
(select FEE_COLLECT_STD_ID from FEE_COLLECT with (nolock)  where FEE_COLLECT_ID in (v.PID )))B where B.sr = 2) ELSE IIF(@P_BR_ID <=2  AND @P_FROMDATE between '2020-05-01' and '2020-08-30' AND [Fee Name] in( 'Fee','Tuition Fee'),'Final Installment 2019 (Full fee)' ,

IIF([Fee Name] like '%Discount as per Govt.%' AND @br_id > 2, [Fee Name] + IIF(dg.DiscountAvailable > 0,' (' + CAST(dg.DiscountAvailable as nvarchar(50)) + '%)', ''),
 
IIF([Fee Name] like '%Discount as per Govt.%' AND @br_id <= 2, 'Discount as per Govt. instructions (Discount already given '+ CAST(dg.DiscountAlready as nvarchar(50)) +'% , Discount available '+ CAST(dg.DiscountAvailable as nvarchar(50)) + '% (2 months))' , [Fee Name])

)
-- [Fee Name]
) END  
--+ IIF((@P_BR_ID = 1 OR @P_BR_ID = 2) AND [Fee Name] like '%Term%' , 
--ISNULL((select IIF ([Fee Name] like '%Term%' AND Fee != FEE_COLLECT_DEF_FEE, ' (Old Fee: '+ CAST(FEE_COLLECT_DEF_FEE as nvarchar(10)) + ')','') from 
--(select ROW_NUMBER() over(partition by FEE_COLLECT_STD_ID order by FEE_COLLECT_FEE_FROM_DATE desc) as sr,FEE_COLLECT_STD_ID,FEE_COLLECT_DEF_FEE  from FEE_COLLECT f 
--join FEE_COLLECT_DEF fd on f.FEE_COLLECT_ID = fd.FEE_COLLECT_DEF_PID
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--where f.FEE_COLLECT_BR_ID = @P_BR_ID and f.FEE_COLLECT_FEE_FROM_DATE < '2018-11-01' and fi.FEE_NAME like '%Term%'
--union
--select 1,181331, 52000
--union
--select 1,181337, 52000
--union
--select 1,181339, 52000
--union
--select 1,181340, 52000
--union
--select 1,181345, 52000
--union
--select 1,181338, 52000
--union
--select 1,181348, 44000
--union
--select 1,181353, 52000
--union
--select 1,181347, 52000
--union
--select 1,181346, 52000
--)A where sr = 1 and FEE_COLLECT_STD_ID = StudentId)
--,'') ,'')

 [Fee Name],CASE WHEN [Fee Name] = 'Discount' and Fee > 0 THEN CAST(Fee as nvarchar(10)) ELSE CAST(Fee as nvarchar(10))  
--format (Fee, '#,###', 'EN-en') 
END Fee,[Status],[Operation],
Arrears,
--CASE WHEN [Fee Name] = 'Discount' and Fee > 0 THEN Fee ELSE [Arrears] END [Arrears],
[Fee Paid],[print_order] from rpt_V_FEE_SLIP_DEF v with (nolock) 
left join feediscountgovt dg with (nolock)  on dg.StdId = v.StudentId
 where 

Fee > 0 --OR [Fee Name] like '%Discount as per Govt.%'


--or Arrears !=0 or [Fee Paid] != 0 ) 
and [Fee Name] != 'Interest Free Loan' --and [Fee Name] != 'Discount' 
AND FeeFromDate between  DATEADD(MM,-1,DATEADD(DD,1,EOMONTH(@P_FROMDATE))) and EOMONTH (@P_FROMDATE)
--AND FeeFromDate >= @FromDate

union
select 1,(select FEE_COLLECT_ID from (select ROW_NUMBER() over(partition by FEE_COLLECT_STD_ID order by FEE_COLLECT_FEE_FROM_DATE desc) as sr,* from FEE_COLLECT)A where sr = 1  and A.FEE_COLLECT_STD_ID = B.FEE_COLLECT_STD_ID) FEE_COLLECT_ID,'Interest Free Loan Amount = Rs. ' + CAST(IFL as nvarchar(15)),'','T','-',0,0,1000001 from
(select FEE_COLLECT_STD_ID, SUM(ISNULL(FEE_COLLECT_DEF_FEE,0)  ) IFL from FEE_COLLECT f with (nolock) 
join FEE_COLLECT_DEF fd with (nolock) on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
join FEE_INFO fi with (nolock)  on fd.FEE_COLLECT_DEF_FEE_NAME = fi.FEE_ID
join STUDENT_INFO s with (nolock)  on s.STDNT_ID = f.FEE_COLLECT_STD_ID




where fi.FEE_NAME = 'Interest Free Loan' and s.STDNT_STATUS = 'T' and ISNULL(s.STDNT_IS_REJOIN,0) = 0  group by FEE_COLLECT_STD_ID)B where IFL > 0


order by PID desc,print_order


			--select [ID],[PID],CASE WHEN [Fee Name] = 'Discount' and Arrears !=0 and [Fee Paid] != 0 THEN 'Discount abc' ELSE [Fee Name] END [Fee Name],[Fee],[Status],[Operation],[Arrears],[Fee Paid],[print_order] from rpt_V_FEE_SLIP_DEF where Fee != 0 or Arrears !=0 or [Fee Paid] != 0 order by print_order
			--union
			--select sr,B.FEE_COLLECT_ID,D.FeeName,0,'T ','+',D.Remaining,0 from 
			--(select * from
			--(select ROW_NUMBER() over (partition by FEE_COLLECT_STD_ID order by FEE_COLLECT_FEE_FROM_DATE DESC) as sr, * from FEE_COLLECT)A where sr = 1 and FEE_COLLECT_FEE_FROM_DATE > @date)B
			--join (select * from (select 'Supplementary' as FeeName, SUPL_DEF_STUDENT_ID StdID, SUM(SUPL_DEF_FEE) + SUM(SUPL_DEF_LATE_FEE_FINE) + SUM(SUPL_DEF_ARREARS) -SUM(SUPL_DEF_ARREARS_RECEIVED) - SUM(SUPL_DEF_FEE_RECEIVED) -SUM(SUPL_DEF_DISCOUNT) as Remaining from SUPLEMENTARY_DEF where SUPL_DEF_STATUS in  ('Partially Received', 'Receivable') group by SUPL_DEF_STUDENT_ID)C where Remaining > 0)D
			--on B.FEE_COLLECT_STD_ID = D.StdID

	End

END

END