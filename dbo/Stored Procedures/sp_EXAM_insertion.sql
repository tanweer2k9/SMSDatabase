CREATE procedure  [dbo].[sp_EXAM_insertion]
                                               
                                               
          @EXAM_HD_ID  numeric,
          @EXAM_BR_ID  numeric,
          @EXAM_CLASS_PLAN_ID  numeric,
          @EXAM_NAME  nvarchar(50) ,
          @EXAM_TOTAL_TYPE  nvarchar(50) ,
          @EXAM_STATUS  char(2) ,
          @EXAM_SESSION_START_DATE date,
          @EXAM_SESSION_END_DATE date,
          @EXAM_FAIL_LIMIT int
   
   
     as  begin
   
     insert into EXAM
     values
     (   
        @EXAM_HD_ID,
        @EXAM_BR_ID,
        @EXAM_CLASS_PLAN_ID,
        @EXAM_NAME,
        @EXAM_TOTAL_TYPE,
        @EXAM_STATUS,
        @EXAM_SESSION_START_DATE,
        @EXAM_SESSION_END_DATE,
        @EXAM_FAIL_LIMIT,
		0
     )
     
end