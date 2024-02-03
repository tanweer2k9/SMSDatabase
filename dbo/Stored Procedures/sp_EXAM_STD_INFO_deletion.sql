CREATE PROCEDURE  [dbo].[sp_EXAM_STD_INFO_deletion]
                                               
                                               
          @STATUS char(10),
          @EXAM_STD_INFO_ID  numeric
   
   
     AS BEGIN 
   
   
     delete from EXAM_STD_INFO
 
 
     where 
          EXAM_STD_INFO_ID =  @EXAM_STD_INFO_ID 
 
end