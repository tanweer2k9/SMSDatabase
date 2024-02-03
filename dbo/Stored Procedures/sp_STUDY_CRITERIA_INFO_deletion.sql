--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Deletion  
--                             Creation Date:       9/15/2012 2:03:23 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     CREATE PROCEDURE  [dbo].[sp_STUDY_CRITERIA_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @STUDY_CRITERIA_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from STUDY_CRITERIA_INFO
 
 
     where 
          STUDY_CRITERIA_ID =  @STUDY_CRITERIA_ID 
 
end