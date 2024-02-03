CREATE procedure  [dbo].[sp_EXAM_updation]
                                               
                                        
          @EXAM_ID numeric,
          @EXAM_HD_ID  numeric,
          @EXAM_BR_ID  numeric,
          @EXAM_CLASS_PLAN_ID  numeric,
          @EXAM_NAME  nvarchar(50) ,
          @EXAM_TOTAL_TYPE  nvarchar(50) ,
          @EXAM_STATUS  char(2),
          @EXAM_SESSION_START_DATE date,
          @EXAM_SESSION_END_DATE date,
          @EXAM_FAIL_LIMIT int
   
   
     as  begin
   
   update EXAM
   set 
     EXAM_CLASS_PLAN_ID = @EXAM_CLASS_PLAN_ID,
     EXAM_NAME = @EXAM_NAME,
     EXAM_TOTAL_TYPE = @EXAM_TOTAL_TYPE,
     EXAM_STATUS = @EXAM_STATUS,
     EXAM_SESSION_START_DATE = @EXAM_SESSION_START_DATE,
     EXAM_SESSION_END_DATE = @EXAM_SESSION_END_DATE,
     EXAM_FAIL_LIMIT = @EXAM_FAIL_LIMIT
     where 
     EXAM_ID = @EXAM_ID and
     EXAM_HD_ID = @EXAM_HD_ID and
     EXAM_BR_ID = @EXAM_BR_ID
     
     END