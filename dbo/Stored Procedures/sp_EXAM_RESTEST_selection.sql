CREATE procedure  [dbo].[sp_EXAM_RESTEST_selection]
                                               
                                               
     @STATUS char(10),
     @EXAM_RETEST_STD_ID  numeric,
	 @TERM_ID  numeric,
	 @HD_ID numeric,
	 @BR_ID numeric
   
   
     AS BEGIN 
   
	declare @class_id int = 0 
	declare @plan_exam_id numeric = 0
	declare @count int = 0

	--set @plan_exam_id = (select * from )
    
	set @class_id = (select top(1) STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_ID = @EXAM_RETEST_STD_ID)
	 if @STATUS = 'L'
     BEGIN   
		select ID, [Student School ID], [First Name],[Family Code],[Class Plan] from VSTUDENT_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T'
		select ID,Name from VTERM_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T'
		
		set @count = (select COUNT(*) from EXAM_DEF ed
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
		join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = @EXAM_RETEST_STD_ID
		join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = att.EXAM_STD_ATT_STD_ID and c.EXAM_STD_COM_IS_RETEST = 0
		join EXAM_RESTEST r on r.EXAM_RETEST_PLAN_EXAM_ID = ed.EXAM_DEF_ID and r.EXAM_RETEST_STD_ID = @EXAM_RETEST_STD_ID
		where pd.DEF_CLASS_ID = @class_id and pd.DEF_TERM = @TERM_ID and att.EXAM_STD_ATT_CLASS_ID = @class_id and att.EXAM_STD_ATT_TERM_ID = @TERM_ID 
		and c.EXAM_STD_COM_TERM_ID = @TERM_ID
		and ed.EXAM_DEF_ID in (select ee.EXAM_ENTRY_PLAN_EXAM_ID from EXAM_ENTRY ee where ee.EXAM_ENTRY_STUDENT_ID = @EXAM_RETEST_STD_ID))


		if @count = 0
		BEGIN

			select ROW_NUMBER() over(order by (select 0)) ID,ed.EXAM_DEF_ID [Plan Exam ID],s.SUB_NAME Subject, ed.EXAM_DEF_TOTAL_MARKS [Total Marks], ed.[EXAM_DEF_PASS_%AGE] [Pass Marks], -3 [Obtain Marks],att.EXAM_STD_ATT_PRESENT_DAYS [Present Days],
			 att.EXAM_STD_ATT_TOTAL_DAYS [Total Days], c.EXAM_STD_COM_COMMENTS Comments from EXAM_DEF ed
			join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
			join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
			join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = @EXAM_RETEST_STD_ID
			join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = att.EXAM_STD_ATT_STD_ID and c.EXAM_STD_COM_IS_RETEST = 0
			where pd.DEF_CLASS_ID = @class_id and pd.DEF_TERM = @TERM_ID and att.EXAM_STD_ATT_CLASS_ID = @class_id and att.EXAM_STD_ATT_TERM_ID = @TERM_ID
			and c.EXAM_STD_COM_TERM_ID = @TERM_ID
			and ed.EXAM_DEF_ID in (select ee.EXAM_ENTRY_PLAN_EXAM_ID from EXAM_ENTRY ee where ee.EXAM_ENTRY_STUDENT_ID = @EXAM_RETEST_STD_ID)

			select 'insert'
		END
		ELSE
		BEGIN
			select ROW_NUMBER() over(order by (select 0)) ID,ed.EXAM_DEF_ID [Plan Exam ID],s.SUB_NAME Subject, ed.EXAM_DEF_TOTAL_MARKS [Total Marks], ed.[EXAM_DEF_PASS_%AGE] [Pass Marks], ee.EXAM_ENTRY_OBTAIN_MARKS [Obtain Marks],att.EXAM_STD_ATT_PRESENT_DAYS [Present Days],
			 att.EXAM_STD_ATT_TOTAL_DAYS [Total Days], c.EXAM_STD_COM_COMMENTS Comments from EXAM_DEF ed
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
		join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = @EXAM_RETEST_STD_ID
		join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = att.EXAM_STD_ATT_STD_ID and c.EXAM_STD_COM_IS_RETEST = 0
		join EXAM_RESTEST r on r.EXAM_RETEST_PLAN_EXAM_ID = ed.EXAM_DEF_ID and r.EXAM_RETEST_STD_ID = @EXAM_RETEST_STD_ID
		join EXAM_ENTRY ee on ee.EXAM_ENTRY_PLAN_EXAM_ID = ed.EXAM_DEF_ID and ee.EXAM_ENTRY_STUDENT_ID = @EXAM_RETEST_STD_ID
		where pd.DEF_CLASS_ID = @class_id and pd.DEF_TERM = @TERM_ID and att.EXAM_STD_ATT_CLASS_ID = @class_id and att.EXAM_STD_ATT_TERM_ID = @TERM_ID 
		and c.EXAM_STD_COM_TERM_ID = @TERM_ID
		select 'update'
		END
     END  
  --   ELSE if @STATUS = 'A'
	 --BEGIN

		--select ID, [Student School ID], [First Name],[Family Code],[Class Plan] from VSTUDENT_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T'
		--select ID,Name from VTERM_INFO where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and Status = 'T'

		--select s.SUB_NAME Subject, ed.EXAM_DEF_TOTAL_MARKS [Total Marks], ed.[EXAM_DEF_PASS_%AGE] [Passing Marks], 0 [Obtain Marks],att.EXAM_STD_ATT_PRESENT_DAYS [Present Days],
		-- att.EXAM_STD_ATT_TOTAL_DAYS [Total Days], c.EXAM_STD_COM_COMMENTS from EXAM_DEF ed
		--join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		--join SUBJECT_INFO s on s.SUB_ID = pd.DEF_SUBJECT
		--join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = @EXAM_RETEST_STD_ID
		--join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = att.EXAM_STD_ATT_STD_ID
		--where pd.DEF_CLASS_ID = @class_id and pd.DEF_TERM = @TERM_ID and att.EXAM_STD_ATT_CLASS_ID = @class_id and att.EXAM_STD_ATT_TERM_ID = @TERM_ID
	 --END
 
     END