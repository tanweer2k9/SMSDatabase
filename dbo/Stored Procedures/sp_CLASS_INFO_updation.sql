
CREATE procedure  [dbo].[sp_CLASS_INFO_updation]
                                               
                                               
          @DEFINITION_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(2) 
   
   
   
     as begin 
   
   
     update CLASS_INFO
 
     set
         
          CLASS_NAME =  @DEFINITION_NAME,
          CLASS_DESC =  @DEFINITION_DESC,
          CLASS_STATUS =  @DEFINITION_STATUS
 
 where 
 
	CLASS_ID = @DEFINITION_ID
 
 
 declare @class_plan_id_count numeric = 0
 declare @DEFINITION_HD_ID numeric = 0
 declare @DEFINITION_BR_ID numeric = 0
 declare @old_class_name nvarchar(50) = ''
		select @old_class_name = CLASS_NAME, @DEFINITION_HD_ID = CLASS_HD_ID, @DEFINITION_BR_ID = CLASS_BR_ID from CLASS_INFO where CLASS_ID = @DEFINITION_ID

	 declare @is_classplan_allowed bit = 0
 	 declare @session_start_date date = ''
	 declare @session_end_date date = ''

	 select @is_classplan_allowed = BR_ADM_IS_CLASS_PLAN_ALLOWED, @session_start_date = BR_ADM_ACCT_START_DATE, @session_end_date = BR_ADM_ACCT_END_DATE from BR_ADMIN where BR_ADM_HD_ID = @DEFINITION_HD_ID and BR_ADM_ID = @DEFINITION_BR_ID
     
	 --if @is_classplan_allowed = 0
	 --BEGIN
		
		--declare @shift_id numeric = 0
	 --declare @department_id numeric = 0
	 --declare @section_id numeric = 0
	 --set @shift_id = (select top(1) SHFT_ID from SHIFT_INFO where SHFT_HD_ID = @DEFINITION_HD_ID and SHFT_BR_ID = @DEFINITION_BR_ID and SHFT_STATUS = 'T')
	 --set @department_id = (select top(1) DEP_ID from DEPARTMENT_INFO where DEP_HD_ID = @DEFINITION_HD_ID and DEP_BR_ID = @DEFINITION_BR_ID and DEP_STATUS = 'T')
	 --set @section_id = (select top(1) SECT_ID from SECTION_INFO where SECT_HD_ID = @DEFINITION_HD_ID and SECT_BR_ID = @DEFINITION_BR_ID and SECT_STATUS = 'T')



		--set @class_plan_id_count = (select COUNT(*) from SCHOOL_PLANE where CLASS_Name = @old_class_name and CLASS_HD_ID = @DEFINITION_HD_ID and CLASS_BR_ID = @DEFINITION_BR_ID)
		--if @class_plan_id_count = 0
		--BEGIN
		--	Exec dbo.sp_SCHOOL_PLANE_insertion @DEFINITION_HD_ID, @DEFINITION_BR_ID, @DEFINITION_NAME,@shift_id,@DEFINITION_ID,@department_id,
		--@section_id,-1,0,0,0,@DEFINITION_STATUS, @session_start_date,@session_end_date,0,0,1
		--END
		--ELSE
		--BEGIN
		--	declare @class_paln_id numeric = 0
		--	set @class_paln_id = (select CLASS_ID from SCHOOL_PLANE where CLASS_Name = @old_class_name and CLASS_HD_ID = @DEFINITION_HD_ID and CLASS_BR_ID = @DEFINITION_BR_ID)
		--	Exec dbo.sp_SCHOOL_PLANE_updation  @class_paln_id,@DEFINITION_HD_ID, @DEFINITION_BR_ID, @DEFINITION_NAME,@shift_id,@DEFINITION_ID,@department_id,
		--	@section_id,-1,0,0,0,@DEFINITION_STATUS, @session_start_date,@session_end_date,0,0,1
		--END
	 --END
 


end