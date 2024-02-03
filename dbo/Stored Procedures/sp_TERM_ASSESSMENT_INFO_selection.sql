CREATE procedure  [dbo].[sp_TERM_ASSESSMENT_INFO_selection]
                                               
                                               
     @STATUS char(10),
	 @DEFINITION_ID numeric,
	 @DEFINITION_HD_ID numeric,
	 @DEFINITION_BR_ID numeric
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT  [ID],[Name],[Description],[Status], [Start Date], [End Date],[Rank] FROM VTERM_ASSESSMENT_INFO
     where 
     [Institute ID] = @DEFINITION_HD_ID and
     [Branch ID] = @DEFINITION_BR_ID and
     [Status] != 'D'      
      
     END  
     
     ELSE if  @STATUS = 'B'
     BEGIN
	SELECT * FROM TERM_ASSESSMENT_INFO
 
     WHERE 
     TERM_ASSESS_ID = @DEFINITION_ID
 
     END
     ELSE if @STATUS = 'C'
     BEGIN
		select ID,[Institute ID] as [HD ID], [Branch ID] as [BR ID], Name from VTERM_ASSESSMENT_INFO where Status = 'T' and 
		[Institute ID] like dbo.set_where_like(@DEFINITION_HD_ID) and 
		[Branch ID] like dbo.set_where_like(@DEFINITION_BR_ID)
     END
     
     Else if @STATUS = 'X'
     BEGIN
    SELECT  ISNULL( MAX(TERM_ASSESS_ID +1),1) FROM TERM_ASSESSMENT_INFO
     
     END 
 
     END