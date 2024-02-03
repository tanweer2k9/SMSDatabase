CREATE PROCEDURE  [dbo].[sp_ALLOWANCE_deletion]
                                               
                                               
          @STATUS char(10),
          @ALLOWANCE_ID  numeric,
          @ALLOWANCE_HD_ID  numeric,
          @ALLOWANCE_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE ALLOWANCE
 SET ALLOWANCE_STATUS = 'D'
 
     where 
          ALLOWANCE_ID =  @ALLOWANCE_ID and 
          ALLOWANCE_HD_ID =  @ALLOWANCE_HD_ID and 
          ALLOWANCE_BR_ID =  @ALLOWANCE_BR_ID 
 
end