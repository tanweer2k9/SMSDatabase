create procedure  [dbo].[sp_EXAM_RESTEST_updation]
                                               
                                               
          @EXAM_RETEST_ID  numeric,
          @EXAM_RETEST_STD_ID  numeric,
          @EXAM_RETEST_PLAN_EXAM_ID  numeric,
          @EXAM_RETEST_OBTAIN_MARKS  float,
          @EXAM_RETEST_OBTAIN_MARKS_LOG  nvarchar(50) 
   
   
     as begin 
   
   
     update EXAM_RESTEST
 
     set
          EXAM_RETEST_STD_ID =  @EXAM_RETEST_STD_ID,
          EXAM_RETEST_PLAN_EXAM_ID =  @EXAM_RETEST_PLAN_EXAM_ID,
          EXAM_RETEST_OBTAIN_MARKS =  @EXAM_RETEST_OBTAIN_MARKS,
          EXAM_RETEST_OBTAIN_MARKS_LOG =  @EXAM_RETEST_OBTAIN_MARKS_LOG
 
     where 
          EXAM_RETEST_ID =  @EXAM_RETEST_ID 
 
end