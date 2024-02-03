CREATE procedure  [dbo].[sp_SCHOOL_PLANE_DEFINITION_insertion]
                                               
                                               
          @DEF_CLASS_ID  numeric,
          @DEF_SUBJECT  numeric ,
          @DEF_TEACHER  numeric ,
          @DEF_TERM numeric,
          @DEF_START_TIME  nvarchar(50) ,
          @DEF_END_TIME  nvarchar(50) ,
          @DEF_STATUS  char(2) ,
		  @status char(1),
		  @DEF_ID numeric,
		  @DEF_IS_COMPULSORY bit
   
     as   begin
   
   if @status = 'I'
    begin
    
	declare @id as numeric		
	set @id = (select  ISNULL( MAX( CLASS_ID ),0) from SCHOOL_PLANE)
   
     insert into SCHOOL_PLANE_DEFINITION
     values
     (       
        @id,
        @DEF_SUBJECT,
        @DEF_TEACHER,
        @DEF_TERM,
        @DEF_START_TIME,
        @DEF_END_TIME,
        @DEF_STATUS   ,
		@DEF_IS_COMPULSORY  
     )


	end


else if @status = 'U'
 begin
   
    update SCHOOL_PLANE_DEFINITION
 
     set
          DEF_CLASS_ID =  @DEF_CLASS_ID,
          DEF_SUBJECT =  @DEF_SUBJECT,
          DEF_TEACHER =  @DEF_TEACHER,
          DEF_TERM =  @DEF_TERM,
          DEF_START_TIME =  @DEF_START_TIME,
          DEF_END_TIME =  @DEF_END_TIME,
          DEF_STATUS =  @DEF_STATUS,
		  DEF_IS_COMPULSORY = @DEF_IS_COMPULSORY 
 
     where 
          DEF_ID =  @DEF_ID 
   
   end
 
 
 else if @status = 'A'
 begin
   
     insert into SCHOOL_PLANE_DEFINITION
     values
     (       
        @DEF_CLASS_ID,
        @DEF_SUBJECT,
        @DEF_TEACHER,
        @DEF_TERM,
        @DEF_START_TIME,
        @DEF_END_TIME,
        @DEF_STATUS,
		@DEF_IS_COMPULSORY      
     )



	 
	 declare @EXAM_DEF_ID  numeric = 0, @exam_Def_class_id numeric = 0

	 set @exam_Def_class_id = (select SCOPE_IDENTITY())

	 select top(1) @EXAM_DEF_ID = EXAM_DEF_ID from EXAM_DEF ed 
	 join EXAM e on e.EXAM_ID = ed.EXAM_DEF_PID
	 where e.EXAM_CLASS_PLAN_ID = @DEF_CLASS_ID


	 insert into EXAM_DEF
select  EXAM_DEF_PID, @exam_Def_class_id, EXAM_DEF_SUBJECT_TYPE_ID, EXAM_DEF_TOTAL_MARKS, [EXAM_DEF_PASS_%AGE], [EXAM_DEF_NEXT_TERM_%AGE], [EXAM_DEF_FINAL_%AGE], EXAM_DEF_STATUS, EXAM_DEF_MARKS_TYPE, EXAM_DEF_GRACE_NUMBERS, EXAM_DEF_TERM_RANKS_TEST, EXAM_DEF_TERM_RANKS_TEST_PERCENTAGE, EXAM_DEF_TERM_RANKS_ASSIGNMENTS, EXAM_DEF_TERM_RANKS_ASSIGNMENTS_PERCENTAGE, EXAM_DEF_TERM_RANKS_PRESENTATIONS, EXAM_DEF_TERM_RANKS_PRESENTATIONS_PERCENTAGE, EXAM_DEF_TERM_RANKS_QUIZ, EXAM_DEF_TERM_RANKS_QUIZ_PERCENTAGE, EXAM_DEF_TERM_BEST_TESTS from EXAM_DEF where EXAM_DEF_ID = @EXAM_DEF_ID   

     
   
   end
 
 
 else if @status = 'D'
 begin
   
   update EXAM_DEF
	   set 
			EXAM_DEF_STATUS = 'D'
	   where
			EXAM_DEF_CLASS_ID = @DEF_ID
   
   
   
    update SCHOOL_PLANE_DEFINITION
 
     set          
          DEF_STATUS =  @DEF_STATUS
 
     where 
          DEF_ID =  @DEF_ID 
   
   end
     
     --insert into SCHOOL_PLANE_DEFINITION
     --values
     --(       
     --   @DEF_CLASS_ID,
     --   @DEF_SUBJECT,
     --   @DEF_TEACHER,
     --   @DEF_TERM,
     --   @DEF_START_TIME,
     --   @DEF_END_TIME,
     --   @DEF_STATUS     
     --)
     
	end