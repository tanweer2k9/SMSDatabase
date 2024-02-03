CREATE procedure  [dbo].[sp_RIGHTS_selection]
                                               
     @STATUS char(10),
     @RIGHTS_HD_ID  numeric,
     @RIGHTS_BR_ID numeric, 
     @RIGHTS_IS_DELETED  bit,
     @RIGHTS_ROLE nvarchar(100),
     @RIGHTS_ADMIN_LEVEL numeric,
     @RIGHTS_STATUS bit
     
     AS 
   
      if @STATUS = 'L'
     BEGIN
   	
	SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      where  RIGHTS_HD_ID = @RIGHTS_HD_ID
      AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      and RIGHTS_ROLE = @RIGHTS_ROLE --'rights2' 
      and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
      and RIGHTS_STATUS = @RIGHTS_STATUS
      and RIGHTS_IS_DELETED = @RIGHTS_IS_DELETED
      
   
   
   
		if @RIGHTS_ADMIN_LEVEL = 1
			begin
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To IT Admin' as [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and  RIGHTS_ADMIN_LEVEL = 1 and RIGHTS_IS_DELETED = 0
			--	union all	
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To School Admin' as [Description],RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS
			where
			RIGHTS_ADMIN_LEVEL = 2 and RIGHTS_IS_DELETED = 0
		
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Branch Admin' [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL + 2 and RIGHTS_IS_DELETED = 0
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL + 3 and RIGHTS_IS_DELETED = 0
			
			select ID,[Institute Name],[Short Name],[Institute Level],Branches from VMAIN_HD_INFO
			where [Status] = 'T' 
			
			
			
			end 
			
			else if @RIGHTS_ADMIN_LEVEL = 2
			begin 
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Branch Admin' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
       and RIGHTS_ADMIN_LEVEL = 3 and RIGHTS_IS_DELETED = 0
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --    and  RIGHTS_ADMIN_LEVEL = 4 and RIGHTS_IS_DELETED = 0
			
			
			
			
			select ID,[Institute ID],Name,Land_line from V_BRANCH_INFO			
			where [Status] = 'T'  and [Institute ID] = @RIGHTS_HD_ID
			
			
			
			end
			
			
			else if @RIGHTS_ADMIN_LEVEL = 3
			begin
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
			AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = 4 and RIGHTS_IS_DELETED = 0
			
			
			
			select ID,[Institute ID],Name,Land_line from V_BRANCH_INFO			
			where [Status] = 'T'  and [Institute ID] = @RIGHTS_HD_ID
			
			
			
			end
			
			
     
     END
    
     else  if @STATUS = 'D'
     BEGIN
   declare @Check int
   set @Check = 
   (
      SELECT count(RIGHTS_RIGHT_PARENTS_CODE) FROM RIGHTS
      where  RIGHTS_HD_ID = @RIGHTS_HD_ID
      AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      and  RIGHTS_ROLE = @RIGHTS_ROLE
      and  RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
       and RIGHTS_IS_DELETED = 0
    ) 
    if @Check = 0 
    select CAST(0 as bit)
    else
    select CAST(1 as bit)
    
      --  SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      --where  RIGHTS_ROLE = 'IA'
     
     END  
     
   

     else if @STATUS = 'B'
     BEGIN
   
   
   	SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      where  RIGHTS_HD_ID = @RIGHTS_HD_ID
      --AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      and RIGHTS_ROLE = @RIGHTS_ROLE --'rights2' 
      and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
      --and RIGHTS_STATUS = @RIGHTS_STATUS
      and RIGHTS_IS_DELETED = @RIGHTS_IS_DELETED
   
   
   
		if @RIGHTS_ADMIN_LEVEL = 1
			begin
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To IT Admin' as [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and  RIGHTS_ADMIN_LEVEL = 1 and RIGHTS_IS_DELETED = 0
			--	union all	
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To School Admin' as [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where
			RIGHTS_ADMIN_LEVEL = 2 and RIGHTS_IS_DELETED = 0
		
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Branch Admin' [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL + 2 and RIGHTS_IS_DELETED = 0
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --   AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL + 3 and RIGHTS_IS_DELETED = 0
			
			select ID,[Institute Name],[Short Name],[Institute Level],Branches from VMAIN_HD_INFO
			where [Status] = 'T' 
			
			
			end 
			
			else if @RIGHTS_ADMIN_LEVEL = 2
			begin 
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Branch Admin' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
       and RIGHTS_ADMIN_LEVEL = 3 and RIGHTS_IS_DELETED = 0
			--union all
			--select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
   --    and  RIGHTS_ADMIN_LEVEL = 4 and RIGHTS_IS_DELETED = 0
			
			
			select ID,[Institute ID],Name,Land_line from V_BRANCH_INFO			
			where [Status] = 'T'  and [Institute ID] = @RIGHTS_HD_ID
			
			end
			
			
			else if @RIGHTS_ADMIN_LEVEL = 3
			begin
			select  DISTINCT( RIGHTS_ROLE ) [Role Name] , 'Rights Allocated To Operator User' [Description] ,RIGHTS_HD_ID [HD],RIGHTS_BR_ID [BR]from RIGHTS where RIGHTS_HD_ID = @RIGHTS_HD_ID
			AND RIGHTS_BR_ID = @RIGHTS_BR_ID and RIGHTS_ADMIN_LEVEL = 4 and RIGHTS_IS_DELETED = 0
			
			
			select ID,[Institute ID],Name,Land_line from V_BRANCH_INFO			
			where [Status] = 'T'  and [Institute ID] = @RIGHTS_HD_ID
			
			
			end
			
			
			
			
			
			
     
     END
   
 
     else if @STATUS = 'X'
     BEGIN     
   			select DISTINCT RIGHTS_ROLE, RIGHTS_ROLE from RIGHTS 
   			where
			RIGHTS_HD_ID = @RIGHTS_HD_ID
			AND @RIGHTS_BR_ID = RIGHTS_BR_ID
			AND  RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
			
			
			
			--select ID,[First Name],[Last Name],[Parent Name],CNIC,Designation,[Status]  from VTEACHER_INFO where [Status] = 'T'  AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.TECH_STATUS [Status]  from USER_INFO U
			join TEACHER_INFO C on U.USER_CODE = C.TECH_ID
			 where U.USER_TYPE = 'Teacher' and U.USER_HD_ID = @RIGHTS_HD_ID and U.USER_BR_ID = @RIGHTS_BR_ID
			
			--select ID,[1st Relation Name],[1ST Relation], [2nd Relation Name],[2nd Relation],[Status]   from VPARENT_INFO where [Status] = 'T' AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.PARNT_STATUS [Status]  from USER_INFO U
			join PARENT_INFO C on U.USER_CODE = C.PARNT_ID
			 where U.USER_TYPE = 'Parent' and U.USER_HD_ID = @RIGHTS_HD_ID and U.USER_BR_ID = @RIGHTS_BR_ID
			
			--select ID,[Student School ID],[Parent ID],[Parent Name],[Class Plan],[Tution Fee],DOB,[Status] from VSTUDENT_INFO where [Status] = 'T' AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.STDNT_STATUS [Status]  from USER_INFO U
			join STUDENT_INFO C on U.USER_CODE = C.STDNT_ID
			 where U.USER_TYPE = 'Student' and U.USER_HD_ID = @RIGHTS_HD_ID and U.USER_BR_ID = @RIGHTS_BR_ID
			

   			
     END
   
   
   
    else if @STATUS = 'T'
     BEGIN     
   			select DISTINCT RIGHTS_ROLE, RIGHTS_ROLE from RIGHTS 
   			where
			RIGHTS_HD_ID = @RIGHTS_HD_ID
			AND @RIGHTS_BR_ID = RIGHTS_BR_ID
			AND  RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
			
			
			
			--select ID,[First Name],[Last Name],[Parent Name],CNIC,Designation,[Status]  from VTEACHER_INFO where [Status] = 'T'  AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.TECH_STATUS [Status]  from USER_INFO U
			join TEACHER_INFO C
			on U.[USER_ID] = C.TECH_USER_INFO_ID			
			where U.USER_TYPE = 'A' and U.USER_HD_ID = @RIGHTS_HD_ID and U.USER_BR_ID = @RIGHTS_BR_ID
			
			
   			
     END
   
   
     if @STATUS = 'A'
     BEGIN
   
   
      SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      where  RIGHTS_HD_ID = @RIGHTS_HD_ID
      AND RIGHTS_BR_ID = @RIGHTS_BR_ID
      and RIGHTS_ROLE = @RIGHTS_ROLE --'rights2' 
      and RIGHTS_ADMIN_LEVEL = @RIGHTS_ADMIN_LEVEL
      --and RIGHTS_STATUS = @RIGHTS_STATUS
      and RIGHTS_IS_DELETED = @RIGHTS_IS_DELETED
     
      --  SELECT RIGHTS_RIGHT_PARENTS_CODE , RIGHTS_RIGHT_CODE ,RIGHTS_RIGHT_TEXT ,RIGHTS_LEVEL ,RIGHTS_RIGHT_NAME , RIGHTS_IS_BUTTON ,RIGHTS_STATUS FROM RIGHTS
      --where  RIGHTS_ROLE = 'C'
   
     END