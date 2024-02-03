
CREATE procedure  [dbo].[sp_EXAM_ENTRY_insertion]
                                               
                                               
          @EXAM_ENTRY_PLAN_EXAM_ID  numeric,
          @EXAM_ENTRY_EXAM_TYPE nvarchar(50),
          @EXAM_ENTRY_STUDENT_ID numeric,
          @EXAM_ENTRY_OBTAIN_MARKS  float,
          @EXAM_ENTRY_ENTER_DATE  datetime,
          @EXAM_ENTRY_STATUS  char(2) ,
		  @EXAM_ENTRY_OBTAINED_MARKS_LOG nvarchar(500),
		  @EXAM_APPROVAL_RANKWISE_STATUS nvarchar(100),
		  @USER_LOGIN_ID numeric
   
   
     as  begin
   
   
     insert into EXAM_ENTRY
     values
     (
        @EXAM_ENTRY_PLAN_EXAM_ID,
        @EXAM_ENTRY_EXAM_TYPE,
        @EXAM_ENTRY_STUDENT_ID,
        @EXAM_ENTRY_OBTAIN_MARKS,
        @EXAM_ENTRY_ENTER_DATE,
        @EXAM_ENTRY_STATUS,
		@EXAM_ENTRY_OBTAINED_MARKS_LOG,
		@USER_LOGIN_ID,
		NULL,
		NULL
     )

	 exec sp_EXAM_APPROVAL_STATUS_insertion @EXAM_ENTRY_PLAN_EXAM_ID,@EXAM_APPROVAL_RANKWISE_STATUS
     
end