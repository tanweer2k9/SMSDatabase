CREATE PROCEDURE  [dbo].[sp_FEE_ADVANCE_deletion]
                                               
                                               
          @STATUS char(10),
          @ADV_FEE_ID  numeric
   
   
     AS BEGIN 
   
	delete from FEE_ADVANCE_DEF where ADV_FEE_DEF_PID = @ADV_FEE_ID
   
     delete from FEE_ADVANCE
     where 
          ADV_FEE_ID =  @ADV_FEE_ID 
 
end