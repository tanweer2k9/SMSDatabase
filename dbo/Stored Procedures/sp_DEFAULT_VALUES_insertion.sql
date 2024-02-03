CREATE procedure  [dbo].[sp_DEFAULT_VALUES_insertion]
                                               
                                               
          @HD_ID  numeric,
          @BR_ID  numeric,
          @PAGE_NAME  nvarchar(50) ,
          @VALUE_NAME  nvarchar(100) ,
          @VALUE  nvarchar(500) 
   
   
     as  begin
   
		declare @count int = (select COUNT(*) from DEFAULT_VALUES  where BR_ID =@BR_ID and PAGE_NAME = @PAGE_NAME and VALUE_NAME = @VALUE_NAME)


		if @count = 0

		BEGIN
			 insert into DEFAULT_VALUES
			 values
			 (
				@HD_ID,
				@BR_ID,
				@PAGE_NAME,
				@VALUE_NAME,
				@VALUE
			 )
		END
		ELSE
		BEGIN
			Update DEFAULT_VALUES set VALUE = @VALUE where BR_ID =@BR_ID and PAGE_NAME = @PAGE_NAME and VALUE_NAME = @VALUE_NAME
		END

		select * from VDEFAULT_VALUES where [BR ID] = @BR_ID
end