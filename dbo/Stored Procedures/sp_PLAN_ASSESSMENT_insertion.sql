CREATE procedure  [dbo].[sp_PLAN_ASSESSMENT_insertion]
                                               
                                        
                                            
          @PLAN_ASSESSMENT_PID  numeric,
          @PLAN_ASSESSMENT_INFO_ID  numeric ,
          @PLAN_ASSESSMENT_TERM_ID numeric,
          @PLAN_ASSESSMENT_TOTAL  float,
          @PLAN_ASSESSMENT_PASS_AGE  float,
          @PLAN_ASSESSMENT_STATUS  char(2),
          @status char(2),
          @PLAN_ASSESSMENT_ID numeric
          
   
   
     as  begin
	
		if @status = 'I'
		begin
			set	@PLAN_ASSESSMENT_PID = (select MAX(EXAM_ID) from EXAM)
			insert into PLAN_ASSESSMENT
			 values
			 (
		        
				@PLAN_ASSESSMENT_PID,
				@PLAN_ASSESSMENT_INFO_ID,
				@PLAN_ASSESSMENT_TERM_ID,
				@PLAN_ASSESSMENT_TOTAL,
				@PLAN_ASSESSMENT_PASS_AGE,
				@PLAN_ASSESSMENT_STATUS
		     
			 )
		end
		
		else if @status = 'A'
		BEGIN
			insert into PLAN_ASSESSMENT
			 values
			 (
		        
				@PLAN_ASSESSMENT_PID,
				@PLAN_ASSESSMENT_INFO_ID,
				@PLAN_ASSESSMENT_TERM_ID,
				@PLAN_ASSESSMENT_TOTAL,
				@PLAN_ASSESSMENT_PASS_AGE,
				@PLAN_ASSESSMENT_STATUS
		     
			 )
		END
		
		else if @status = 'U'
		BEGIN
			update PLAN_ASSESSMENT
 
     set
          PLAN_ASSESSMENT_PID =  @PLAN_ASSESSMENT_PID,
          PLAN_ASSESSMENT_INFO_ID =  @PLAN_ASSESSMENT_INFO_ID,
          PLAN_ASSESSMENT_TERM_ID =  @PLAN_ASSESSMENT_TERM_ID,
          PLAN_ASSESSMENT_TOTAL =  @PLAN_ASSESSMENT_TOTAL,
          [PLAN_ASSESSMENT_PASS_%AGE] =  @PLAN_ASSESSMENT_PASS_AGE,
          PLAN_ASSESSMENT_STATUS =  @PLAN_ASSESSMENT_STATUS
 
     where 
          PLAN_ASSESSMENT_ID =  @PLAN_ASSESSMENT_ID 
			
		END
		
		--declare @assement_info_id numeric = (select ASSESSMENT_ID from ASSESSMENT_INFO where ASSESSMENT_HD_ID = (select EXAM_HD_ID from EXAM where EXAM_ID = @PLAN_ASSESSMENT_PID) and ASSESSMENT_BR_ID = (select EXAM_BR_ID from EXAM where EXAM_ID = @PLAN_ASSESSMENT_PID) and ASSESSMENT_NAME = @PLAN_ASSESSMENT_INFO_ID )
		--declare @term_id numeric = (select TERM_ID from TERM_INFO where TERM_HD_ID = (select EXAM_HD_ID from EXAM where EXAM_ID = @PLAN_ASSESSMENT_PID) and TERM_BR_ID = (select EXAM_BR_ID from EXAM where EXAM_ID = @PLAN_ASSESSMENT_PID) and TERM_NAME = @PLAN_ASSESSMENT_INFO_ID )
   
     
     
end