CREATE PROCEDURE  [dbo].[sp_EXAM_ASSESS_CATEGORY_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @EXAM_CAT_ID  numeric
   
   
     AS BEGIN 
   delete from EXAM_ASSESS_CATEGORY_INFO
 
 
     where 
          EXAM_CAT_MAIN_CAT_ID =  @EXAM_CAT_ID 
   
     delete from EXAM_ASSESS_CATEGORY_INFO
 
 
     where 
          EXAM_CAT_ID =  @EXAM_CAT_ID 
 
end