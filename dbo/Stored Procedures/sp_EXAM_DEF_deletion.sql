CREATE PROCEDURE  [dbo].[sp_EXAM_DEF_deletion]
                                               
                                               
          @STATUS char(10),
          @EXAM_DEF_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from EXAM_DEF where EXAM_DEF_ID = @EXAM_DEF_ID     
 
end