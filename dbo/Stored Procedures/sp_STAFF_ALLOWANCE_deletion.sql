CREATE PROCEDURE  [dbo].[sp_STAFF_ALLOWANCE_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_ALLOWANCE_ID  numeric,
          @STAFF_ALLOWANCE_HD_ID  numeric,
          @STAFF_ALLOWANCE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update STAFF_ALLOWANCE
 set STAFF_ALLOWANCE_STATUS = 'D'
 
     where 
          STAFF_ALLOWANCE_ID =  @STAFF_ALLOWANCE_ID and 
          STAFF_ALLOWANCE_HD_ID =  @STAFF_ALLOWANCE_HD_ID 
          --and           STAFF_ALLOWANCE_BR_ID =  @STAFF_ALLOWANCE_BR_ID 
 
end