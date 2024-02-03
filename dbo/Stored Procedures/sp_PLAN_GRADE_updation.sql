CREATE procedure  [dbo].[sp_PLAN_GRADE_updation]
                                               
                                               
          @P_GRADE_ID  numeric,
          @P_GRADE_HD_ID  numeric,
          @P_GRADE_BR_ID  numeric,
          @P_GRADE_PLAN_NAME  nvarchar(50) ,
          @P_GRADE_STATUS  char(2),
          @P_GRADE_SESSION_START_DATE date,
          @P_GRADE_SESSION_END_DATE date,
		  @P_GRADE_SUBJECT_AWRADS_MARKS float
        
   
   
     as begin 
   
   
     update PLAN_GRADE
 
	 set
      P_GRADE_PLAN_NAME =  @P_GRADE_PLAN_NAME,
      P_GRADE_STATUS =  @P_GRADE_STATUS,
      P_GRADE_SESSION_START_DATE = @P_GRADE_SESSION_START_DATE,
      P_GRADE_SESSION_END_DATE = @P_GRADE_SESSION_END_DATE,
	  P_GRADE_SUBJECT_AWRADS_MARKS = @P_GRADE_SUBJECT_AWRADS_MARKS
 
     where 
      P_GRADE_ID =  @P_GRADE_ID and 
      P_GRADE_HD_ID =  @P_GRADE_HD_ID and 
      P_GRADE_BR_ID =  @P_GRADE_BR_ID
 
end