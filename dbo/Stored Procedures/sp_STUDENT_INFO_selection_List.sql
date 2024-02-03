
CREATE procedure [dbo].[sp_STUDENT_INFO_selection_List]
                                               
  
     @HD_ID  numeric,
     @BR_ID  numeric,
	 @SessionId numeric



	 AS


	  SELECT ROW_NUMBER() over (order by  [Class ID],CAST([Student School ID] as int),Status DESC) as Serial, [ID] ,[Student School ID] [StudnetNo] ,[Class Plan] as [Class],[First Name] FirstName,CASE WHEN [Status] = 'T' THEN CAST(1 as bit) ELSE CAST(0 as bit) END [Status],[Parent Name] [ParentName],[Fatehr Cell #] FatherCell, ISNULL(ParentEmail, ' ') ParentEmail
,[Family Code] FamilyCode,DOA,CASE WHEN [Gender] = 1 THEN 'Male' ELSE 'Female' END [Gender],[Father Address] FatherAddress,[P. Area] Area,[P. City] City,[Image],[Category],CreatedDate,CreatedBy,UpdatedDate,UpdateBy,[Date of Leaving] from VSTUDENT_INFO
   where SessionId = @SessionId and [Institute ID] = @HD_ID    
    and  [Branch ID] = @BR_ID
    and  [Status] != 'D'
	order by [Class Order],Status desc,CAST([Student School ID] as int)