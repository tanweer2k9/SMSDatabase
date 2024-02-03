
CREATE procedure  [dbo].[sp_RIGHTS_PAGES_selection]
                                               
                                               
     @STATUS char(10),
     @HD_ID numeric,
	 @BR_ID numeric,
	 @LOGIN_ID numeric,
	 @PACKAGE_ID numeric
	 
   
AS BEGIN 


  --   declare @STATUS char(10) = 'B'
  --   declare @HD_ID numeric = 2
	 --declare @BR_ID numeric = 1
	 --declare @LOGIN_ID numeric = 1081
	 --declare @PACKAGE_ID numeric = 4


	if @STATUS = 'L'
	BEGIN
		declare @right_type int = 0
		declare @user_type nvarchar(50) = (select USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID)
		if @user_type = 'A'
		begin		
			declare @user_type_teacher_admin int = (select COUNT(*) from TEACHER_INFO t
												join USER_INFO u on t.TECH_USER_INFO_ID = u.USER_ID and USER_TYPE = 'A' 											
												where u.USER_ID = 10)
				if @user_type_teacher_admin = 1
					set @right_type = 3
				else 
					set @right_type = 2
		end
		
		else if @user_type = 'SA'
			set @right_type = 1
			
			declare @bit_status bit = 1
			declare @bit_status_load bit = 1
			if @right_type = 0 -- IT
			begin
				select distinct (ID), [Page Name], [Page Text], [Page Parent Code], [Page Child Code], @bit_status as [Page Status], @bit_status_load as [Load Status], CAST(0 as bit) Dashboard,Url from VRIGHTS_IT
				
				
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Super Admin' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] = 1
				select ID,[Institute Name] Name,[Short Name],[Institute Level],Branches from VMAIN_HD_INFO 
				where [Status] = 'T'
			end
			else if @right_type = 1 -- Super Admin
			begin				
				select distinct (ID), [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],[Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where [Institute ID] = @HD_ID and [Package Type] = 1 and [Page Status] = 1
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Admin' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] = 2 and [Institute ID] = @HD_ID
				select distinct (ID),[Institute ID],Name,Land_line from V_BRANCH_INFO	
				where [Status] = 'T'  and [Institute ID] = @HD_ID
			end
			else if @right_type = 2 --  Admin
			begin				
				select distinct (ID), [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],[Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where  [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Package Type] = 2  and [Page Status] = 1
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Operator User' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] not in (1,2) and [Institute ID] = @HD_ID and [Branch ID] = @BR_ID
				select 0 as ID, 'Nothing' as Name
			end
			else if @right_type = 3 --  Admin Teacher	
			begin				
				select distinct (ID), [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],[Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where  [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Package Type] = 3 and [Page Status] = 1
				select  DISTINCT( [Package Name] ) [Role Name] , 'Rights Allocated To Operator User' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] not in (1,2,3) 
				select 0 as ID, 'Nothing' as Name
			end	
	END
	
	ELSE IF @STATUS = 'B'
	BEGIN
		set @right_type = 0
		set @user_type = (select USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID)
		if @user_type = 'A'
		begin		
			set @user_type_teacher_admin  = (select COUNT(*) from TEACHER_INFO t
												join USER_INFO u on t.TECH_USER_INFO_ID = u.USER_ID and USER_TYPE = 'A' 											
												where u.USER_ID = @LOGIN_ID)
				if @user_type_teacher_admin = 1
					set @right_type = 3
				else 
					set @right_type = 2
		end
		
		else if @user_type = 'SA'
			set @right_type = 1
			
			
			if @right_type = 0 -- IT
			begin
				
				select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],[Load Status],Dashboard,Url  from VRIGHTS_PAGES 
				where [Package ID] = @PACKAGE_ID and [Load Status] = 1
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Super Admin' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] = 1
				select ID,[Institute Name],[Short Name],[Institute Level],Branches from VMAIN_HD_INFO
				where [Status] = 'T' 
			end
			else if @right_type = 1 -- Super Admin
			begin
				select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status], [Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where [Package ID] = @PACKAGE_ID and [Load Status] = 1
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Admin' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] = 2
				select ID,[Institute ID],Name,Land_line from V_BRANCH_INFO			
				where [Status] = 'T'  and [Institute ID] = @HD_ID
			end
			else if @right_type = 2 --  Admin
			begin
				select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status], [Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where  [Package ID] = @PACKAGE_ID and [Load Status] = 1
				select  [ID], [Package Name] as [Role Name] , 'Rights Allocated To Operator User' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] in (3,4)
				select 0 as ID, 'Nothing' as Name
			end
			else if @right_type = 3 --  Admin Teacher
			begin
				select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status], [Load Status],Dashboard,Url from VRIGHTS_PAGES 
				where [Package ID] = @PACKAGE_ID and [Load Status] = 1
				select  DISTINCT( [ID] ) , [Package Name] as [Role Name] , 'Rights Allocated To Operator User' as [Description],[Institute ID] [HD],
				[Branch ID] [BR] from VRIGHTS_PACKAGES where [Package Type] = 4
				select 0 as ID, 'Nothing' as Name
			end	
	END
	
	 ELSE IF @STATUS = 'T'
     BEGIN     
   			select ID, [Package Name] from VRIGHTS_PACKAGES
   			where
			[Institute ID] = @HD_ID
			AND [Branch ID] = @BR_ID
			AND  [Package Type] not in (1,2)
			
			
			
			--select ID,[First Name],[Last Name],[Parent Name],CNIC,Designation,[Status]  from VTEACHER_INFO where [Status] = 'T'  AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.TECH_STATUS [Status]  from USER_INFO U
			join TEACHER_INFO C
			on U.[USER_ID] = C.TECH_USER_INFO_ID			
			where U.USER_TYPE in ('A','SA','Director') and U.USER_HD_ID = @HD_ID and U.USER_BR_ID = @BR_ID
			
			
   			
     END
     
	else if @STATUS = 'X'
     BEGIN     
   			select ID, [Package Name] from VRIGHTS_PACKAGES
   			where
			
			[Branch ID]  = @BR_ID
			AND  [Package Type] not in (1,2)
			
			declare @SessionId numeric = (select b.BR_ADM_SESSION from BR_ADMIN b where BR_ADM_ID = @BR_ID)
			
			--select ID,[First Name],[Last Name],[Parent Name],CNIC,Designation,[Status]  from VTEACHER_INFO where [Status] = 'T'  AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], 
			CAST((SELECT sp.CLASS_Name + ', ' AS 'data()' FROM SCHOOL_PLANE sp where sp.CLASS_TEACHER = c.TECH_ID and sp.CLASS_SESSION_ID = @SessionId FOR XML PATH('')) as nvarchar(MAX)) as [Class Teacher],
			U.USER_STATUS [Allow Login],C.TECH_STATUS [Status],c.TECH_EMAIL  from USER_INFO U
			join TEACHER_INFO C on U.USER_CODE = C.TECH_ID
			--left join SCHOOL_PLANE sp on sp.CLASS_TEACHER = c.TECH_ID and sp.CLASS_SESSION_ID = @SessionId
			 where U.USER_TYPE = 'Teacher' and U.USER_HD_ID = @HD_ID and U.USER_BR_ID = @BR_ID and c.TECH_STATUS = 'T'
			
			--select ID,[1st Relation Name],[1ST Relation], [2nd Relation Name],[2nd Relation],[Status]   from VPARENT_INFO where [Status] = 'T' AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			--select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.PARNT_STATUS [Status], s.STDNT_SCHOOL_ID [Std#], (s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as [Student Name]  from USER_INFO U
			--join PARENT_INFO C on U.USER_CODE = C.PARNT_ID
			--join STUDENT_INFO s on s.STDNT_PARANT_ID =  c.PARNT_ID
			-- where U.USER_TYPE = 'Parent' and s.STDNT_HD_ID = @HD_ID and s.STDNT_BR_ID = @BR_ID


			 --select ID,[1st Relation Name],[1ST Relation], [2nd Relation Name],[2nd Relation],[Status]   from VPARENT_INFO where [Status] = 'T' AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by B.ID) SR#,* from
			(select distinct ID, [User ID], [User Name], [Display Name], Password, [Rights Role], [Allow Login], Status,ParentMobile,ParentEmail,Std#,[Student Name],Class  from
			(select U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.PARNT_STATUS [Status], c.PARNT_CELL_NO ParentMobile, c.PARNT_EMAIL ParentEmail,
			CAST((SELECT STDNT_SCHOOL_ID + ', ' AS 'data()' FROM STUDENT_INFO where STDNT_PARANT_ID = c.PARNT_ID  FOR XML PATH('')) as nvarchar(MAX)) as [Std#],
			CAST((SELECT STDNT_FIRST_NAME + ', ' AS 'data()' FROM STUDENT_INFO where STDNT_PARANT_ID = c.PARNT_ID  FOR XML PATH('')) as nvarchar(MAX)) as [Student Name] ,
			CAST((SELECT sp.CLASS_Name + ', ' AS 'data()' FROM STUDENT_INFO s join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID where STDNT_PARANT_ID = c.PARNT_ID  FOR XML PATH('')) as nvarchar(MAX)) as [Class] 
			  from USER_INFO U
			join PARENT_INFO C on U.USER_CODE = C.PARNT_ID
			join STUDENT_INFO s on s.STDNT_PARANT_ID =  c.PARNT_ID and s.STDNT_STATUS = 'T' and (c.PARNT_BR_ID = @BR_ID OR s.STDNT_BR_ID = @BR_ID)
			 where U.USER_TYPE = 'Parent'  and u.USER_BR_ID  in (select COMBINE_BRANCHES_ID from COMBINE_BRANCHES where FROM_BRANCH_ID = @BR_ID)
			 )A where [Student Name] is not null 
			 )B
			
			--select ID,[Student School ID],[Parent ID],[Parent Name],[Class Plan],[Tution Fee],DOB,[Status] from VSTUDENT_INFO where [Status] = 'T' AND [Institute ID] = @RIGHTS_HD_ID AND [Branch ID] = @RIGHTS_BR_ID
			select ROW_NUMBER () Over (Order by U.[USER_ID]) SR#, U.[USER_ID] ID, U.[USER_CODE] [User ID],U.[USER_NAME] [User Name],U.USER_DISPLAY_NAME [Display Name],s.CLASS_Name Class,U.USER_PASSWORD [Password],U.USER_ROLE [Rights Role], U.USER_STATUS [Allow Login],C.STDNT_STATUS [Status]  from USER_INFO U
			join STUDENT_INFO C on U.USER_CODE = C.STDNT_ID
			join SCHOOL_PLANE s on s.CLASS_ID = c.STDNT_CLASS_PLANE_ID			
			 where U.USER_TYPE = 'Student' and U.USER_HD_ID = @HD_ID and U.USER_BR_ID = @BR_ID  and c.STDNT_STATUS = 'T'

			 order by CLASS_ID
			
     END
     
     ELSE IF @STATUS = 'A'
     BEGIN
   
   set @user_type = (select USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID)
	if @user_type = 'IT'
	begin
		set @bit_status = 1
		select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code], @bit_status as [Page Status],'' Dashboard,Url,Color,Icon from VRIGHTS_IT
				
		
		
	end
	else if @user_type = 'SA'
	begin
			select DISTINCT (ID), [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],Dashboard,Url,Color,Icon  from VRIGHTS_PAGES 
			where [Institute ID] = @HD_ID and [Package ID] = @PACKAGE_ID   
	end

	else
	
	select ID, [Page Name], [Page Text], [Page Parent Code], [Page Child Code],[Page Status],Dashboard,Url,Color,Icon  from VRIGHTS_PAGES 
	where  [Package ID] = @PACKAGE_ID   

     END  

END