CREATE PROCEDURE  [dbo].[sp_STAFF_LATE_TIME_DEDUCTION_deletion]
                                               
                                               
          @STATUS char(10),
          @DEDUCTION_STAFF_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STAFF_LATE_TIME_DEDUCTION
 
 
     where 
          DEDUCTION_STAFF_ID =  @DEDUCTION_STAFF_ID 
 
end