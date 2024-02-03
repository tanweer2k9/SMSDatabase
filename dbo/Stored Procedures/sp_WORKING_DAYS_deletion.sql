CREATE PROCEDURE  [dbo].[sp_WORKING_DAYS_deletion]
                                               
                                               
          @STATUS char(10),
          @WORKING_DAYS_ID  numeric,
          @WORKING_DAYS_HD_ID  numeric,
          @WORKING_DAYS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from WORKING_DAYS
 
 
     where 
          WORKING_DAYS_ID =  @WORKING_DAYS_ID and 
          WORKING_DAYS_HD_ID =  @WORKING_DAYS_HD_ID and 
          WORKING_DAYS_BR_ID =  @WORKING_DAYS_BR_ID 
 
end