CREATE PROCEDURE  [dbo].[sp_STAFF_WORKING_DAYS_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_WORKING_DAYS_ID  numeric,
          @STAFF_WORKING_DAYS_HD_ID  numeric,
          @STAFF_WORKING_DAYS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update STAFF_WORKING_DAYS
 set STAFF_WORKING_DAYS_STATUS = 'D'
 
     where 
          STAFF_WORKING_DAYS_ID =  @STAFF_WORKING_DAYS_ID and 
          STAFF_WORKING_DAYS_HD_ID =  @STAFF_WORKING_DAYS_HD_ID 
          --and           STAFF_WORKING_DAYS_BR_ID =  @STAFF_WORKING_DAYS_BR_ID 
 
end