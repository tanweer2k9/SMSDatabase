CREATE procedure  [dbo].[sp_STAFF_SALLERY_QUERY_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_SALLERY_ID  numeric,
     @STAFF_SALLERY_HD_ID  numeric,
     @STAFF_SALLERY_BR_ID  numeric,
     @STAFF_SALLERY_STAFF_ID numeric,
     @STAFF_SALLERY_START_DATE date,
     @STAFF_SALLERY_END_DATE date
     

   
     AS BEGIN 

	if @STATUS = 'L'
     BEGIN
	declare @current_month int =  ( select  DATEPART(MM,MAX([Date] ))  from VSTAFF_SALLERY )
	declare @current_year int = ( select  DATEPART(yyyy,MAX([Date] ))  from VSTAFF_SALLERY )	
	
   
     SELECT [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary]
	  from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and DATEPART(MM,[Date]) = @current_month  and DATEPART(yyyy,[Date]) = @current_year and [Status] != 'Fully Paid'
     
	 SELECT [Staff ID] ID, [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary] from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and DATEPART(MM,[Date]) = @current_month  and DATEPART(yyyy,[Date]) = @current_year and [Status] = 'Fully Paid'
     END  

   
   
     else if @STATUS = 'B'
     BEGIN
   
     SELECT  [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary] from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and [Date] between @STAFF_SALLERY_START_DATE and @STAFF_SALLERY_END_DATE and [Status] != 'Fully Paid'
     
	 SELECT  [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary] from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and [Date] between @STAFF_SALLERY_START_DATE  and @STAFF_SALLERY_END_DATE and [Status] = 'Fully Paid'
     END  
     
     else if @STATUS = 'S'-- staff
     begin
     SELECT * FROM VTEACHER_INFO
      where 
    [Institute ID] = @STAFF_SALLERY_HD_ID
    --and  [Branch ID] like [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID)
    and  [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID))
    and [Status] != 'D'
     end
     
     
     else if @STATUS = 'C' -- collection
	begin
	
	SELECT [Staff ID] ID, [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary] from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and [Staff ID] = @STAFF_SALLERY_STAFF_ID and [Status] != 'Fully Paid'
    
	SELECT [Staff ID] ID, [Emp Code], Department,Designation,[Staff First Name] +' ' + [Staff Last Name]as [Name],[Salary Month],[Working Days] [Salary Days],
	 [Total Presenets] P, [Total Absents] A,[Total Leaves] LE,[Late Days] LA, [Deduct Days],Salary [Basic Salary], [Total Deductions] Deductions, [Total Earnings] Allowances,
	 [Absent Detuctions] [Attendance Deduction], [Net Total] [Net Salary] from VSTAFF_SALLERY where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and [Staff ID] = @STAFF_SALLERY_STAFF_ID and [Status] = 'Fully Paid'
     select Name, [Contact #] as [Staff Cell] from VTEACHER_INFO where [Branch ID] in (select * from dbo.get_centralized_br_id ('S',@STAFF_SALLERY_BR_ID)) and
     [Institute ID] = @STAFF_SALLERY_HD_ID and ID = @STAFF_SALLERY_STAFF_ID
     
	--SELECT * from VSTAFF_SALLERY where [Branch ID] like [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID) and
 --    [Institute ID] = @STAFF_SALLERY_HD_ID and [Staff ID] = @STAFF_SALLERY_STAFF_ID and [Status] != 'Fully Paid'
 --   SELECT * from VSTAFF_SALLERY where [Branch ID] like [dbo].[get_centralized_br_id]('S', @STAFF_SALLERY_BR_ID) and
 --    [Institute ID] = @STAFF_SALLERY_HD_ID and [Staff ID] = @STAFF_SALLERY_STAFF_ID and [Status] = 'Fully Paid'
     
	end
	
     END