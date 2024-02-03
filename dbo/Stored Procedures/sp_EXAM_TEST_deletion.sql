CREATE PROCEDURE  [dbo].[sp_EXAM_TEST_deletion]
                                               
                                               
          @STATUS char(10),
          @EXAM_TEST_ID  numeric,
          @EXAM_TEST_HD_ID  numeric,
          @EXAM_TEST_BR_ID  numeric
   
   
     AS BEGIN 
   
   
     update EXAM_TEST
     set EXAM_TEST_STATUS = 'D'
 
 
     where 
          EXAM_TEST_ID =  @EXAM_TEST_ID and 
          EXAM_TEST_HD_ID =  @EXAM_TEST_HD_ID and 
          EXAM_TEST_BR_ID =  @EXAM_TEST_BR_ID 
 
end