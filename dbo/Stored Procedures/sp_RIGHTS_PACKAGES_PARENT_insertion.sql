CREATE procedure  [dbo].[sp_RIGHTS_PACKAGES_PARENT_insertion]
                                               
                                               
          @PACKAGES_HD_ID  numeric,
          @PACKAGES_BR_ID  numeric,
          @PACKAGES_NAME  nvarchar(100) ,
          @PACKAGES_TYPE  numeric 
   
   
     as  begin
   
   
     insert into RIGHTS_PACKAGES_PARENT
     values
     (
        @PACKAGES_HD_ID,
        @PACKAGES_BR_ID,
        @PACKAGES_NAME,
        @PACKAGES_TYPE
     
     )
     
     
     declare @package_id numeric = (select MAX(PACKAGES_ID) from RIGHTS_PACKAGES_PARENT)
     
     if @PACKAGES_TYPE = 1
     update USER_INFO set USER_ROLE = @package_id
     where USER_HD_ID = @PACKAGES_HD_ID and USER_STATUS != 'D' and USER_TYPE = 'SA'
     
     else if @PACKAGES_TYPE = 2
     update USER_INFO set USER_ROLE = @package_id
     where USER_HD_ID = @PACKAGES_HD_ID and USER_BR_ID = @PACKAGES_BR_ID and USER_STATUS != 'D' and USER_TYPE = 'A'
     and USER_ID not in (select TECH_USER_INFO_ID from TEACHER_INFO)
     
end