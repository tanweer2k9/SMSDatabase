CREATE procedure  [dbo].[sp_WORKING_HOURS_selection]
                                               
                                               
     @STATUS char(10),
     @WORKING_HOURS_ID  numeric,
     @WORKING_HOURS_HD_ID  numeric,
     @WORKING_HOURS_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'L'
     BEGIN
   
     SELECT WORKING_HOURS_ID as ID, WORKING_HOURS_TIME_IN as [Time In], WORKING_HOURS_TIME_OUT as [Time Out]
     FROM WORKING_HOURS
     where
      WORKING_HOURS_HD_ID =  @WORKING_HOURS_HD_ID and 
     WORKING_HOURS_BR_ID =  @WORKING_HOURS_BR_ID and
     WORKING_HOURS_STATUS = 'T'
     
     
     
     END  
     ELSE
     BEGIN
  SELECT * FROM WORKING_HOURS
 
 
     WHERE
     WORKING_HOURS_ID =  @WORKING_HOURS_ID and 
     WORKING_HOURS_HD_ID =  @WORKING_HOURS_HD_ID and 
     WORKING_HOURS_BR_ID =  @WORKING_HOURS_BR_ID 
 
     END
 
     END