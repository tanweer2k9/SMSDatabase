﻿CREATE procedure  [dbo].[sp_WORKING_HOURS_PACKAGES_selection]
                                               
                                               
     @STATUS char(10),
     @HOURS_PACK_ID  numeric,
     @HOURS_PACK_HD_ID  numeric,
     @HOURS_PACK_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
		 BEGIN   
			SELECT ID, Name FROM VWORKING_HOURS_PACKAGES where [Institute ID] = @HOURS_PACK_HD_ID and [Branch ID] = @HOURS_PACK_BR_ID
			select * from WORKING_HOURS_PACKAGES_DEF where WORK_PACK_DEF_PID = 0
			select WORKING_HOURS_TIME_IN, WORKING_HOURS_TIME_OUT from WORKING_HOURS where WORKING_HOURS_HD_ID = @HOURS_PACK_HD_ID and WORKING_HOURS_BR_ID = @HOURS_PACK_BR_ID
			select WORKING_DAYS_NAME, WORKING_DAYS_VALUE from WORKING_DAYS where WORKING_DAYS_HD_ID = @HOURS_PACK_HD_ID and WORKING_DAYS_BR_ID = @HOURS_PACK_BR_ID
		 END  
     else if @STATUS = 'B'
	 begin
			SELECT ID, Name FROM VWORKING_HOURS_PACKAGES where [Institute ID] = @HOURS_PACK_HD_ID and [Branch ID] = @HOURS_PACK_BR_ID
			select * from WORKING_HOURS_PACKAGES_DEF where WORK_PACK_DEF_PID = @HOURS_PACK_ID
			select WORKING_HOURS_TIME_IN, WORKING_HOURS_TIME_OUT from WORKING_HOURS where WORKING_HOURS_HD_ID = @HOURS_PACK_HD_ID and WORKING_HOURS_BR_ID = @HOURS_PACK_BR_ID
			select WORKING_DAYS_NAME, WORKING_DAYS_VALUE from WORKING_DAYS where WORKING_DAYS_HD_ID = @HOURS_PACK_HD_ID and WORKING_DAYS_BR_ID = @HOURS_PACK_BR_ID
	 end

 
     END