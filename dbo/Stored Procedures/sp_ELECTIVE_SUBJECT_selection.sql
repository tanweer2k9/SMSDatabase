CREATE procedure  [dbo].[sp_ELECTIVE_SUBJECT_selection]
                                               
                                               
     @STATUS char(10),
     @ELE_SUB_ID  numeric,
     @ELE_SUB_HD_ID  numeric,
     @ELE_SUB_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN  
     
	 
	 SELECT ID, Subject,'S' [Status] FROM VELECTIVE_SUBJECT_DEF
	 where ID = 0

	 SELECT * FROM VELECTIVE_SUBJECT
	where
		 [Institute ID] = @ELE_SUB_HD_ID  and
		[Branch ID] = @ELE_SUB_BR_ID and 
		Status != 'D'

     END  
     ELSE
     BEGIN
			SELECT ID, [Subject],'S' [Status] FROM VELECTIVE_SUBJECT_DEF
			 WHERE
			 PID =  @ELE_SUB_ID
 
				SELECT * FROM VELECTIVE_SUBJECT
					where
					[Institute ID] = @ELE_SUB_HD_ID  and
					[Branch ID] = @ELE_SUB_BR_ID and 
					Status != 'D'

     END
 

 	 select ID, Name from VSCHOOL_PLANE 
	 where 
		[Institute ID] = @ELE_SUB_HD_ID  and
		[Branch ID] = @ELE_SUB_BR_ID and 
		Status = 'T' and [Is Mandatory] = 0

	--select ID, Name from VSUBJECT_INFO
	--where
	--[Institute ID] = @ELE_SUB_HD_ID  and
	--	[Branch ID] = @ELE_SUB_BR_ID and 
	--	Status = 'T'

		select [Subject ID], MAX([Subject]) as [Subject], MAX(CAST([Is Compulsory] AS tinyint)) as [Is Compulsory], [Class ID] from
		(
		select [Subject ID], Subject,[Is Compulsory],[Class ID] from VSCHOOL_PLANE_DEFINITION where [Class ID] in 
		(select ID from VSCHOOL_PLANE  where [Institute ID] = @ELE_SUB_HD_ID  and [Branch ID] = @ELE_SUB_BR_ID and Status = 'T' and [Is Mandatory] = 0)
		and Status = 'T'
		)A where [Is Compulsory] = 0  group by [Class ID], [Subject ID]



     END