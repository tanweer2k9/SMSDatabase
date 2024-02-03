CREATE procedure  [dbo].[sp_RIGHTS_PACKAGES_CHILD_insertion]
                                               
                                               
          @PACKAGES_DEF_PID  numeric,
          @PACKAGES_DEF_RIGHTS_PAGES_ID  numeric,
          @PACKAGES_DEF_STATUS  bit,
          @STATUS char(2),
          @PACKAGES_DEF_LOAD_STATUS bit,
		  @PACKAGES_DEF_IS_DASHBOARD bit
   
     as  begin
   
   declare @current_package_type int = 0
   declare @child_package_ID int = 0
   declare @child_package_id_count int = 0
   declare @child_def_page_count int = 0
   declare @table table (package_type int)
   declare @i int = 1
   
   if @STATUS = 'I'
   begin
		set @PACKAGES_DEF_PID = (select MAX(PACKAGES_ID) from RIGHTS_PACKAGES_PARENT)
   
		
     insert into RIGHTS_PACKAGES_CHILD
     values
     (
        @PACKAGES_DEF_PID,
        @PACKAGES_DEF_RIGHTS_PAGES_ID,
        @PACKAGES_DEF_STATUS,
        @PACKAGES_DEF_LOAD_STATUS,
		@PACKAGES_DEF_IS_DASHBOARD     
     )
    end
    
    else if @STATUS = 'U'
    begin
		update RIGHTS_PACKAGES_CHILD set PACKAGES_DEF_STATUS = @PACKAGES_DEF_STATUS , PACKAGES_DEF_IS_DASHBOARD = @PACKAGES_DEF_IS_DASHBOARD
		where PACKAGES_DEF_PID = @PACKAGES_DEF_PID and PACKAGES_DEF_RIGHTS_PAGES_ID = @PACKAGES_DEF_RIGHTS_PAGES_ID
		
		set @current_package_type = (select PACKAGES_TYPE from RIGHTS_PACKAGES_PARENT where PACKAGES_ID = @PACKAGES_DEF_PID)
		if @current_package_type = 1
		begin
			insert into @table values(2)
		end
		else if @current_package_type = 2
		begin
			insert into @table values(3)
			insert into @table values(4)
			insert into @table values(-1)
		end
		else if @current_package_type = 3
		begin
			insert into @table values(4)
			insert into @table values(-1)
		end
		
	
		set @child_package_id_count = (select COUNT(*) from RIGHTS_PACKAGES_PARENT where PACKAGES_TYPE in (select package_type from @table))
		while @i <= @child_package_id_count
		begin
			 select @child_package_ID = PACKAGES_ID from (select ROW_NUMBER() over (order by (select 0)) as sr, PACKAGES_ID from RIGHTS_PACKAGES_PARENT where PACKAGES_TYPE in (select package_type from @table))A where @i = sr
			
			set @child_def_page_count = (select COUNT(*) from RIGHTS_PACKAGES_CHILD where PACKAGES_DEF_PID = @child_package_ID and PACKAGES_DEF_RIGHTS_PAGES_ID = @PACKAGES_DEF_RIGHTS_PAGES_ID) 
			if @child_def_page_count = 0					
			begin
				insert into RIGHTS_PACKAGES_CHILD values ( @child_package_ID, @PACKAGES_DEF_RIGHTS_PAGES_ID, 0, @PACKAGES_DEF_STATUS,0)
			end
			else
			begin
				update RIGHTS_PACKAGES_CHILD set  PACKAGES_DEF_STATUS = 0, PACKAGES_DEF_LOAD_STATUS = @PACKAGES_DEF_STATUS 
				where PACKAGES_DEF_PID = @child_package_ID and PACKAGES_DEF_RIGHTS_PAGES_ID = @PACKAGES_DEF_RIGHTS_PAGES_ID 
			end
			set @i = @i + 1
		end

		
		--update RIGHTS_PACKAGES_CHILD set PACKAGES_DEF_STATUS 
		
    end

     
end