
CREATE procedure  [dbo].[sp_RIGHTS_USER_ALLOCATION_updation]
                                               
                                               
          @PACKAGES_ID  numeric,
          @PACKAGES_HD_ID  numeric,
          @PACKAGES_BR_ID  numeric,
          @LOGIN_ID  numeric,
          @PACKAGES_TYPE  numeric,
          @USER_DISPLAY_NAME nvarchar(100),
          @USER_PASSWORD nvarchar(100),		 
		  @LOGIN_ALLOWED nvarchar(2)
   
   
     as begin 
   
   
     update RIGHTS_PACKAGES_PARENT
 
     set          
          PACKAGES_TYPE =  @PACKAGES_TYPE
 
     where 
          PACKAGES_ID =  @PACKAGES_ID and 
          PACKAGES_HD_ID =  @PACKAGES_HD_ID and 
          PACKAGES_BR_ID =  @PACKAGES_BR_ID 
	
	update USER_INFO 
	set	
			USER_ROLE = @PACKAGES_ID,
			USER_DISPLAY_NAME = @USER_DISPLAY_NAME,
			USER_PASSWORD = @USER_PASSWORD,
			USER_STATUS = @LOGIN_ALLOWED
	where 
			USER_ID = @LOGIN_ID 
end