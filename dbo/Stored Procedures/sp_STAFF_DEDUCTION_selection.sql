create procedure  [dbo].[sp_STAFF_DEDUCTION_selection]
                                               
                                               
     @STATUS char(10),
     @STAFF_DEDUCTION_ID  numeric,
     @STAFF_DEDUCTION_HD_ID  numeric,
     @STAFF_DEDUCTION_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     if @STATUS = 'A'
     BEGIN
   
     SELECT * FROM STAFF_DEDUCTION
     END  
     ELSE
     BEGIN
  SELECT * FROM STAFF_DEDUCTION
 
 
     WHERE
     STAFF_DEDUCTION_ID =  @STAFF_DEDUCTION_ID and 
     STAFF_DEDUCTION_HD_ID =  @STAFF_DEDUCTION_HD_ID and 
     STAFF_DEDUCTION_BR_ID =  @STAFF_DEDUCTION_BR_ID 
 
     END
 
     END