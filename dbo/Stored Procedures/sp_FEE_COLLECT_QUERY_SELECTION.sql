CREATE procedure [dbo].[sp_FEE_COLLECT_QUERY_SELECTION]
	
		  @FEE_COLLECT_HD_ID  numeric,
          @FEE_COLLECT_BR_ID  numeric,
          @FEE_COLLECT_FEE_STATUS  nvarchar(30),
          @FEE_COLLECT_DATE date,
          @FEE_COLLECT_DATE_END date,
          @status char(1),
       	  @FEE_USER_TYPE nvarchar(50),
		  @FEE_USER_ID numeric,
		  @FEE_PARENT_ID numeric	
	
	As 
	--First it was taking too much time then I add this and now again taking too much time so I removed it
	--SET ARITHABORT ON;
	
--	declare		  @FEE_COLLECT_HD_ID  numeric = 2
--declare          @FEE_COLLECT_BR_ID  numeric = 1
--declare          @FEE_COLLECT_FEE_STATUS  nvarchar(30) = 'B'
--declare          @FEE_COLLECT_DATE date = '1900-01-01'
-- declare         @FEE_COLLECT_DATE_END date = ''
--declare          @status char(1) = 'defaulter'
-- declare      	  @FEE_USER_TYPE nvarchar(50) = 'A'
--declare		  @FEE_USER_ID numeric = 1
--declare		  @FEE_PARENT_ID numeric = 0	
	
		declare @parent nvarchar(50) = ''
		declare @bracnh_id nvarchar(50) = ''
		declare @student nvarchar(50) = '%'
		
		declare @recieved_date_start date = ''
		declare @recieved_date_end date = ''
		
		set @parent = dbo.[set_where_like] (@FEE_PARENT_ID)
		set @bracnh_id =  dbo.[set_where_like] (@FEE_COLLECT_BR_ID)		
	
		if @FEE_USER_TYPE = 'Student'
		begin
			set @student = dbo.[set_where_like] (@FEE_USER_ID)
		end
		
		if @FEE_USER_TYPE = 'Parent'
		begin
			set @parent = dbo.[set_where_like] (@FEE_USER_ID)
		end
		
		
	 --if @status = 'L'
		--begin		
		--	if @FEE_COLLECT_FEE_STATUS = 'Receivable'
		--		begin
		--			select distinct(ID), [Institute ID],[Branch ID],[Student ID],[Current Fee],[Fee Received],Arrears,[Arrears Received],[Net Total],[Date],[Status],[Class Plan],Name,[Parent Name],Class,Section,[Fee Mounths],[Date Received] from VFEE_COLLECT_QUERY		
		--			where [Status] = @FEE_COLLECT_FEE_STATUS
		--			and [Institute ID] = @FEE_COLLECT_HD_ID
		--			and [Branch ID] like @bracnh_id
		--			and DATEPART(MM,@FEE_COLLECT_DATE) = DATEPART(MM,[Date]) 
		--			and DATEPART(YY,@FEE_COLLECT_DATE) = DATEPART(YY,[Date])	
		--			and [Student ID] like @student
		--			and [Parent ID] like @parent
		--		end
				
		--	else
		--		begin
		--			select distinct(ID), [Institute ID],[Branch ID],[Student ID],[Current Fee],[Fee Received],Arrears,[Arrears Received],[Net Total],[Date],[Status],[Class Plan],Name,[Parent Name],Class,Section,[Fee Mounths],[Date Received] from VFEE_COLLECT_QUERY		
		--			where [Status] = @FEE_COLLECT_FEE_STATUS
		--			and [Institute ID] = @FEE_COLLECT_HD_ID
		--			and [Branch ID] like @bracnh_id
		--			and DATEPART(MM,@FEE_COLLECT_DATE) = DATEPART(MM,[Date Received]) 
		--			and DATEPART(YY,@FEE_COLLECT_DATE) = DATEPART(YY,[Date Received])	
		--			and [Student ID] like @student
		--			and [Parent ID] like @parent
		--		end
		 
		--End	
		
		 if @status = 'B'
		begin
			if @FEE_COLLECT_FEE_STATUS = 'Receivable'
			begin
				if @FEE_COLLECT_DATE = '1900-01-01'
				begin
					select @FEE_COLLECT_DATE = MIN([Date]), @FEE_COLLECT_DATE_END = MAX([Date]) from VFEE_COLLECT_QUERY
				end
				select * from
				(select distinct (ID), [Institute ID],[Branch ID],[Student ID],Name,[Parent Name],[Class Plan],Class,Section,[Fee Months],[Date],[Current Fee],[Fee Received] as [Current Fee Received] ,Arrears,[Arrears Received],([Current Fee] - [Fee Received] + Arrears - [Arrears Received]) as [Net Receivable],[Date Received],[Status] as [Fee Status], CAST([Student School ID] as int) [Student School ID],ClassOrder from VFEE_COLLECT_QUERY f	
				
				where [Status] = @FEE_COLLECT_FEE_STATUS
				and [Institute ID] = @FEE_COLLECT_HD_ID
				and [Branch ID] like @bracnh_id
				and [Date] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
				and [Student ID] like @student
				and [Parent ID] like @parent
				and [Student Status] = 'T')B
				order by ClassOrder, CAST([Student School ID] as int)
			end
			
			
			else if @FEE_COLLECT_FEE_STATUS = 'defaulter'
			begin
				if @FEE_COLLECT_DATE = '1900-01-01'
				begin
					select @FEE_COLLECT_DATE = MIN([Date]), @FEE_COLLECT_DATE_END = MAX([Date]) from VFEE_COLLECT_QUERY
					select @recieved_date_start = MIN([Date Received]), @recieved_date_end = MAX([Date Received]) from VFEE_COLLECT_QUERY
				end
				else
					select @recieved_date_start = @FEE_COLLECT_DATE, @recieved_date_end = @FEE_COLLECT_DATE_END
				
				
				-- Both are same difference is only that of Date and Date Received in where clause
				
					select *, (ISNULL([IFL Dis],0) + [Current]) as [Current Fee], (ISNULL([IFL Arrears Dis],0) + [Arrears Fee]) as Arrears from
					(select  *,(select SUM(fd.FEE_COLLECT_DEF_FEE) from FEE_COLLECT_DEF fd where fd.FEE_COLLECT_DEF_PID = B.[Invoice ID] and fd.FEE_COLLECT_DEF_OPERATION = '-') [IFL Dis],(select SUM(fd.FEE_COLLECT_DEF_ARREARS) from FEE_COLLECT_DEF fd where fd.FEE_COLLECT_DEF_PID = B.[Invoice ID] and fd.FEE_COLLECT_DEF_OPERATION = '-') [IFL Arrears Dis] from
					(
					select ID as [Invoice ID],[Student ID] ID,f.[Challan No],f.[Bill No],[Student School ID] as [St. No.], Class, Name [Student Name], [Parent Name] [Father Name],[Parent Cell] [Contact No.], case when [Installment Name] is null THEN [Fee Months] ELSE [Installment Name] END [Fee Months], [Current Fee] as [Current] ,  Arrears as [Arrears Fee],([Current Fee] + Arrears) as [Net Total], ([Arrears Received] + [Fee Received]) as [Fee Received], [Date Received] [Partially Fee Receiving Date], Rec.[Amount History],rec.[Date History],ISNULL([Cheq History],'') [Cheq History],[Current Fee] + Arrears - [Fee Received] - [Arrears Received] as [Balance Amount],[Class Plan],CASE WHEN Status = 'Partially Received' OR Status = 'Partially Received' THEN 'Partially Received' ELSE Status END as [Fee Status], [Fee Notes],a.[COA Account],[From Date],[ClassOrder]
					from VFEE_COLLECT_QUERY f
					left join (select * from dbo.FEE_COLLECT_QUERY_SELECTION_GET_ACCOUNTS(@FEE_COLLECT_BR_ID)) a on a.[Fee Collect ID] = f.ID
					left join (select MULTI_RECEIVE_INVOICE_ID, 

 STUFF(
(SELECT ',' + CAST(r2.MULTI_RECEIVE_AMOUNT as nvarchar(100))
FROM FEE_MULTIPLE_RECEIVED_AMOUNT r2
WHERE r1.MULTI_RECEIVE_INVOICE_ID = r2.MULTI_RECEIVE_INVOICE_ID
order by MULTI_RECEIVE_ID
FOR XML PATH('')),1,1,'') AS [Amount History],

 STUFF(
(SELECT ',' + CONVERT(nvarchar(50), r2.MULTI_RECEIVE_DATE_RECEIVE,103)
FROM FEE_MULTIPLE_RECEIVED_AMOUNT r2
WHERE r1.MULTI_RECEIVE_INVOICE_ID = r2.MULTI_RECEIVE_INVOICE_ID
order by MULTI_RECEIVE_ID
FOR XML PATH('')),1,1,'') AS [Date History]

from FEE_MULTIPLE_RECEIVED_AMOUNT r1 group by MULTI_RECEIVE_INVOICE_ID) Rec on Rec.MULTI_RECEIVE_INVOICE_ID = f.ID

left join (select B.CHEQ_FEE_COLLECT_ID [Invoice ID],

 STUFF(
(SELECT ',' + CAST(A.CHEQ_CHEQUE_NO as nvarchar(100)) from
(select cf1.CHEQ_FEE_COLLECT_ID, c1.CHEQ_CHEQUE_NO,c1.CHEQ_ID
 from 
CHEQ_FEE_INFO cf1 
join CHEQUE_INFO c1 on c1.CHEQ_ID = cf1.CHEQ_FEE_CHEQUE_ID)A
WHERE A.CHEQ_FEE_COLLECT_ID = B.CHEQ_FEE_COLLECT_ID
order by A.CHEQ_ID
FOR XML PATH('')),1,1,'') AS [Cheq History]

from
 (select cf1.CHEQ_FEE_COLLECT_ID, c1.CHEQ_CHEQUE_NO,c1.CHEQ_ID
 from 
CHEQ_FEE_INFO cf1 
join CHEQUE_INFO c1 on c1.CHEQ_ID = cf1.CHEQ_FEE_CHEQUE_ID)B
group by B.CHEQ_FEE_COLLECT_ID)C on C.[Invoice ID] = f.ID



					where  [Student Status] = 'T'
					and [Institute ID] = @FEE_COLLECT_HD_ID
					and [Branch ID] like @bracnh_id
					and [Date] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
					and [Student ID] like @student
					and [Parent ID] like @parent
					)B)C order by [ClassOrder], CAST([St. No.] as int), CAST(CAST(DATEPART(MM,[From Date]) as nvarchar(2))  + CAST(DATEPART(YYYY,[From Date]) as nvarchar(5)) as int)
					--union

					--select ID as [Invoice ID],[Student ID] ID, [Student School ID] as [St. No.], Class, Name [Student Name], [Parent Name] [Father Name],[Parent Cell] [Contact No.], [Fee Months],  [Current Fee] ,  Arrears,[Fee Received], [Arrears Received], [Date Received] [Partially Fee Receiving Date], [Net Total] - [Fee Received] - [Arrears Received] as [Balance Amount],[Class Plan],Status as [Fee Status]
					--from VFEE_COLLECT_QUERY 
					--where [Status] not in ('Fully Transfered', 'Partially Transfered') and [Student Status] = 'T'
					--and [Institute ID] = @FEE_COLLECT_HD_ID
					--and [Branch ID] like @bracnh_id
					--and [Date Received] between @recieved_date_start and @recieved_date_end
					--and [Student ID] like @student
					

					

				--select ID, [Institute ID], [Branch ID],[Student ID], [Class Plan],Name,[Parent Name],Class,Section,[Fee Months],[Date],SUM([Current Fee]) as [Current Fee], SUM([Fee Received]) as [Current Fee Received],  Arrears, [Arrears Received], SUM([Current Fee]) - SUM([Fee Received]) + Arrears - [Arrears Received] as [Net Defaulter Amount],[Date Received],[Status] as [Fee Status]
				--from 
				--(select distinct(ID), [Institute ID],[Branch ID],[Student ID],[Current Fee],0 [Fee Received], Arrears, [Arrears Received],[Date],[Status],[Class Plan],Name,[Parent Name],Class,Section,[Fee Months],[Date Received] from VFEE_COLLECT_QUERY		
				--where [Status] in ('Fully Transfered', 'Partially Transfered')
				--and [Institute ID] = @FEE_COLLECT_HD_ID
				--and [Branch ID] like @bracnh_id
				--and [Date] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
				--and [Student ID] like @student
				--and [Parent ID] like @parent				
				
				--union all
				
				--select distinct(ID), [Institute ID],[Branch ID],[Student ID],0[Current Fee], [Fee Received], Arrears, [Arrears Received],[Date],[Status],[Class Plan],Name,[Parent Name],Class,Section,[Fee Months],[Date Received] from VFEE_COLLECT_QUERY
				--where [Status] in ('Fully Transfered', 'Partially Transfered')
				--and [Institute ID] = @FEE_COLLECT_HD_ID
				--and [Branch ID] like @bracnh_id
				--and [Date Received] between @recieved_date_start and @recieved_date_end
				--and [Student ID] like @student
				--and [Parent ID] like @parent)A 
				--group by 
				--(ID), [Institute ID],[Branch ID],[Student ID], [Date],Arrears, [Arrears Received],[Status],[Class Plan],Name,[Parent Name],Class,Section,[Fee Months],[Date Received]
				end

			else if @FEE_COLLECT_FEE_STATUS = 'Partially Received'
			BEGIN
				if @FEE_COLLECT_DATE = '1900-01-01'
				begin
					select @FEE_COLLECT_DATE = MIN([Date]), @FEE_COLLECT_DATE_END = MAX([Date]) from VFEE_COLLECT_QUERY
					select @recieved_date_start = MIN([Date Received]), @recieved_date_end = MAX([Date Received]) from VFEE_COLLECT_QUERY
				end
				else
					select @recieved_date_start = @FEE_COLLECT_DATE, @recieved_date_end = @FEE_COLLECT_DATE_END
				
				
				-- Both are same difference is only that of Date and Date Received in where clause
				
					select ROW_NUMBER() over (order by [Class Plan], CAST([St. No.] as int)) as Sr, * from
					(
					select [Student ID] ID, [Student School ID] as [St. No.], Class, Name [Student Name], [Parent Name] [Father Name],[Parent Cell] [Contact No.], [Fee Months],
	 [Net Total] [Total Fee Amount], ([Arrears Received] + [Fee Received])[Fee Received], [Date Received] [Partially Fee Receiving Date], 
	 [Net Total] - [Fee Received] - [Arrears Received] as [Balance Amount],[Class Plan]
   from VFEE_COLLECT_QUERY a where [Status] = 'Partially Received' and [Student Status] = 'T'
					and [Institute ID] = @FEE_COLLECT_HD_ID
					and [Branch ID] like @bracnh_id
					and [Date] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
					and [Student ID] like @student
					and [Parent ID] like @parent

					union

								select [Student ID] ID, [Student School ID] as [St. No.], Class, Name [Student Name], [Parent Name] [Father Name],[Parent Cell] [Contact No.], [Fee Months],	 [Net Total] [Total Fee Amount], ([Arrears Received] + [Fee Received])[Fee Received], [Date Received] [Partially Fee Receiving Date], 
	 [Net Total] - [Fee Received] - [Arrears Received] as [Balance Amount],[Class Plan]
   from VFEE_COLLECT_QUERY a where [Status] = 'Partially Received' and [Student Status] = 'T'
					and [Institute ID] = @FEE_COLLECT_HD_ID
					and [Branch ID] like @bracnh_id
					and [Date Received] between @recieved_date_start and @recieved_date_end
					and [Student ID] like @student
					)A order by [Class Plan], CAST([St. No.] as int)
			END
			else if @FEE_COLLECT_FEE_STATUS = 'Fully Received'
			begin 
				if @FEE_COLLECT_DATE = '1900-01-01'
				begin
					select @FEE_COLLECT_DATE = MIN([Date Received]), @FEE_COLLECT_DATE_END = MAX([Date Received]) from VFEE_COLLECT_QUERY
				end
				select ROW_NUMBER() over (order by [Class Plan], CAST([St. No.] as int)) as Sr, * from
					(
				--select distinct(ID), [Institute ID],[Branch ID],[Student ID],[Class Plan],Name,[Parent Name],Class,Section,[Fee Months],Date,[Current Fee],[Fee Received] as [Current Fee Received],Arrears,[Arrears Received],[Net Total] as [Net Fully Received],[Date Received],[Status] as [Fee Status],CAST([Student School ID] as int) from VFEE_COLLECT_QUERY
				select [Student ID] ID, [Student School ID] as [St. No.], Class, Name [Student Name], [Parent Name] [Father Name],[Parent Cell] [Contact No.], [Fee Months],
	 [Net Total] [Total Fee Amount], ([Arrears Received] + [Fee Received])[Fee Received], [Date Received] [Partially Fee Receiving Date], 
	 [Net Total] - [Fee Received] - [Arrears Received] as [Balance Amount],[Class Plan] from VFEE_COLLECT_QUERY
				where [Status] = @FEE_COLLECT_FEE_STATUS
				and [Institute ID] = @FEE_COLLECT_HD_ID
				and [Branch ID] like @bracnh_id
				and [Date Received] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
				and [Student ID] like @student
				and [Parent ID] like @parent)A
				order by [Class Plan], CAST([St. No.] as int)
			end
			else
			begin
				if @FEE_COLLECT_DATE = '1900-01-01'
				begin
					select @FEE_COLLECT_DATE = MIN([Date Received]), @FEE_COLLECT_DATE_END = MAX([Date Received]) from VFEE_COLLECT_QUERY
				end
				select distinct(ID), [Institute ID],[Branch ID],[Student ID],[Class Plan],Name,[Parent Name],Class,Section,[Fee Months],Date,[Current Fee],[Fee Received] as [Current Fee Received],Arrears,[Arrears Received],([Current Fee] - [Fee Received] + Arrears - [Arrears Received]) as [Net Partially Receivable],[Date Received],[Status] as [Fee Status],CAST([Student School ID] as int) from VFEE_COLLECT_QUERY
				where [Status] = @FEE_COLLECT_FEE_STATUS
				and [Institute ID] = @FEE_COLLECT_HD_ID
				and [Branch ID] like @bracnh_id
				and [Date Received] between @FEE_COLLECT_DATE and @FEE_COLLECT_DATE_END
				and [Student ID] like @student
				and [Parent ID] like @parent
				order by [Class Plan],CAST([Student School ID] as int)
			end
		End	
		
		
    else if @status = 'C'
	Begin
		select * from VFEE_COLLECT
		where Status = 'Closed'
		and [Institute ID] = @FEE_COLLECT_HD_ID
		and [Branch ID] = @FEE_COLLECT_BR_ID	
		and DATEPART(MM,@FEE_COLLECT_DATE) = DATEPART(MM,[Date]) 
		and DATEPART(YY,@FEE_COLLECT_DATE) = DATEPART(YY,[Date]) 
		 
	End