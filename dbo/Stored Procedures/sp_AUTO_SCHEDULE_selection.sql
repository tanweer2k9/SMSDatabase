CREATE procedure  [dbo].[sp_AUTO_SCHEDULE_selection]
                                               
                                               
     
     @SCHEDULE_HD_ID  numeric,
     @SCHEDULE_BR_ID  numeric
   
   
     AS BEGIN 
   
	 
		SELECT * FROM AUTO_SCHEDULE
 
		WHERE
		

		SCHEDULE_HD_ID =  @SCHEDULE_HD_ID and 
		SCHEDULE_BR_ID =  @SCHEDULE_BR_ID 
 
	 
 
     END