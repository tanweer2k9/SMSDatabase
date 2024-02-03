CREATE procedure  [dbo].[sp_CLASS_INFO_insertion]
                                               
                                               
          @DEFINITION_HD_ID  numeric,
          @DEFINITION_BR_ID  numeric,
          @DEFINITION_NAME  nvarchar(50) ,
          @DEFINITION_DESC  nvarchar(max) ,
          @DEFINITION_STATUS  char(1) 
   
   
   
     as  begin
   
  
   
     insert into CLASS_INFO
     values
     (
       
        @DEFINITION_HD_ID,
        @DEFINITION_BR_ID,
        @DEFINITION_NAME,
        @DEFINITION_DESC,
        @DEFINITION_STATUS
     
     )

	 declare @class_id int = 0
	 set @class_id = SCOPE_IDENTITY()

	 declare @is_classplan_allowed bit = 0
	 declare @session_start_date date = ''
	 declare @session_end_date date = ''

	 select @is_classplan_allowed = BR_ADM_IS_CLASS_PLAN_ALLOWED, @session_start_date = BR_ADM_ACCT_START_DATE, @session_end_date = BR_ADM_ACCT_END_DATE from BR_ADMIN where BR_ADM_HD_ID = @DEFINITION_HD_ID and BR_ADM_ID = @DEFINITION_BR_ID
     
	 set @is_classplan_allowed = ISNULL(@is_classplan_allowed, CAST(1 as bit))

	 if @is_classplan_allowed = 0
	 BEGIN

	 declare @shift_id numeric = 0
	 declare @department_id numeric = 0
	 declare @section_id numeric = 0
	 set @shift_id = (select top(1) SHFT_ID from SHIFT_INFO where SHFT_HD_ID = @DEFINITION_HD_ID and SHFT_BR_ID = @DEFINITION_BR_ID and SHFT_STATUS = 'T')
	 set @department_id = (select top(1) DEP_ID from DEPARTMENT_INFO where DEP_HD_ID = @DEFINITION_HD_ID and DEP_BR_ID = @DEFINITION_BR_ID and DEP_STATUS = 'T')
	 set @section_id = (select top(1) SECT_ID from SECTION_INFO where SECT_HD_ID = @DEFINITION_HD_ID and SECT_BR_ID = @DEFINITION_BR_ID and SECT_STATUS = 'T')


		exec [dbo].[sp_SCHOOL_PLANE_insertion] @DEFINITION_HD_ID, @DEFINITION_BR_ID, @DEFINITION_NAME,@shift_id,@class_id,@department_id,
		@section_id,-1,0,0,0,@DEFINITION_STATUS, @session_start_date,@session_end_date,0,0,1
	 END

end