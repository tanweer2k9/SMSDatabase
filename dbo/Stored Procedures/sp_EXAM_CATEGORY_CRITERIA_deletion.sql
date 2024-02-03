--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Deletion  
--                             Creation Date:       4/6/2015 1:01:26 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE PROCEDURE  [dbo].[sp_EXAM_CATEGORY_CRITERIA_deletion]
                                               
                                               
          @STATUS char(10),
          @CAT_CRITERIA_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from EXAM_CATEGORY_CRITERIA
 
 
     where 
          CAT_CRITERIA_ID =  @CAT_CRITERIA_ID 
 
end