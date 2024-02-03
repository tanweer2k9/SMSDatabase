CREATE PROCEDURE [dbo].[rpt_FEE_SLIP_SELECTION]
	 
	 @status char(10),
     @FEE_COLLECT_ID  numeric,
     @FEE_COLLECT_HD_ID  numeric,
     @FEE_COLLECT_BR_ID  numeric,
	 @FEE_COLLECT_DATE date,
	 @ORDER_BY nvarchar(50),
	 @IS_COMBINE_BRANCHES bit
AS

	declare @tbl_br_id table (BR_ID int)

							
	declare @t table (Invoice_id numeric, amount float)
	declare @tbl_check_not_cleared table (std_id int, amount float)
	--declare @FROM_DATE date = ''
	--	declare @TO_DATE date = ''
		
	--	set @FROM_DATE = (select MIN(FEE_COLLECT_FEE_FROM_DATE) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED = @FEE_COLLECT_DATE)
	--	set @TO_DATE = (select MAX(FEE_COLLECT_FEE_TO_DATE) from FEE_COLLECT where FEE_COLLECT_DATE_FEE_GENERATED = @FEE_COLLECT_DATE)
		
		insert into @t
		select ADV_FEE_DEF_FEE_COLLECT_ID, SUM(ADV_FEE_DEF_AMOUNT) from FEE_ADVANCE_DEF group by ADV_FEE_DEF_FEE_COLLECT_ID
		--select [Std ID], SUM(Amount) from (	select [Std ID],d.Amount from VFEE_ADVANCE a
		--join VFEE_ADVANCE_DEF d on d.PID = a.ID	where d.[From Date] between @FROM_DATE and @TO_DATE and d.Adjust = 'T'
		--union
		--select [Std ID],d.Amount from VFEE_ADVANCE a	join VFEE_ADVANCE_DEF d on d.PID = a.ID
		--where d.[to Date] between @FROM_DATE and @TO_DATE and d.Adjust = 'T')B group by [Std ID]	
		
		declare @cell_no_type nvarchar(50) = ISNULL((select [Invoice Mobile No] from V_BRANCH_INFO where [Institute ID] = @FEE_COLLECT_HD_ID and ID = @FEE_COLLECT_BR_ID),'Parent')
		declare @invoice_mobile_txt nvarchar(15) = ''
		

		insert into @tbl_check_not_cleared select FEE_COLLECT_STD_ID, SUM(FEE_COLLECT_NOT_CLEARED_BANK_AMOUNT) as amount from FEE_COLLECT group by FEE_COLLECT_STD_ID

		if @cell_no_type = 'Parent'
			set @invoice_mobile_txt = 'P. #'
		else
			set @invoice_mobile_txt = 'Std #'
		
		
		--declare @IS_COMBINE_BRANCHES bit = 1

			if @IS_COMBINE_BRANCHES = 1
				BEGIN
					insert into @tbl_br_id
					select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID  = @FEE_COLLECT_BR_ID
				END
				ELSE
				BEGIN
					insert into @tbl_br_id
					select @FEE_COLLECT_BR_ID
				END


	if @status = 'M'
		Begin				
		
				if @ORDER_BY = 'Student'
				BEGIN
		
					select *,[Net Total] + IIF([Branch ID] = 10, 500, 1000) NetTotalAfterDueDate from
					(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name][Month], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears) Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] ,[Due Date], [School ID], CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell] , ISNULL(t.amount,0) as  [Advance Fee], @invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],CASE WHEN [School ID] = '' THEN 50000 ELSE  CONVERT(numeric(18,0),[School ID]) END as [Sch ID],[Logo Reports], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-31', [Net Total] - Arrears, [Net Total] - ISNULL(t.amount,0)) [Net Total],ClassOrder,ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle, IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail   from rpt_V_FEE_SLIP v
					left join @t t on t.Invoice_id = ID
					left join @tbl_check_not_cleared c on c.std_id = [Std ID]

					
					where [Net Total] > 0 and
						
					[Branch ID] in ( select BR_ID from @tbl_br_id)
					and ID != 404530
					--and [Status] = 'Receivable'
					and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
					and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))A
					order by [Branch ID] desc,ClassOrder,[Sch ID]
				END
				ELSE
				BEGIN
				select *,[Net Total] + IIF([Branch ID] = 10, 500, 1000) NetTotalAfterDueDate from
					(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name] [Month], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears)      Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID], CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell] , ISNULL(t.amount,0) as [Advance Fee], @invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction], CASE WHEN [Family Code] = '' THEN 5000000 ELSE  CONVERT(numeric(18,0),[Family Code]) END as FamCode,[Logo Reports],( IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30', [Net Total] - Arrears, [Net Total] - ISNULL(t.amount,0))) [Net Total],ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle, IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail    from rpt_V_FEE_SLIP  
					left join @t t on t.Invoice_id = ID		
					left join @tbl_check_not_cleared c on c.std_id = [Std ID]
					where [Net Total] > 0 and
						[Branch ID] in ( select BR_ID from @tbl_br_id)
				
					--and [Status] = 'Receivable'
					and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
					and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))A
					order by FamCode
				END

		--select * from rpt_V_FEE_SLIP_DEF where [Status] = 'T'

		End
		
	Else if @status = 'B'
		Begin				
		select *,[Net Total] + IIF([Branch ID] = 10, 500, 1000) NetTotalAfterDueDate from
		(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name][Month],  IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears)  Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID],CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell] , ISNULL(t.amount,0) as [Advance Fee],@invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],[Logo Reports],  IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30', [Net Total] - Arrears, [Net Total] - ISNULL(t.amount,0))  [Net Total],ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle,IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail     from rpt_V_FEE_SLIP  
		left join @t t on t.Invoice_id = ID
		left join @tbl_check_not_cleared c on c.std_id = [Std ID]
		where [Net Total] > 0 and ID = @FEE_COLLECT_ID and
		    [Institute ID] = @FEE_COLLECT_HD_ID and
		    [Branch ID] = @FEE_COLLECT_BR_ID )A
			order by [Family Code]

		End


Else if @status = 'C'
		Begin				
		--select * ,(select CONVERT(NVARCHAR(5), Day( [DAY]) ) from VFEE_SETTING where [Institute ID] = @FEE_COLLECT_HD_ID and [Branch ID] = @FEE_COLLECT_BR_ID) +  '/' +  CONVERT(nvarchar(10), DATEPART(MM, [Date])) + '/' +   CONVERT(nvarchar(10), DATEPART(YYYY, [Date])) [Due Date]	 from rpt_V_FEE_SLIP  

		IF @ORDER_BY = 'Student'
		BEGIN
			select *,[Net Total] + IIF([Branch ID] = 10, 500, 1000) NetTotalAfterDueDate from
			(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name][Month], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears)  Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID],CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell], ISNULL(t.amount,0) as [Advance Fee],@invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],CASE WHEN [School ID] = '' THEN 50000 ELSE  CONVERT(numeric(18,0),[School ID]) END as [Sch ID],[Logo Reports],   IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30', [Net Total] - Arrears, [Net Total] - ISNULL(t.amount,0))  [Net Total],ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle, IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail    from rpt_V_FEE_SLIP  
			left join @t t on t.Invoice_id = ID
			left join @tbl_check_not_cleared c on c.std_id = [Std ID]
			where [Net Total] > 0 and
			[Institute ID] = @FEE_COLLECT_HD_ID and
			[Branch ID] = @FEE_COLLECT_BR_ID and 
			[Class ID] = @FEE_COLLECT_ID
			--and [Status] = 'Receivable'
			and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
			and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))A
			order by [Sch ID]
		END
		ELSE
		BEGIN
		select *,[Net Total] + IIF([Branch ID] = 10, 500, 1000) NetTotalAfterDueDate from
			(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name][Month], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears)  Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID],CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell], ISNULL(t.amount,0) as [Advance Fee],@invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],CASE WHEN [Family Code] = '' THEN 5000000 ELSE  CONVERT(numeric(18,0),[Family Code]) END as FamCode,[Logo Reports],( IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30', [Net Total] - Arrears, [Net Total] - ISNULL(t.amount,0)) ) [Net Total],ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle, IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail     from rpt_V_FEE_SLIP  
			left join @t t on t.Invoice_id = ID
			left join @tbl_check_not_cleared c on c.std_id = [Std ID]
			where [Net Total] > 0 and
			[Institute ID] = @FEE_COLLECT_HD_ID and
			[Branch ID] = @FEE_COLLECT_BR_ID and 
			[Class ID] = @FEE_COLLECT_ID
			--and [Status] = 'Receivable'
			and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
			and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))A
			order by FamCode
		END
				



		    
		end



Else if @status = 'F'
		Begin				
		
		--select distinct(ID),[Institute ID],[Branch ID],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Month],Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID],CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell], ISNULL(t.amount,0) as [Advance Fee],@invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction] from rpt_V_FEE_SLIP  
		--join @t t on t.std_id = [Std ID]
		--left join @tbl_check_not_cleared c on c.std_id = [Std ID]
		--where
		--    [Institute ID] = @FEE_COLLECT_HD_ID and
		--    [Branch ID] = @FEE_COLLECT_BR_ID and 
		--    [Std ID] = @FEE_COLLECT_ID
		--    and [Status] = 'Receivable'
		--    and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
		--    and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date])
		--	order by [Family Code]

		select *,[Net Total] + 1000 NetTotalAfterDueDate from
		(select distinct(ID),[Institute ID],[Branch ID],[Branch Name],[First Name],[Last Name],Class,Section,[Std ID],[Date],[Installment Name][Month], IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30',0,Arrears)  Arrears,Notes,STD_FEE_NOTES_STATUS,[Status],[Father Name],[Class ID],[Bank Name],[Bank Acct Title],[Bank Acct no] , [Due Date], [School ID],CASE WHEN @cell_no_type = 'Parent' THEN [Parent Cell] ELSE [Student Cell] END as [Cell], ISNULL(t.amount,0) as [Advance Fee],@invoice_mobile_txt as [Mobile No Inovice],[Start Date],[Attendance From Date],[Attendance To Date],[Parent Address],[Family Code],'1. Late Fee Rs. ' + CAST([Late Fee Fine] as nvarchar(50)) + ' Per Day' as instruction,[Late Fee Fine],c.amount as [Amount Not Cleared], '3. Reprinting charges of Challan Form is Rs.' + CAST([Reprinting Charges] as nvarchar(50)) as [Reprinting Instruction],[Logo Reports],( IIF([Branch ID] <=2 AND [Start Date] between '2020-05-01' and '2020-08-30', [Net Total] - Arrears, [Net Total]- ISNULL(t.amount,0) ) ) [Net Total],ISNULL(BankDetail1,'') BankDetail1,ISNULL(BankDetail2,'') BankDetail2 ,ISNULL(CareOfTitle,'') CareOfTitle,IIF([Branch ID] = 5, dbo.fn_Get_Bill_No( [Start Date],[End Date],[School ID]), BillNo) BillNo,REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST([Reprinting Charges] as nvarchar(50))),'##latefeefine##',CAST([Late Fee Fine] as nvarchar(50))) ParentCopyInstruction,ChallanNo,ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', [Late Fee Fine]) BankCopyInstruction,ISNULL(ParentEmail,'') ParentEmail     from rpt_V_FEE_SLIP  
		left join @t t on t.Invoice_id = ID
		left join @tbl_check_not_cleared c on c.std_id = [Std ID]
		where [Net Total] > 0 and
		    --[Institute ID] = @FEE_COLLECT_HD_ID and
		    --[Branch ID] = @FEE_COLLECT_BR_ID and 
		    [Parent ID] = @FEE_COLLECT_ID
		    --and [Status] = 'Receivable'
		    and datepart(YY,@FEE_COLLECT_DATE) = datepart(YY,[Start Date])
		    and datepart(MM,@FEE_COLLECT_DATE) = datepart(MM,[Start Date]))A
			order by [family code]
		    
		end
ELSE if @status = 'R'
BEGIN
	select m.Id ID, b.BR_ADM_HD_ID [Institute ID], m.BrId [Branch ID], b.BR_ADM_NAME [Branch Name], s.StudentName [First Name],'' [Last Name], sp.CLASS_Name Class, '' Section,s.Id [Std ID], GETDATE() [Date], m.InstallmentName [Month], 0 Arrears,'' Notes,'' STD_FEE_NOTES_STATUS,  FeeStatus [Status], ParentName [Father Name], CLASS_ID [Class ID], b.BR_ADM_BANK_NAME [Bank Name], b.BR_ADM_ACCT_TITLE [Bank Acct Title], b.BR_ADM_ACCT_NO [Bank Acct no], FORMAT (DueDate, 'MMM. dd, yyyy') [Due Date], s.RegistrationNo [School ID],ParentMobileNo [Cell],  0 [Advance Fee],'P. #'  [Mobile No Inovice],StartDate [Start Date],GETDATE()  [Attendance From Date],GETDATE() [Attendance To Date], Address + ' ' + ISNULL(c.CITY_NAME, '') [Parent Address],'' [Family Code],'1. Late Fee Rs. ' + CAST(FEE_SETTING_FINE as nvarchar(50)) + ' Per Day' as instruction, FEE_SETTING_FINE [Late Fee Fine],0 [Amount Not Cleared],'3. Reprinting charges of Challan Form is Rs.' + CAST(FEE_SETTING_REPRINT_CHARGES as nvarchar(50)) as [Reprinting Instruction] , 0 FamCode, h.MAIN_INFO_LOGO_REPORTS [Logo Reports], NetTotal [Net Total], fc.BankDetail1, fc.BankDetail2,fc.CareOfTitle,BillNo, REPLACE(REPLACE(SchoolCopyInstruction,'##reprinting##', CAST(FEE_SETTING_REPRINT_CHARGES as nvarchar(50))),'##latefeefine##',CAST(FEE_SETTING_FINE as nvarchar(50))) SchoolCopyInstruction,REPLACE(REPLACE(ParentCopyInstruction,'##reprinting##', CAST(FEE_SETTING_REPRINT_CHARGES as nvarchar(50))),'##latefeefine##',CAST(FEE_SETTING_FINE as nvarchar(50))) ParentCopyInstruction,ChallanNo,FORMAT (DueDate, 'MMM. dd, yyyy') ValidDate,REPLACE(BankCopyInstruction,'##latefeefine##', FEE_SETTING_FINE) BankCopyInstruction,'' ParentEmail,NetTotal + 1000 NetTotalAfterDueDate  from  StdRegFeeGenerationMaster m
join StudentRegistration s on s.Id = m.StudentRegistrationId
join BR_ADMIN b on b.BR_ADM_ID = m.BrId
join SCHOOL_PLANE sp on sp.CLASS_ID = s.ClassId
join CITY_INFO c on c.CITY_ID = s.CityId
join FEE_SETTING f on f.FEE_SETTING_BR_ID = m.BrId
join MAIN_HD_INFO h on h.MAIN_INFO_ID = b.BR_ADM_HD_ID
join FeeChallanBankDetail fc on fc.BrId = m.BrId


where m.Id = @FEE_COLLECT_ID
END