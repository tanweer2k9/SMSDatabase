CREATE PROCEDURE  [dbo].[sp_STAFF_LEAVES_deletion]
                                               
                                               
          @STATUS char(10),
          @STAFF_LEAVES_ID  numeric,
          @STAFF_LEAVES_HD_ID  numeric,
          @STAFF_LEAVES_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     UPDATE STAFF_LEAVES
 SET STAFF_LEAVES_STATUS = 'D'
 
     where 
          STAFF_LEAVES_ID =  @STAFF_LEAVES_ID and 
          STAFF_LEAVES_HD_ID =  @STAFF_LEAVES_HD_ID 
          --and           STAFF_LEAVES_BR_ID =  @STAFF_LEAVES_BR_ID 
 
end