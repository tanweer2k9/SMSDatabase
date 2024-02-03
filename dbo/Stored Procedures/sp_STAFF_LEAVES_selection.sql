CREATE procedure  [dbo].[sp_STAFF_LEAVES_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_LEAVES_ID  numeric,
     @STAFF_LEAVES_HD_ID  numeric,
     @STAFF_LEAVES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM STAFF_LEAVES
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_LEAVES
 
 
     WHERE
     STAFF_LEAVES_ID =  @STAFF_LEAVES_ID and 
     STAFF_LEAVES_HD_ID =  @STAFF_LEAVES_HD_ID and 
     STAFF_LEAVES_BR_ID =  @STAFF_LEAVES_BR_ID 
 
     END
 
     END