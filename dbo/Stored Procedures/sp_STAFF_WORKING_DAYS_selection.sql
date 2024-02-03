create procedure  [dbo].[sp_STAFF_WORKING_DAYS_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_WORKING_DAYS_ID  numeric,
     @STAFF_WORKING_DAYS_HD_ID  numeric,
     @STAFF_WORKING_DAYS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM STAFF_WORKING_DAYS
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_WORKING_DAYS
 
 
     WHERE
     STAFF_WORKING_DAYS_ID =  @STAFF_WORKING_DAYS_ID and 
     STAFF_WORKING_DAYS_HD_ID =  @STAFF_WORKING_DAYS_HD_ID and 
     STAFF_WORKING_DAYS_BR_ID =  @STAFF_WORKING_DAYS_BR_ID 
 
     END
 
     END