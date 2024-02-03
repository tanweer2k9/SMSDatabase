
CREATE procedure  [dbo].[sp_EXAM_TEST_updation]
                                               
                                               
          @EXAM_TEST_ID  numeric,
          @EXAM_TEST_HD_ID  numeric,
          @EXAM_TEST_BR_ID  numeric,
          @EXAM_TEST_CLASS_ID  numeric,
          @EXAM_TEST_INFO_ID  numeric,
          @EXAM_TEST_TERM_ID  numeric,
          @EXAM_TEST_SUBJECT_ID  numeric,
          @EXAM_TEST_NAME  nvarchar(200) ,
          @EXAM_TEST_TOTAL_MARKS  float,
          @EXAM_TEST_PASS_AGE float,
          @EXAM_TEST_PLAN_GRADE_ID  numeric,
          @EXAM_TEST_ENTER_DATE  date,
          @EXAM_TEST_STATUS  char(2) ,
		  @EXAM_TEST_TYPE nvarchar(50)
   
   
     as begin 
   
   
     update EXAM_TEST
 
     set
          EXAM_TEST_CLASS_ID =  @EXAM_TEST_CLASS_ID,
          EXAM_TEST_INFO_ID =  @EXAM_TEST_INFO_ID,
          EXAM_TEST_TERM_ID =  @EXAM_TEST_TERM_ID,
          EXAM_TEST_SUBJECT_ID =  @EXAM_TEST_SUBJECT_ID,
          EXAM_TEST_NAME =  @EXAM_TEST_NAME,
          EXAM_TEST_TOTAL_MARKS =  @EXAM_TEST_TOTAL_MARKS,
          [EXAM_TEST_PASS_%AGE] =  @EXAM_TEST_PASS_AGE,
          EXAM_TEST_PLAN_GRADE_ID =  @EXAM_TEST_PLAN_GRADE_ID,
          EXAM_TEST_ENTER_DATE =  @EXAM_TEST_ENTER_DATE,
          EXAM_TEST_STATUS =  @EXAM_TEST_STATUS,
		  EXAM_TEST_TYPE = @EXAM_TEST_TYPE
 
     where 
          EXAM_TEST_ID =  @EXAM_TEST_ID and 
          EXAM_TEST_HD_ID =  @EXAM_TEST_HD_ID and 
          EXAM_TEST_BR_ID =  @EXAM_TEST_BR_ID 
 
end