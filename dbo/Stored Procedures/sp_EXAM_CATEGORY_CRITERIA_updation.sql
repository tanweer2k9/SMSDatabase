--     *****************************************************************************************************************************************************************
 
 
--                             Code Type:           Store Procedure For Updation  
--                             Creation Date:       4/6/2015 1:01:26 PM
--                             Auther:              Muhammad Usman Raza Attari
--                             Developed By :       786 Software House 
 
 
--    *****************************************************************************************************************************************************************
 
     create procedure  [dbo].[sp_EXAM_CATEGORY_CRITERIA_updation]
                                               
                                               
          @CAT_CRITERIA_ID  numeric,
          @CAT_CRITERIA_HD_ID  numeric,
          @CAT_CRITERIA_BR_ID  numeric,
          @CAT_CRITERIA_EXAM_CAT_ID  numeric,
          @CAT_CRITERIA_NAME  nvarchar(300) ,
          @CAT_CRITERIA_STATUS  char(2) 
   
   
     as begin 
   
   
     update EXAM_CATEGORY_CRITERIA
 
     set
          CAT_CRITERIA_HD_ID =  @CAT_CRITERIA_HD_ID,
          CAT_CRITERIA_BR_ID =  @CAT_CRITERIA_BR_ID,
          CAT_CRITERIA_EXAM_CAT_ID =  @CAT_CRITERIA_EXAM_CAT_ID,
          CAT_CRITERIA_NAME =  @CAT_CRITERIA_NAME,
          CAT_CRITERIA_STATUS =  @CAT_CRITERIA_STATUS
 
     where 
          CAT_CRITERIA_ID =  @CAT_CRITERIA_ID 
 
end