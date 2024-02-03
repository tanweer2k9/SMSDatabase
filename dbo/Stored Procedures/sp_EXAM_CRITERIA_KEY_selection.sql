

CREATE procedure  [dbo].[sp_EXAM_CRITERIA_KEY_selection]
                                               
                                               
     @STATUS char(10),     
	 @HD_ID numeric,
	 @BR_ID numeric,
     @CLASS_ID numeric,
	 @CRITERIA_KEY_STD_ID numeric,
	 @USER_PK_ID numeric, 
	 @SessionId numeric,
	 @PID numeric,
	 @Title nvarchar(500)

     AS BEGIN 
	




	

	 --declare @STATUS char(10) = 'L',     
	 --@HD_ID numeric = 2,
	 --@BR_ID numeric = 3,
  --   @CLASS_ID numeric = 0,
	 --@CRITERIA_KEY_STD_ID numeric = 0,
	 --	 @USER_PK_ID numeric = 181252




	 declare @tblEXAM_CRITERIA_KEY table ([CRITERIA_KEY_ID] [numeric](18, 0),
	[CRITERIA_KEY_STD_ID] [numeric](18, 0) NULL,
	[CRITERIA_KEY_CAT_CRITERIA_ID] [numeric](18, 0) NULL,
	[CRITERIA_KEY] [nvarchar](15) NULL,
	[CRITERIA_KEY_PRINCIPAL] [nvarchar](15) NULL,
	[CRITERIA_KEY_TERM_ID] [numeric](18, 0) NULL,
	[CRITERIA_KEY_CLASS_ID] [numeric](18, 0) NULL,
	[CRITERIA_KEY_PID] [numeric](18, 0) NULL)


insert into @tblEXAM_CRITERIA_KEY
select e.* from EXAM_CRITERIA_KEY e with (nolock)
join SCHOOL_PLANE sp on sp.CLASS_ID = e.CRITERIA_KEY_CLASS_ID
where sp.CLASS_SESSION_ID = @SessionId





			declare @user_type nvarchar(50) = 0
			declare @user_id numeric = 0
			declare @is_admin_enter_marks bit = 0
			declare @is_class_teacher bit = 0


			declare @one int = 1


			set @is_admin_enter_marks = (select BR_ADM_IS_ENTER_MARKS from BR_ADMIN where BR_ADM_ID = @BR_ID)

			select @user_id = USER_CODE, @user_type = USER_TYPE from USER_INFO where USER_ID = @USER_PK_ID
			declare @count_exam_assessment_principal int = 0
			set @count_exam_assessment_principal = (select COUNT(*) from EXAM_APPROVAL_SETTINGS 
			where APPROVAL_HD_ID = @HD_ID and APPROVAL_BR_ID = @BR_ID and APPROVAL_STATUS = 'E' and APPROVAL_DESIGNATION = 'Principal Exam Assessment' and APPROVAL_STAFF_ID = @user_id)

			


			declare @tbl table ([Main Sub Cat ID] numeric,[Main Category] nvarchar(100), [Sub Category] nvarchar(100), [Criteria Assess] nvarchar(300), [Cat ID] numeric, [Criteria ID] numeric, [Term Rank] nvarchar(10),  [Criteria Teacehr Key] char(1), [Criteria Principal Key] char(1))
			declare @tbl_update table ([Main Sub Cat ID] numeric,[Main Category] nvarchar(100), [Sub Category] nvarchar(100), [Criteria Assess] nvarchar(300), [Cat ID] numeric, [Criteria ID] numeric, [Term Rank] nvarchar(10), [Criteria Teacehr Key] char(1), [Criteria Principal Key] char(1))
			if @CLASS_ID = 0
			BEGIN

				if @count_exam_assessment_principal = 1 or (@user_type in ('A','SA') and @is_admin_enter_marks = 1)
				BEGIN
					set @CLASS_ID = (select top(@one) ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID and [Status] ='T' and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e)  and [Session Id] = @SessionId and [Level] = 1 order by [Order]) 
				
				END
				ELSE 
				BEGIN 
					set @CLASS_ID = (select top(@one) ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID and [Status] ='T' and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e) and [Class Teacher ID] = @user_id  and [Session Id] = @SessionId and [Level] = 1 order by [Order]	)				
				END

				
			END

				--Set PID if Title is empty and on page load
				if @Title = ''
				BEGIN
					set @PID = (select top(@one) Id from EXAM_CRITERIA_KEY_Parent where SessionId =@SessionId order by Id desc)
				END
				ELSE
				BEGIN				
					set @PID = (select Id from EXAM_CRITERIA_KEY_Parent where SessionId = @SessionId and Title = @Title and BrId =@BR_ID)	
				END
			
			
		
			if (select COUNT(*) from VSCHOOL_PLANE where [Class Teacher ID] = @user_id and ID =  @CLASS_ID) = 1
			BEGIN
				set @is_class_teacher = 1
			END

			
			

			if @count_exam_assessment_principal = 1 or (@user_type in ('A','SA') and @is_admin_enter_marks = 1)
			BEGIN
					--select *,(select COUNT(*) from EXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID and (e.CRITERIA_KEY_PRINCIPAL is not null OR @is_admin_enter_marks = 1 )) as CountApproved

					select s.ID,[Institute ID],[Branch ID],[Std. School ID], Class,[First Name],[Last Name],CASE WHEN A.CRITERIA_KEY_STD_ID is NULL THEN CAST(0 as bit) ELSE CAST(1 as bit) END IsProcessed, [Father's Name],[Father Cell #],[Family Code],House,DOA,DOB,CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, Area, City,[Father Address] , (select COUNT(*) from @tblEXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID ) as CountApproved,[Status] from VSTUDENT_SELECTION s 
					left join (select distinct CRITERIA_KEY_STD_ID from @tblEXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @CLASS_ID  and CRITERIA_KEY_PID = @PID)A on A.CRITERIA_KEY_STD_ID = s.ID
					left join tblStudentClassPlan c on c.StudentId = s.ID and c.SessionId = @SessionId
					--left join EXAM_STD_INFO es on es.EXAM_STD_INFO_STD_ID = s. Created and Updated By
					where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T' and c.ClassId = @CLASS_ID and s.[SessionId] = @SessionId order by CAST(s.[Std. School ID] as bigint)


					--select s.ID,[Institute ID],[Branch ID],[Std. School ID], Class,[First Name],[Last Name],CASE WHEN A.CRITERIA_KEY_STD_ID is NULL THEN CAST(0 as bit) ELSE CAST(1 as bit) END IsProcessed, [Father's Name],[Father Cell #],[Family Code],House,DOA,DOB,CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, Area, City,[Father Address] , (select COUNT(*) from EXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID ) as CountApproved,[Status] from VSTUDENT_SELECTION s 
					
					--left join (select distinct CRITERIA_KEY_STD_ID from EXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @CLASS_ID and CRITERIA_KEY_PID = @PID )A on A.CRITERIA_KEY_STD_ID = s.ID
					--join tblStudentClassPlan c on c.StudentId = s.ID and c.SessionId = @SessionId 
					----left join EXAM_STD_INFO es on es.EXAM_STD_INFO_STD_ID = s. Created and Updated By
					--where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T'  and c.ClassId = @CLASS_ID and s.[Session Id] = @SessionId order by CAST(s.[Std. School ID] as bigint)

					select ID, Name, [Class Teacher],Class from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID	and [Status] ='T'
					and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e) and [Session Id] = @SessionId and [Level] = 1 order by [Order]
			END

			ELSE if @user_type = 'Teacher' or @is_class_teacher = 1
			BEGIN
					select ID,[Institute ID],[Branch ID],[Std. School ID], Class,[First Name],[Last Name],CASE WHEN A.CRITERIA_KEY_STD_ID is NULL THEN CAST(0 as bit) ELSE CAST(1 as bit) END IsProcessed, [Father's Name],[Father Cell #],[Family Code],House,DOA,DOB,CASE WHEN Gender = 1 THEN 'Male' ELSE 'Female' END Gender, Area, City,[Father Address] , (select COUNT(*) from @tblEXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID ) as CountApproved,[Status] from VSTUDENT_SELECTION s 
					left join (select distinct CRITERIA_KEY_STD_ID from @tblEXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @CLASS_ID and CRITERIA_KEY_PID = @PID)A on A.CRITERIA_KEY_STD_ID = ID
					where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T' and [Class ID] = @CLASS_ID and [SessionId] = @SessionId order by CAST(s.[Std. School ID] as bigint)

					select ID, Name, [Class Teacher],Class from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID	and [Status] ='T'
					and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e) and [Class Teacher ID] = @user_id and [Session Id] = @SessionId and [Level] = 1 order by [Order]
			END

			ELSE   
			BEGIN

				if @user_type = 'Student'
				BEGIN
					select * from VSTUDENT_SELECTION where ID = @user_id  and [SessionId] = @SessionId
					select ID, Name, [Class Teacher] from VSCHOOL_PLANE where ID in (select [Class ID] from VSTUDENT_SELECTION where ID = @user_id ) and [Session Id] = @SessionId and [Level] = 1 order by [Order]
				END
				ELSE IF @user_type = 'Parent'
				BEGIN
					select * from VSTUDENT_SELECTION where [Parent ID] = @user_id and [SessionId] = @SessionId
					select ID, Name, [Class Teacher] from VSCHOOL_PLANE where ID in (select [Class ID] from VSTUDENT_SELECTION where [Parent ID] = @user_id ) and [Session Id] = @SessionId and [Level] = 1 order by [Order]
				END


				
			END
			
				

				

		 if @STATUS = 'L'
		 BEGIN

				
				if (select COUNT(*) from @tblEXAM_CRITERIA_KEY where CRITERIA_KEY_PID = @PID and CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID and CRITERIA_KEY_CLASS_ID = @CLASS_ID ) = 0
				BEGIN
					set @PID =  (select top(@one) Id from (select distinct Id from @tblEXAM_CRITERIA_KEY e
									join  EXAM_CRITERIA_KEY_Parent p on p.Id = e.CRITERIA_KEY_PID where  SessionId = @SessionId and BrId = @BR_ID and CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID
									
									)A order by Id desc)
				END
   
				insert into @tbl
				select distinct [Main Sub Cat ID],C.[Main Category], CASE WHEN c.[Sub Category] is NULL THEN '-' ELSE c.[Sub Category] END [Sub Category], C.[Criteria Assess], C.[Cat ID], C.[Criteria ID],
				'T' + CAST(t.TERM_ASSESS_RANK as nvarchar(10)) [Term Rank],'X','X'
				--,t.TERM_ID [Term ID], t.TERM_NAME [Term]
				 from TERM_ASSESSMENT_INFO t
				cross join
				(
				select [Main Sub Cat ID],eck.CRITERIA_KEY_ID ID, ecc.CAT_CRITERIA_ID [Criteria ID],ecc.CAT_CRITERIA_NAME [Criteria Assess], [Main Category], [Sub Category], [Cat ID]
				 from @tblEXAM_CRITERIA_KEY eck
				RIGHT join EXAM_CATEGORY_CRITERIA ecc on ecc.CAT_CRITERIA_ID = eck.CRITERIA_KEY_CAT_CRITERIA_ID

				join

				(select [Main Sub Cat ID],CASE WHEN [Sub Cat ID] is Null THEN [Main Cat ID] ELSE [Sub Cat ID] END [Cat ID], [Main Category], [Sub Category]   from 
				(select ea2.EXAM_CAT_MAIN_CAT_ID [Main Sub Cat ID],ea1.EXAM_CAT_ID  [Main Cat ID],ea2.EXAM_CAT_ID[Sub Cat ID],ea1.EXAM_CAT_NAME [Main Category], ea2.EXAM_CAT_NAME [Sub Category] from 
				EXAM_ASSESS_CATEGORY_INFO ea1
				left join EXAM_ASSESS_CATEGORY_INFO ea2 on ea2.EXAM_CAT_MAIN_CAT_ID = ea1.EXAM_CAT_ID and ea2.EXAM_CAT_STATUS = 'T' and ea2.EXAM_CAT_CLASS_ID = @CLASS_ID
				where ea1.EXAM_CAT_MAIN_CAT_ID = -1 and ea1.EXAM_CAT_STATUS = 'T'and ea1.EXAM_CAT_HD_ID =@HD_ID and ea1.EXAM_CAT_BR_ID = @BR_ID 
				and ea1.EXAM_CAT_CLASS_ID = @CLASS_ID 
				)A)B on B.[Cat ID] = ecc.CAT_CRITERIA_EXAM_CAT_ID
				where ecc.CAT_CRITERIA_STATUS = 'T' and ecc.CAT_CRITERIA_HD_ID = @HD_ID and ecc.CAT_CRITERIA_BR_ID = @BR_ID)C
				where t.TERM_ASSESS_HD_ID = @HD_ID and t.TERM_ASSESS_BR_ID = @BR_ID and t.TERM_ASSESS_STATUS = 'T'
				and t.TERM_ASSESS_START_DATE < GETDATE()


				insert into @tbl_update
				select [Main Sub Cat ID],[Main Category], CASE WHEN [Sub Category] is null THEN '-' ELSE [Sub Category] END [Sub Category] ,ecc.CAT_CRITERIA_NAME [Criteria Assess], 
				[Cat ID], ecc.CAT_CRITERIA_ID [Criteria ID],'T' + CAST(t.TERM_ASSESS_RANK as nvarchar(10)) [Term ID], eck.CRITERIA_KEY, 
				CASE WHEN eck.CRITERIA_KEY_PRINCIPAL is null or eck.CRITERIA_KEY_PRINCIPAL = '' THEN eck.CRITERIA_KEY ELSE eck.CRITERIA_KEY_PRINCIPAL END  from @tblEXAM_CRITERIA_KEY eck
				join EXAM_CATEGORY_CRITERIA ecc on ecc.CAT_CRITERIA_ID = eck.CRITERIA_KEY_CAT_CRITERIA_ID
				join
				(select [Main Sub Cat ID],CASE WHEN [Sub Cat ID] is Null THEN [Main Cat ID] ELSE [Sub Cat ID] END [Cat ID], [Main Category], [Sub Category]   from 
				(select ea2.EXAM_CAT_MAIN_CAT_ID [Main Sub Cat ID],ea1.EXAM_CAT_ID  [Main Cat ID],ea2.EXAM_CAT_ID[Sub Cat ID],ea1.EXAM_CAT_NAME [Main Category], ea2.EXAM_CAT_NAME [Sub Category] from 
				EXAM_ASSESS_CATEGORY_INFO ea1
				left join EXAM_ASSESS_CATEGORY_INFO ea2 on ea2.EXAM_CAT_MAIN_CAT_ID = ea1.EXAM_CAT_ID and ea2.EXAM_CAT_STATUS = 'T' and ea2.EXAM_CAT_CLASS_ID = @CLASS_ID
				where ea1.EXAM_CAT_MAIN_CAT_ID = -1 and ea1.EXAM_CAT_STATUS = 'T'and ea1.EXAM_CAT_HD_ID =@HD_ID and ea1.EXAM_CAT_BR_ID = @BR_ID 
				and ea1.EXAM_CAT_CLASS_ID = @CLASS_ID 
				)A)B on B.[Cat ID] = ecc.CAT_CRITERIA_EXAM_CAT_ID				
				join TERM_ASSESSMENT_INFO t on t.TERM_ASSESS_ID = eck.CRITERIA_KEY_TERM_ID
				where ecc.CAT_CRITERIA_STATUS = 'T' and ecc.CAT_CRITERIA_HD_ID = @HD_ID and ecc.CAT_CRITERIA_BR_ID = @BR_ID and eck.CRITERIA_KEY_PID = @PID
				and eck.CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID and t.TERM_ASSESS_START_DATE < GETDATE()

				
				declare @terms_count int = 0
				
				set @terms_count = 
				(select COUNT(*) from TERM_ASSESSMENT_INFO where TERM_ASSESS_HD_ID = @HD_ID and TERM_ASSESS_BR_ID = @BR_ID and TERM_ASSESS_STATUS = 'T' 
				and TERM_ASSESS_START_DATE < GETDATE() and TERM_ASSESS_ID not in 
				  (select distinct CRITERIA_KEY_TERM_ID from @tblEXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @CLASS_ID and CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID))
				  
				  

				insert into @tbl_update

				select * from @tbl 
				where [Term Rank] not in (select [Term Rank] from @tbl_update)
				union
				select * from @tbl 
				where [Criteria ID] not in (select [Criteria ID] from @tbl_update)


				select ROW_NUMBER() over(order by [Main Sub Cat ID], [Criteria ID]) as ID,* from (select [Main Category], [Sub Category], [Criteria Assess], [Cat ID], [Criteria ID],[Main Sub Cat ID],
				CASE WHEN [Key Type] = 'Criteria Teacehr Key' THEN 'T' + [Term Rank] ELSE [Term Rank] END [Term Rank], Keys  from
				(
				select * from @tbl_update
				unpivot ([Keys] FOR [Key Type] IN ([Criteria Teacehr Key], [Criteria Principal Key])) as final_unpivot
				)A)B

				pivot (MAX([Keys]) FOR [Term Rank] IN ([T1], [T2],[T3],[T4],[T5],[T6],[T7],[T8],[TT1], [TT2],[TT3],[TT4],[TT5],[TT6],[TT7],[TT8])

				) as final_tbl order by [Main Sub Cat ID],[Criteria ID]
				--TT1 are Teachers numbers
				select ID, Name, [Rank] from VTERM_ASSESSMENT_INFO where [Institute ID] = @HD_ID and [Branch ID] =  @BR_ID 
				and [Start Date] < GETDATE() and Status = 'T'
				order by [Rank]

				select * from VEXAM_STD_INFO where [Class ID] = @CLASS_ID and [Std ID] = @CRITERIA_KEY_STD_ID and PID = @PID

				declare @insert_update nvarchar(50) = ''
				
				if @terms_count = 0
				BEGIN 
					set @insert_update = 'Update'
				END
				ELSE
				BEGIN
					set @insert_update = 'Insert'
				END


				if @count_exam_assessment_principal = 0
					
					Select 'Teacher', @insert_update,CRITERIA_KEY_TERM_ID term_id, Sum(Case When CRITERIA_KEY_PRINCIPAL IS Not NULL Then 1  Else 0
 End)  principal_entered_count, Sum(Case When CRITERIA_KEY_PRINCIPAL Is NULL Then 1 Else 0 End) principal_not_entered_count, Count(1) total From @tblEXAM_CRITERIA_KEY where CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID group by CRITERIA_KEY_TERM_ID
					--select (select COUNT(*) from EXAM_CRITERIA_KEY e where CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID and e.CRITERIA_KEY_PRINCIPAL is null) as [PrincipalNullCount]
				ELSE
					select 'Principal', @insert_update --Pricipal Can Insert After the Teacehr can insert. means @insert_update = 'Update' for principal it is update

				



					

		 END

		 select Id,Title from EXAM_CRITERIA_KEY_Parent where SessionId =@SessionId order by Id desc













	

	 ----declare @STATUS char(10) = 'L',     
	 ----@HD_ID numeric = 2,
	 ----@BR_ID numeric = 1,
  ----   @CLASS_ID numeric = 0,
	 ----@CRITERIA_KEY_STD_ID numeric = 585,
	 ----	 @USER_PK_ID numeric = 464

		--	declare @user_type nvarchar(50) = 0
		--	declare @user_id numeric = 0
		--	declare @is_admin_enter_marks bit = 0
		--	declare @is_class_teacher bit = 0

		--	set @is_admin_enter_marks = (select BR_ADM_IS_ENTER_MARKS from BR_ADMIN where BR_ADM_ID = @BR_ID)

		--	select @user_id = USER_CODE, @user_type = USER_TYPE from USER_INFO where USER_ID = @USER_PK_ID
		--	declare @count_exam_assessment_principal int = 0
		--	set @count_exam_assessment_principal = (select COUNT(*) from EXAM_APPROVAL_SETTINGS 
		--	where APPROVAL_HD_ID = @HD_ID and APPROVAL_BR_ID = @BR_ID and APPROVAL_STATUS = 'E' and APPROVAL_DESIGNATION = 'Principal Exam Assessment' and APPROVAL_STAFF_ID = @user_id)


		--	declare @tbl table ([Main Category] nvarchar(100), [Sub Category] nvarchar(100), [Criteria Assess] nvarchar(300), [Cat ID] numeric, [Criteria ID] numeric, [Term Rank] nvarchar(10),  [Criteria Teacehr Key] char(1), [Criteria Principal Key] char(1))
		--	declare @tbl_update table ([Main Category] nvarchar(100), [Sub Category] nvarchar(100), [Criteria Assess] nvarchar(300), [Cat ID] numeric, [Criteria ID] numeric, [Term Rank] nvarchar(10), [Criteria Teacehr Key] char(1), [Criteria Principal Key] char(1))
		--	if @CLASS_ID = 0
		--	BEGIN

		--		if @count_exam_assessment_principal = 1 or (@user_type in ('A','SA') and @is_admin_enter_marks = 1)
		--		BEGIN
		--			set @CLASS_ID = (select top(1) ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID and [Status] ='T' and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e))
				
		--		END
		--		ELSE 
		--		BEGIN 
		--			set @CLASS_ID = (select top(1) ID from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID and [Status] ='T' and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e) and [Class Teacher ID] = @user_id)					
		--		END
		--	END


		--	if (select COUNT(*) from VSCHOOL_PLANE where [Class Teacher ID] = @user_id and ID =  @CLASS_ID) = 1
		--	BEGIN
		--		set @is_class_teacher = 1
		--	END




		--	if @count_exam_assessment_principal = 1 or (@user_type in ('A','SA') and @is_admin_enter_marks = 1)
		--	BEGIN
		--			select *,(select COUNT(*) from EXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID and (e.CRITERIA_KEY_PRINCIPAL is not null OR @is_admin_enter_marks = 1 )) as CountApproved
		--			from VSTUDENT_SELECTION s where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T' and [Class ID] = @CLASS_ID

		--			select ID, Name, [Class Teacher] from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID	and [Status] ='T'
		--			and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e)
		--	END

		--	ELSE if @user_type = 'Teacher' or @is_class_teacher = 1
		--	BEGIN
		--			select *,(select COUNT(*) from EXAM_CRITERIA_KEY e where e.CRITERIA_KEY_STD_ID = s.ID and (e.CRITERIA_KEY_PRINCIPAL is not null OR @is_admin_enter_marks = 1 )) as CountApproved from VSTUDENT_SELECTION s where [Institute ID] = @HD_ID and [Branch ID] = @BR_ID and [Status] = 'T' and [Class ID] = @CLASS_ID

		--			select ID, Name, [Class Teacher] from VSCHOOL_PLANE where [Institute ID] = @HD_ID and  [Branch ID] = @BR_ID	and [Status] ='T'
		--			and ID in (select e.EXAM_CAT_CLASS_ID from EXAM_ASSESS_CATEGORY_INFO e) and [Class Teacher ID] = @user_id
		--	END

		--	ELSE
		--	BEGIN
		--		select * from VSTUDENT_SELECTION where ID is null

		--			select ID, Name, [Class Teacher] from VSCHOOL_PLANE where ID is null
		--	END
			
				

				

		-- if @STATUS = 'L'
		-- BEGIN

				

   
		--		insert into @tbl
		--		select C.[Main Category], CASE WHEN c.[Sub Category] is NULL THEN '-' ELSE c.[Sub Category] END [Sub Category], C.[Criteria Assess], C.[Cat ID], C.[Criteria ID],
		--		'T' + CAST(t.TERM_ASSESS_RANK as nvarchar(10)) [Term Rank],'X','X'
		--		--,t.TERM_ID [Term ID], t.TERM_NAME [Term]
		--		 from TERM_ASSESSMENT_INFO t
		--		cross join
		--		(
		--		select eck.CRITERIA_KEY_ID ID, ecc.CAT_CRITERIA_ID [Criteria ID],ecc.CAT_CRITERIA_NAME [Criteria Assess], [Main Category], [Sub Category], [Cat ID]
		--		 from EXAM_CRITERIA_KEY eck
		--		RIGHT join EXAM_CATEGORY_CRITERIA ecc on ecc.CAT_CRITERIA_ID = eck.CRITERIA_KEY_CAT_CRITERIA_ID

		--		join

		--		(select CASE WHEN [Sub Cat ID] is Null THEN [Main Cat ID] ELSE [Sub Cat ID] END [Cat ID], [Main Category], [Sub Category]   from 
		--		(select ea1.EXAM_CAT_ID  [Main Cat ID],ea2.EXAM_CAT_ID[Sub Cat ID],ea1.EXAM_CAT_NAME [Main Category], ea2.EXAM_CAT_NAME [Sub Category] from 
		--		EXAM_ASSESS_CATEGORY_INFO ea1
		--		left join EXAM_ASSESS_CATEGORY_INFO ea2 on ea2.EXAM_CAT_MAIN_CAT_ID = ea1.EXAM_CAT_ID and ea2.EXAM_CAT_STATUS = 'T' and ea2.EXAM_CAT_CLASS_ID = @CLASS_ID
		--		where ea1.EXAM_CAT_MAIN_CAT_ID = -1 and ea1.EXAM_CAT_STATUS = 'T'and ea1.EXAM_CAT_HD_ID =@HD_ID and ea1.EXAM_CAT_BR_ID = @BR_ID 
		--		and ea1.EXAM_CAT_CLASS_ID = @CLASS_ID 
		--		)A)B on B.[Cat ID] = ecc.CAT_CRITERIA_EXAM_CAT_ID
		--		where ecc.CAT_CRITERIA_STATUS = 'T' and ecc.CAT_CRITERIA_HD_ID = @HD_ID and ecc.CAT_CRITERIA_BR_ID = @BR_ID)C
		--		where t.TERM_ASSESS_HD_ID = @HD_ID and t.TERM_ASSESS_BR_ID = @BR_ID and t.TERM_ASSESS_STATUS = 'T'
		--		and t.TERM_ASSESS_START_DATE < GETDATE()


		--		insert into @tbl_update
		--		select [Main Category], CASE WHEN [Sub Category] is null THEN '-' ELSE [Sub Category] END [Sub Category] ,ecc.CAT_CRITERIA_NAME [Criteria Assess], 
		--		[Cat ID], ecc.CAT_CRITERIA_ID [Criteria ID],'T' + CAST(t.TERM_ASSESS_RANK as nvarchar(10)) [Term ID], eck.CRITERIA_KEY, 
		--		CASE WHEN eck.CRITERIA_KEY_PRINCIPAL is null or eck.CRITERIA_KEY_PRINCIPAL = '' THEN eck.CRITERIA_KEY ELSE eck.CRITERIA_KEY_PRINCIPAL END  from EXAM_CRITERIA_KEY eck
		--		join EXAM_CATEGORY_CRITERIA ecc on ecc.CAT_CRITERIA_ID = eck.CRITERIA_KEY_CAT_CRITERIA_ID
		--		join
		--		(select CASE WHEN [Sub Cat ID] is Null THEN [Main Cat ID] ELSE [Sub Cat ID] END [Cat ID], [Main Category], [Sub Category]   from 
		--		(select ea1.EXAM_CAT_ID  [Main Cat ID],ea2.EXAM_CAT_ID[Sub Cat ID],ea1.EXAM_CAT_NAME [Main Category], ea2.EXAM_CAT_NAME [Sub Category] from 
		--		EXAM_ASSESS_CATEGORY_INFO ea1
		--		left join EXAM_ASSESS_CATEGORY_INFO ea2 on ea2.EXAM_CAT_MAIN_CAT_ID = ea1.EXAM_CAT_ID and ea2.EXAM_CAT_STATUS = 'T' and ea2.EXAM_CAT_CLASS_ID = @CLASS_ID
		--		where ea1.EXAM_CAT_MAIN_CAT_ID = -1 and ea1.EXAM_CAT_STATUS = 'T'and ea1.EXAM_CAT_HD_ID =@HD_ID and ea1.EXAM_CAT_BR_ID = @BR_ID 
		--		and ea1.EXAM_CAT_CLASS_ID = @CLASS_ID 
		--		)A)B on B.[Cat ID] = ecc.CAT_CRITERIA_EXAM_CAT_ID				
		--		join TERM_ASSESSMENT_INFO t on t.TERM_ASSESS_ID = eck.CRITERIA_KEY_TERM_ID
		--		where ecc.CAT_CRITERIA_STATUS = 'T' and ecc.CAT_CRITERIA_HD_ID = @HD_ID and ecc.CAT_CRITERIA_BR_ID = @BR_ID
		--		and eck.CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID and t.TERM_ASSESS_START_DATE < GETDATE()

				
		--		declare @terms_count int = 0
				
		--		set @terms_count = 
		--		(select COUNT(*) from TERM_ASSESSMENT_INFO where TERM_ASSESS_HD_ID = @HD_ID and TERM_ASSESS_BR_ID = @BR_ID and TERM_ASSESS_STATUS = 'T' 
		--		and TERM_ASSESS_START_DATE < GETDATE() and TERM_ASSESS_ID not in 
		--		  (select distinct CRITERIA_KEY_TERM_ID from EXAM_CRITERIA_KEY where CRITERIA_KEY_CLASS_ID = @CLASS_ID and CRITERIA_KEY_STD_ID = @CRITERIA_KEY_STD_ID))
				  
				  

		--		insert into @tbl_update

		--		select * from @tbl 
		--		where [Term Rank] not in (select [Term Rank] from @tbl_update)
		--		union
		--		select * from @tbl 
		--		where [Criteria ID] not in (select [Criteria ID] from @tbl_update)


		--		select ROW_NUMBER() over(order by [Cat ID]) as ID,* from (select [Main Category], [Sub Category], [Criteria Assess], [Cat ID], [Criteria ID], 
		--		CASE WHEN [Key Type] = 'Criteria Teacehr Key' THEN 'T' + [Term Rank] ELSE [Term Rank] END [Term Rank], Keys  from
		--		(
		--		select * from @tbl_update
		--		unpivot ([Keys] FOR [Key Type] IN ([Criteria Teacehr Key], [Criteria Principal Key])) as final_unpivot
		--		)A)B

		--		pivot (MAX([Keys]) FOR [Term Rank] IN ([T1], [T2],[T3],[T4],[T5],[T6],[T7],[T8],[TT1], [TT2],[TT3],[TT4],[TT5],[TT6],[TT7],[TT8])

		--		) as final_tbl order by [Cat ID]
		--		--TT1 are Teachers numbers
		--		select ID, Name, [Rank] from VTERM_ASSESSMENT_INFO where [Institute ID] = @HD_ID and [Branch ID] =  @BR_ID 
		--		and [Start Date] < GETDATE() and Status = 'T'
		--		order by [Rank]

		--		select * from VEXAM_STD_INFO where [Class ID] = @CLASS_ID and [Std ID] = @CRITERIA_KEY_STD_ID

		--		declare @insert_update nvarchar(50) = ''
				
		--		if @terms_count = 0
		--		BEGIN 
		--			set @insert_update = 'Update'
		--		END
		--		ELSE
		--		BEGIN
		--			set @insert_update = 'Insert'
		--		END


		--		if @count_exam_assessment_principal = 0
					
		--			select 'Teacher', @insert_update
		--		ELSE
		--			select 'Principal', @insert_update --Pricipal Can Insert After the Teacehr can insert. means @insert_update = 'Update' for principal it is update

		-- END

     END