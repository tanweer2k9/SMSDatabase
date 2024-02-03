CREATE procedure  [dbo].[sp_RIGHTS_insertion]
                                               
                                               
          @RIGHTS_HD_ID  numeric,
          @RIGHTS_BR_ID numeric,
          @RIGHTS_RIGHT_PARENTS_CODE  nvarchar(50) ,
          @RIGHTS_RIGHT_CODE  nvarchar(50) ,
          @RIGHTS_RIGHT_NAME  nvarchar(100) ,
          @RIGHTS_RIGHT_TEXT  nvarchar(50) ,
          @RIGHTS_ROLE  nvarchar(100) ,
          @RIGHTS_ADMIN_LEVEL  numeric,
          @RIGHTS_LEVEL  numeric,
          @RIGHTS_RIGHT_APPLICABLE  bit,
          @RIGHTS_SUB_RIGHT_APPLICABLE1  bit,
          @RIGHTS_STATUS  bit,
          @RIGHTS_IS_DELETED  bit,
          @RIGHTS_IS_BUTTON  bit
   
   
     as  begin
   
   
   
   
      --delete from RIGHTS  
      --where  RIGHTS_HD_ID = @RIGHTS_HD_ID
      --AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      --and  RIGHTS_ROLE = @RIGHTS_ROLE
      --and  RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
   
   
     insert into RIGHTS
     values
     (
        @RIGHTS_HD_ID,
        @RIGHTS_BR_ID,
        @RIGHTS_RIGHT_PARENTS_CODE,
        @RIGHTS_RIGHT_CODE,
        @RIGHTS_RIGHT_NAME,
        @RIGHTS_RIGHT_TEXT,
        @RIGHTS_ROLE,
        @RIGHTS_ADMIN_LEVEL,
        @RIGHTS_LEVEL,
        @RIGHTS_RIGHT_APPLICABLE,
        @RIGHTS_SUB_RIGHT_APPLICABLE1,
        @RIGHTS_STATUS,
        @RIGHTS_IS_DELETED,
        @RIGHTS_IS_BUTTON
     
     
     )
     
     
     
     
     if @RIGHTS_ADMIN_LEVEL < 3
     BEGIN
		update USER_INFO	
		set USER_ROLE = @RIGHTS_ROLE	
		where [USER_ID] = ( select top(1) [USER_ID] from USER_INFO where USER_HD_ID = @RIGHTS_HD_ID and USER_TYPE = 'SA' and  USER_STATUS != 'D')
	 End
	
     
     
     else if @RIGHTS_ADMIN_LEVEL < 4
     BEGIN
		update USER_INFO	
		set USER_ROLE = @RIGHTS_ROLE	
		where [USER_ID] = ( select top(1) [USER_ID] from USER_INFO where USER_HD_ID = @RIGHTS_HD_ID and USER_BR_ID = @RIGHTS_BR_ID  and USER_TYPE = 'A' and USER_STATUS != 'D')
	 End
	
		
     
end