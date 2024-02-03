CREATE PROCEDURE  [dbo].[sp_SCHOOL_PLANE_deletion]
                                               
                                               
          @STATUS char(2),
          @CLASS_ID numeric,
          @CLASS_HD_ID  numeric,
          @CLASS_BR_ID  numeric
          
   
   
     AS
   


   declare @count int = 0
			set @count = (select COUNT(*) from FEE_COLLECT where FEE_COLLECT_HD_ID = @CLASS_HD_ID and FEE_COLLECT_BR_ID = @CLASS_HD_ID and FEE_COLLECT_PLAN_ID = @CLASS_ID) 
							+
						(select COUNT(*) from STUDENT_INFO where STDNT_HD_ID = @CLASS_HD_ID and STDNT_BR_ID = @CLASS_HD_ID and STDNT_CLASS_PLANE_ID = @CLASS_ID and STDNT_STATUS != 'D') 
						+
						(select COUNT(*) from STUDENT_ROLL_NUM where STUDENT_ROLL_NUM_HD_ID = @CLASS_HD_ID and STUDENT_ROLL_NUM_BR_ID = @CLASS_HD_ID and STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID and STUDENT_ROLL_NUM_STATUS !='D') 
						+
						(select COUNT(*) from EXAM where EXAM_HD_ID = @CLASS_HD_ID and EXAM_BR_ID = @CLASS_HD_ID and EXAM_CLASS_PLAN_ID = @CLASS_ID and EXAM_STATUS != 'D') 

	if @count = 0
	begin

		   IF @STATUS = 'U'
			BEGIN 
				update SCHOOL_PLANE
					set CLASS_STATUS = 'D'
					 where 
								  CLASS_ID = @CLASS_ID and
								  CLASS_HD_ID =  @CLASS_HD_ID and 
								  CLASS_BR_ID =  @CLASS_BR_ID 
          
          
							 update SCHOOL_PLANE_DEFINITION  
							  set DEF_STATUS = 'D'     
								  where 
								  DEF_CLASS_ID = @CLASS_ID
          
							   update STUDENT_FEE_NOTES
							set
								STD_FEE_NOTES_STATUS = 'D' 
		
							where STD_FEE_NOTES_HD_ID = @CLASS_HD_ID
								and STD_FEE_NOTES_BR_ID = @CLASS_BR_ID
								and STD_FEE_NOTES_CLASS_ID = @CLASS_ID       
          
					    
       
		   END      
  
		  else IF @STATUS = 'D'
			BEGIN 
			 delete from SCHOOL_PLANE
		
			 where 
				  CLASS_ID = @CLASS_ID and
				  CLASS_HD_ID =  @CLASS_HD_ID and 
				  CLASS_BR_ID =  @CLASS_BR_ID 
                    
			 delete from SCHOOL_PLANE_DEFINITION       
			   where  DEF_CLASS_ID = @CLASS_ID
	   
   
		   delete from STUDENT_FEE_NOTES
		   where STD_FEE_NOTES_HD_ID = @CLASS_HD_ID
				and STD_FEE_NOTES_BR_ID = @CLASS_BR_ID
				and STD_FEE_NOTES_CLASS_ID = @CLASS_ID
   
		   end
		select 'ok'
	end

	else
	begin
		select 'use'
	end