
     CREATE procedure  [dbo].[sp_FEE_REMARKS_FAMILY_HISTORY_insertion]
                                               
                                               
          @FEE_REMARKS_STD_ID  numeric,
          @FEE_REMARKS_SESSION_ID  numeric,
          @FEE_REMARKS  nvarchar(MAX) 
   
   
     as  begin
   

	declare @count int = 0
	set @count = (select COUNT(*) from FEE_REMARKS_FAMILY_HISTORY where FEE_REMARKS_STD_ID  = @FEE_REMARKS_STD_ID  and FEE_REMARKS_SESSION_ID = @FEE_REMARKS_SESSION_ID)

   if @count = 0
	   BEGIN
		 insert into FEE_REMARKS_FAMILY_HISTORY
		 values
		 (
			@FEE_REMARKS_STD_ID,
			@FEE_REMARKS_SESSION_ID,
			@FEE_REMARKS
     
     
		 )
	   END
   ELSE
   BEGIN

	update FEE_REMARKS_FAMILY_HISTORY 
		set FEE_REMARKS = @FEE_REMARKS 

where FEE_REMARKS_STD_ID  = @FEE_REMARKS_STD_ID  and FEE_REMARKS_SESSION_ID = @FEE_REMARKS_SESSION_ID
   END
   	


     
end