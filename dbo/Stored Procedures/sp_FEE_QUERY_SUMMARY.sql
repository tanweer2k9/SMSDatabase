CREATE proc [dbo].[sp_FEE_QUERY_SUMMARY]
	@STATUS char,
	@FEE_START_DATE date,
	@FEE_END_DATE date,
	@FEE_PLAN_ID int,
	@FEE_HD_ID numeric,
	@FEE_BR_ID numeric,
	@FEE_USER_TYPE nvarchar(50),
	@FEE_USER_ID numeric,
	@FEE_PARENT_ID numeric


as
begin



--declare @FEE_START_DATE date = '1900-01-01'
--declare @FEE_END_DATE date = '2013-09-01'
--declare @FEE_PLAN_ID int = 0
--declare @FEE_HD_ID numeric = 1
--declare @FEE_BR_ID numeric = 1

--declare @FEE_USER_TYPE nvarchar(50) = 'A'
--declare @FEE_USER_ID numeric = 1
--declare @STATUS char = 'T'
--declare @FEE_PARENT_ID numeric = 0
create table #tbl_daily_fee ([Invoice ID] numeric, [Fee ID] int, [Total Fee] float)
if @STATUS = 'Q'
begin
	select 0
	select 0
	select CLASS_ID as ID,CLASS_HD_ID as [HD ID], CLASS_BR_ID as [BR ID],CLASS_Name as Name from SCHOOL_PLANE where CLASS_STATUS = 'T'
	
end
else
begin
	declare @receivable varchar(50) = ''
	declare @received varchar(50) = ''


	declare @where_clause varchar(200) = ''
	declare @where_clause_class varchar(200) = ''
	declare @where_parent varchar(200) = ''
	declare @group_by varchar(max) = ''
	declare @columns varchar(max) = ''
	declare @where_clause_date_gener varchar(200) = ' '
	declare @where_clause_date_recieved varchar(200) = ' '
	declare @order_by varchar(200) = ' '
	declare @sum_of_total varchar(1000) = ''
	declare @sr_order varchar(200) = ''

	declare @total_fee_fully_trans varchar(500)= '(case when FEE_COLLECT_DEF_OPERATION = ''-''  then FEE_COLLECT_DEF_FEE else FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS END )'
	declare @received_fee_fully_trans varchar(500)= '(df.[Total Fee])'
	declare @total_fee_partially_trans varchar(500)= '(case when FEE_COLLECT_DEF_OPERATION = ''-''  then FEE_COLLECT_DEF_FEE else df.[Total Fee] END )'
	declare @received_fee_partially_trans varchar(500)= '(df.[Total Fee])'

	declare @defaulter varchar(4000) = '0'
	declare @join_clause varchar(2000) = 'from FEE_INFO f
				join FEE_COLLECT_DEF cd on  f.FEE_ID = cd.FEE_COLLECT_DEF_FEE_NAME  
				join VFEE_QUERY v on v.[Invoice ID] = cd.FEE_COLLECT_DEF_PID
				join #tbl_daily_fee df on df.[Invoice ID] = v.[Invoice ID] and f.FEE_ID = df.[Fee ID]
				join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and v.[Fee ID] = pd.PLAN_FEE_DEF_PLAN_ID
				where pd.PLAN_FEE_DEF_STATUS = ''T'' '

	declare @fee_status_fully_tran varchar(500) = 'and  v.[Fee Status] not in (''Fully Transfered'', ''Partially Transfered'')'
	declare @fee_status_partially_tran varchar(500) = 'and  v.[Fee Status] = ''Partially Transfered'''
	declare @fee_status_both varchar(500) = 'and  v.[Fee Status] in (''Fully Transfered'', ''Partially Transfered'')'
		 
		 declare @v_col_names varchar(1000) = 'v.[Institute ID],v.[Branch ID],v.[Invoice ID], v.[Student ID], v.Name, v.[Class Plan], v.[Month Year], f.FEE_NAME as [Fee Name],v.[int Month Year], v.[Class ID]'
		 declare @final_col_names varchar(1000) = '[Institute ID],[Branch ID],[Invoice ID], [Student ID], Name, [Class Plan], [Month Year]'
		 declare @total_col_names varchar(500) = '[Institute ID],[Branch ID],[Invoice ID], [Student ID], Name, [Class Plan], [Month Year],[int Month Year], [Class ID]'
		 declare @group_by_clause varchar(500) = 'A.[Institute ID],A.[Branch ID], A.[Student ID],A.[int Month Year], A.Name,A.[Class ID],A.[Class Plan], A.[Month Year], A.[Fee Name] , a.[Student ID], A.[Invoice ID], A.opertor'
		 

		declare @cols as varchar(max), @t_cols as varchar(max), @rb_cols as varchar(max), @rd_cols as varchar(max), 
		 @t_cols_sum as varchar(max), @rb_cols_sum as varchar(max), @rd_cols_sum as varchar(max),
		 @t_cols_total as varchar(max), @rb_cols_total as varchar(max), @rd_cols_total as varchar(max), 
		 @query as nvarchar(max), @query2 as varchar(max), @query_parent as varchar(max)
		

	if @FEE_USER_TYPE = 'A' or @FEE_USER_TYPE = 'SA' or @FEE_USER_TYPE = 'IT' or @FEE_USER_TYPE = 'Student' or @FEE_USER_TYPE = 'Parent'

	begin
				set @where_clause = @where_clause + ' and [Institute ID] in (select * from dbo.get_all_hd_id (' + convert(varchar(50),@FEE_HD_ID) + '))'
				--set @where_clause = @where_clause + ' and [Institute ID] = ' + convert(varchar(50),@FEE_HD_ID)
				set @where_clause_class = @where_clause_class + 'and CLASS_HD_ID = ' + convert(varchar(50),@FEE_HD_ID)
				set @where_parent = @where_parent + ' and [Institute ID] = ' + convert(varchar(50),@FEE_HD_ID)
				
				set @where_clause = @where_clause + ' and [Branch ID] in (select * from dbo.get_all_br_id (' + convert(varchar(50),@FEE_BR_ID) + '))'
				--set @where_clause = @where_clause + ' and [Branch ID] = ' + convert(varchar(50),@FEE_BR_ID)
				set @where_clause_class = @where_clause_class + ' and CLASS_BR_ID = ' + convert(varchar(50),@FEE_BR_ID)
				set @where_parent = @where_parent + ' and [Branch ID] in (select * from [dbo].[get_centralized_br_id](''P'', ' + convert(varchar(50),@FEE_BR_ID) +'))'		

		
		
		if @STATUS = 'S' --Student wise
		begin
			set @group_by = '[Institute ID],[Branch ID],[Student ID], [Name],[Class ID]'
			set @columns = '[Institute ID],[Branch ID], [Student ID], [Name],[Class ID],'
			set @order_by = '[Student ID], [Name]'
			set @sr_order = '[Student ID]'
		end
		
		else if @STATUS = 'T' --Total Class plan
		begin
			set @group_by = '[Institute ID],[Branch ID],[Class ID], [Class Plan]'
			set @columns = '[Institute ID],[Branch ID], [Class Plan], [Class ID],'
			set @order_by = '[Class ID], [Class Plan]'
			set @sr_order = '[Class ID]'
		end
		
		else if @STATUS = 'P' --Student Wise and Class plan Wise
		begin
			set @group_by = '[Institute ID],[Branch ID],[Student ID], [Name], [Class ID], [Class Plan]'
			set @columns = '[Institute ID],[Branch ID],[Student ID], [Name], [Class Plan],[Class ID],  '
			set @order_by = '[Student ID], [Name], [Class ID], [Class Plan]'
			set @sr_order = '[Student ID]'
		end
		
		else if @STATUS = 'D' --For Defaulter
		begin
			set @group_by = '[Institute ID],[Branch ID],[Student ID], [Name]'
			set @columns = '[Institute ID],[Branch ID], [Student ID], [Name], '
			set @order_by = '[Student ID], [Name]'
			set @sr_order = '[Student ID]'
			
			set @total_fee_fully_trans = '(case when FEE_COLLECT_DEF_OPERATION = ''-''  then FEE_COLLECT_DEF_FEE else FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS END) '
			set @received_fee_fully_trans = '(FEE_COLLECT_DEF_FEE_PAID  + FEE_COLLECT_DEF_ARREARS_RECEIVED )'
			set @total_fee_partially_trans = ' (case when FEE_COLLECT_DEF_OPERATION = ''-''  then FEE_COLLECT_DEF_FEE else FEE_COLLECT_DEF_FEE + FEE_COLLECT_DEF_ARREARS END) '
			set @received_fee_partially_trans = '(FEE_COLLECT_DEF_FEE_PAID  + FEE_COLLECT_DEF_ARREARS_RECEIVED )'
			
			
			set @fee_status_fully_tran = 'and  v.[Fee Status] = ''Fully Transfered'''
			set @fee_status_partially_tran = 'and  v.[Fee Status] = ''Partially Transfered'''		
			
		end


		if @FEE_USER_TYPE = 'SA' or @FEE_USER_TYPE = 'A' or @FEE_USER_TYPE = 'IT'
		begin
			set @receivable = 'RL '
			set @received = 'RD '
				
				if @FEE_PARENT_ID != 0
				begin
					set @where_clause = @where_clause + ' and [Parent ID] = ' + convert(varchar(50),@FEE_PARENT_ID)
				end
		end
		
		if @FEE_USER_TYPE = 'Parent' or @FEE_USER_TYPE = 'Student'
		begin	
			set @receivable = 'PL '
			set @received = 'PD '
			
				if @FEE_USER_TYPE = 'Parent'
				begin
					set @where_clause = @where_clause + ' and [Parent ID] = ' + convert(varchar(50),@FEE_USER_ID)
				end

				else if @FEE_USER_TYPE = 'Student'
				begin
					set @where_clause = @where_clause + ' and [Student ID] = ' + convert(varchar(50),@FEE_USER_ID)
				end
		end



		if @FEE_START_DATE != '1900-01-01'
			begin
				set @where_clause_date_gener = ' and Date between @from AND @to '
				set @where_clause_date_recieved = 'and [Date Received] between @from AND @to '
			end

		if @FEE_PLAN_ID != 0
			begin
				set @where_clause = @where_clause + ' and [Class ID] = ' + convert(varchar(50),@FEE_PLAN_ID)
			end
		
		
		select @cols = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), FEE_NAME, 120))  from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
		
		select @t_cols = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), 'T ' +FEE_NAME, 120)) from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
		            
		select @rb_cols = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), @receivable + FEE_NAME, 120)) from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'' + '')

		select @rd_cols = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), @received +FEE_NAME, 120)) from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')

		
		
				select @t_cols_total = STUFF((SELECT '+' + 'ISNULL(' + QUOTENAME(convert(varchar(50), 'T ' +FEE_NAME, 120)) + ', 0)' from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
		--set @t_cols_total = @t_cols_total + 'AS [T Total]'
		
		select @rb_cols_total = STUFF((SELECT '+' + 'ISNULL(' + QUOTENAME(convert(varchar(50), @receivable +FEE_NAME, 120)) + ', 0)' from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
		--set @rb_cols_total = @rb_cols_total + 'AS [' + @receivable + 'Total]'
		
		select @rd_cols_total = STUFF((SELECT '+' + 'ISNULL(' + QUOTENAME(convert(varchar(50), @received +FEE_NAME, 120)) + ', 0)' from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
		--set @rd_cols_total = @rd_cols_total + 'AS [' + @received +'Total]'
		
		
		
		select @t_cols_sum = STUFF((SELECT ',' + 'SUM(' + QUOTENAME(convert(varchar(50), 'T ' +FEE_NAME, 120)) + ') as [T ' + FEE_NAME + ']'  from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
			--set @t_cols_sum = @t_cols_sum + ', Sum([T Total]) as [T Total]'
		
		select @rb_cols_sum = STUFF((SELECT ',' + 'SUM(' + QUOTENAME(convert(varchar(50), @receivable +FEE_NAME, 120)) + ') as [' + @receivable + FEE_NAME + ']'  from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
			--set @rb_cols_sum = @rb_cols_sum + ', Sum([' + @receivable + 'Total]) as [' + @receivable + 'Total]'
		
		select @rd_cols_sum = STUFF((SELECT ',' + 'SUM(' + QUOTENAME(convert(varchar(50), @received +FEE_NAME, 120)) + ') as ['+ @received + FEE_NAME + ']'  from FEE_INFO where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') ,1,1,'')
			--set @rd_cols_sum = @rd_cols_sum + ', Sum([' + @received +'Total]) as [' + @received +'Total]'
		
		set @sum_of_total = 'Sum([T Total]) as [T Total], Sum([' + @receivable + 'Total]) as [' + @receivable + 'Total], Sum([' + @received +'Total]) as [' + @received +'Total]'
		
		--select @t_cols_sum
		--select @rb_cols_sum
		--select @rd_cols_sum
		

		
		
		--select @cols
		--select @t_cols
		--select @rb_cols
		--select @rd_cols

	if @STATUS = 'D'
	begin
		--set @defaulter = 'select top(1) FEE_COLLECT_DEF_ARREARS from (select FEE_COLLECT_DEF_ID, FEE_COLLECT_DEF_ARREARS ' + @join_clause + @fee_status_fully_tran
		--	 + @where_clause_date_gener + @where_clause + ' union all select FEE_COLLECT_DEF_ID, FEE_COLLECT_DEF_ARREARS ' 
		--		+ @join_clause + @fee_status_partially_tran + @where_clause_date_gener + @where_clause 
		--		+ ')D order by FEE_COLLECT_DEF_ID'
		
		set @defaulter = 'select top(1) FEE_COLLECT_DEF_ARREARS ' + @join_clause + @fee_status_both + @where_clause_date_gener + @where_clause
		
	end

declare @daily_fee_start_date date = ''
declare @daily_fee_end_date date = ''
if @FEE_START_DATE = '1900-01-01'
begin
	set @daily_fee_start_date = (select MIN(FEE_COLLECT_DATE_FEE_GENERATED) from FEE_COLLECT)
	set @daily_fee_end_date = (select MAX(FEE_COLLECT_DATE_FEE_RECEIVED) from FEE_COLLECT)
end
else
begin
	set @daily_fee_start_date = @FEE_START_DATE
	set @daily_fee_end_date = @FEE_END_DATE
end


insert into #tbl_daily_fee
EXEC sp_FEE_DAILY_RECIEVE @daily_fee_start_date, @daily_fee_end_date


	set @query =  ';with tbl as (

	select ' + @total_col_names +',[Fee Name], T, case when opertor = ''-'' then 0 else RL end as ' + @receivable+', RD as ' + @received+' from
	(
	select ' + @total_col_names +',[Fee Name],opertor,
	case when opertor = ''+'' or [T] = 0 then [T] else -[T] end as T , case when opertor = ''+'' or RL = 0 then RL else -RL end as RL, RD 
	from
	(select ' + @total_col_names +',[Fee Name],opertor,  SUM(T) as T, SUM(T - RD) as RL, SUM(RD) as RD from 
	(
	(
	select '+  @v_col_names +',pd.PLAN_FEE_OPERATION as opertor, 
	(' + @total_fee_fully_trans + ' + (' + @defaulter +')) T 
	, 0 RD

	from FEE_INFO f
	join FEE_COLLECT_DEF cd on  f.FEE_ID = cd.FEE_COLLECT_DEF_FEE_NAME  
	join VFEE_QUERY v on v.[Invoice ID] = cd.FEE_COLLECT_DEF_PID		
	join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and v.[Fee ID] = pd.PLAN_FEE_DEF_PLAN_ID
	where pd.PLAN_FEE_DEF_STATUS = ''T'' ' + @fee_status_fully_tran + @where_clause_date_gener + @where_clause + '

	union all

	select '+  @v_col_names +',pd.PLAN_FEE_OPERATION as opertor, 
	' + @total_fee_partially_trans +' T 
	, 0 RD

	from FEE_INFO f
	join FEE_COLLECT_DEF cd on  f.FEE_ID = cd.FEE_COLLECT_DEF_FEE_NAME  
	join VFEE_QUERY v on v.[Invoice ID] = cd.FEE_COLLECT_DEF_PID
	join #tbl_daily_fee df on df.[Invoice ID] = v.[Invoice ID] and f.FEE_ID = df.[Fee ID]
	join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and v.[Fee ID] = pd.PLAN_FEE_DEF_PLAN_ID
	where pd.PLAN_FEE_DEF_STATUS = ''T''  ' + @fee_status_partially_tran + @where_clause_date_gener + @where_clause + '
	)

	union all

	(
	select '+  @v_col_names +',pd.PLAN_FEE_OPERATION as opertor, 
	0 T 
	, ' + @received_fee_fully_trans +' RD

	from FEE_INFO f
	join FEE_COLLECT_DEF cd on  f.FEE_ID = cd.FEE_COLLECT_DEF_FEE_NAME  
	join VFEE_QUERY v on v.[Invoice ID] = cd.FEE_COLLECT_DEF_PID
	join #tbl_daily_fee df on df.[Invoice ID] = v.[Invoice ID] and f.FEE_ID = df.[Fee ID]
	join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and v.[Fee ID] = pd.PLAN_FEE_DEF_PLAN_ID
	where pd.PLAN_FEE_DEF_STATUS = ''T'' ' + @fee_status_fully_tran + @where_clause_date_recieved + @where_clause + '

	union all

	select '+  @v_col_names +',pd.PLAN_FEE_OPERATION as opertor, 
	0 T 
	, ' + @received_fee_partially_trans +' RD

	from FEE_INFO f
	join FEE_COLLECT_DEF cd on  f.FEE_ID = cd.FEE_COLLECT_DEF_FEE_NAME  
	join VFEE_QUERY v on v.[Invoice ID] = cd.FEE_COLLECT_DEF_PID
	join #tbl_daily_fee df on df.[Invoice ID] = v.[Invoice ID] and f.FEE_ID = df.[Fee ID]
	join PLAN_FEE_DEF pd on pd.PLAN_FEE_DEF_FEE_NAME = f.FEE_ID and v.[Fee ID] = pd.PLAN_FEE_DEF_PLAN_ID
	where pd.PLAN_FEE_DEF_STATUS = ''T'' ' + @fee_status_partially_tran + @where_clause_date_recieved + @where_clause + '
	)

	)A group by '+ @group_by_clause +'
	) B
	)C
	)
	, unpivt_tbl as
	(
	select ' + @total_col_names+', all_fee_names + '' '' + CONVERT(varchar(50), [Fee Name]) as all_fee_names, fee_value from tbl

	unpivot
	(fee_value for all_fee_names in ([T],' + @receivable+', ' + @received+')) as tbl
	)

	,pivt_tbl as 
	(
	select * from unpivt_tbl

	pivot 
	(max(fee_value) for all_fee_names in (' + @t_cols + ','+@rb_cols + ','+@rd_cols + ')) as final_tbl)

	, sum_cols as (
	select *,' + @t_cols_total + 'AS [T Total], ('+ @t_cols_total + ' - ('+ @rd_cols_total + ')) AS [' + @receivable + 'Total] , '+@rd_cols_total +' AS [' + @received +'Total] from pivt_tbl )

	select ROW_NUMBER() over(order by (select ' + @sr_order+ ')) as Sr#,' +@columns + @t_cols_sum + ','+@rb_cols_sum + ','+@rd_cols_sum + ',' +@sum_of_total + ' from sum_cols group by ' + @group_by + ' order by ' + @order_by


	--select ROW_NUMBER() over(order by (select 0)) as Sr#, ' + @columns + @t_cols_sum + ','  + @rb_cols_sum + ','  + @rd_cols_sum + ','  +@t_cols_total + ','  + @rb_cols_total + ','  + @rd_cols_total + ' from pivt_tbl group by ' + @group_by + ' order by ' + @order_by



	--select @query

			create table #temp ([Fees Name] nvarchar(200))
			insert into #temp select FEE_NAME as [Fees Name] from FEE_INFO  where FEE_HD_ID in (select * from dbo.get_all_hd_id (@FEE_HD_ID)) and FEE_BR_ID in (select * from dbo.get_all_br_id (@FEE_BR_ID))group by FEE_NAME order by MIN(FEE_ID)

			select * from #temp
			union all
			select 'Total' as [Fees Name]
			
			drop table #temp
		exec sp_executesql @query, N'@from smalldatetime, @to smalldatetime', @from = @FEE_START_DATE, @to = @FEE_END_DATE
		
		set @query2 = 'select CLASS_ID as ID,CLASS_HD_ID as [HD ID], CLASS_BR_ID as [BR ID],CLASS_Name as Name from SCHOOL_PLANE where CLASS_STATUS = ''T'''
		
		exec(@query2)
		set @query_parent = 'select * from VPARENT_INFO where [Status]  = ''T'' ' + @where_parent + ' order by ID asc '
			exec (@query_parent)
		drop table #tbl_daily_fee
	end
end
end