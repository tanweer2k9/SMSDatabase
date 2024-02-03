CREATE procedure  [dbo].[sp_ASSESSMENT_INFO_selection]
                                               
                                               
     @STATUS char(10),
	 @DEFINITION_ID numeric,
	 @DEFINITION_HD_ID numeric,
	 @DEFINITION_BR_ID numeric
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
     SELECT  [ID],[Name],[Description],[Status] FROM  VASSESSMENT_INFO
     where 
     [Institute ID] = @DEFINITION_HD_ID and
     [Branch ID] = @DEFINITION_BR_ID and
     [Status] != 'D' 
      
     END  
     
     ELSE if  @STATUS = 'B'
     BEGIN
	SELECT * FROM ASSESSMENT_INFO
 
     WHERE 
     ASSESSMENT_ID = @DEFINITION_ID
 
     END
     
     
     Else if @STATUS = 'X'
     BEGIN
    SELECT  ISNULL( MAX(ASSESSMENT_ID +1),1) FROM ASSESSMENT_INFO
     
     END 
 
     END