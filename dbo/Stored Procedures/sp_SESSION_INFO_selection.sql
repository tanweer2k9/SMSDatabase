

CREATE procedure  [dbo].[sp_SESSION_INFO_selection]
                                               
                                               
     @STATUS char(10),
     @SESSION_ID  numeric,
     @SESSION_HD_ID  numeric,
     @SESSION_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
		 SELECT ID,Description,[Start Date],[End Date],Rank,Status FROM VSESSION_INFO
		 where  
		 [Institute ID] =  @SESSION_HD_ID and 
		 [Branch ID] =  @SESSION_BR_ID 
		 and Status != 'D' order by [Start Date] 
		 END  
 END