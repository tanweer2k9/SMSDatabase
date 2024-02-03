CREATE procedure  [dbo].[sp_RIGHTS_PAGES_insertion]
                                               
                                               
          @RIGHTS_PAGES_NAME  nvarchar(150) ,
          @RIGHTS_PAGES_TEXT  nvarchar(150) ,
          @RIGHTS_PAGES_PARENT_CODE  nvarchar(150) ,
          @RIGHTS_PAGES_CHILD_CODE  nvarchar(150),
		  @RIGHTS_PAGES_URL nvarchar(250),
          @STATUS char(2) 
   
   
     as  begin
   
   --P for Right Pages insertion only
     insert into RIGHTS_PAGES
     values
     (
        @RIGHTS_PAGES_NAME,
        @RIGHTS_PAGES_TEXT,
        @RIGHTS_PAGES_PARENT_CODE,
        @RIGHTS_PAGES_CHILD_CODE,
		@RIGHTS_PAGES_URL,
		NULL,
		NULL
     )
     
     --C for both insertion right_insertion and right_package_child
     declare @Pages_id numeric = (select MAX(RIGHTS_PAGES_ID) from RIGHTS_PAGES)
     
     if @STATUS = 'C'
     BEGIN
		declare @count_child_packages int =  (select count(*) from RIGHTS_PACKAGES_PARENT where PACKAGES_TYPE = 1)
		declare @i int = 1
		declare @package_id numeric = 0
		declare @package_status bit = 0
		declare @package_load_status bit = 1
		while @i <= @count_child_packages
		begin
			
			 select @package_id = PACKAGES_ID from (select ROW_NUMBER() over(order by (select 0)) as sr, PACKAGES_ID from RIGHTS_PACKAGES_PARENT where PACKAGES_TYPE = 1)A where sr = @i
				insert into RIGHTS_PACKAGES_CHILD values (@package_id, @Pages_id, @package_status,@package_load_status,0)
			
			set @i = @i + 1
		end
     END        
end

select * from RIGHTS_PACKAGES_CHILD