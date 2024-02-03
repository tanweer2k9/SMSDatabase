CREATE PROCEDURE  [dbo].[sp_EXAM_ENTRY_deletion]
                                               
                                               
          @STATUS char(10),
          @EXAM_ENTRY_ID  numeric
   
   
     AS BEGIN 
   
   
     update EXAM_ENTRY
     set EXAM_ENTRY_STATUS = 'D'
 
 
     where 
          EXAM_ENTRY_ID =  @EXAM_ENTRY_ID 
 
end