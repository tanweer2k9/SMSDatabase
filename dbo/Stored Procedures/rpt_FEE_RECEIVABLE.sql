CREATE PROCEDURE [dbo].[rpt_FEE_RECEIVABLE]

	@HD_ID NUMERIC,
	@BR_ID NUMERIC,
	@STUDENT_ID NUMERIC,
	@PLAN_ID NUMERIC,
	@FEE_STATUS NVARCHAR(50),
	@FROM_DATE datetime,
	@TO_DATE datetime,
	@STATUS nvarchar(50),
	@FEE_USER_TYPE nvarchar(50),
	@FEE_USER_ID numeric,
	@FEE_PARENT_ID numeric
AS
BEGIN

--	declare @HD_ID NUMERIC = 2
--declare @BR_ID NUMERIC = 1
--declare @STUDENT_ID NUMERIC = 1
--declare @PLAN_ID NUMERIC = 0
--declare @FEE_STATUS NVARCHAR(50) = 'All'
--declare @FROM_DATE datetime = '2012-12-20'
--declare @TO_DATE datetime = '2013-09-01'
--declare @STATUS nvarchar(50) = 'FEE'
--declare @FEE_PARENT_ID numeric = 0
--declare @FEE_USER_TYPE nvarchar(50) = 'Parent'
--declare @FEE_USER_ID numeric = 5
	
		
	declare @start_date_generate date
	declare @end_date_generate date
	declare @start_date_received date
	declare @end_date_received date
	
	
	declare @parent nvarchar(50) = ''
	declare @bracnh_id nvarchar(50) = ''
	declare @student nvarchar(50) = '%'
	
	declare @plan nvarchar(20) = ''
	declare @where_clause  nvarchar(max) = ''
	declare @query  nvarchar(max) = ''
	
	
	
	if @FROM_DATE = '1900-01-01'
	begin
		select @start_date_generate = MIN([Date]), @end_date_generate = Max([Date]),  
		@start_date_received = MIN([Date Received]), @end_date_received = Max([Date Received]) from rpt_V_FEE_RECEIVABLE
		set @where_clause = ' and Date BETWEEN @FROM_DATE AND @TO_DATE '
	end
	else
	begin
		set @start_date_generate = @FROM_DATE
		set @end_date_generate = @TO_DATE
		set @start_date_received = @FROM_DATE
		set @end_date_received = @TO_DATE
	end
		
	
	set @parent = dbo.[set_where_like] (@FEE_PARENT_ID)
	set @plan = dbo.[set_where_like] (@PLAN_ID)
	
	if @FEE_USER_TYPE = 'Student'
	begin
		set @student = dbo.[set_where_like] (@FEE_USER_ID)
	end
	
	if @FEE_USER_TYPE = 'Parent'
	begin
		set @parent = dbo.[set_where_like] (@FEE_USER_ID)
	end
	
	
	if @PLAN_ID = 0
	begin
		set @plan = '%'
	end
	else
	begin
		set @plan = CONVERT(nvarchar(10), @PLAN_ID)
		--set @where_clause = @where_clause + ' and [Plan ID] = ' + CONVERT(nvarchar(10), @PLAN_ID)
	end
	
	--if @FEE_STATUS = 'All'
	--	begin
	--		set @FEE_STATUS = '%'	
	--	end
	
	if @FEE_PARENT_ID = '0'
		begin
			if @FEE_USER_TYPE != 'Parent'
			begin
				set @parent = '%'
			end
		end
		
	else		
		set @parent = CONVERT(nvarchar(10), @FEE_PARENT_ID)		
		
	if @BR_ID = '0'
		 begin
			set @bracnh_id = '%'
		end
		
	else
		begin
			set @bracnh_id = CONVERT(nvarchar(10), @BR_ID)
		end
	
	

	
	--IF (@STATUS='ID')
	--			BEGIN
	--			SELECT ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved] FROM rpt_V_FEE_RECEIVABLE				
	--			where [Institute ID] = @HD_ID and
	--			Branch = @BR_ID and 
	--			ID = @STUDENT_ID				
	--			group by ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved],[Plan ID]
	--			order by ID
	--END
	
	--ELSE IF (@STATUS = 'P_ID')
	--	BEGIN
	--	IF @FEE_STATUS='All'
	--				BEGIN
	--				SELECT ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved]  FROM rpt_V_FEE_RECEIVABLE
	--				where [Institute ID] = @HD_ID and
	--				Branch = @BR_ID and
	--				[Plan ID] = @PLAN_ID
	--				group by ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved],[Plan ID]
	--				order by ID
	--				END
					
	--				ELSE
	--				BEGIN
					
	--				SELECT ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved]  FROM rpt_V_FEE_RECEIVABLE
	--				where [Institute ID] = @HD_ID and
	--				Branch = @BR_ID and 												
	--				[Status] = @FEE_STATUS and
	--				[Plan ID] = @PLAN_ID
	--				group by ID,[First Name],[Last Name],Class,Section,[Current Fee],[Fee Received],Status,Month,Year,Arrears,[Arrears Recieved],[Plan ID]
	--				order by ID
	--	END
	--	end
	--ELSE IF (@STATUS = 'DATE')
	--BEGIN
	--SELECT ID,[First Name],[Last Name],Class,Section,[Total Fee],[Fee Received],Status FROM V_rpt_Fee_Receivable

	--				where [Institute ID] = @HD_ID and
	--				Branch = @BR_ID and 
	--				Date BETWEEN @FROM_DATE AND @TO_DATE
	
	--END
	
	--ELSE 
	IF (@STATUS ='FEE')
	BEGIN
	
					IF @FEE_STATUS='All'
					BEGIN
						select [Invoice ID],ID,[First Name] ,[Last Name],Class,Section, SUM([Current Fee]) as [Current Fee], SUM([Fee Received]) as [Fee Received], Month , Year, SUM(Arrears) as Arrears, SUM([Arrears Recieved]) as [Arrears Recieved],Status from 
						(
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,[Current Fee], 0 [Fee Received],Status, Month , Year ,Arrears, 0 [Arrears Recieved], [Month int] from rpt_V_FEE_RECEIVABLE where [Date] between @start_date_generate and @end_date_generate and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] not in ('Fully Transfered', 'Partially Transfered') and [Parent ID] like @parent and [ID] like @student
							union ALL
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,[Fee Received] as [Current Fee], 0 [Fee Received],Status, Month , Year ,[Arrears Recieved] as Arrears, 0 [Arrears Recieved], [Month int] from rpt_V_FEE_RECEIVABLE where [Date] between @start_date_generate and @end_date_generate and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] = 'Partially Transfered' and [Parent ID] like @parent and [ID] like @student
							 
							UNION ALL
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,0 [Current Fee], [Fee Received],Status, Month , Year ,0 Arrears, [Arrears Recieved], [Month int]  from rpt_V_FEE_RECEIVABLE where [Date Received] between @start_date_received and @end_date_received and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and [Parent ID] like @parent and [ID] like @student and [Status] != 'Fully Transfered'
						) a
						group by ID, [Month int], [Month]  , [Year],[First Name] ,[Last Name],Class,Section,Status,[Invoice ID]
						order by ID,[Year], [Month int]
						END
					
					ELSE IF @FEE_STATUS = 'Receivable'					
						BEGIN 
							select [Invoice ID],ID,[First Name] ,[Last Name],Class,Section, SUM([Current Fee]) as [Current Fee], SUM([Fee Received]) as [Fee Received], Status, Month , Year, SUM(Arrears) as Arrears, SUM([Arrears Recieved]) as [Arrears Recieved],Status from 
						(
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,[Current Fee], 0 [Fee Received],Status, Month , Year ,Arrears, 0 [Arrears Recieved], [Month int] from rpt_V_FEE_RECEIVABLE where [Date] between @start_date_generate and @end_date_generate and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] ='Receivable' and [Parent ID] like @parent and [ID] like @student							
							
						) a
						group by ID, [Month int], [Month]  , [Year],[First Name] ,[Last Name],Class,Section,Status,[Invoice ID]
						order by ID,[Year], [Month int]	
						END
					ELSE IF @FEE_STATUS = 'Fully Received'
					BEGIN
						select [Invoice ID],ID,[First Name] ,[Last Name],Class,Section, SUM([Current Fee]) as [Current Fee], SUM([Fee Received]) as [Fee Received], Status, Month , Year, SUM(Arrears) as Arrears, SUM([Arrears Recieved]) as [Arrears Recieved],Status from 
						(
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,[Current Fee], 0 [Fee Received],Status, Month , Year ,Arrears, 0 [Arrears Recieved], [Month int] from rpt_V_FEE_RECEIVABLE where [Date] between @start_date_generate and @end_date_generate and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] ='Fully Received' and [Parent ID] like @parent and [ID] like @student
							
							UNION ALL
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,0 [Current Fee], [Fee Received],Status, Month , Year ,0 Arrears, [Arrears Recieved], [Month int]  from rpt_V_FEE_RECEIVABLE where [Date Received] between @start_date_received and @end_date_received and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] ='Fully Received' and [Parent ID] like @parent and [ID] like @student
						) a
						group by ID, [Month int], [Month]  , [Year],[First Name] ,[Last Name],Class,Section,Status,[Invoice ID]
						order by ID,[Year], [Month int]
					END	
					ELSE IF @FEE_STATUS = 'Partially Received'
					BEGIN
						select [Invoice ID],ID,[First Name] ,[Last Name],Class,Section, SUM([Current Fee]) as [Current Fee], SUM([Fee Received]) as [Fee Received], Status, Month , Year, SUM(Arrears) as Arrears, SUM([Arrears Recieved]) as [Arrears Recieved],Status from 
						(
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,[Current Fee], 0 [Fee Received],Status, Month , Year ,Arrears, 0 [Arrears Recieved], [Month int] from rpt_V_FEE_RECEIVABLE where [Date] between @start_date_generate and @end_date_generate and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] ='Partially Received' and [Parent ID] like @parent and [ID] like @student							
							UNION ALL
							select [Invoice ID], ID,[First Name] ,[Last Name],Class,Section,0 [Current Fee], [Fee Received],Status, Month , Year ,0 Arrears, [Arrears Recieved], [Month int]  from rpt_V_FEE_RECEIVABLE where [Date Received] between @start_date_received and @end_date_received and [Institute ID] in (select * from dbo.get_all_hd_id (@HD_ID)) and [Branch] in (select * from dbo.get_all_br_id (@BR_ID)) and [Plan ID] like @plan and  [Status] ='Partially Received' and [Parent ID] like @parent and [ID] like @student
						) a
						group by ID, [Month int], [Month]  , [Year],[First Name] ,[Last Name],Class,Section,Status,[Invoice ID]
						order by ID,[Year], [Month int]
					END
					
	END			




END