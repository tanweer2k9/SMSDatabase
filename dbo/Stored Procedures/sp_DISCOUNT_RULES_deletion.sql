--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Deletion  
--                             Creation Date:       9/13/2014 8:21:40 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE PROCEDURE  [dbo].[sp_DISCOUNT_RULES_deletion]
                                               
                                               
          @STATUS char(10),
          @DIS_RUL_ID  numeric,
          @DIS_RUL_HD_ID  numeric,
          @DIS_RUL_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from DISCOUNT_RULES
 
 
     where 
          DIS_RUL_ID =  @DIS_RUL_ID and 
          DIS_RUL_HD_ID =  @DIS_RUL_HD_ID and 
          DIS_RUL_BR_ID =  @DIS_RUL_BR_ID 
 
end