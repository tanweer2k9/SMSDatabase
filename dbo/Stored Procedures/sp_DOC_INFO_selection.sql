CREATE procedure  [dbo].[sp_DOC_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @DOC_INFO_ID  numeric,
     @DOC_INFO_ACT_ID  numeric
   
   
     AS BEGIN 
 
	
		if @STATUS = 'L'
		BEGIN
		SELECT DOC_INFO_ID as [ID],DOC_INFO_NAME AS [Document Type Name],DOC_INFO_CUSTODAN as [Custodian],DOC_INFO_TEXT as [Document Name],DOC_INFO_PATH as [Path],DOC_INFO_STATUS as [Status]  FROM DOC_INFO 
		where DOC_INFO_ACT_ID = null		
		
		select ID, Name from VDOC_NAME_INFO Doc		
		where Status = 'T'
		
		select ID, Name from VDOC_CUSTODIAN_INFO
		where Status = 'T'
		
		END
   
   
     
     ELSE if @STATUS = 'S'
     
     BEGIN
	 SELECT DOC_INFO_ID as [ID],DOC_INFO_NAME AS [Document Type Name],DOC_INFO_CUSTODAN as [Custodian],DOC_INFO_TEXT as [Document Name],DOC_INFO_PATH as [Path],DOC_INFO_STATUS as [Status]  FROM DOC_INFO
     WHERE 
     DOC_INFO_ACT_ID =  @DOC_INFO_ACT_ID 
	 and DOC_INFO_ACT_TYPE = 'STD'
	 and DOC_INFO_STATUS != 'D' 
     END
 
	 ELSE if @STATUS = 'T'
     
     BEGIN
	 SELECT DOC_INFO_ID as [ID],DOC_INFO_NAME AS [Document Type Name],DOC_INFO_CUSTODAN as [Custodian],DOC_INFO_TEXT as [Document Name],DOC_INFO_PATH as [Path],DOC_INFO_STATUS as [Status]  FROM DOC_INFO
     WHERE 
     DOC_INFO_ACT_ID =  @DOC_INFO_ACT_ID 
	 and DOC_INFO_ACT_TYPE = 'TECH'
	 and DOC_INFO_STATUS != 'D' 
     END
     
      ELSE if @STATUS = 'P'
     
     BEGIN
	 SELECT DOC_INFO_ID as [ID],DOC_INFO_NAME AS [Document Type Name],DOC_INFO_CUSTODAN as [Custodian],DOC_INFO_TEXT as [Document Name],DOC_INFO_PATH as [Path],DOC_INFO_STATUS as [Status]  FROM DOC_INFO
     WHERE 
     DOC_INFO_ACT_ID =  @DOC_INFO_ACT_ID 
	 and DOC_INFO_ACT_TYPE = 'PRNT'
	 and DOC_INFO_STATUS != 'D' 
     END
     
 
    else if @STATUS = 'A'
     BEGIN   
     SELECT DOC_INFO_ID as [ID],DOC_INFO_NAME AS [Document Type Name],DOC_INFO_CUSTODAN as [Custodian],DOC_INFO_TEXT as [Document Name],DOC_INFO_PATH as [Path],DOC_INFO_STATUS as [Status]  FROM DOC_INFO
     END  
     
 
 
     END