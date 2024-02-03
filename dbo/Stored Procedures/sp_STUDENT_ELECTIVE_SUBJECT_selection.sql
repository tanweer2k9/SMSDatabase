CREATE procedure  [dbo].[sp_STUDENT_ELECTIVE_SUBJECT_selection]
                                               
                                               
     @STATUS char(10),
     @STD_ELE_SUB_ID  numeric,
     @STD_ELE_SUB_STDNT_ID  numeric,
	 @CLASS_ID  numeric,
	 @HD_ID  numeric,
	 @BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN   
		SELECT ID, [Group Name] FROM VELECTIVE_SUBJECT p
			where [Class ID] = @CLASS_ID

		--SELECT PID,SUB_ID as [Subject ID], SUB_NAME as [Subject] FROM VELECTIVE_SUBJECT p
		--join VELECTIVE_SUBJECT_DEF c on p.ID = c.PID
		--join SUBJECT_INFO s on s.SUB_ID = c.Subject
		
		SELECT PID,c.ID as [Subject ID], SUB_NAME as [Subject] FROM VELECTIVE_SUBJECT p
		join VELECTIVE_SUBJECT_DEF c on p.ID = c.PID
		join SUBJECT_INFO s on s.SUB_ID = c.Subject
		where [Class ID] = @CLASS_ID order by PID

--		SELECT STD_ELE_SUB_SUBJECT_ID as [Subject ID], 1 as [Is Select], 1 as [Select Group] FROM STUDENT_ELECTIVE_SUBJECT
		
		SELECT e.ELE_SUB_DEF_ID as [Subject ID], 1 as [Is Select], 1 as [Select Group] 
		FROM STUDENT_ELECTIVE_SUBJECT s
		join ELECTIVE_SUBJECT_DEF e on s.STD_ELE_SUB_SUBJECT_ID = e.ELE_SUB_DEF_ID
		WHERE			
			STD_ELE_SUB_STDNT_ID =  @STD_ELE_SUB_STDNT_ID 

		select CLASS_MIN_ELECTIVE_SUBJECTS, CLASS_MAX_ELECTIVE_SUBJECTS from SCHOOL_PLANE
		where CLASS_ID = @CLASS_ID
     END  
  --   ELSE if @STATUS = 'A'
  --   BEGIN
		--SELECT STD_ELE_SUB_SUBJECT_ID as [Subject ID], 1 as [Is Select] FROM STUDENT_ELECTIVE_SUBJECT
		--WHERE			
		--	STD_ELE_SUB_STDNT_ID =  @STD_ELE_SUB_STDNT_ID 
 
  --   END
 
     END


	SELECT ROW_NUMBER() over (order by (select 0)) as Serial, [ID] ,[Student School ID] [Std. School ID] ,[Class Plan] as [Class],[First Name],[Last Name],[Status],[Parent Name] [Father's Name],[Fatehr Cell #]
,[Family Code],[House],[Registered Date] DOA,[DOB],[Gender],[Father Address],[P. Area] Area,[P. City] City,[Country],[Religion]  ,[Image],[Session],[Institute ID]
,[Branch ID],[Parent ID],[Fee ID],[Student Registration ID],[Register By ID],[Type],[Previous School],[Mother Language],[Emergency Contact Name]
,[Emergency Contact Cell #],[Cell #],[Temperory Address],[Permanant Address],[Transport],[Email Address]   ,[Date],[Session ID],[Description],[Discount Rule ID]
,[House ID],[Conduct ID],[Conduct],[Date of Leaving],[With Draw No],[Category],[Remarks],[City ID],[City] as [Std. City],[Area ID],[Area] as [Std. Area],[Class ID]
  ,(select COUNT(*) from FEE_COLLECT where FEE_COLLECT_STD_ID = ID) as [Fee Count], [Scholarship ID], [Lab Type],[Is Rejoin] FROM VSTUDENT_INFO
         where [Institute ID] = @HD_ID   
    and  [Branch ID] = @BR_ID
    and  [Status] = 'T'
	and [Class ID] in (select CLASS_ID from SCHOOL_PLANE where CLASS_HD_ID = @HD_ID and CLASS_BR_ID = @BR_ID and CLASS_IS_MANDATORY = CAST(0 as bit))
    order by ID asc