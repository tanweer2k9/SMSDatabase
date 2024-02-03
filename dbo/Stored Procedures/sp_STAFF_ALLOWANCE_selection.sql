CREATE procedure  [dbo].[sp_STAFF_ALLOWANCE_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_ALLOWANCE_ID  numeric,
     @STAFF_ALLOWANCE_HD_ID  numeric,
     @STAFF_ALLOWANCE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM STAFF_ALLOWANCE
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_ALLOWANCE
 
 
     WHERE
     STAFF_ALLOWANCE_ID =  @STAFF_ALLOWANCE_ID and 
     STAFF_ALLOWANCE_HD_ID =  @STAFF_ALLOWANCE_HD_ID and 
     STAFF_ALLOWANCE_BR_ID like [dbo].[get_centralized_br_id]('S', @STAFF_ALLOWANCE_BR_ID)
 
     END
 
     END