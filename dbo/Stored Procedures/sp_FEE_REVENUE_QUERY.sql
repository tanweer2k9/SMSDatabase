

CREATE PROC [dbo].[sp_FEE_REVENUE_QUERY]

 @DATE date ,
 @HD_ID numeric ,
 @BR_ID numeric 

AS


--declare @DATE date = '2017-01-01'
--declare @HD_ID numeric = 1
--declare @BR_ID numeric = 1
declare @tbl table ([Fee Names] nvarchar(100), [Type] nvarchar(100))
declare @query1 nvarchar(MAX) = ''
declare @query2 nvarchar(MAX) = ''
declare @fee_names nvarchar(MAX) = ''
declare @fee_names_isnull nvarchar(MAX) = ''
declare @fee_names_sum nvarchar(MAX) = ''
declare @fee_names_sum_group_by nvarchar(MAX) = ''
declare @fee_names_arrears nvarchar(MAX) = ''
declare @fee_names_isnull_arrears nvarchar(MAX) = ''
declare @fee_names_sum_arrears nvarchar(MAX) = ''
declare @fee_names_sum_group_by_arrears nvarchar(MAX) = ''

insert into @tbl
select FEE_NAME, [Type] from 
(select f.FEE_NAME,f.FEE_RANK, 'CurrentFee' [Type] from FEE_INFO f
join
(select * from FEE_COLLECT_DEF where  FEE_COLLECT_DEF_TOTAL > 0 and  FEE_COLLECT_DEF_PID in
(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @DATE) and FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID ))Def
on f.FEE_ID = Def.FEE_COLLECT_DEF_FEE_NAME where f.FEE_NAME not in ( 'Interest Free Loan','Reprinting Charges') GROUP BY f.FEE_NAME,f.FEE_RANK 

union 


select f.FEE_NAME +' Arrears', f.FEE_RANK,'Arrears' [Type] from FEE_INFO f
join
(select * from FEE_COLLECT_DEF where  FEE_COLLECT_DEF_TOTAL > 0 and  FEE_COLLECT_DEF_PID in
(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @DATE) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @DATE) and FEE_COLLECT_HD_ID = @HD_ID and FEE_COLLECT_BR_ID = @BR_ID ))Def
on f.FEE_ID = Def.FEE_COLLECT_DEF_FEE_NAME where f.FEE_NAME not in ( 'Interest Free Loan','Reprinting Charges') GROUP BY f.FEE_NAME,f.FEE_RANK 
)A

order by FEE_RANK





select @fee_names = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50),  [Fee Names], 120)) from @tbl where [Type]= 'CurrentFee'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_isnull = STUFF((SELECT  ',' + 'SUM(ISNULL('+QUOTENAME(convert(varchar(50),  [Fee Names], 120))+ ',0)) as ['+ [Fee Names]+']' from @tbl where [Type]= 'CurrentFee' FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_sum =  STUFF((SELECT '+'   + QUOTENAME(convert(varchar(50),  [Fee Names], 120))   from @tbl where [Type]= 'CurrentFee'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_sum_group_by = STUFF((SELECT  ',' + 'SUM('+QUOTENAME(convert(varchar(50),  [Fee Names], 120))+ ') as ['+ [Fee Names]+']' from @tbl where [Type]= 'CurrentFee'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')





select @fee_names_arrears = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50),  [Fee Names] , 120)) from @tbl where [Type]= 'Arrears'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_isnull_arrears = STUFF((SELECT  ',' + 'SUM(ISNULL('+QUOTENAME(convert(varchar(50),  [Fee Names], 120))+ ',0)) as ['+ [Fee Names]+']' from @tbl where [Type]= 'Arrears' FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_sum_arrears =  STUFF((SELECT '+'   + QUOTENAME(convert(varchar(50),  [Fee Names], 120))   from @tbl where [Type]= 'Arrears'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

select @fee_names_sum_group_by_arrears = STUFF((SELECT  ',' + 'SUM('+QUOTENAME(convert(varchar(50),  [Fee Names], 120))+ ') as ['+ [Fee Names]+']' from @tbl where [Type]= 'Arrears'  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')


set @query1 = 
'
;with cte as 
(
select s.STDNT_ID ID, s.STDNT_SCHOOL_ID [Std #], s.STDNT_FIRST_NAME Name,sp.CLASS_Name [Class],sp.CLASS_ID [Class ID],sp.CLASS_ORDER [ClassOrder],fi.FEE_NAME [Fee Name],(fi.FEE_NAME + '' Arrears'') [Fee Name Arrears],def.FEE_COLLECT_DEF_FEE CurrentFee, (FEE_COLLECT_DEF_ARREARS) [CurrentFee Arrears],f.FEE_COLLECT_INSTALLMENT_NAME as [Fee Month]   from FEE_COLLECT f 
join
(
select * from FEE_COLLECT_DEF where  FEE_COLLECT_DEF_TOTAL > 0 and  FEE_COLLECT_DEF_PID in
(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @from) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @from) and FEE_COLLECT_HD_ID = '+CAST(@HD_ID as varchar(10))+' and FEE_COLLECT_BR_ID = '+CAST(@BR_ID as varchar(10)) +') ) Def
on f.FEE_COLLECT_ID = Def.FEE_COLLECT_DEF_PID
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
join FEE_INFO fi on fi.FEE_ID = Def.FEE_COLLECT_DEF_FEE_NAME
),
final_tbl1 as
(
select * from cte
pivot (max ([CurrentFee]) for [Fee Name] in ('+@fee_names+'))as f_pivot_tbl
pivot (max ([CurrentFee Arrears]) for [Fee Name Arrears] in ('+@fee_names_arrears+'))as f_pivot_tbl1
)
,
final_tbl as
(
select ID,MAX([Std #]) [Std #], MAX(Name)Name, MAX(Class)Class,MAX([Class ID])[Class ID],MAX([ClassOrder])[ClassOrder],MAX([Fee Month])[Fee Month],'+@fee_names_isnull+','+@fee_names_isnull_arrears+' from  final_tbl1 group by ID
)
select ROW_NUMBER() over (order by [ClassOrder],CAST([Std #] as int)) as Sr,ID, [Std #], Name, Class,[Fee Month] ,'+@fee_names+','+@fee_names_arrears+',('+@fee_names_sum+'+'+@fee_names_sum_arrears+') as Total from  final_tbl '




set @query2 = 
'
;with cte as 
(
select s.STDNT_ID ID, s.STDNT_SCHOOL_ID [Std #], s.STDNT_FIRST_NAME Name,sp.CLASS_Name [Class],sp.CLASS_ID [Class ID],sp.CLASS_ORDER [ClassOrder],fi.FEE_NAME [Fee Name],(fi.FEE_NAME + '' Arrears'') [Fee Name Arrears],def.FEE_COLLECT_DEF_FEE CurrentFee, (FEE_COLLECT_DEF_ARREARS) [CurrentFee Arrears],f.FEE_COLLECT_INSTALLMENT_NAME as [Fee Month]   from FEE_COLLECT f 
join
(
select * from FEE_COLLECT_DEF where FEE_COLLECT_DEF_TOTAL > 0 and  FEE_COLLECT_DEF_PID in
(select FEE_COLLECT_ID from FEE_COLLECT where DATEPART(MM, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(MM, @from) and DATEPART(YYYY, FEE_COLLECT_FEE_FROM_DATE) = DATEPART(YYYY, @from) and FEE_COLLECT_HD_ID = '+CAST(@HD_ID as varchar(10))+' and FEE_COLLECT_BR_ID = '+CAST(@BR_ID as varchar(10)) +') ) Def
on f.FEE_COLLECT_ID = Def.FEE_COLLECT_DEF_PID
join STUDENT_INFO s on s.STDNT_ID = f.FEE_COLLECT_STD_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
join FEE_INFO fi on fi.FEE_ID = Def.FEE_COLLECT_DEF_FEE_NAME
),
final_tbl1 as
(
select * from cte
pivot (max ([CurrentFee]) for [Fee Name] in ('+@fee_names+'))as f_pivot_tbl
pivot (max ([CurrentFee Arrears]) for [Fee Name Arrears] in ('+@fee_names_arrears+'))as f_pivot_tbl1
)
,
final_tbl2 as
(
select ID,MAX([Std #]) [Std #], MAX(Name)Name, MAX(Class)Class,MAX([Class ID])[Class ID],MAX([ClassOrder])[ClassOrder],MAX([Fee Month])[Fee Month],'+@fee_names_isnull+','+@fee_names_isnull_arrears+' from  final_tbl1 group by ID
)
,
final_tbl3 as
(
select SUM ([Class ID]) [Class ID], MAX(Class) Class,MAX([ClassOrder]) [ClassOrder],COUNT(*) [No. of Std.],MAX([Fee Month]) [Fee Month], '+@fee_names_sum_group_by+','+@fee_names_sum_group_by_arrears+' from  final_tbl2 group by [Class ID],[Class]
)
select ROW_NUMBER() over (order by [ClassOrder]) as Sr,Class,[No. of Std.],[Fee Month],'+@fee_names+','+@fee_names_arrears+',('+@fee_names_sum+'+'+@fee_names_sum_arrears+') as Total from  final_tbl3 
'





exec sp_executesql @query1, N'@from date', @from = @DATE
exec sp_executesql @query2, N'@from date', @from = @DATE

select * from @tbl