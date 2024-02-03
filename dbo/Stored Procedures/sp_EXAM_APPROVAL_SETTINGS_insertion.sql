CREATE procedure  [dbo].[sp_EXAM_APPROVAL_SETTINGS_insertion]
                                               
                                               
          @APPROVAL_HD_ID  numeric,
          @APPROVAL_BR_ID  numeric,
          @APPROVAL_STAFF_ID  numeric,
          @APPROVAL_DESIGNATION  nvarchar(50) ,
          @APPROVAL_RANK  int,
          @APPROVAL_STATUS  char(1) 
   
   
     as  begin
   
   declare @id numeric = 0
   declare @is_update  char = 'T'

   if @APPROVAL_DESIGNATION = 'Principal Exam Assessment' and @APPROVAL_STATUS = 'E'
   BEGIN
		set @id  =(select top(1) APPROVAL_ID from EXAM_APPROVAL_SETTINGS where APPROVAL_HD_ID = @APPROVAL_HD_ID and APPROVAL_BR_ID = @APPROVAL_BR_ID  and APPROVAL_DESIGNATION = 'Principal Exam Assessment' and APPROVAL_STATUS = 'E')
		set @id = ISNULL(@id,0)

		if @id != 0
		BEGIN
			update EXAM_APPROVAL_SETTINGS set APPROVAL_STAFF_ID = @APPROVAL_STAFF_ID where APPROVAL_ID = @id
			set @is_update = 'F'
		END
   END
   
   

   
   if @is_update = 'T'
   BEGIN
     insert into EXAM_APPROVAL_SETTINGS
     values
     (
        @APPROVAL_HD_ID,
        @APPROVAL_BR_ID,
        @APPROVAL_STAFF_ID,
        @APPROVAL_DESIGNATION,
        @APPROVAL_RANK,
        @APPROVAL_STATUS
     
     
     )
    END
	
end