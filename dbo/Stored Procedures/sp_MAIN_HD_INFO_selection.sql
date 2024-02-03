
CREATE procedure  [dbo].[sp_MAIN_HD_INFO_selection]
                                               
     @STATUS char(10),
     @MAIN_INFO_ID  numeric
   
   
     AS BEGIN    
     if @STATUS = 'L'
     BEGIN   		
		SELECT ID,[Institute Level],[Institute Name],Logo,Branches,[Date Format],City,[Session Start Date],[Session End Date],[Status], [User Name], [Password],[Point Out URL],[Reports Logo],[Fore Color],[Back Color] FROM VMAIN_HD_INFO
		
		select DATE_ID [ID],DATE_NAME [Name] from DATE_INFO
		where DATE_STATUS = 'T'
		
		select INST_LEVEL_ID ID,INST_LEVEL_NAME [Name] from INSTITUTION_LEVEL_INFO
		where INST_LEVEL_STATUS = 'T'
		
		select ID,NAME from VNATIONALITY_INFO
		where [Status] = 'T'
		
     END  
     
     ELSE if @STATUS = 'B'
     BEGIN
			SELECT ID,[Institute Level],[Institute Name],Logo,Branches,[Date Format],City,[Session Start Date],[Session End Date],[Status], [User Name], [Password],[Point Out URL],[Reports Logo],[Fore Color],[Back Color] FROM VMAIN_HD_INFO
	 
			SELECT * FROM VMAIN_HD_INFO  
			WHERE
			ID =  @MAIN_INFO_ID 
 
     END
     
     ELSE IF @STATUS = 'A'
     begin
		select ID, [Institute Name] as Name from VMAIN_HD_INFO
     end
 
  END