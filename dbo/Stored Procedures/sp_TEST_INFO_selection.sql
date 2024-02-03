CREATE procedure  [dbo].[sp_TEST_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @TEST_ID  numeric,
     @TEST_HD_ID  numeric,
     @TEST_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     --if @STATUS = 'A'
     --BEGIN
   
     --SELECT * FROM TEST_INFO
     --END  
     --ELSE
     --BEGIN
		SELECT ID, Name, Description, Status FROM VTEST_INFO
 
 
		 WHERE
		 [Institute ID] =  @TEST_HD_ID and 
		 [Branch ID] =  @TEST_BR_ID and
		 Status != 'D'
 
     --END
 
     END