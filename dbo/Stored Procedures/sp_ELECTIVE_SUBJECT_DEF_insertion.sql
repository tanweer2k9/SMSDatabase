CREATE procedure  [dbo].[sp_ELECTIVE_SUBJECT_DEF_insertion]
                                               
                          
		  @ELE_SUB_DEF_ID numeric,
          @ELE_SUB_DEF_PID  numeric,
          @ELE_SUB_DEF_SUB_ID  numeric,
          @ELE_SUB_DEF_STATUS  char(2) 
   
   
     as  begin
   


	--declare @count int = 0

	--set @count =  (select COUNT(*) from ELECTIVE_SUBJECT_DEF where ELE_SUB_DEF_PID = @ELE_SUB_DEF_PID and ELE_SUB_DEF_SUB_ID = @ELE_SUB_DEF_SUB_ID)

	--if @count = 0

	if @ELE_SUB_DEF_STATUS = 'I'
   begin
		 insert into ELECTIVE_SUBJECT_DEF
		 values
		 (
			@ELE_SUB_DEF_PID,
			@ELE_SUB_DEF_SUB_ID,
			'T'
		 )
	 end
	 else if @ELE_SUB_DEF_STATUS = 'U'
	 begin
			     update ELECTIVE_SUBJECT_DEF
 
			 set
				 
				  ELE_SUB_DEF_SUB_ID =  @ELE_SUB_DEF_SUB_ID,
				  ELE_SUB_DEF_STATUS =  'T'
 
			 where 
				  ELE_SUB_DEF_ID =  @ELE_SUB_DEF_ID 
	 end
	--else
	--begin
	--	 update ELECTIVE_SUBJECT_DEF
 
 --    set
 --         ELE_SUB_DEF_ID =  @ELE_SUB_DEF_ID,
 --         ELE_SUB_DEF_SUB_ID =  @ELE_SUB_DEF_SUB_ID,
 --         ELE_SUB_DEF_STATUS =  @ELE_SUB_DEF_STATUS
 
 --    where 
 --         ELE_SUB_DEF_PID =  @ELE_SUB_DEF_PID 		
	--end
     
end