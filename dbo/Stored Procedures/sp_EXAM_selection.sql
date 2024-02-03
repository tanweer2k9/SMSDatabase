
CREATE procedure  [dbo].[sp_EXAM_selection]
                                               
                                               
     @STATUS char(10),
     @EXAM_ID  numeric,
    -- @EXAM_ID_DEF numeric,
     @EXAM_HD_ID  numeric,
     @EXAM_BR_ID  numeric,
     @EXAM_ASSESMENT_TYPE nvarchar(50),
     @EXAM_CLASS_PLAN_ID numeric,
	 @SessionId numeric
   
   
     AS BEGIN 
   
   
   
	
--        declare @STATUS char(10) = 'L'
--     declare @EXAM_ID  numeric = 26
--    -- @EXAM_ID_DEF numeric,
--declare     @EXAM_HD_ID  numeric = 2
-- declare    @EXAM_BR_ID  numeric = 1
--  declare   @EXAM_ASSESMENT_TYPE nvarchar(50) = 'Each'
--     declare @EXAM_CLASS_PLAN_ID numeric  = 1
     
    declare @assessment_type nvarchar(100)
	 declare @class_id as numeric
	 declare @max_exam_deff_id numeric = ISNULL((select MAX(ID) from VEXAM_DEF where [Branch ID] = @EXAM_BR_ID), 0)
	 
	 declare @grace_numbers int = 3
	 
   		if @EXAM_CLASS_PLAN_ID = 0
				begin
					set @class_id = (select min(ID) from VSCHOOL_PLANE where [Status]='T' and [Branch ID] = @EXAM_BR_ID)
				end
				else
				
				begin
					set @class_id = @EXAM_CLASS_PLAN_ID
				end
   
   set @assessment_type = (select BR_ADM_ASSEMENT_TYPE from BR_ADMIN where BR_ADM_HD_ID = @EXAM_HD_ID and BR_ADM_ID = @EXAM_BR_ID)
   set @assessment_type = ISNULL(@assessment_type, 'Grade')

     if @STATUS = 'L'
     BEGIN			
				if @EXAM_ASSESMENT_TYPE = 'Final'
				BEGIN
					if @assessment_type = 'Marks'
					begin
						select ID, Name, 'Final Term' as Term,10 as [Total Marks], 0 as [Pass %age] from VASSESSMENT_INFO as assessment_0
						where Status = 'T'
					end
					else
					begin
						select ID, Name, 'Final Term' as Term,-1 as [Total Marks], -1 as [Pass %age] from VASSESSMENT_INFO as assessment_0
						where Status = 'T'
					end
				END
				else
				BEGIN
					if @assessment_type = 'Marks'
					begin
						select ID, Name, t.TERM_NAME as Term, 10 as [Total Marks], 0 as [Pass %age] from VASSESSMENT_INFO v
						cross join TERM_INFO t
						where t.TERM_STATUS = 'T' and v.Status = 'T'
						
					end
					else
					begin
						select ID, Name, t.TERM_NAME as Term, -1 as [Total Marks], -1 as [Pass %age] from VASSESSMENT_INFO v
						cross join TERM_INFO t
						where t.TERM_STATUS = 'T' and v.Status = 'T'					
					end
				END
			    
			   	 
				SELECT (ROW_NUMBER() over( order by(select 0)) + @max_exam_deff_id) as  [ID], [Term ID] as Term,[Subject ID] as Subject,0 as [Subject Type], 'Numbers' as [Marks Type], @grace_numbers as [Grace Numbers],100 as [Total Marks],
				40 as [Pass %age],0 as [%age In Next Term],'' as [Terms Test],'' as [Terms Test Percent],'' as  [Terms Assignment],'' as [Terms Assignment Percent],'' as [Terms Presentation],'' as [Terms Presentation Percent],'' as [Terms Quiz],'' as [Terms Quiz Percent], 0 as [Best Tests],CASE WHEN [Term ID] = 8 THEN 100 ELSE 0 END as [%age In Final],ID as PID FROM VSCHOOL_PLANE_DEFINITION as plan_deff_1
				where [Class ID] = @class_id		   
					   and [Status] = 'T' order by [Subject ID], [Term ID]
					   	
					   
				--select EXAM_DEF_ID as ID,EXAM_DEF_TOTAL_MARKS as [Total Marks],[EXAM_DEF_PASS_%AGE] as [Pass %age],[EXAM_DEF_FINAL_%AGE] as [Final %age],EXAM_DEF_STATUS as [Status] from EXAM_DEF
				--where EXAM_DEF_PID = @EXAM_ID 
				--and EXAM_DEF_CLASS_ID  =  @EXAM_ID_DEF
				 
			    
     	END
     
     if @STATUS = 'B'

		begin
		
				
					
			select ID,Name,Term, [Total Marks], [Pass %age] from VPLAN_ASSESSMENT
			where PID = @EXAM_ID and [Status] != 'D'    
					
			
			select * from (
			
			select ID, [Term ID] as Term, [Subject ID] as Subject,[Subject Type ID] as [Subject Type], [Marks Type],[Grace Numbers],[Total Marks], [Pass %age], [%age In Next Term],[Terms Test],[Terms Test Percent], [Terms Assignment],[Terms Assignment Percent],[Terms Presentation],[Terms Presentation Percent],[Terms Quiz],[Terms Quiz Percent] , [Best Tests],[%age In Final], [Class ID] as PID from VEXAM_DEF										
			where PID = @EXAM_ID and Status = 'T'			
			
			--union all 
			--select (ROW_NUMBER() over( order by(select 0)) + @max_exam_deff_id) as  [ID], [Term ID] as Term, [Subject ID] as Subject, 0 as [Subject Type],'Numbers' as [Marks Type], @grace_numbers as [Grace Numbers],100 [Total Marks],0 [Pass %age], 0[%age In Next Term],'' as [Term Ranks],'' as [Term Ranks %age], 0 [%age In Final], ID as PID from VSCHOOL_PLANE_DEFINITION 
			--where ID not in (select EXAM_DEF_CLASS_ID from EXAM_DEF ed where EXAM_DEF_STATUS = 'T') 
			--and [Class ID] in (select EXAM_CLASS_PLAN_ID from EXAM where EXAM_ID = @EXAM_ID and EXAM_STATUS = 'T')
			--and Status = 'T'
			)A order by A.[Subject], A.Term, A.[Subject Type]

   
		  END
		   
     if @STATUS = 'C'
		  BEGIN
			set @class_id = (select [Class Plan ID] from VEXAM where ID = @EXAM_ID)
				if @EXAM_ASSESMENT_TYPE = 'Final'
				BEGIN
					if @assessment_type = 'Marks'
					begin
						select ID, Name, 'Final Term' as Term,10 as [Total Marks], 0 as [Pass %age] from VASSESSMENT_INFO as assessment_0
						where Status = 'T'
					end
					else
					begin
						select ID, Name, 'Final Term' as Term,-1 as [Total Marks], -1 as [Pass %age] from VASSESSMENT_INFO as assessment_0
						where Status = 'T'
					end
				END
				else
				BEGIN
					if @assessment_type = 'Marks'
					begin
						select ID, Name, t.TERM_NAME as Term, 10 as [Total Marks], 0 as [Pass %age] from VASSESSMENT_INFO v
						cross join TERM_INFO t
						where t.TERM_STATUS = 'T' and v.Status = 'T'
						
					end
					else
					begin
						select ID, Name, t.TERM_NAME as Term, -1 as [Total Marks], -1 as [Pass %age] from VASSESSMENT_INFO v
						cross join TERM_INFO t
						where t.TERM_STATUS = 'T' and v.Status = 'T'					
					end
				END
				
				select ID, [Term ID] as Term, [Subject ID] as Subject,[Subject Type ID] as [Subject Type], [Marks Type],[Grace Numbers],[Total Marks],[Pass %age], [%age In Next Term],[Terms Test],[Terms Test Percent], [Terms Assignment],[Terms Assignment Percent],[Terms Presentation],[Terms Presentation Percent],[Terms Quiz],[Terms Quiz Percent], [Best Tests],[%age In Final], [Class ID] as PID from VEXAM_DEF
					where PID = @EXAM_ID	 
		  END
	
	
		  		  
			SELECT ID,[Class Plan], Name,[Total Type], Status, [Session Start Date], [Session End Date], [Fail Limit]  FROM VEXAM as Exam_plan_2
	 where [Institute ID] = @EXAM_HD_ID and
		   [Branch ID] = @EXAM_BR_ID
		   and [Status] !='D' and SessionId = @SessionId
	
     
	 select [ID],[Name] from VSCHOOL_PLANE as class_plan3
	 where [Institute ID] = @EXAM_HD_ID and
			[Branch ID] = @EXAM_BR_ID and
						[Status] ='T' and [Session Id] = @SessionId
	
     select [ID],[Name] from VASSESSMENT_INFO as assessment_deff_4
     where [Institute ID] = @EXAM_HD_ID and
			[Branch ID] = @EXAM_BR_ID and
		    [Status] = 'T'
			
	
	
     select distinct ID, Name from VTERM_INFO
     where [Institute ID] = @EXAM_HD_ID and
			[Branch ID] = @EXAM_BR_ID and
			
			 [Status] = 'T'
			 			 
			 select (ROW_NUMBER() over( order by(select 0)) + @max_exam_deff_id) as  [ID], [Term ID] as Term, [Subject ID] as Subject, 0 as [Subject Type], 'Numbers' as [Marks Type], @grace_numbers as [Grace Numbers],100 [Total Marks],0 [Pass %age], 0[%age In Next Term],'' as [Terms Test Percent],'' as  [Terms Assignment],'' as [Terms Assignment Percent],'' as [Terms Presentation],'' as [Terms Presentation Percent],'' as [Terms Quiz],'' as [Terms Quiz Percent], 0 as [Best Tests], 0 [%age In Final], [Class ID] as PID from VSCHOOL_PLANE_DEFINITION 
			where ID not in (select EXAM_DEF_CLASS_ID from EXAM_DEF where EXAM_DEF_STATUS = 'T') 
			and [Class ID] in (select EXAM_CLASS_PLAN_ID from EXAM where EXAM_ID = @EXAM_ID and EXAM_STATUS = 'T')
			and Status = 'T'
			
			
		select distinct ([Term ID]) as ID, Term as Name from VSCHOOL_PLANE_DEFINITION where [Class ID] = @class_id
		
		select distinct ([Subject ID]) as ID, Subject as Name from VSCHOOL_PLANE_DEFINITION where [Class ID] = @class_id
		
		select 0 as ID, 'Whole' as Name
		union all
		select SUBJECT_TYPE_ID as ID, SUBJECT_TYPE_NAME as Name from SUBJECT_TYPE_INFO where SUBJECT_TYPE_HD_ID = @EXAM_HD_ID and SUBJECT_TYPE_BR_ID = @EXAM_BR_ID and SUBJECT_TYPE_STATUS = 'T'
     
     		select (ROW_NUMBER() over( order by(select 0)) + @max_exam_deff_id) as  [ID], [Term ID] as Term, [Subject ID] as Subject, 0 as [Subject Type],'Numbers' as [Marks Type], @grace_numbers as [Grace Numbers],100 [Total Marks],0 [Pass %age], 0[%age In Next Term],'' as [Terms Test Percent],'' as  [Terms Assignment],'' as [Terms Assignment Percent],'' as [Terms Presentation],'' as [Terms Presentation Percent],'' as [Terms Quiz],'' as [Terms Quiz Percent], 0 as [Best Tests], 0 [%age In Final], ID as PID from VSCHOOL_PLANE_DEFINITION 
			where ID not in (select EXAM_DEF_CLASS_ID from EXAM_DEF where EXAM_DEF_STATUS = 'T') 
			and [Class ID] in (select EXAM_CLASS_PLAN_ID from EXAM where EXAM_ID = @EXAM_ID and EXAM_STATUS = 'T')
			and Status = 'T' order by [Subject], Term, [Subject Type]
     
  END