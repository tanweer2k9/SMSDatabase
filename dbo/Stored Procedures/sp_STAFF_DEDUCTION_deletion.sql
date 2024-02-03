CREATE PROCEDURE  [dbo].[sp_STAFF_DEDUCTION_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_DEDUCTION_ID  numeric,
          @STAFF_DEDUCTION_HD_ID  numeric,
          @STAFF_DEDUCTION_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update STAFF_DEDUCTION 
     set STAFF_DEDUCTION_STATUS = 'D'
 
 
     where 
          STAFF_DEDUCTION_ID =  @STAFF_DEDUCTION_ID and 
          STAFF_DEDUCTION_HD_ID =  @STAFF_DEDUCTION_HD_ID 
          --and           STAFF_DEDUCTION_BR_ID =  @STAFF_DEDUCTION_BR_ID 
 
end