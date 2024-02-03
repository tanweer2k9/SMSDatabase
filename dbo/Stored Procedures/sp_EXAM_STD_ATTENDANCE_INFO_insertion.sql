CREATE procedure  [dbo].[sp_EXAM_STD_ATTENDANCE_INFO_insertion]
                                               
                                               
          @EXAM_STD_ATT_STD_ID  numeric,
          @EXAM_STD_ATT_CLASS_ID  numeric,
          @EXAM_STD_ATT_SUB_ID  numeric,
          @EXAM_STD_ATT_TERM_ID  numeric,
          @EXAM_STD_ATT_TOTAL_DAYS  int,
          @EXAM_STD_ATT_PRESENT_DAYS  int,
		  @EXAM_STD_COM_COMMENTS nvarchar(1000)
   
   
     as  begin
   
	delete from EXAM_STD_ATTENDANCE_INFO where EXAM_STD_ATT_STD_ID = @EXAM_STD_ATT_STD_ID and EXAM_STD_ATT_CLASS_ID = @EXAM_STD_ATT_CLASS_ID and EXAM_STD_ATT_SUB_ID = @EXAM_STD_ATT_SUB_ID
	and EXAM_STD_ATT_TERM_ID = @EXAM_STD_ATT_TERM_ID 

     insert into EXAM_STD_ATTENDANCE_INFO
     values
     (
        @EXAM_STD_ATT_STD_ID,
        @EXAM_STD_ATT_CLASS_ID,
        @EXAM_STD_ATT_SUB_ID,
        @EXAM_STD_ATT_TERM_ID,
        @EXAM_STD_ATT_TOTAL_DAYS,
        @EXAM_STD_ATT_PRESENT_DAYS
     
     
     )

	 delete from EXAM_STD_COMMENTS where EXAM_STD_COM_STD_ID = @EXAM_STD_ATT_STD_ID and EXAM_STD_COM_CLASS_ID = @EXAM_STD_ATT_CLASS_ID 
	and EXAM_STD_COM_TERM_ID = @EXAM_STD_ATT_TERM_ID 


	 insert into EXAM_STD_COMMENTS VALUES (@EXAM_STD_ATT_STD_ID, @EXAM_STD_ATT_CLASS_ID, @EXAM_STD_ATT_TERM_ID, @EXAM_STD_COM_COMMENTS,0)

	
     
end