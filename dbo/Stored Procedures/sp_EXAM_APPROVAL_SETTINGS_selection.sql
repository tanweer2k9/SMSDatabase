CREATE procedure  [dbo].[sp_EXAM_APPROVAL_SETTINGS_selection]
                                               
                                               
     @STATUS char(10),
     @APPROVAL_ID  numeric,
     @APPROVAL_HD_ID  numeric,
     @APPROVAL_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM vEXAM_APPROVAL_SETTINGS
     END  
     ELSE
     BEGIN
		 SELECT ID,[Staff ID], [Designation],[Rank],[Status] FROM vEXAM_APPROVAL_SETTINGS
 
 
     WHERE
     [HD ID] =  @APPROVAL_HD_ID and 
     [BR ID] =  @APPROVAL_BR_ID 
	 and [Status] in ('T','F')
     END

	 select TECH_ID as ID,TECH_FIRST_NAME+TECH_LAST_NAME AS [Name] from TEACHER_INFO where 
	 TECH_HD_ID=@APPROVAL_HD_ID and TECH_BR_ID=@APPROVAL_BR_ID and TECH_STATUS='T'

	 	SELECT [Staff ID] FROM vEXAM_APPROVAL_SETTINGS
     WHERE
     [HD ID] =  @APPROVAL_HD_ID and 
     [BR ID] =  @APPROVAL_BR_ID 
	 and [Status] = 'E'
	 and Designation = 'Principal Exam Assessment'
 
     END