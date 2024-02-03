CREATE procedure  [dbo].[sp_TEACHER_INFO_selection]
                                               
                                               
     @STATUS char(1),
     @TECH_ID  numeric,
     @TECH_HD_ID  numeric,
     @TECH_BR_ID  numeric
      
      
    AS BEGIN 
    
     --declare @STATUS char(1) = 'L'
     --declare @TECH_ID  numeric = 4
     --declare @TECH_HD_ID  numeric = 2
     --declare @TECH_BR_ID  numeric = 1
     
   if @STATUS = 'L'
   BEGIN
    SELECT * FROM VTEACHER_INFO
      where 
    [Institute ID] =  @TECH_HD_ID 
    and  [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('S', @TECH_BR_ID)) 
    and [Status] !='D' order by Ranking
	
	select DGRE_ID as Code,DGRE_NAME as Name from DEGREE_INFO
	where DGRE_STATUS  = 'T'
	and DGRE_HD_ID = @TECH_HD_ID and DGRE_BR_ID = @TECH_BR_ID
    
	--select PARNT_ID as Code,PARNT_FULL_NAME as Name from  PARENT_INFO
	--where PARNT_STATUS !='D' and PARNT_STATUS !='F'
		
		
		
		select * from VPARENT_INFO
		 where [Institute ID] = @TECH_HD_ID   
    and  [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('P', @TECH_BR_ID))
    and  [Status]  = 'T'
	
	
	select RELIGION_ID as Code,RELIGION_NAME as Name from RELIGION_INFO
	where RELIGION_STATUS  = 'T'
		and RELIGION_HD_ID = @TECH_HD_ID and RELIGION_BR_ID = @TECH_BR_ID
	
	select NATIONALITY_ID as Code,NATIONALITY_NAME as Name from NATIONALITY_INFO
	where NATIONALITY_STATUS  = 'T'
	and NATIONALITY_HD_ID = @TECH_HD_ID and NATIONALITY_BR_ID = @TECH_BR_ID
	
	
	select LANG_ID as Code,LANG_NAME as Name from LANG_INFO
	where LANG_STATUS  = 'T'
	and LANG_HD_ID = @TECH_HD_ID and LANG_BR_ID = @TECH_BR_ID
	
	
	select DESIGNATION_ID as Code,DESIGNATION_NAME as Name from DESIGNATION_INFO
	where DESIGNATION_STATUS  = 'T'
	and DESIGNATION_HD_ID = @TECH_HD_ID and DESIGNATION_BR_ID = @TECH_BR_ID
	
	select USER_CODE as ID , USER_STATUS as [Status], USER_TYPE as [Type] from USER_INFO
	where
	USER_HD_ID = @TECH_HD_ID
	and USER_BR_ID in ( select * from [dbo].[get_centralized_br_id]('P', @TECH_BR_ID)) and
	[USER_ID] in (select TECH_USER_INFO_ID from TEACHER_INFO)
	--and USER_TYPE = 'Teacher' 
	--and USER_STATUS != 'D'
	
	--select DEDUCTION_ID as [ID],  DEDUCTION_NAME as [Name], DEDUCTION_PRCNT_BS as [Employee Contribution], DEDUCTION_PRCNT_SS as 
	--[School Contribution], DEDUCTION_STATUS as [Status]			
	--from DEDUCTION
	--where
	--DEDUCTION_BR_ID = @TECH_BR_ID and
	--DEDUCTION_HD_ID = @TECH_HD_ID and 
	--DEDUCTION_STATUS != 'D'
	
	select DEDUCTION_ID as [ID], DEDUCTION_NAME as [Name]		
	from DEDUCTION
	where
	DEDUCTION_BR_ID = @TECH_BR_ID and
	DEDUCTION_HD_ID = @TECH_HD_ID and 
	DEDUCTION_STATUS = 'T'
	
	--select STAFF_DEDUCTION_ID as [ID],STAFF_DEDUCTION_DED_ID as [Deduction ID], STAFF_DEDUCTION_VAL_TYPE as [Value Type], 
	--STAFF_DEDUCTION_MONTHS as [Months], STAFF_DEDUCTION_TYPE as [Type], 
	--STAFF_DEDUCTION_PRCNT_BS as [Employee Contribution], STAFF_DEDUCTION_PRCNT_SS as [School Contribution],
	--STAFF_DEDUCTION_REFUNDABLE as [Refundable], STAFF_DEDUCTION_STATUS as [Status], STAFF_DEDUCTION_STAFF_ID as [Staff ID]
	--from STAFF_DEDUCTION s, DEDUCTION d
	
	select STAFF_DEDUCTION_ID as [ID], d.DEDUCTION_NAME as [Name], STAFF_DEDUCTION_VAL_TYPE as [Value Type], 
	STAFF_DEDUCTION_MONTHS as [Months], STAFF_DEDUCTION_TYPE as [Type], 
	STAFF_DEDUCTION_PRCNT_BS as [Employee Contribution], STAFF_DEDUCTION_PRCNT_SS as [School Contribution],
	STAFF_DEDUCTION_REFUNDABLE as [Refundable], STAFF_DEDUCTION_STATUS as [Status], STAFF_DEDUCTION_STAFF_ID as [Staff ID], 
	d.DEDUCTION_ID as [Ded ID]
	from STAFF_DEDUCTION s
	join DEDUCTION d
	on s.STAFF_DEDUCTION_DED_ID = d.DEDUCTION_ID
		
	where 
		--STAFF_DEDUCTION_BR_ID = @TECH_BR_ID and
	STAFF_DEDUCTION_HD_ID = @TECH_HD_ID and 
	STAFF_DEDUCTION_STATUS != 'D'
	
	select ALLOWANCE_ID as [ID],  ALLOWANCE_NAME as [Name]
	from ALLOWANCE
	where
	ALLOWANCE_BR_ID = @TECH_BR_ID and
	ALLOWANCE_HD_ID = @TECH_HD_ID and 
	ALLOWANCE_STATUS = 'T'
	
	select s.STAFF_ALLOWANCE_ID as [ID], a.ALLOWANCE_NAME as [Name], STAFF_ALLOWANCE_VAL_TYPE as [Value Type], 
	STAFF_ALLOWANCE_MONTHS as [Months], STAFF_ALLOWANCE_TYPE as [Type], 
	STAFF_ALLOWANCE_AMOUNT as [Amount], STAFF_ALLOWANCE_STATUS as [Status], STAFF_ALLOWANCE_STAFF_ID as [Staff ID],
	a.ALLOWANCE_ID as [Allow ID]
	from STAFF_ALLOWANCE s
	join ALLOWANCE a
	on s.STAFF_ALLOWANCE_ALLOW_ID = a.ALLOWANCE_ID
	where 
	--STAFF_ALLOWANCE_BR_ID = @TECH_BR_ID and
	STAFF_ALLOWANCE_HD_ID = @TECH_HD_ID and 
	STAFF_ALLOWANCE_STATUS != 'D'
	
		select * from VSTAFF_LEAVES 
	where 
		[Institute ID] =  @TECH_HD_ID and
		--[Branch ID] = @TECH_BR_ID and
		[Status] = 'T'
	

    
 --  select STAFF_LEAVES_ID as [ID], STAFF_LEAVES_NAME as [Name], STAFF_LEAVES_YEAR as [Year],
 --  STAFF_LEAVES_MONTHLY_LIMIT as [Month], STAFF_LEAVES_TRANSFER_YEAR as [Transfer Year],
 --  STAFF_LEAVES_TRANSFER_MONTH as [Transfer Month], STAFF_LEAVES_STAFF_ID as [Staff ID], STAFF_LEAVES_ABSENT_DEDUCTION as [Absent Deduction],
 --  STAFF_LEAVES_LATE_PER_ABSENT as [Late Per Absent]
   
 --  from STAFF_LEAVES
 --  where
 --  STAFF_LEAVES_BR_ID = @TECH_BR_ID and
	--STAFF_LEAVES_HD_ID = @TECH_HD_ID and 
	--STAFF_LEAVES_STATUS = 'T'
	
	select STAFF_WORKING_DAYS_ID as ID, STAFF_WORKING_DAYS_NAME as Name, STAFF_WORKING_DAYS_DAY_STATUS as [Day Status],
	STAFF_WORKING_DAYS_TIME_IN as [Time In], STAFF_WORKING_DAYS_TIME_OUT as [Time Out], 
	STAFF_WORKING_DAYS_STAFF_ID as [Staff ID], STAFF_WORKING_DAYS_PACKAGE_ID [Package ID]
		
	from STAFF_WORKING_DAYS
	where
	--STAFF_WORKING_DAYS_BR_ID = @TECH_BR_ID and
	STAFF_WORKING_DAYS_HD_ID = @TECH_HD_ID and 
	STAFF_WORKING_DAYS_STATUS = 'T'
	
	SELECT WORKING_DAYS_ID AS ID, WORKING_DAYS_NAME AS Name, 
	WORKING_DAYS_VALUE AS [Day Status] FROM WORKING_DAYS
	where
	WORKING_DAYS_BR_ID = @TECH_BR_ID and
	WORKING_DAYS_HD_ID = @TECH_HD_ID and 
	WORKING_DAYS_STATUS = 'T'
	
	SELECT WORKING_HOURS_ID as ID, WORKING_HOURS_TIME_IN as [Time In], WORKING_HOURS_TIME_OUT as [Time Out]
     FROM WORKING_HOURS
     where
      WORKING_HOURS_HD_ID =  @TECH_HD_ID and 
     WORKING_HOURS_BR_ID =  @TECH_BR_ID and
     WORKING_HOURS_STATUS = 'T'

	select DEP_ID as Code,DEP_NAME as Name from DEPARTMENT_INFO
	where DEP_STATUS  = 'T'
	and DEP_HD_ID = @TECH_HD_ID and DEP_BR_ID = @TECH_BR_ID

	select ID, Name from VWORKING_HOURS_PACKAGES where  [Institute ID] = @TECH_HD_ID and [Branch ID] = @TECH_BR_ID and Status = 'T'
	select * from WORKING_HOURS_PACKAGES_DEF where WORK_PACK_DEF_PID in (select ID from VWORKING_HOURS_PACKAGES where  [Institute ID] = @TECH_HD_ID and [Branch ID] = @TECH_BR_ID and Status = 'T')

	select ID, Name from VCITY_INFO 
	where 
		[Institute ID] =  @TECH_HD_ID and
		[Branch ID] = @TECH_BR_ID and
		[Status] = 'T'


	select DEDUCTION_ID as ID, DEDUCTION_FROM_TIME AS [From Time], DEDUCTION_TO_TIME as [To Time], DEDUCTION_PERCENT_SALARY as [Percent of Salary], DEDUCTION_STAFF_ID as [Staff ID] from STAFF_LATE_TIME_DEDUCTION

	select BR_ADM_PAYROLL_HOURS_IN_DAY, BR_ADM_PAYROLL_MINUTES_IN_HOUR from BR_ADMIN where BR_ADM_ID = @TECH_BR_ID

	select ID, Name from VSTAFF_TYPE_INFO 
	where 
		[Institute ID] =  @TECH_HD_ID and
		[Branch ID] = @TECH_BR_ID and
		[Status] = 'T'


	 select * from TBL_COA where COA_Name = 'Staff' and CMP_ID = @TECH_HD_ID and BRC_ID = @TECH_BR_ID and COA_isDeleted = 0
	 select * from TBL_DEFAULT_ACCT where DEFAULT_ACCT_KEY = 'Staff' and CMP_ID = @TECH_HD_ID and BRC_ID = @TECH_BR_ID and DEFAULT_ACCT_isDeleted = 0
      
	  select BANK_ID ID, BANK_NAME Name from BANK_INFO where BANK_HD_ID = @TECH_HD_ID and BANK_BR_ID = @TECH_BR_ID and BANK_STATUS = 'T' 

    END

     ELSE if @STATUS = 'B'
     BEGIN
	SELECT * FROM VTEACHER_INFO
 
          where  ID = @TECH_ID   

		and  [Status] != 'D' order by Ranking
   
	select USER_STATUS as [Login Status]  from USER_INFO
	where USER_CODE = @TECH_ID and
		 USER_TYPE = 'Teacher'
		 
		END
    
    
    ELSE IF @STATUS = 'R'
    begin
		select ID, Name, Designation, ISNULL(Ranking,1000) as [Ranking #] from VTEACHER_INFO where 
		[Institute ID] =  @TECH_HD_ID 
		 and  [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('S', @TECH_BR_ID)) and
		[Status] = 'T' order by [Ranking #]
    end
    
    
    Else if @STATUS = 'A'
     BEGIN
	SELECT * FROM VTEACHER_INFO
      where 
    [Institute ID] =  @TECH_HD_ID 
    and  [Branch ID] in ( select * from [dbo].[get_centralized_br_id]('S', @TECH_BR_ID)) 
    and [Status] = 'T' order by Ranking
 
     END
 
  END