CREATE PROCEDURE  [dbo].[sp_WORKING_HOURS_PACKAGES_deletion]
                                               
                                               
          @STATUS char(10),
          @HOURS_PACK_ID  numeric,
          @HOURS_PACK_HD_ID  numeric,
          @HOURS_PACK_BR_ID  numeric
   
   
     AS BEGIN 
   
   
	delete from WORKING_HOURS_PACKAGES_DEF where WORK_PACK_DEF_PID = @HOURS_PACK_ID

     delete from WORKING_HOURS_PACKAGES where HOURS_PACK_ID =  @HOURS_PACK_ID
          
 
end