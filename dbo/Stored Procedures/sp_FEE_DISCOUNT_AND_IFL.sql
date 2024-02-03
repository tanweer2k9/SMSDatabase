

CREATE PROC [dbo].[sp_FEE_DISCOUNT_AND_IFL]

 @DATE date ,
 @HD_ID numeric ,
 @BR_ID numeric 

AS



--declare @DATE date = '2016-09-01'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1

;with cte as
(
select s.STDNT_ID ID, s.STDNT_SCHOOL_ID [Std #], s.STDNT_FIRST_NAME Name,sp.CLASS_Name [Class],sp.CLASS_ID [Class ID],fi.FEE_NAME [Fee Name],def.FEE_COLLECT_DEF_FEE Fee,dbo.get_month_name(f.FEE_COLLECT_FEE_FROM_DATE,f.FEE_COLLECT_FEE_TO_DATE) as [Fee Month],(f.FEE_COLLECT_ARREARS + f.FEE_COLLECT_FEE) [Total Fee], (f.FEE_COLLECT_ARREARS_RECEIVED + f.FEE_COLLECT_FEE_PAID) [Fee Received]  from FEE_COLLECT f 
join
(
select * from FEE_COLLECT_DEF where FEE_COLLECT_DEF_FEE_NAME in (select FEE_ID from FEE_INFO where  FEE_NAME in( 'Discount','Interest Free Loan')) and FEE_COLLECT_DEF_FEE > 0 and  FEE_COLLECT_DEF_PID in
(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @DATE) and FEE_COLLECT_HD_ID = @HD_ID  and FEE_COLLECT_BR_ID = @BR_ID ) ) Def
on f.FEE_COLLECT_ID = Def.FEE_COLLECT_DEF_PID
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
join FEE_INFO fi on fi.FEE_ID = Def.FEE_COLLECT_DEF_FEE_NAME
)
,final_tbl as
(
select * from cte
pivot (max ([Fee]) for [Fee Name] in ([Discount],[Interest Free Loan]))as f_pivot_tbl)
select ROW_NUMBER() over (order by [Class ID],CAST([Std #] as int)) as Sr ,ID,[Std #],Name,[Class],[Fee Month],ISNULL(Discount,0) Discount, ISNULL([Interest Free Loan],0) [Interest Free Loan]  from final_tbl