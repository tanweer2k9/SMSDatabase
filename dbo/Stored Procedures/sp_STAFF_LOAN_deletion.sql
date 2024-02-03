CREATE PROCEDURE  [dbo].[sp_STAFF_LOAN_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_LOAN_ID  numeric,
          @STAFF_LOAN_HD_ID  numeric,
          @STAFF_LOAN_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE STAFF_LOAN
 SET STAFF_LOAN_STATUS = 'D'
 
     where 
          STAFF_LOAN_ID =  @STAFF_LOAN_ID 
          and 
          STAFF_LOAN_HD_ID =  @STAFF_LOAN_HD_ID
          -- and 
          --STAFF_LOAN_BR_ID =  @STAFF_LOAN_BR_ID 
 
end