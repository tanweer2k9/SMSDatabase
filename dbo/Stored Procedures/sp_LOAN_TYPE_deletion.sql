CREATE PROCEDURE  [dbo].[sp_LOAN_TYPE_deletion]
                                               
                                               
          @STATUS char(10),
          @LOAN_TYPE_ID  numeric
   
   
     AS BEGIN 
   
   
     update LOAN_TYPE
 set LOAN_TYPE_STATUS = 'D'
 
     where 
          LOAN_TYPE_ID =  @LOAN_TYPE_ID 
 
end