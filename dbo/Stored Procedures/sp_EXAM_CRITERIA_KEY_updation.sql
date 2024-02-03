CREATE procedure  [dbo].[sp_EXAM_CRITERIA_KEY_updation]
                                               
                                               
          @CRITERIA_KEY_ID  numeric,
          @CRITERIA_KEY_STD_ID  numeric,
          @CRITERIA_KEY_CAT_CRITERIA_ID  numeric,
          @CRITERIA_KEY  nvarchar(15) 
   
   
     as begin 
   
   
     update EXAM_CRITERIA_KEY
 
     set
          CRITERIA_KEY_STD_ID =  @CRITERIA_KEY_STD_ID,
          CRITERIA_KEY_CAT_CRITERIA_ID =  @CRITERIA_KEY_CAT_CRITERIA_ID,
          CRITERIA_KEY =  @CRITERIA_KEY
 
     where 
          CRITERIA_KEY_ID =  @CRITERIA_KEY_ID 
 
end