﻿CREATE procedure  [dbo].[sp_WORKING_HOURS_updation]                                             
          @WORKING_HOURS_ID  numeric,
          @WORKING_HOURS_HD_ID  numeric,
          @WORKING_HOURS_BR_ID  numeric,
          @WORKING_HOURS_TIME_IN  nvarchar(50) ,
          @WORKING_HOURS_TIME_OUT  nvarchar(50) ,
          @WORKING_HOURS_STATUS  char(2)    
     as begin 
   
    update WORKING_HOURS
     set
          WORKING_HOURS_TIME_IN =  @WORKING_HOURS_TIME_IN,
          WORKING_HOURS_TIME_OUT =  @WORKING_HOURS_TIME_OUT,
		  WORKING_HOURS_STATUS =  'T'
     where           
          WORKING_HOURS_HD_ID =  @WORKING_HOURS_HD_ID and 
          WORKING_HOURS_BR_ID =  @WORKING_HOURS_BR_ID 
   
end