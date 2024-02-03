
CREATE procedure  [dbo].[sp_EXAM_ENTRY_selection]
     
     @EXAM_ENTRY_HD_ID  numeric,
     @EXAM_ENTRY_BR_ID  numeric,     
     @EXAM_ENTRY_CLASS_ID  numeric,	
     @EXAM_ENTRY_TERM_ID  numeric,
     @EXAM_ENTRY_SUBJECT_ID  numeric,
     @EXAM_ENTRY_EXAM_TYPE nvarchar(100),
     @EXAM_ENTRY_EXAM_TYPE_ID numeric,
     @STATUS char(10),
	 @USER_LOGIN_ID numeric
   
   
     AS BEGIN 
        

		declare @SessionId numeric = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @EXAM_ENTRY_BR_ID) 
    --declare @EXAM_ENTRY_HD_ID  numeric = 2,
			 --@EXAM_ENTRY_BR_ID  numeric = 1  ,
			 --@EXAM_ENTRY_CLASS_ID  numeric = 3,
			 --@EXAM_ENTRY_TERM_ID  numeric = 1,
			 --@EXAM_ENTRY_SUBJECT_ID  numeric = 1,
			 --@EXAM_ENTRY_EXAM_TYPE nvarchar(100) = 'Test',
			 --@EXAM_ENTRY_EXAM_TYPE_ID numeric = 2,
			 --@STATUS char(10) = 'A',
			 --@USER_LOGIN_ID numeric=1
  
   -- start approval individual ranks   

   declare @Test_Type nvarchar(50) = 'Test'
   
   if @EXAM_ENTRY_EXAM_TYPE != 'Exam'
   BEGIN
		set @Test_Type = @EXAM_ENTRY_EXAM_TYPE
		set @EXAM_ENTRY_EXAM_TYPE = 'Test'
   END 
      declare @tbl table (exam_entry_id numeric, approval_rank int, exam_marks float)
declare @count_exam_entry_records int = 0
declare @i int = 1

declare @exam_entry_id numeric = 0
declare @exam_entry_marks_log nvarchar(500) = ''
declare @exam_std_att_subject_is_compulsory bit = 0
declare @exam_std_att_subject_id numeric = 0

set @count_exam_entry_records = (SELECT COUNT(*) FROM EXAM_ENTRY 
WHERE EXAM_ENTRY_PLAN_EXAM_ID 
IN (SELECT EXAM_DEF_ID FROM EXAM_DEF WHERE EXAM_DEF_CLASS_ID 
IN (select DEF_ID from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID )))

-- For check subject ID will be zero or not. If isubject is not cumpulsory then subject ID will be 0
set @exam_std_att_subject_is_compulsory = (select DEF_IS_COMPULSORY from SCHOOL_PLANE_DEFINITION where DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_STATUS = 'T')
if @exam_std_att_subject_is_compulsory = 0
BEGIN
	set @exam_std_att_subject_id = @EXAM_ENTRY_SUBJECT_ID
END

while @i <= @count_exam_entry_records
BEGIN
	select @exam_entry_id=EXAM_ENTRY_ID,@exam_entry_marks_log=EXAM_ENTRY_OBTAINED_MARKS_LOG
	 from (select ROW_NUMBER() over (order by (select 0)) as sr,EXAM_ENTRY.EXAM_ENTRY_ID,EXAM_ENTRY_OBTAINED_MARKS_LOG
	 from EXAM_ENTRY WHERE EXAM_ENTRY_PLAN_EXAM_ID 
		IN (SELECT EXAM_DEF_ID FROM EXAM_DEF WHERE EXAM_DEF_CLASS_ID 
		IN (select DEF_ID from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID)))A 
		where sr=@i
		insert into @tbl
		select @exam_entry_id,id-1,val from dbo.split(@exam_entry_marks_log,',')
		 

	set @i = @i + 1
END
-- end the approval individual ranks 

		declare @t table (ID int, [Std ID] int , [School ID] int , [Std Name] nvarchar(50), Class nvarchar(50),  [Roll#] int,
		 [Total Marks] int, [Pass Marks] int, [Obtain Marks] int, [Marks Log] nvarchar(500),[Plan Exam ID] int,[Present Days] int,[Total Days] int, Comments nvarchar(1000) )
		declare @tbl_ClassIDandName as table (ID numeric ,Name nvarchar(50), [Order] int)	
		declare @tbl_ClassTerm as table (ID numeric, Name nvarchar(50))
		declare @tbl_ClassesTermsAndSubjects as table (Class numeric,Term numeric,Subject numeric)
		
		 declare @exam_type_id nvarchar(50) = '',
			 	 @exam nvarchar(10)= 'Exam',
				 @test nvarchar(10)= 'Test',
				 @exam_count int = 0,
				 @test_count int = 0,
				 @userType as nvarchar(50) = 'A',
				 @userCode as numeric = 0,
			   	 @Count as bit = 0,
			  	 @CountSubAdmin as numeric = 0,
			     @isEnabled as bit = 0,
				 @enabled as nvarchar(50) = 'disabled',
				 @isInTeacherInfo as numeric,
				 @IsInSubjectInfo as numeric,
				 @isVisible as bit = 0,
				 @teacher as nvarchar(50) = ''
				 ,@designation as nvarchar(50)
				 ,@rank as numeric=0
				,@approvalStatus as nvarchar(100)
				,@exam_plan_id as numeric=0
				,@isApproved as numeric=0
				,@currentApprovedRank as numeric=0

		select @userType=USER_TYPE,@userCode= USER_CODE from USER_INFO where USER_ID=@USER_LOGIN_ID
		 select @rank=APPROVAL_RANK,@designation=APPROVAL_DESIGNATION from EXAM_APPROVAL_SETTINGS where APPROVAL_STAFF_ID=@userCode and APPROVAL_STATUS != 'E'
		select  @Count=count(*) from EXAM_APPROVAL_SETTINGS e where e.APPROVAL_STAFF_ID=@userCode and APPROVAL_STATUS != 'E'
		and e.APPROVAL_HD_ID=@EXAM_ENTRY_HD_ID and e.APPROVAL_BR_ID 
		in ( select * from [dbo].[get_centralized_br_id]('S', @EXAM_ENTRY_BR_ID))   --   e.APPROVAL_BR_ID=@EXAM_ENTRY_BR_ID and e.APPROVAL_HD_ID=@EXAM_ENTRY_HD_ID


			select @exam_plan_id=ed.EXAM_DEF_ID from SCHOOL_PLANE_DEFINITION spd 
				inner join EXAM_DEF ed on ed.EXAM_DEF_CLASS_ID=spd.DEF_ID
				where spd.DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and spd.DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and spd.DEF_TERM=@EXAM_ENTRY_TERM_ID
				and ed.EXAM_DEF_SUBJECT_TYPE_ID=@EXAM_ENTRY_EXAM_TYPE_ID


		select 	@approvalStatus=eas.EXAM_APPROVAL_RANKWISE_STATUS from EXAM_APPROVAL_STATUS eas 
		where eas.EXAM_APPROVAL_PLAN_EXAM_ID=@exam_plan_id

		if @userType = 'A'
		BEGIN
			select @isEnabled=br.BR_ADM_IS_ENTER_MARKS from BR_ADMIN br where br.BR_ADM_ID=@EXAM_ENTRY_BR_ID
			 set @isEnabled= isnull(@isEnabled,0)
		END
			 
		select @isInTeacherInfo= count(*) from TEACHER_INFO t where t.TECH_USER_INFO_ID=@USER_LOGIN_ID
		-- if @IsInSubjectInfo =0 it has no subject
		select @IsInSubjectInfo= count(*) from SCHOOL_PLANE_DEFINITION s where s.DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and
			s.DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and s.DEF_TERM=@EXAM_ENTRY_TERM_ID 
			 and s.DEF_TEACHER=@userCode and s.DEF_STATUS='T'
		--if @CountSubAdmin = 0 then it is main admin
	 Select @CountSubAdmin=count(*) from TEACHER_INFO 
		where TECH_USER_INFO_ID=@USER_LOGIN_ID and TECH_STATUS='T'

		if @USER_LOGIN_ID = 30548 OR (select COUNT(*) from USER_INFO where USER_DISPLAY_NAME = 'Campus Admin' and USER_ID = @USER_LOGIN_ID ) > 0
		BEGIN
			set @CountSubAdmin = 0
		END
	

		--Sub Admin can Act as admin for temporary Adding Sub Admin to zero
		--set @CountSubAdmin = 0
		

			-- -- -- -- -- -- -- -- --  FOR APPROVAL STATUS AND REVERSE APPROVALS -- -- -- -- -- -- -- -- -- -- -- -- -- 

					select top(1) @currentApprovedRank=(id-1) ,@isApproved= val from dbo.split(@approvalStatus,',')
					where val <>0
					 order by id desc

			-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
			-- if exam type is exam

			if(@EXAM_ENTRY_EXAM_TYPE='Exam')
			begin
			if @userType ='A' and @isEnabled=1 and @CountSubAdmin =0
			 --and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
			begin 
				set @enabled='enabled'
			end

			else if @isInTeacherInfo<>0 and @IsInSubjectInfo<>0  
			and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
			begin
				set @enabled='enabled'
			end			
			else if (select COUNT(*) from @tbl w where w.approval_rank + 1 = @rank) != 0  
			and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
			BEGIN
				set @enabled='enabled'
			END
			end
			else if(@EXAM_ENTRY_EXAM_TYPE='Test')
			begin
				if((@isInTeacherInfo<>0 and @IsInSubjectInfo<>0 )or (@CountSubAdmin=0 and @isEnabled<>0) )
			-- if exam type is test
					begin
						set @enabled='enabled'
					end
					else
					begin
						set @enabled='disabled'
					end
			end

		if @rank > 0
		BEGIN
			set @enabled='enabled'
		END
		
		set @teacher=cast(@userCode as nvarchar)

			if @IsInSubjectInfo > 0 OR (@isEnabled=1 and @CountSubAdmin =0)or @Count = 1
			begin
				set @isVisible=1
				set @teacher='%'				
			end
			
			--if (@isEnabled=1 and @CountSubAdmin =0)or @Count = 1
			--BEGIN
			--	set @isVisible = 1
			--END


     if @STATUS = 'L'
     BEGIN   
		select * from @t --For Structure only means column names only
		select 'insert',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
     END     
     
     ELSE IF @STATUS = 'A'
     BEGIN     
		
			if @EXAM_ENTRY_EXAM_TYPE = @exam
				BEGIN
					set @exam_count =  (select count(*) from (select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, -1 as [Roll#], 
					d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks],en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
					 en.EXAM_ENTRY_STATUS as [Status]

					from EXAM_ENTRY en
					join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
					join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
					join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
					join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
					join VStudentSubjects ss on ss.StudentId = s.STDNT_ID and ss.ClassId = CLASS_ID and ss.SubjectId = pd.DEF_SUBJECT and ss.TermId = @EXAM_ENTRY_TERM_ID
					--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
					--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
					

					where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
					and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
					and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE = @exam)B)
					
					if @exam_count = 0
						BEGIN
							select ROW_NUMBER() over( order by (CAST([School ID] as int))) as ID,* from
							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class,-1 as [Roll#], 
							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
							 / 100) as [Pass Marks], 0 as [Obtain Marks], '' [Marks Log],d.EXAM_DEF_ID as [Plan Exam ID]
							 , ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],c.EXAM_STD_COM_COMMENTS Comments

							from EXAM_DEF d
							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = ex.EXAM_CLASS_PLAN_ID and s.STDNT_STATUS = 'T'
							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T' 
							join VStudentSubjects ss on ss.StudentId = s.STDNT_ID and ss.ClassId = CLASS_ID and ss.SubjectId = pd.DEF_SUBJECT and ss.TermId = @EXAM_ENTRY_TERM_ID
							--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
							--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
							and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID
							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0

							where EXAM_DEF_STATUS = 'T' and ex.EXAM_CLASS_PLAN_ID = @EXAM_ENTRY_CLASS_ID
							and pd.DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
							and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID  )A			
							
							select 'insert',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
						END			
					
					else
						BEGIN
						--  here the pivot table starts
						
								;with tbl_before_pivt
								as
								(select * from @tbl)
								,tbl_pivot as
								(
								select * from tbl_before_pivt
								pivot (MAX(exam_marks)
							FOR approval_rank IN ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9])
							) AS PivotTable
							)
							select Q.*, tbl_pivot.* from tbl_pivot
							right join

							(select distinct en.EXAM_ENTRY_ID as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
							s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class,-1 as [Roll#], 
							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
							 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
							 en.EXAM_ENTRY_STATUS as [Status], ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],
							 c.EXAM_STD_COM_COMMENTS Comments

							from EXAM_ENTRY en
							join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
							join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID 
							--and s.STDNT_STATUS = 'T'
							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
							join VStudentSubjects ss on ss.StudentId = s.STDNT_ID and ss.ClassId = CLASS_ID and ss.SubjectId = pd.DEF_SUBJECT  and ss.TermId = @EXAM_ENTRY_TERM_ID
							--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
							--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') 
							--and r.STUDENT_ROLL_NUM_STATUS = 'T'
							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0
							where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
							and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
							and en.EXAM_ENTRY_STATUS = 'T'	and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID and en.EXAM_ENTRY_EXAM_TYPE = @exam					
							
							union all
							--student that are new added
							select * from 
							(select 0 as ID,[Plan Exam ID], [Std ID], [School ID],
							[Std Name], Class, Roll#, [Total Marks], [Pass Marks], [Obtain Marks],[Marks Log],'T' as [Status],[Present Days],[Total Days],Comments
							 from
							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, -1 as [Roll#], 
							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
							 / 100) as [Pass Marks], 0 as [Obtain Marks],'' [Marks Log], d.EXAM_DEF_ID as [Plan Exam ID]
							 , ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],c.EXAM_STD_COM_COMMENTS Comments

							from EXAM_DEF d
							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = ex.EXAM_CLASS_PLAN_ID and s.STDNT_STATUS = 'T'
							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T' 
							join VStudentSubjects ss on ss.StudentId = s.STDNT_ID and ss.ClassId = CLASS_ID and ss.SubjectId = pd.DEF_SUBJECT  and ss.TermId = @EXAM_ENTRY_TERM_ID
							--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
							--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
							and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID
							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0

							where EXAM_DEF_STATUS = 'T' and ex.EXAM_CLASS_PLAN_ID = @EXAM_ENTRY_CLASS_ID
							and pd.DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
							and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID  )A)B where [Std ID] not in 
							--student that are in the exam entry table
							(select [Std ID] from
								(select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
								s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, -1 as [Roll#], 
								d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
								 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
								 en.EXAM_ENTRY_STATUS as [Status]
								 --,att.EXAM_STD_ATT_PRESENT_DAYS [Present Days],att.EXAM_STD_ATT_TOTAL_DAYS [Total Days]

								from EXAM_ENTRY en
								join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
								join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
								join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
								join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID 
								--and s.STDNT_STATUS = 'T'
								join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
								join VStudentSubjects ss on ss.StudentId = s.STDNT_ID and ss.ClassId = CLASS_ID and ss.SubjectId = pd.DEF_SUBJECT  and ss.TermId = @EXAM_ENTRY_TERM_ID
								--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
								--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') 
								--join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
								--and r.STUDENT_ROLL_NUM_STATUS = 'T'
								where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
								and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
								and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE = @exam)C
							)) Q
							on Q.ID = tbl_pivot.exam_entry_id order by CAST([School ID] as int)
							
							select 'update',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
						END

				END
			
			ELSE IF @EXAM_ENTRY_EXAM_TYPE = @test
			BEGIN
			
					set @test_count = (select Count(*) from (select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, -1 as [Roll#], 
					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], 
					 en.EXAM_ENTRY_STATUS as [Status]

					from EXAM_ENTRY en
					join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
					join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'

					--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
					--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
					where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE=@Test_Type)C)
				
				--select @test_count as [Test Count for Tanveer memon]

				if @test_count = 0
				BEGIN
					select ROW_NUMBER() over( order by ([Std ID])) as ID,*,0 [Total Days], 0 [Present Days],'' Comments from
					(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
					s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, -1 as [Roll#], 
					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
					 / 100) as [Pass Marks], 0 as [Obtain Marks], et.EXAM_TEST_ID as [Plan Exam ID]

					from EXAM_TEST et
					join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = et.EXAM_TEST_CLASS_ID and s.STDNT_STATUS = 'T'
					join SCHOOL_PLANE p on CLASS_ID = EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
					--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
					--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
					where EXAM_TEST_STATUS = 'T' and et.EXAM_TEST_CLASS_ID = @EXAM_ENTRY_CLASS_ID and
					et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID 				
					)A
					select 'insert'	,@enabled,1,'',@EXAM_ENTRY_EXAM_TYPE
				END
				
				ELSE
				BEGIN
					select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, -1 as [Roll#], 
					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], en.EXAM_ENTRY_STATUS as [Status], 0 [Total Days], 0 [Present Days],'' Comments

					from EXAM_ENTRY en
					join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
					join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
					--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
					--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
					where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T'
					
					union all
							--student that are new added
							select *, 0 [Total Days], 0 [Present Days],'' Comments from 
							(select ROW_NUMBER() over( order by ([Std ID])) as ID,[Plan Exam ID], [Std ID], [School ID],
							[Std Name], Class, Roll#, [Total Marks], [Pass Marks], [Obtain Marks],'T' as [Status] from
							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, -1 as [Roll#], 
							et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
							 / 100) as [Pass Marks], 0 as [Obtain Marks], et.EXAM_TEST_ID as [Plan Exam ID]

							from EXAM_TEST et
							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = et.EXAM_TEST_CLASS_ID and s.STDNT_STATUS = 'T'
							join SCHOOL_PLANE p on CLASS_ID = EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
							--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
							--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
							where EXAM_TEST_STATUS = 'T' and et.EXAM_TEST_CLASS_ID = @EXAM_ENTRY_CLASS_ID and
							et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID 				
							)A)B where [Std ID] not in 
							--student that are in the exam entry table
							(select [Std ID] from
								(select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
							s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, -1 as [Roll#], 
							et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
							 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], 
							 en.EXAM_ENTRY_STATUS as [Status]

							from EXAM_ENTRY en
							join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
							join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
							join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
							--join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
							--and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
							where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T')C
							)
							
					select 'update',@enabled,1,'',@EXAM_ENTRY_EXAM_TYPE
				END
			END
     END
     

    -- if admin and super admin or it or present in rank then the query below
if @userType='SA' or @userType='A' or @userType='IT' or @Count>0
	begin
		if @Count > 0
		BEGIN
			insert into @tbl_ClassIDandName
			select [ID],[Name],[Order] from VSCHOOL_PLANE i
			where [Institute ID] = @EXAM_ENTRY_HD_ID and
			[Branch ID] = @EXAM_ENTRY_BR_ID and  [Session Id] = @SessionId and
			[Status] ='T' and Name in (select LTRIM(RTRIM(val)) from dbo.split((select d.DESIGNATION_DESC from TEACHER_INFO t join DESIGNATION_INFO d on d.DESIGNATION_NAME = t.TECH_DESIGNATION and d.DESIGNATION_BR_ID = @EXAM_ENTRY_BR_ID  and d.DESIGNATION_STATUS = 'T' where TECH_ID = @userCode),',')) 
		END
		ELSE
		BEGIN
			insert into @tbl_ClassIDandName
			select [ID],[Name],[Order] from VSCHOOL_PLANE i
			where [Institute ID] = @EXAM_ENTRY_HD_ID and [Session Id] = @SessionId and Level != 1 and
			[Branch ID] = @EXAM_ENTRY_BR_ID and
			[Status] ='T' 
		END
	

	end
	else 
	begin
		insert into @tbl_ClassIDandName
		select distinct ID,Name,[Order] from SCHOOL_PLANE_DEFINITION sp
		join vSCHOOL_PLANE on sp.DEF_CLASS_ID=ID
		join TEACHER_INFO t on t.TECH_ID = sp.DEF_TEACHER 
		join USER_INFO u on u.USER_CODE = t.TECH_ID
		where sp.DEF_TEACHER like @teacher and [Session Id] = @SessionId and Level != 1
	end
	select ID,Name AS [Class Name] from @tbl_ClassIDandName order by [Order]

	 -- idhr kaam krna he
	-- if teacher then below

	-- end

	if @EXAM_ENTRY_CLASS_ID = 0
	BEGIN
		set @EXAM_ENTRY_CLASS_ID = (select top(1)ID from @tbl_ClassIDandName)
	END
	
	if @EXAM_ENTRY_EXAM_TYPE = @exam
	BEGIN	
		insert into @tbl_ClassTerm
		select ID,Name from 
		(
		select distinct (t.ID) as ID, t.Name as Name,[Rank] from 
		SCHOOL_PLANE_DEFINITION
		join VTERM_INFO t on t.ID = DEF_TERM and Status	='T' and DEF_STATUS ='T' 
		where 
		DEF_CLASS_ID =@EXAM_ENTRY_CLASS_ID and [Institute ID] = @EXAM_ENTRY_HD_ID and [Branch ID] = @EXAM_ENTRY_BR_ID and
			[Status] ='T' and DEF_TEACHER like @teacher and 
			
			(CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(148 as nvarchar(10)) END  
			OR  CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(155 as nvarchar(10)) END 
			OR  CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(179 as nvarchar(10)) END 
			OR  CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(187 as nvarchar(10)) END 
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(163 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(167 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(159 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(195 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(127 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(191 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(137 as nvarchar(10)) END
			OR CAST(t.ID as nvarchar(10)) like CASE WHEN @userType = 'A' AND @CountSubAdmin = 0 THEN '%' ELSE CAST(183 as nvarchar(10)) END
		
			))B	order by [Rank]
			 
		if @EXAM_ENTRY_TERM_ID = 0
			BEGIN			
				set @EXAM_ENTRY_TERM_ID = ( select Top(1) ID  from @tbl_ClassTerm) 
			END
			
	END
	
	ELSE
	BEGIN
		insert into @tbl_ClassTerm
		select ID,Name from
		(select distinct (t.ID) as ID, t.Name as Name,[Rank]
		from VEXAM_TEST et
		join VTERM_INFO t on t.ID = et.Term and t.Status	='T'
		where 
		et.[Class ID] =@EXAM_ENTRY_CLASS_ID  and et.[Institute ID] = @EXAM_ENTRY_HD_ID and et.[Branch ID] = @EXAM_ENTRY_BR_ID and
			et.[Status] ='T')B order by [Rank]
			
			if @EXAM_ENTRY_TERM_ID = 0
			BEGIN			
				set @EXAM_ENTRY_TERM_ID = ( select Top(1) ID  from @tbl_ClassTerm) 
			END
	END
	
	select ID,Name as [Term] from @tbl_ClassTerm
	
	if @EXAM_ENTRY_EXAM_TYPE = @exam
	BEGIN

		select distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION
		join SUBJECT_INFO on SUB_ID = DEF_SUBJECT 
		where DEF_CLASS_ID =@EXAM_ENTRY_CLASS_ID and DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_STATUS ='T' and SUB_STATUS = 'T'
		and DEF_TEACHER like @teacher
		if @EXAM_ENTRY_SUBJECT_ID = 0
			BEGIN
					set @EXAM_ENTRY_SUBJECT_ID = (select Top(1) ID from (select distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION
		join SUBJECT_INFO on SUB_ID = DEF_SUBJECT 
		where DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_STATUS ='T' and SUB_STATUS = 'T' and DEF_TEACHER like @teacher)A)
			END

	END
	
	ELSE -- if exam type is test then this
	BEGIN
		select distinct (et.Subject) as ID, SUB_NAME as Name from VEXAM_TEST et
		join SUBJECT_INFO on SUB_ID = et.Subject
		inner join SCHOOL_PLANE_DEFINITION spd on et.Subject=spd.DEF_SUBJECT 
		where et.[Class ID] =@EXAM_ENTRY_CLASS_ID and et.Term = @EXAM_ENTRY_TERM_ID and et.Status ='T' and SUB_STATUS = 'T' 
		and DEF_TEACHER like @teacher
		if @EXAM_ENTRY_SUBJECT_ID = 0
			BEGIN
					set @EXAM_ENTRY_SUBJECT_ID = (select Top(1) ID from (select distinct (et.Subject) as ID, SUB_NAME as Name from VEXAM_TEST et
					join SUBJECT_INFO on SUB_ID = et.Subject 
					join SCHOOL_PLANE_DEFINITION spd on spd.DEF_SUBJECT=et.Subject
					where et.[Class ID] = @EXAM_ENTRY_CLASS_ID
					and et.Term = @EXAM_ENTRY_TERM_ID and et.Status ='T' and SUB_STATUS = 'T'  and DEF_TEACHER like @teacher)A)
			END
	END
				
		
		set @exam_type_id = dbo.set_where_like(@EXAM_ENTRY_EXAM_TYPE_ID)
		
		--select ID, Name from VEXAM where [Institute ID] = @EXAM_ENTRY_HD_ID and
		--	[Branch ID] = @EXAM_ENTRY_BR_ID and	[Status] ='T' and [Class Plan ID] = @EXAM_ENTRY_CLASS_ID
		
		--remove distinct keyword infront of subject type id
		select [Subject Type ID] as ID, [Subject Type] as Name, [Marks Type], Subject from VEXAM_DEF vd
		where [Term ID] = @EXAM_ENTRY_TERM_ID and [Subject ID] = @EXAM_ENTRY_SUBJECT_ID
		and PID = (select ID from VEXAM where [Institute ID] = @EXAM_ENTRY_HD_ID and [Branch ID] = @EXAM_ENTRY_BR_ID
					and Status = 'T' and [Class Plan ID] =@EXAM_ENTRY_CLASS_ID )

		
		select ID, Name from VEXAM_TEST where [Institute ID] = @EXAM_ENTRY_HD_ID and
		[Branch ID] = @EXAM_ENTRY_BR_ID and	[Status] ='T' and [Class ID] in (select ID from @tbl_ClassIDandName)
		and Term = @EXAM_ENTRY_TERM_ID and [Subject] = @EXAM_ENTRY_SUBJECT_ID and [Test Type] = @Test_Type
		
		select SUB_GRADE_ID as ID, SUB_GRADE_NAME as Name from SUBJECT_GRADE_INFO where SUB_GRADE_HD_ID = @EXAM_ENTRY_HD_ID and SUB_GRADE_BR_ID = @EXAM_ENTRY_BR_ID and SUB_GRADE_STATUS = 'T'
		


	--	if exam then below
	if @EXAM_ENTRY_EXAM_TYPE='Exam' and @STATUS='A'
	begin
		
	select APPROVAL_RANK as Rank,APPROVAL_DESIGNATION+' - '+ t.TECH_FIRST_NAME  as [Name + Designation] from EXAM_APPROVAL_SETTINGS 
 inner join TEACHER_INFO t on APPROVAL_STAFF_ID=t.TECH_ID
 where APPROVAL_RANK<=@rank and APPROVAL_HD_ID = @EXAM_ENTRY_HD_ID and APPROVAL_BR_ID = @EXAM_ENTRY_BR_ID and APPROVAL_STATUS = 'T' and APPROVAL_STAFF_ID = @userCode and APPROVAL_STATUS != 'E'
 union
 select 0, t.TECH_DESIGNATION+ ' - ' + t.TECH_FIRST_NAME from SCHOOL_PLANE_DEFINITION spd
 join TEACHER_INFO t on spd.DEF_TEACHER=t.TECH_ID
 where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and DEF_STATUS = 'T'
		
 end
 else
 begin
 select '' as Rank,''  as [Name + Designation] 
 end
 select @isEnabled as [Is Admin Enter Marks]
 --else then only structure
 
 if (select COUNT(*) from SCHOOL_PLANE_DEFINITION where DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and  DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_IS_COMPULSORY = 0 and DEF_STATUS = 'T') > 0
 BEGIN
	select s.*, e.ELE_SUB_DEF_SUB_ID [Subject ID] from STUDENT_ELECTIVE_SUBJECT s
	join ELECTIVE_SUBJECT_DEF e on e.ELE_SUB_DEF_ID = s.STD_ELE_SUB_SUBJECT_ID
	where e.ELE_SUB_DEF_SUB_ID = @EXAM_ENTRY_SUBJECT_ID
 END
 ELSE
 BEGIN
	select 'Compulsory' as Compulsory
 END
 
 --
     END


	 -- change log

	 -- hardcoded rank and designation for test, 
	 -- hardcoded enabled and visible table for tests
	 -- if status is a then run the code in if examtype ='Exam'




--ALTER procedure  [dbo].[sp_EXAM_ENTRY_selection]
     
--     @EXAM_ENTRY_HD_ID  numeric,
--     @EXAM_ENTRY_BR_ID  numeric,     
--     @EXAM_ENTRY_CLASS_ID  numeric,	
--     @EXAM_ENTRY_TERM_ID  numeric,
--     @EXAM_ENTRY_SUBJECT_ID  numeric,
--     @EXAM_ENTRY_EXAM_TYPE nvarchar(100),
--     @EXAM_ENTRY_EXAM_TYPE_ID numeric,
--     @STATUS char(10),
--	 @USER_LOGIN_ID numeric
   
   
--     AS BEGIN 
        
--    --declare @EXAM_ENTRY_HD_ID  numeric = 2,
--			 --@EXAM_ENTRY_BR_ID  numeric = 1  ,
--			 --@EXAM_ENTRY_CLASS_ID  numeric = 3,
--			 --@EXAM_ENTRY_TERM_ID  numeric = 1,
--			 --@EXAM_ENTRY_SUBJECT_ID  numeric = 1,
--			 --@EXAM_ENTRY_EXAM_TYPE nvarchar(100) = 'Test',
--			 --@EXAM_ENTRY_EXAM_TYPE_ID numeric = 2,
--			 --@STATUS char(10) = 'A',
--			 --@USER_LOGIN_ID numeric=1
  
--   -- start approval individual ranks   
--      declare @tbl table (exam_entry_id numeric, approval_rank int, exam_marks float)
--declare @count_exam_entry_records int = 0
--declare @i int = 1

--declare @exam_entry_id numeric = 0
--declare @exam_entry_marks_log nvarchar(500) = ''
--declare @exam_std_att_subject_is_compulsory bit = 0
--declare @exam_std_att_subject_id numeric = 0

--set @count_exam_entry_records = (SELECT COUNT(*) FROM EXAM_ENTRY 
--WHERE EXAM_ENTRY_PLAN_EXAM_ID 
--IN (SELECT EXAM_DEF_ID FROM EXAM_DEF WHERE EXAM_DEF_CLASS_ID 
--IN (select DEF_ID from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID )))

---- For check subject ID will be zero or not. If isubject is not cumpulsory then subject ID will be 0
--set @exam_std_att_subject_is_compulsory = (select DEF_IS_COMPULSORY from SCHOOL_PLANE_DEFINITION where DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_STATUS = 'T')
--if @exam_std_att_subject_is_compulsory = 0
--BEGIN
--	set @exam_std_att_subject_id = @EXAM_ENTRY_SUBJECT_ID
--END

--while @i <= @count_exam_entry_records
--BEGIN
--	select @exam_entry_id=EXAM_ENTRY_ID,@exam_entry_marks_log=EXAM_ENTRY_OBTAINED_MARKS_LOG
--	 from (select ROW_NUMBER() over (order by (select 0)) as sr,EXAM_ENTRY.EXAM_ENTRY_ID,EXAM_ENTRY_OBTAINED_MARKS_LOG
--	 from EXAM_ENTRY WHERE EXAM_ENTRY_PLAN_EXAM_ID 
--		IN (SELECT EXAM_DEF_ID FROM EXAM_DEF WHERE EXAM_DEF_CLASS_ID 
--		IN (select DEF_ID from SCHOOL_PLANE_DEFINITION where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID)))A 
--		where sr=@i
--		insert into @tbl
--		select @exam_entry_id,id-1,val from dbo.split(@exam_entry_marks_log,',')
		 

--	set @i = @i + 1
--END
---- end the approval individual ranks 

--		declare @t table (ID int, [Std ID] int , [School ID] int , [Std Name] nvarchar(50), Class nvarchar(50),  [Roll#] int,
--		 [Total Marks] int, [Pass Marks] int, [Obtain Marks] int, [Marks Log] nvarchar(500),[Plan Exam ID] int,[Present Days] int,[Total Days] int, Comments nvarchar(1000) )
--		declare @tbl_ClassIDandName as table (ID numeric ,Name nvarchar(50))	
--		declare @tbl_ClassTerm as table (ID numeric, Name nvarchar(50))
--		declare @tbl_ClassesTermsAndSubjects as table (Class numeric,Term numeric,Subject numeric)
		
--		 declare @exam_type_id nvarchar(50) = '',
--			 	 @exam nvarchar(10)= 'Exam',
--				 @test nvarchar(10)= 'Test',
--				 @exam_count int = 0,
--				 @test_count int = 0,
--				 @userType as nvarchar(50) = 'A',
--				 @userCode as numeric = 0,
--			   	 @Count as bit = 0,
--			  	 @CountSubAdmin as numeric = 0,
--			     @isEnabled as bit = 0,
--				 @enabled as nvarchar(50) = 'disabled',
--				 @isInTeacherInfo as numeric,
--				 @IsInSubjectInfo as numeric,
--				 @isVisible as bit = 0,
--				 @teacher as nvarchar(50) = ''
--				 ,@designation as nvarchar(50)
--				 ,@rank as numeric=0
--				,@approvalStatus as nvarchar(100)
--				,@exam_plan_id as numeric=0
--				,@isApproved as numeric=0
--				,@currentApprovedRank as numeric=0

--		select @userType=USER_TYPE,@userCode= USER_CODE from USER_INFO where USER_ID=@USER_LOGIN_ID
--		 select @rank=APPROVAL_RANK,@designation=APPROVAL_DESIGNATION from EXAM_APPROVAL_SETTINGS where APPROVAL_STAFF_ID=@userCode
--		select  @Count=count(*) from EXAM_APPROVAL_SETTINGS e where e.APPROVAL_STAFF_ID=@userCode 
--		and e.APPROVAL_HD_ID=@EXAM_ENTRY_HD_ID and e.APPROVAL_BR_ID 
--		in ( select * from [dbo].[get_centralized_br_id]('S', @EXAM_ENTRY_BR_ID))   --   e.APPROVAL_BR_ID=@EXAM_ENTRY_BR_ID and e.APPROVAL_HD_ID=@EXAM_ENTRY_HD_ID


--			select @exam_plan_id=ed.EXAM_DEF_ID from SCHOOL_PLANE_DEFINITION spd 
--				inner join EXAM_DEF ed on ed.EXAM_DEF_CLASS_ID=spd.DEF_ID
--				where spd.DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and spd.DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and spd.DEF_TERM=@EXAM_ENTRY_TERM_ID
--				and ed.EXAM_DEF_SUBJECT_TYPE_ID=@EXAM_ENTRY_EXAM_TYPE_ID


--		select 	@approvalStatus=eas.EXAM_APPROVAL_RANKWISE_STATUS from EXAM_APPROVAL_STATUS eas 
--		where eas.EXAM_APPROVAL_PLAN_EXAM_ID=@exam_plan_id

--		select @isEnabled=br.BR_ADM_IS_ENTER_MARKS from BR_ADMIN br where br.BR_ADM_ID=@EXAM_ENTRY_BR_ID
--		 set @isEnabled= isnull(@isEnabled,0)
	 
--		select @isInTeacherInfo= count(*) from TEACHER_INFO t where t.TECH_USER_INFO_ID=@USER_LOGIN_ID
--		-- if @IsInSubjectInfo =0 it has no subject
--		select @IsInSubjectInfo= count(*) from SCHOOL_PLANE_DEFINITION s where s.DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and
--			s.DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and s.DEF_TERM=@EXAM_ENTRY_TERM_ID 
--			 and s.DEF_TEACHER=@userCode and s.DEF_STATUS='T'
--		--if @CountSubAdmin = 0 then it is main admin
--	 Select @CountSubAdmin=count(*) from TEACHER_INFO 
--		where TECH_USER_INFO_ID=@USER_LOGIN_ID and TECH_STATUS='T'

--		--Sub Admin can Act as admin for temporary Adding Sub Admin to zero
--		set @CountSubAdmin = 0
		
--			-- -- -- -- -- -- -- -- --  FOR APPROVAL STATUS AND REVERSE APPROVALS -- -- -- -- -- -- -- -- -- -- -- -- -- 

--					select top(1) @currentApprovedRank=(id-1) ,@isApproved= val from dbo.split(@approvalStatus,',')
--					where val <>0
--					 order by id desc

--			-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--			-- if exam type is exam

--			if(@EXAM_ENTRY_EXAM_TYPE='Exam')
--			begin
--			if @userType ='A' and @isEnabled=1 and @CountSubAdmin =0
--			 and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
--			begin 
--				set @enabled='enabled'
--			end

--			else if @isInTeacherInfo<>0 and @IsInSubjectInfo<>0  
--			and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
--			begin
--				set @enabled='enabled'
--			end			
--			else if (select COUNT(*) from @tbl w where w.approval_rank + 1 = @rank) != 0  
--			and (@rank=@currentApprovedRank or @rank=@currentApprovedRank+1)
--			BEGIN
--				set @enabled='enabled'
--			END
--			end
--			else if(@EXAM_ENTRY_EXAM_TYPE='Test')
--			begin
--				if((@isInTeacherInfo<>0 and @IsInSubjectInfo<>0 )or (@CountSubAdmin=0 and @isEnabled<>0) )
--			-- if exam type is test
--					begin
--						set @enabled='enabled'
--					end
--					else
--					begin
--						set @enabled='disabled'
--					end
--			end

--		set @teacher=cast(@userCode as nvarchar)

--			if @IsInSubjectInfo > 0 OR (@isEnabled=1 and @CountSubAdmin =0)or @Count = 1
--			begin
--				set @isVisible=1
--				set @teacher='%'				
--			end
			
--			--if (@isEnabled=1 and @CountSubAdmin =0)or @Count = 1
--			--BEGIN
--			--	set @isVisible = 1
--			--END


--     if @STATUS = 'L'
--     BEGIN   
--		select * from @t
--		select 'insert',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
--     END     
     
--     ELSE IF @STATUS = 'A'
--     BEGIN     
		
--			if @EXAM_ENTRY_EXAM_TYPE = @exam
--				BEGIN
--					set @exam_count =  (select count(*) from (select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--					d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
--					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks],en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
--					 en.EXAM_ENTRY_STATUS as [Status]

--					from EXAM_ENTRY en
--					join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
--					join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
--					join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
--					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
--					join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
--					join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--					and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
					

--					where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
--					and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
--					and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE = @exam)B)
					
--					if @exam_count = 0
--						BEGIN
--							select ROW_NUMBER() over( order by ([Std ID])) as ID,* from
--							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
--							 / 100) as [Pass Marks], 0 as [Obtain Marks], '' [Marks Log],d.EXAM_DEF_ID as [Plan Exam ID]
--							 , ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],c.EXAM_STD_COM_COMMENTS Comments

--							from EXAM_DEF d
--							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
--							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
--							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = ex.EXAM_CLASS_PLAN_ID and s.STDNT_STATUS = 'T'
--							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T' 
--							join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--							and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
--							and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
--							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID
--							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
--							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0

--							where EXAM_DEF_STATUS = 'T' and ex.EXAM_CLASS_PLAN_ID = @EXAM_ENTRY_CLASS_ID
--							and pd.DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
--							and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID  )A			
							
--							select 'insert',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
--						END			
					
--					else
--						BEGIN
--						--  here the pivot table starts
						
--								;with tbl_before_pivt
--								as
--								(select * from @tbl)
--								,tbl_pivot as
--								(
--								select * from tbl_before_pivt
--								pivot (MAX(exam_marks)
--							FOR approval_rank IN ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9])
--							) AS PivotTable
--							)
--							select Q.*, tbl_pivot.* from tbl_pivot
--							join

--							(select distinct en.EXAM_ENTRY_ID as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--							s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
--							 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
--							 en.EXAM_ENTRY_STATUS as [Status], ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],
--							 c.EXAM_STD_COM_COMMENTS Comments

--							from EXAM_ENTRY en
--							join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
--							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
--							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
--							join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID 
--							--and s.STDNT_STATUS = 'T'
--							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
--							join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--							and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') 
--							--and r.STUDENT_ROLL_NUM_STATUS = 'T'
--							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
--							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
--							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0
--							where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
--							and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
--							and en.EXAM_ENTRY_STATUS = 'T'	and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
--							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID and en.EXAM_ENTRY_EXAM_TYPE = @exam					
							
--							union all
--							--student that are new added
--							select * from 
--							(select ROW_NUMBER() over( order by ([Std ID])) as ID,[Plan Exam ID], [Std ID], [School ID],
--							[Std Name], Class, Roll#, [Total Marks], [Pass Marks], [Obtain Marks],[Marks Log],'T' as [Status],[Present Days],[Total Days],Comments
--							 from
--							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--							d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
--							 / 100) as [Pass Marks], 0 as [Obtain Marks],'' [Marks Log], d.EXAM_DEF_ID as [Plan Exam ID]
--							 , ISNULL(att.EXAM_STD_ATT_PRESENT_DAYS,0) [Present Days],ISNULL(att.EXAM_STD_ATT_TOTAL_DAYS,0) [Total Days],c.EXAM_STD_COM_COMMENTS Comments

--							from EXAM_DEF d
--							join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
--							join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
--							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = ex.EXAM_CLASS_PLAN_ID and s.STDNT_STATUS = 'T'
--							join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T' 
--							join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--							and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--							left join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
--							left join EXAM_STD_COMMENTS c on c.EXAM_STD_COM_STD_ID = s.STDNT_ID and c.EXAM_STD_COM_CLASS_ID = @EXAM_ENTRY_CLASS_ID
--							and c.EXAM_STD_COM_TERM_ID = @EXAM_ENTRY_TERM_ID and c.EXAM_STD_COM_IS_RETEST = 0
--							where EXAM_DEF_STATUS = 'T' and ex.EXAM_CLASS_PLAN_ID = @EXAM_ENTRY_CLASS_ID
--							and pd.DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
--							and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID and att.EXAM_STD_ATT_SUB_ID = @exam_std_att_subject_id and att.EXAM_STD_ATT_TERM_ID = @EXAM_ENTRY_TERM_ID
--							and att.EXAM_STD_ATT_CLASS_ID = @EXAM_ENTRY_CLASS_ID )A)B where [Std ID] not in 
--							--student that are in the exam entry table
--							(select [Std ID] from
--								(select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--								s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--								d.EXAM_DEF_TOTAL_MARKS as [Total Marks], ((d.[EXAM_DEF_PASS_%AGE] * d.EXAM_DEF_TOTAL_MARKS)
--								 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], en.EXAM_ENTRY_OBTAINED_MARKS_LOG [Marks Log],
--								 en.EXAM_ENTRY_STATUS as [Status]
--								 --,att.EXAM_STD_ATT_PRESENT_DAYS [Present Days],att.EXAM_STD_ATT_TOTAL_DAYS [Total Days]

--								from EXAM_ENTRY en
--								join EXAM_DEF d on en.EXAM_ENTRY_PLAN_EXAM_ID = d.EXAM_DEF_ID and EXAM_DEF_STATUS = 'T'
--								join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = d.EXAM_DEF_CLASS_ID and pd.DEF_STATUS = 'T'
--								join EXAM ex on ex.EXAM_ID = d.EXAM_DEF_PID and ex.EXAM_STATUS = 'T'
--								join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID 
--								--and s.STDNT_STATUS = 'T'
--								join SCHOOL_PLANE p on CLASS_ID = ex.EXAM_CLASS_PLAN_ID and p.CLASS_STATUS = 'T'
--								join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--								and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') 
--								--join EXAM_STD_ATTENDANCE_INFO att on att.EXAM_STD_ATT_STD_ID = s.STDNT_ID
--								--and r.STUDENT_ROLL_NUM_STATUS = 'T'
--								where pd.DEF_SUBJECT =@EXAM_ENTRY_SUBJECT_ID and pd.DEF_TERM = @EXAM_ENTRY_TERM_ID
--								and pd.DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and d.EXAM_DEF_SUBJECT_TYPE_ID = @EXAM_ENTRY_EXAM_TYPE_ID
--								and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE = @exam)C
--							)) Q
--							on Q.ID = tbl_pivot.exam_entry_id
							
--							select 'update',@enabled,@isVisible,@approvalStatus,@EXAM_ENTRY_EXAM_TYPE,@exam_std_att_subject_is_compulsory as [Is Compulsory Subject]
--						END

--				END
			
--			ELSE IF @EXAM_ENTRY_EXAM_TYPE = @test
--			BEGIN
			
--					set @test_count = (select Count(*) from (select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
--					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], 
--					 en.EXAM_ENTRY_STATUS as [Status]

--					from EXAM_ENTRY en
--					join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
--					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
--					join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
--					join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--					and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--					where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T' and en.EXAM_ENTRY_EXAM_TYPE='Test')C)
				
--				--select @test_count as [Test Count for Tanveer memon]

--				if @test_count = 0
--				BEGIN
--					select ROW_NUMBER() over( order by ([Std ID])) as ID,*,0 [Total Days], 0 [Present Days],'' Comments from
--					(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--					s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
--					 / 100) as [Pass Marks], 0 as [Obtain Marks], et.EXAM_TEST_ID as [Plan Exam ID]

--					from EXAM_TEST et
--					join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = et.EXAM_TEST_CLASS_ID and s.STDNT_STATUS = 'T'
--					join SCHOOL_PLANE p on CLASS_ID = EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
--					join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--					and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--					where EXAM_TEST_STATUS = 'T' and et.EXAM_TEST_CLASS_ID = @EXAM_ENTRY_CLASS_ID and
--					et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID 				
--					)A
--					select 'insert'	,@enabled,1,'',@EXAM_ENTRY_EXAM_TYPE
--				END
				
--				ELSE
--				BEGIN
--					select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--					s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--					et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
--					 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], 
--					 en.EXAM_ENTRY_STATUS as [Status], 0 [Total Days], 0 [Present Days],'' Comments

--					from EXAM_ENTRY en
--					join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
--					join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
--					join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
--					join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--					and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--					where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T'
					
--					union all
--							--student that are new added
--							select *, 0 [Total Days], 0 [Present Days],'' Comments from 
--							(select ROW_NUMBER() over( order by ([Std ID])) as ID,[Plan Exam ID], [Std ID], [School ID],
--							[Std Name], Class, Roll#, [Total Marks], [Pass Marks], [Obtain Marks],'T' as [Status] from
--							(select distinct ( s.STDNT_ID) as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--							s.STDNT_FIRST_NAME as [Std Name],CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--							et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
--							 / 100) as [Pass Marks], 0 as [Obtain Marks], et.EXAM_TEST_ID as [Plan Exam ID]

--							from EXAM_TEST et
--							join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = et.EXAM_TEST_CLASS_ID and s.STDNT_STATUS = 'T'
--							join SCHOOL_PLANE p on CLASS_ID = EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
--							join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--							and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--							where EXAM_TEST_STATUS = 'T' and et.EXAM_TEST_CLASS_ID = @EXAM_ENTRY_CLASS_ID and
--							et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID 				
--							)A)B where [Std ID] not in 
--							--student that are in the exam entry table
--							(select [Std ID] from
--								(select distinct  (en.EXAM_ENTRY_ID) as ID, en.EXAM_ENTRY_PLAN_EXAM_ID as [Plan Exam ID],s.STDNT_ID as [Std ID], s.STDNT_SCHOOL_ID as [School ID],
--							s.STDNT_FIRST_NAME as [Std Name], p.CLASS_Name as Class, r.STUDENT_ROLL_NUM_ROLL_NO as [Roll#], 
--							et.EXAM_TEST_TOTAL_MARKS as [Total Marks], ((et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS)
--							 / 100) as [Pass Marks], en.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks], 
--							 en.EXAM_ENTRY_STATUS as [Status]

--							from EXAM_ENTRY en
--							join EXAM_TEST et on en.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
--							join STUDENT_INFO s on s.STDNT_ID = en.EXAM_ENTRY_STUDENT_ID and s.STDNT_STATUS = 'T'
--							join SCHOOL_PLANE p on CLASS_ID = et.EXAM_TEST_CLASS_ID and p.CLASS_STATUS = 'T'
--							join STUDENT_ROLL_NUM r on r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID 
--							and r.STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and r.STUDENT_ROLL_NUM_STATUS = 'T'
--							where et.EXAM_TEST_ID = @EXAM_ENTRY_EXAM_TYPE_ID and en.EXAM_ENTRY_STATUS = 'T')C
--							)
							
--					select 'update',@enabled,1,'',@EXAM_ENTRY_EXAM_TYPE
--				END
--			END
--     END
     

--    -- if admin and super admin or it or present in rank then the query below
--if @userType='SA' or @userType='A' or @userType='IT' or @Count>0
--	begin
--	insert into @tbl_ClassIDandName
--	select [ID],[Name] from VSCHOOL_PLANE i
--	where [Institute ID] = @EXAM_ENTRY_HD_ID and
--	[Branch ID] = @EXAM_ENTRY_BR_ID and
--	[Status] ='T'

--	end
--	else 
--	begin
--		insert into @tbl_ClassIDandName
--		select distinct ID,Name from SCHOOL_PLANE_DEFINITION sp
--		join vSCHOOL_PLANE on sp.DEF_CLASS_ID=ID
--		join TEACHER_INFO t on t.TECH_ID = sp.DEF_TEACHER 
--		join USER_INFO u on u.USER_CODE = t.TECH_ID
--		where sp.DEF_TEACHER like @teacher
--	end
--	select ID,Name AS [Class Name] from @tbl_ClassIDandName

--	 -- idhr kaam krna he
--	-- if teacher then below

--	-- end

--	if @EXAM_ENTRY_CLASS_ID = 0
--	BEGIN
--		set @EXAM_ENTRY_CLASS_ID = (select top(1)ID from @tbl_ClassIDandName)
--	END
	
--	if @EXAM_ENTRY_EXAM_TYPE = @exam
--	BEGIN	
--		insert into @tbl_ClassTerm
--		select distinct (t.ID) as ID, t.Name as Name from 
--		SCHOOL_PLANE_DEFINITION
--		join VTERM_INFO t on t.ID = DEF_TERM and Status	='T'
--		where 
--		DEF_CLASS_ID =@EXAM_ENTRY_CLASS_ID and [Institute ID] = @EXAM_ENTRY_HD_ID and [Branch ID] = @EXAM_ENTRY_BR_ID and
--			[Status] ='T' and DEF_TEACHER like @teacher
			
--		if @EXAM_ENTRY_TERM_ID = 0
--			BEGIN			
--				set @EXAM_ENTRY_TERM_ID = ( select Top(1) ID  from @tbl_ClassTerm) 
--			END
			
--	END
	
--	ELSE
--	BEGIN
--		insert into @tbl_ClassTerm
--		select distinct (t.ID) as ID, t.Name as Name
--		from VEXAM_TEST et
--		join VTERM_INFO t on t.ID = et.Term and t.Status	='T'
--		where 
--		et.[Class ID] =@EXAM_ENTRY_CLASS_ID  and et.[Institute ID] = @EXAM_ENTRY_HD_ID and et.[Branch ID] = @EXAM_ENTRY_BR_ID and
--			et.[Status] ='T'
			
--			if @EXAM_ENTRY_TERM_ID = 0
--			BEGIN			
--				set @EXAM_ENTRY_TERM_ID = ( select Top(1) ID  from @tbl_ClassTerm) 
--			END
--	END
	
--	select ID,Name as [Term] from @tbl_ClassTerm
	
--	if @EXAM_ENTRY_EXAM_TYPE = @exam
--	BEGIN

--		select distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION
--		join SUBJECT_INFO on SUB_ID = DEF_SUBJECT 
--		where DEF_CLASS_ID =@EXAM_ENTRY_CLASS_ID and DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_STATUS ='T' and SUB_STATUS = 'T'
--		and DEF_TEACHER like @teacher
--		if @EXAM_ENTRY_SUBJECT_ID = 0
--			BEGIN
--					set @EXAM_ENTRY_SUBJECT_ID = (select Top(1) ID from (select distinct (DEF_SUBJECT) as ID, SUB_NAME as Name from SCHOOL_PLANE_DEFINITION
--		join SUBJECT_INFO on SUB_ID = DEF_SUBJECT 
--		where DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_TERM = @EXAM_ENTRY_TERM_ID and DEF_STATUS ='T' and SUB_STATUS = 'T' and DEF_TEACHER like @teacher)A)
--			END

--	END
	
--	ELSE -- if exam type is test then this
--	BEGIN
--		select distinct (et.Subject) as ID, SUB_NAME as Name from VEXAM_TEST et
--		join SUBJECT_INFO on SUB_ID = et.Subject
--		inner join SCHOOL_PLANE_DEFINITION spd on et.Subject=spd.DEF_SUBJECT 
--		where et.[Class ID] =@EXAM_ENTRY_CLASS_ID and et.Term = @EXAM_ENTRY_TERM_ID and et.Status ='T' and SUB_STATUS = 'T' 
--		and DEF_TEACHER like @teacher
--		if @EXAM_ENTRY_SUBJECT_ID = 0
--			BEGIN
--					set @EXAM_ENTRY_SUBJECT_ID = (select Top(1) ID from (select distinct (et.Subject) as ID, SUB_NAME as Name from VEXAM_TEST et
--					join SUBJECT_INFO on SUB_ID = et.Subject 
--					join SCHOOL_PLANE_DEFINITION spd on spd.DEF_SUBJECT=et.Subject
--					where et.[Class ID] = @EXAM_ENTRY_CLASS_ID
--					and et.Term = @EXAM_ENTRY_TERM_ID and et.Status ='T' and SUB_STATUS = 'T'  and DEF_TEACHER like @teacher)A)
--			END
--	END
				
		
--		set @exam_type_id = dbo.set_where_like(@EXAM_ENTRY_EXAM_TYPE_ID)
		
--		--select ID, Name from VEXAM where [Institute ID] = @EXAM_ENTRY_HD_ID and
--		--	[Branch ID] = @EXAM_ENTRY_BR_ID and	[Status] ='T' and [Class Plan ID] = @EXAM_ENTRY_CLASS_ID
		
--		--remove distinct keyword infront of subject type id
--		select [Subject Type ID] as ID, [Subject Type] as Name, [Marks Type], Subject from VEXAM_DEF vd
--		where [Term ID] = @EXAM_ENTRY_TERM_ID and [Subject ID] = @EXAM_ENTRY_SUBJECT_ID
--		and PID = (select ID from VEXAM where [Institute ID] = @EXAM_ENTRY_HD_ID and [Branch ID] = @EXAM_ENTRY_BR_ID
--					and Status = 'T' and [Class Plan ID] =@EXAM_ENTRY_CLASS_ID )

		
--		select ID, Name from VEXAM_TEST where [Institute ID] = @EXAM_ENTRY_HD_ID and
--		[Branch ID] = @EXAM_ENTRY_BR_ID and	[Status] ='T' and [Class ID] in (select ID from @tbl_ClassIDandName)
--		and Term = @EXAM_ENTRY_TERM_ID and [Subject] = @EXAM_ENTRY_SUBJECT_ID and [Class ID] = @EXAM_ENTRY_CLASS_ID
		
--		select SUB_GRADE_ID as ID, SUB_GRADE_NAME as Name from SUBJECT_GRADE_INFO where SUB_GRADE_HD_ID = @EXAM_ENTRY_HD_ID and SUB_GRADE_BR_ID = @EXAM_ENTRY_BR_ID and SUB_GRADE_STATUS = 'T'
		


--	--	if exam then below
--	if @EXAM_ENTRY_EXAM_TYPE='Exam' and @STATUS='A'
--	begin
		
--	select APPROVAL_RANK as Rank,APPROVAL_DESIGNATION+' - '+ t.TECH_FIRST_NAME  as [Name + Designation] from EXAM_APPROVAL_SETTINGS 
-- inner join TEACHER_INFO t on APPROVAL_STAFF_ID=t.TECH_ID
-- where APPROVAL_RANK<=@rank and APPROVAL_HD_ID = @EXAM_ENTRY_HD_ID and APPROVAL_BR_ID = @EXAM_ENTRY_BR_ID and APPROVAL_STATUS = 'T'
-- union
-- select 0, t.TECH_DESIGNATION+ ' - ' + t.TECH_FIRST_NAME from SCHOOL_PLANE_DEFINITION spd
-- join TEACHER_INFO t on spd.DEF_TEACHER=t.TECH_ID
-- where DEF_CLASS_ID=@EXAM_ENTRY_CLASS_ID and DEF_TERM=@EXAM_ENTRY_TERM_ID and DEF_SUBJECT=@EXAM_ENTRY_SUBJECT_ID and DEF_STATUS = 'T'
		
-- end
-- else
-- begin
-- select '' as Rank,''  as [Name + Designation] 
-- end
-- select @isEnabled as [Is Admin Enter Marks]
-- --else then only structure
 
-- if (select COUNT(*) from SCHOOL_PLANE_DEFINITION where DEF_SUBJECT = @EXAM_ENTRY_SUBJECT_ID and  DEF_CLASS_ID = @EXAM_ENTRY_CLASS_ID and DEF_IS_COMPULSORY = 0 and DEF_STATUS = 'T') > 0
-- BEGIN
--	select * from STUDENT_ELECTIVE_SUBJECT where STD_ELE_SUB_SUBJECT_ID = @EXAM_ENTRY_SUBJECT_ID
-- END
-- ELSE
-- BEGIN
--	select 'Compulsory' as Compulsory
-- END
 
-- --
--     END


--	 -- change log

--	 -- hardcoded rank and designation for test, 
--	 -- hardcoded enabled and visible table for tests
--	 -- if status is a then run the code in if examtype ='Exam'