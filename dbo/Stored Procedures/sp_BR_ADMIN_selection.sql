CREATE procedure  [dbo].[sp_BR_ADMIN_selection]                                                                                            
     @STATUS char(10),
     @BR_ADM_HD_ID  numeric,
     @BR_ADM_ID numeric
   
     AS BEGIN    
     
     --declare @STATUS char(10) = 'L'
     --declare @BR_ADM_HD_ID  numeric = 2
     --declare @BR_ADM_ID numeric   = 1

	 declare @branches_count int =0
	 set @branches_count = (select COUNT(*) from V_BRANCH_INFO where [Institute ID] = @BR_ADM_HD_ID) 

     if @STATUS = 'L'
     BEGIN
   
		SELECT ID,[Institute ID],Name,Email,Website,Land_line,Mobile,[Status],[Login Status],[Parent Centralize ID], [Staff Centralize ID],[Assessment Type], [User Name], [Password],[Invoice Mobile No],[Minutes in hour],[Hours in day],[Is Overtime Generate in Slip],[Late Minutes],Commission,[Overtime After Time Out],[Overtime Calculation Type] ,[Is Advance Accounting],[Is Advacne Class Plan], [Is Fees with Accounts],[Fees Per Month],[Student Late Minutes],BankDetail1,BankDetail2,CareOfTitle FROM V_BRANCH_INFO
		where [Institute ID] = @BR_ADM_HD_ID
		and [Status] != 'D'
		group by ID,[Institute ID],Name,Email,Website,Land_line,Mobile,[Status],[Login Status],[Parent Centralize ID], [Staff Centralize ID],[Assessment Type],[User Name], [Password],[Invoice Mobile No],[Minutes in hour],[Hours in day],[Is Overtime Generate in Slip],[Late Minutes],Commission,[Overtime After Time Out],[Overtime Calculation Type],[Is Advance Accounting],[Is Advacne Class Plan], [Is Fees with Accounts],[Fees Per Month],[Student Late Minutes],BankDetail1,BankDetail2,CareOfTitle
		
		if @branches_count = 0
			select ID,NAME from VNATIONALITY_INFO where Status = 'T' and [Institute ID] = 1
		 else
		 	select ID,NAME from VNATIONALITY_INFO where [Status] = 'T' and [Institute ID] = @BR_ADM_HD_ID


		
		SELECT ANN_HOLI_ID as ID, ANN_HOLI_NAME as Name, ANN_HOLI_DATE as [Date], ANN_HOLI_STATUS as [Status] FROM ANNUAL_HOLIDAYS 
		where ANN_HOLI_ID = null
		  
		select 0 ID,'Over All' Name
		  union all
		select ID,Name from VFEE_INFO
		where [Institute ID] = @BR_ADM_HD_ID
		and [Branch ID] = @BR_ADM_ID
		and [Status] = 'T'	
		
		

				
     END  
     ELSE if @STATUS = 'B'
     BEGIN
     
		SELECT ID,[Institute ID],Name,Email,Website,Land_line,Mobile,[Status],[Login Status],[Parent Centralize ID], [Staff Centralize ID],[Assessment Type],[User Name], [Password],[Invoice Mobile No],[Minutes in hour],[Hours in day] ,[Is Overtime Generate in Slip],[Late Minutes],Commission,[Overtime After Time Out],[Overtime Calculation Type],[Is Advance Accounting],[Is Advacne Class Plan], [Is Fees with Accounts],[Fees Per Month],[Student Late Minutes],BankDetail1,BankDetail2,CareOfTitle FROM V_BRANCH_INFO
		where [Institute ID] = @BR_ADM_HD_ID
		and [Status] != 'D'
		group by ID,[Institute ID],Name,Email,Website,Land_line,Mobile,[Status],[Login Status],[Parent Centralize ID], [Staff Centralize ID],[Assessment Type],[User Name], [Password],[Invoice Mobile No],[Minutes in hour],[Hours in day],[Is Overtime Generate in Slip],[Late Minutes],Commission,[Overtime After Time Out],[Overtime Calculation Type],[Is Advance Accounting],[Is Advacne Class Plan], [Is Fees with Accounts],[Fees Per Month],[Student Late Minutes],BankDetail1,BankDetail2,CareOfTitle
  
		SELECT * FROM V_BRANCH_INFO
		 WHERE
		 [Institute ID] =  @BR_ADM_HD_ID and 
		 ID = @BR_ADM_ID     
		 
     END
     
	
	ELSE if @STATUS = 'A'
	begin
		SELECT ID,Name FROM V_BRANCH_INFO
		where [Institute ID] = @BR_ADM_HD_ID
		and [Status] != 'D'
	end
	
			
 ELSE if @STATUS = 'P'  --Password Information
 begin
	select top(1) USER_INFO.USER_NAME as [Login Name], USER_INFO.USER_PASSWORD as [Password] from USER_INFO
	join BR_ADMIN  on USER_BR_ID = BR_ADM_ID where USER_TYPE = 'A'
	order by BR_ADM_ID desc 
	
 end

  SELECT ANN_HOLI_ID as ID, ANN_HOLI_NAME as Name, ANN_HOLI_DATE as [Date], ANN_HOLI_STATUS as [Status] FROM ANNUAL_HOLIDAYS 
     WHERE      
     ANN_HOLI_HD_ID =  @BR_ADM_HD_ID and 
     ANN_HOLI_BR_ID =  @BR_ADM_ID and
     ANN_HOLI_STATUS != 'D'
 
 
	select WORKING_DAYS_ID as ID,WORKING_DAYS_NAME [Days Name],WORKING_DAYS_VALUE [Days Value] ,WORKING_DAYS_DEPENDENCE [Dependence] from WORKING_DAYS
	where
	WORKING_DAYS_HD_ID = @BR_ADM_HD_ID and
	WORKING_DAYS_BR_ID = @BR_ADM_ID and
	WORKING_DAYS_STATUS = 'T'
			
	select SMS_API_ID as ID, SMS_API_NAME as Name, SMS_API_BRAND_NAME as [Brand Name], SMS_API_USERNAME as [User Name],
	SMS_API_PASSWORD as [Password], SMS_API_SIGNATURE as [Signature] from SMS_API where SMS_API_ID in (select BR_ADM_SMS_API_ID from BR_ADMIN where BR_ADM_ID = @BR_ADM_ID)
	
	if @branches_count = 0
		select ID,Name from VCITY_INFO where [Institute ID] =  1 and  Status = 'T'		
	else
		select ID,Name from VCITY_INFO where [Institute ID] =  @BR_ADM_HD_ID and [Branch ID] =  @BR_ADM_ID and Status = 'T'
     END

	 select b.BR_ADM_ID, + h.MAIN_INFO_INSTITUTION_SHORT_NAME +' (' + b.BR_ADM_NAME  + ')' from BR_ADMIN b
	 join MAIN_HD_INFO h on b.BR_ADM_HD_ID = h.MAIN_INFO_ID 
	 where b.BR_ADM_STATUS = 'T'