
CREATE procedure  [dbo].[sp_STUDENT_INFO_selection]
                                               
                                               
     @STATUS char(1),
     @STDNT_ID numeric,
     @STDNT_HD_ID  numeric,
     @STDNT_BR_ID  numeric
	 
   
     AS BEGIN 
   if @STATUS = 'L'
   BEGIN
   SELECT ROW_NUMBER() over (order by (select 0)) as Serial, [ID] ,[Student School ID] [Std. School ID] ,[Class Plan] as [Class],[First Name],[Last Name],
   --CASE WHEN [Status] = 'T' THEN CAST(1 as bit) ELSE CAST(0 as bit) END 
   [Status],[Parent Name] [Father's Name],[Fatehr Cell #]
,[Family Code],[House],[Registered Date] DOA,[DOB],CASE WHEN [Gender] = 1 THEN 'Male' ELSE 'Female' END [Gender],[Father Address],[P. Area] Area,[P. City] City,[Country],[Religion]  ,[Image],[Session],[Institute ID]
,[Branch ID],[Parent ID],[Fee ID],[Student Registration ID],[Register By ID],[Type],[Previous School],[Mother Language],[Emergency Contact Name]
,[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address]   ,[Date],[Session ID],[Description],[Discount Rule ID]
,[House ID],[Conduct ID],[Conduct],[Date of Leaving],[With Draw No],[Category],[Remarks],[City ID],[City] as [Std. City],[Area ID],[Area] as [Std. Area],[Class ID]
  ,(select COUNT(*) from FEE_COLLECT where FEE_COLLECT_STD_ID = ID) as [Fee Count], [Scholarship ID], [Lab Type],[Is Rejoin] FROM VSTUDENT_INFO
         where [Institute ID] = @STDNT_HD_ID   
    and  [Branch ID] = @STDNT_BR_ID
    and  [Status] != 'D'
    order by ID asc

    --group by ID,[Institute ID],[Branch ID],[Parent Name],[Plan Name],[Register By ID],[Type],[First Name],[Last Name],Gender,Country,Religion,DOB,[Previous School],[Mother Language],[Emergency Contact Name],[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address],[Image],[Registered Date],[Status]
    
    select CLASS_ID as Code,CLASS_Name as Name, CLASS_IS_SUPPLEMENTARY_BILLS as Supplementry from SCHOOL_PLANE
    where CLASS_STATUS = 'T'
    and CLASS_HD_ID = @STDNT_HD_ID and CLASS_BR_ID = @STDNT_BR_ID
    
    --select PARNT_ID as Code,PARNT_FULL_NAME as Name from  PARENT_INFO
    
		select p.ID, [Family Code], h.MAIN_INFO_INSTITUTION_FULL_NAME School,b.BR_ADM_NAME Branch, p.[1st Relation Name],p.[2nd Relation Name],p.[1st Relation CNIC],p.[2nd Relation CNIC], p.[1st Relation Cell #],p.[2nd Relation Cell #],p.[1ST Relation],p.[2nd Relation],p.Area,p.City,p.[1st Relation Image],p.[2nd Relation Image],CASE WHEN [Status] = 'T' THEN CAST(1 as bit) ELSE CAST(0 as bit) END [Status],p.[1st Relation Occupation], p.[2nd Relation Occupation],p.[1st Relation Temperory Address],p.[2nd Relation Temperory Address],p.[1st Relation Permanant Address],p.[2nd Relation Permanant Address],p.[1st Relation Land Line #],[Area ID],[City ID]  from VPARENT_INFO p
		join MAIN_HD_INFO h on h.MAIN_INFO_ID = p.[Institute ID]
		join BR_ADMIN b on b.BR_ADM_ID = p.[Branch ID]
		 where --[Institute ID] = @STDNT_HD_ID   and  
		 [Branch ID] in  (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @STDNT_BR_ID) --( select * from [dbo].[get_centralized_br_id]('P', @STDNT_BR_ID))
    and  [Status]  = 'T'
    order by ID asc
		
	
	select RELIGION_ID as Code,RELIGION_NAME as Name from RELIGION_INFO
	where RELIGION_STATUS  = 'T'
	and RELIGION_HD_ID = @STDNT_HD_ID and RELIGION_BR_ID = @STDNT_BR_ID
	
	select NATIONALITY_ID as Code,NATIONALITY_NAME as Name from NATIONALITY_INFO
	where NATIONALITY_STATUS  = 'T'
	and NATIONALITY_HD_ID = @STDNT_HD_ID and NATIONALITY_BR_ID = @STDNT_BR_ID
	
	select LANG_ID as Code,LANG_NAME as Name from LANG_INFO
	where LANG_STATUS  = 'T'
	and LANG_HD_ID = @STDNT_HD_ID and LANG_BR_ID = @STDNT_BR_ID
	
	select TRANSPORT_ID as Code,TRANSPORT_NAME as Name from TRANSPORT_INFO
	where TRANSPORT_STATUS  = 'T'
	and TRANSPORT_HD_ID = @STDNT_HD_ID and TRANSPORT_BR_ID = @STDNT_BR_ID
	
	
	select USER_CODE as ID , USER_STATUS  as [Status] from USER_INFO
	where
	
	USER_HD_ID = @STDNT_HD_ID
	and USER_BR_ID = @STDNT_BR_ID
	and USER_TYPE = 'Student' 
	and USER_STATUS != 'D'
	
	
	select * from VPLAN_FEE
		 where [Institute ID] = @STDNT_HD_ID   
    and  [Branch ID] = @STDNT_BR_ID
    and  [Status]  = 'T'
    order by ID asc
	
   	select ID,Name from VPEOPLE_RELATIONS_INFO
	
	where [Institute ID] = @STDNT_HD_ID            
    and  [Branch ID] = @STDNT_BR_ID
    and [Status] ='T'

	select ID,Name from VFEE_INFO
	
	where [Institute ID] = @STDNT_HD_ID            
    and  [Branch ID] = @STDNT_BR_ID
    and [Status] ='T'

	select ID, Name,[Class ID] from VDISCOUNT_RULES 
		where [Institute ID] = @STDNT_HD_ID            
		and  [Branch ID] = @STDNT_BR_ID
		and [Status] ='T'

	select ID, Name from VHOUSES_INFO
		where [Institute ID] = @STDNT_HD_ID            
		and  [Branch ID] = @STDNT_BR_ID
		and [Status] ='T'

		select ID, Name from VCONDUCT_INFO
		where [Institute ID] = @STDNT_HD_ID            
		and  [Branch ID] = @STDNT_BR_ID
		and [Status] ='T'

		select ID, Name from VCITY_INFO
		where [Institute ID] = @STDNT_HD_ID            
		and  [Branch ID] = @STDNT_BR_ID
		and [Status] ='T'

		select ID, Name from VAREA_INFO
		where [Institute ID] = @STDNT_HD_ID            
		and  [Branch ID] = @STDNT_BR_ID
		and [Status] ='T'

		declare @tb table(code int)
		insert into @tb 
		SELECT CAST(LEFT(Val,PATINDEX('%[^0-9]%', Val+'a')-1) as bigint)as family_code from(
		SELECT SUBSTRING([Family Code], PATINDEX('%[0-9]%', [Family Code]), LEN([Family Code])) Val from VPARENT_INFO 
		
		)A
		select MAX(code)  from @tb



		select es.STD_ELE_SUB_STDNT_ID as [Std ID], SUB_NAME [Subject]
		FROM STUDENT_ELECTIVE_SUBJECT es
		join ELECTIVE_SUBJECT_DEF ed on ed.ELE_SUB_DEF_ID = es.STD_ELE_SUB_SUBJECT_ID
		JOIN SUBJECT_INFO s ON s.SUB_ID = ed.ELE_SUB_DEF_SUB_ID
		where s.SUB_HD_ID = @STDNT_HD_ID and s.SUB_BR_ID = @STDNT_BR_ID


		select SCH_DRAW_ID, SCH_DRAW_NAME from SCHOLARSHIP_WITHDRAWL where SCH_DRAW_HD_ID = @STDNT_HD_ID and SCH_DRAW_BR_ID = @STDNT_BR_ID and SCH_DRAW_STATUS = 'T'
		


   END
   
    ELSE if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM VSTUDENT_INFO
         where [Institute ID] = @STDNT_HD_ID   
    and  [Branch ID] = @STDNT_BR_ID
    and  [Status] != 'D'
   --group by ID,[Institute ID],[Branch ID],[Parent Name],[Plan Name],[Register By ID],[Type],[First Name],[Last Name],Gender,Country,Religion,DOB,[Previous School],[Mother Language],[Emergency Contact Name],[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address],[Image],[Registered Date],[Status]
    
   
    
     END  
     
     ELSE IF @STATUS = 'S'
     SELECT *, CASE when ID > 0 then (select STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_ID = ID) ELSE 0 END as 
     [Class ID] FROM VSTUDENT_INFO
		where [Status] = 'T' order by ID
    
     ELSE if @STATUS = 'B'
     BEGIN
	SELECT * FROM VSTUDENT_INFO
 
          where  ID = @STDNT_ID   
    and  [Status] != 'D'
    order by ID asc
    --group by ID,[Parent Name],[Institute ID],[Branch ID],[Parent Name],[Plan Name],[Register By ID],[Type],[First Name],[Last Name],Gender,Country,Religion,DOB,[Previous School],[Mother Language],[Emergency Contact Name],[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address],[Image],[Registered Date],[Status]
  
	select USER_STATUS as [Login Status]  from USER_INFO
	where USER_CODE = @STDNT_ID and
		 USER_TYPE = 'Student'
	
     END
 
	
 
     END