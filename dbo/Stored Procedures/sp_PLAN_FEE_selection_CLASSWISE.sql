
CREATE PROC [dbo].[sp_PLAN_FEE_selection_CLASSWISE]

 @CLASS_ID numeric,
 @BR_ID numeric,
 @STATUS char(1),
 @SessionId numeric

 AS
--declare @CLASS_ID numeric = 1,
--@BR_ID numeric = 1


if @STATUS = 'L'
BEGIN
	select ID,Name from VSCHOOL_PLANE where Status = 'T'  and [Branch ID] =@BR_ID and [Session Id] = @SessionId order by [Order]
	select ID,Name from VINSTALLMENT_INFO where  [Branch ID] =@BR_ID and Status = 'T' order by [Rank]
END

ELSE
BEGIN
	declare @query1 nvarchar(MAX) = ''
	declare @fee_names varchar(MAX) = ''
	declare @fee_names_isnull nvarchar(MAX) = ''
	declare @tbl table (ID int,[Fee Names] nvarchar(100), [Fee Type] nvarchar(100), Operation char(1), [Fee Months] nvarchar(50))



	insert into @tbl
	select FEE_ID ,FEE_NAME,MAX(FEE_TYPE),MAX(FEE_OPERATION),MAX(FEE_MONTHS) from FEE_INFO f join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = pd.PLAN_FEE_DEF_PLAN_ID where pd.PLAN_FEE_DEF_STATUS = 'T' and s.STDNT_CLASS_PLANE_ID = @CLASS_ID and FEE_BR_ID =@BR_ID and FEE_STATUS = 'T' GROUP BY f.FEE_ID,f.FEE_NAME,f.FEE_RANK order by f.FEE_RANK



	select @fee_names = STUFF((SELECT  ',' + QUOTENAME(convert(varchar(50),  [Fee Names], 120)) from  @tbl FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

	select @fee_names_isnull = STUFF((SELECT  ',' + 'ISNULL('+QUOTENAME(convert(varchar(50),  [Fee Names], 120))+ ',-1) as ['+ [Fee Names]+']' from @tbl  FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')



	select @query1 = ' ; with cte as 

	( select p.PLAN_FEE_ID [Plan Fee ID],s.STDNT_ID ID,s.STDNT_SCHOOL_ID [Std #],s.STDNT_FIRST_NAME [Name],f.FEE_NAME [Fee Name],d.PLAN_FEE_DEF_FEE [Fee],p.PLAN_FEE_INSTALLMENT_ID [Installement ID],STDNT_DISCOUNT_RULE_ID [Template ID],p.PLAN_FEE_FORMULA [Fee Formula],p.PLAN_FEE_IS_FEE_GENERATE [Is Fee Generate],p.PLAN_FEE_IS_FORMULA_APPLY [Is Formula Apply],p.PLAN_FEE_NOTES [Notes],(select d.VALUE from DEFAULT_VALUES d where d.PAGE_NAME = ''Fee Plan'' and d.VALUE_NAME in (''From Month'') and d.BR_ID = '+CAST(@BR_ID as varchar(10))+') [From Month],
	(select d1.VALUE from DEFAULT_VALUES d1 where d1.PAGE_NAME = ''Fee Plan'' and d1.VALUE_NAME in (''To Month'') and d1.BR_ID = '+CAST(@BR_ID as varchar(10))+') [To Month] from 
	STUDENT_INFO s
	join PLAN_FEE p on p.PLAN_FEE_ID = s.STDNT_CLASS_FEE_ID
	join PLAN_FEE_DEF d on d.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID and d.PLAN_FEE_DEF_STATUS = ''T''
	join FEE_INFO f on f.FEE_ID = d.PLAN_FEE_DEF_FEE_NAME and f.FEE_STATUS = ''T'' and d.PLAN_FEE_DEF_STATUS = ''T''
	where  STDNT_STATUS = ''T'' and STDNT_CLASS_PLANE_ID = '+CAST(@CLASS_ID as varchar(10))+' and s.STDNT_BR_ID = '+CAST(@BR_ID as varchar(10))+'  and d.PLAN_FEE_DEF_STATUS = ''T''
	),

	final_tbl1 as
	(
	select * from cte
	pivot (max ([Fee]) for [Fee Name] in ('+@fee_names+'))as f_pivot_tbl
	)
	select ROW_NUMBER() over(order by CAST([Std #] as int)) Sr ,[Plan Fee ID],ID,[Std #], [Name],[Installement ID],[Template ID],CAST(0 as bit) [Is Template Change],[Fee Formula], [Is Fee Generate], [Is Formula Apply], [From Month], [To Month],'+@fee_names+','''' [Total Fee],[Notes],'''' as abc from final_tbl1 order by CAST([Std #] as int)
	'

	select ID,Name from VSCHOOL_PLANE where Status = 'T' and [Branch ID] =@BR_ID and [Session Id] = @SessionId order by [Order]

	select ID,Name from VINSTALLMENT_INFO where  [Branch ID] =@BR_ID and Status = 'T' order by [Rank]

	select * from @tbl

	exec  (@query1) 

	select
	(select d.VALUE from DEFAULT_VALUES d where d.PAGE_NAME = 'Fee Plan' and d.VALUE_NAME in ('From Month') and d.BR_ID = @BR_ID ) [From Month],
	(select d1.VALUE from DEFAULT_VALUES d1 where d1.PAGE_NAME = 'Fee Plan' and d1.VALUE_NAME in ('To Month') and d1.BR_ID = @BR_ID ) [To Month]
	
	select s.STDNT_ID [Std ID], f.FEE_ID [Fee ID],f.FEE_NAME [Fee Name],f.FEE_TYPE [Fee Type],pd.PLAN_FEE_IS_ONCE_PAID [Is Once Paid] from FEE_INFO f join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID join STUDENT_INFO s on s.STDNT_CLASS_FEE_ID = pd.PLAN_FEE_DEF_PLAN_ID where pd.PLAN_FEE_DEF_STATUS = 'T' and s.STDNT_CLASS_PLANE_ID = @CLASS_ID and FEE_BR_ID =@BR_ID and FEE_STATUS = 'T' 
and FEE_TYPE in( 'Once', 'Custom Once')
--GROUP BY f.FEE_ID,f.FEE_NAME,f.FEE_RANK order by f.FEE_RANK

select ID,Name from VDISCOUNT_RULES where [Class ID] =@CLASS_ID and Status = 'T'

END