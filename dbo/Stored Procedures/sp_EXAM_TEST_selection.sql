

CREATE procedure  [dbo].[sp_EXAM_TEST_selection]
                                               
                                               
     @STATUS char(10),
     @EXAM_TEST_ID  numeric,
     @EXAM_TEST_HD_ID  numeric,
     @EXAM_TEST_BR_ID  numeric,
     @EXAM_TEST_CLASS_ID  numeric,
	 @EXAM_TEST_SUBJECT_ID numeric,
	 @EXAM_TEST_TYPE nvarchar(50)
   
   
     AS BEGIN 
   
   
	if @EXAM_TEST_CLASS_ID = 0
			BEGIN
				set @EXAM_TEST_CLASS_ID = (select top(1)[ID] from VSCHOOL_PLANE
			where [Institute ID] = @EXAM_TEST_HD_ID and
			[Branch ID] = @EXAM_TEST_BR_ID and
			[Status] ='T' )
			END
			
			
			
			if @EXAM_TEST_SUBJECT_ID = 0
			BEGIN
				set @EXAM_TEST_SUBJECT_ID = (select top(1) ID from (select  distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION 
			join SUBJECT_INFO on SUB_ID = DEF_SUBJECT
			where DEF_CLASS_ID = @EXAM_TEST_CLASS_ID and DEF_STATUS = 'T' and SUB_STATUS = 'T'
			and SUB_HD_ID = @EXAM_TEST_HD_ID and
			SUB_BR_ID = @EXAM_TEST_BR_ID and
			SUB_STATUS ='T' )A)
			END
   
     if @STATUS = 'L'
		 BEGIN
			SELECT * FROM EXAM_TEST
			
		 END  
		 
	ELSE IF @STATUS = 'C'
	BEGIN
		SELECT ID, Term, Subject, Test, Name, [Total Marks], [Pass %age], [Grade], Status FROM VEXAM_TEST where [Class ID] = @EXAM_TEST_CLASS_ID and [Subject] = @EXAM_TEST_SUBJECT_ID and [Institute ID] = @EXAM_TEST_HD_ID and [Branch ID] = @EXAM_TEST_BR_ID and Status != 'D' and [Test Type] = @EXAM_TEST_TYPE
	END
     ELSE
		 BEGIN
		
		SELECT * FROM EXAM_TEST
	 
	 
		 WHERE
		 EXAM_TEST_ID =  @EXAM_TEST_ID and 
		 EXAM_TEST_HD_ID =  @EXAM_TEST_HD_ID and 
		 EXAM_TEST_BR_ID =  @EXAM_TEST_BR_ID 
	 
		 END
		 
			select [ID],[Name] from VSCHOOL_PLANE
			where [Institute ID] = @EXAM_TEST_HD_ID and
			[Branch ID] = @EXAM_TEST_BR_ID and
			[Status] ='T' 
			
			select ID, Name from VTERM_INFO		 where [Institute ID] = @EXAM_TEST_HD_ID and
			[Branch ID] = @EXAM_TEST_BR_ID and
			[Status] ='T'
			
			


			select distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION 
			join SUBJECT_INFO on SUB_ID = DEF_SUBJECT
			where DEF_CLASS_ID = @EXAM_TEST_CLASS_ID and DEF_STATUS = 'T' and SUB_STATUS = 'T'
			
			select TEST_ID as ID, TEST_NAME as Name from TEST_INFO where TEST_HD_ID = @EXAM_TEST_HD_ID and TEST_BR_ID = @EXAM_TEST_BR_ID and TEST_STATUS = 'T'
			
			select ID, Name from VGRADE_INFO where [Institute ID] = @EXAM_TEST_HD_ID and [Branch ID] = @EXAM_TEST_BR_ID and Status = 'T'

 
     END