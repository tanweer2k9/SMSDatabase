CREATE PROCEDURE  [dbo].[sp_FEE_ADVANCE_DEF_deletion]
                                               
                                               
          @STATUS char(10),
          @ADV_FEE_DEF_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from FEE_ADVANCE_DEF
 
 
     where 
          ADV_FEE_DEF_ID =  @ADV_FEE_DEF_ID 
 
end