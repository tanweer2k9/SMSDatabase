
CREATE PROC [dbo].[rpt_EXAM_ANNUAL_ACADEMIC_DETAIL]
@dt dbo.[type_EXAM_ANNUAL_ACADEMIC_DETAIL_TABLE] readonly


AS



--insert into @dt_parent 
--select * from dt_parent

declare @dt_child table ([Std ID] [int] NULL,
	[Subject] [nvarchar](100) NULL,
	[Total Marks] [nvarchar](100) NULL,
	[Obtained Marks] [nvarchar](100) NULL,
	[Pass Marks] [nvarchar](100) NULL,
	[Percent] [nvarchar](100) NULL,
	[Grade] [nvarchar](100) NULL,
	[Position] [nvarchar](100) NULL,
	[Max Marks] [nvarchar](100) NULL,
	[No of Std] [nvarchar](100) NULL,
	[term_id] [int] NULL,
	[Final Term %age] [float] NULL,
	[Reamrks] [nvarchar](100) NULL,
	[Next Term %age] [float] NULL,
	[Term Rank] [int] NULL,
	[Marks Type] [nvarchar](100) NULL,
	[Class ID] [int] NULL,
	[Assignment] [float] NULL,
	[Quiz] [float] NULL,
	[Presentation] [float] NULL,
	[Test] [float] NULL
	)
	

insert into @dt_child
select * from @dt


declare @count int = 0
declare @i int = 1
declare @std_id int = 0
declare @class_id  numeric = 0
declare @subject nvarchar(100) = ''
declare @subject_id numeric = 0
declare @term_id int = 0
declare @quiz float =0 
declare @test float =0
declare @assignment float =0
declare @presentation float =0



declare @tbl_test_marks table ([TotalMarks] float, [ObtainMarks] float, [PassMarks] float, Perent float, [Type] nvarchar(50))



set @count = (select COUNT(*) from @dt_child)

WHILE @i<=@count
BEGIN
	select @subject = Subject,@class_id = [Class ID], @term_id = term_id,@std_id = [Std ID] from (select ROW_NUMBER() over(order by [Std ID]) as sr, * from @dt_child)A where sr = @i
	select top(1) @subject_id = SUB_ID from SUBJECT_INFO where SUB_NAME = @subject and SUB_STATUS = 'T' and SUB_BR_ID = (select top(1) CLASS_BR_ID from SCHOOL_PLANE where CLASS_ID = @class_id and CLASS_STATUS = 'T')

	insert into @tbl_test_marks 
	select * from dbo.[CALCULATE_EXAM_TEST_MARKS_FOR_ACADEMIC_DETAIL] (@class_id,@subject_id,@term_id,@std_id)

	select @test = ObtainMarks from @tbl_test_marks where Type = 'Test'
	select @quiz = ObtainMarks from @tbl_test_marks where Type = 'Quiz'
	select @presentation = ObtainMarks from @tbl_test_marks where Type = 'Presentation'
	select @assignment = ObtainMarks from @tbl_test_marks where Type = 'Assignment'

	update @dt_child set Quiz = @quiz, Presentation = @presentation, Assignment =@assignment,Test = @test where term_id =@term_id and Subject = @subject and [Std ID] = @std_id

 	set @i = @i + 1
END



select * from @dt_child


--declare @dt_annual table ([Std ID] int, Subject nvarchar(100), [Total Marks] nvarchar(30), [Obtained Marks] nvarchar(30),[Pass Marks] nvarchar(30), Term int, [Term Rank] int,[Next Term age] float, [Final Term age] float, [Percent] nvarchar(10), Grade nvarchar(10), [Marks Type] nvarchar(20), [Class ID] int, [Grace Numbers] float, Position int, [Total Position] int, [Max Marks] float, Remarks nvarchar(20))
--declare @dt_percent table ([Std ID] int,  Term int, [Class ID] int, [Total Marks] nvarchar(30), [Obtained Marks] nvarchar(30), [Pass Marks] nvarchar(30),[Percent] float)

--declare @term_rank_count int = 0
--declare @term_rank int = 0
--declare @std_count int = 0
--declare @std_id int = 0
--declare @subject_count int = 0
--declare @subject nvarchar(100) = ''
--declare @subject_id numeric = 0
--declare @term_id int = 0
--declare @total_marks nvarchar(20) = ''
--declare @obtain_marks nvarchar(20) = ''
--declare @pass_marks nvarchar(20) = ''
--declare @annual_pass_marks float = 0
--declare @annual_total_marks float = 0
--declare @annual_obtain_marks float = 0
--declare @next_term_age float = 0
--declare @final_term_age float = 0
--declare @marks_type nvarchar(50) = ''
--declare @calculated nvarchar(50) = 'Calculated'
--declare @actual nvarchar(50) = 'Actual'
--declare @decimal_places int = 0
--declare @class_id int = 0
--declare @grace_numbers int = 0
--declare @fail_limit int = 0
--declare @test_total_marks float = 0
--declare @test_pass_marks float = 0
--declare @test_obtain_marks float = 0
--declare @test_percent float = 0
--declare @tbl_test_marks table ([TotalMarks] float, [ObtainMarks] float, [PassMarks] float, Perent float, [Type] nvarchar(50))


--declare @next_term_calculated_actual nvarchar(50)= 'Actual'
--declare @i int = 2
--declare @j int = 1
--declare @k int = 1
--declare @count_previous_term_rank int = 0

--select @term_rank_count = count([Term Rank]) from (select [Term Rank] from @dt_child group by [Term Rank])A



--insert into @dt_annual
--select [Std ID], Subject, [Total Marks], [Obtained Marks], [Pass Marks],term_id, [Term Rank], [Next Term %age],[Final Term %age],0,'',[Marks Type],[Class ID],0,0,0,0,''  from @dt_child where [Term Rank] = 1

--while @i <= @term_rank_count
--begin
--set @term_rank = @i
--	select @std_count = count([Std ID]) from (select [Std ID] from @dt_child where [Term Rank] = @i group by [Std ID])A
--	set @j = 1
--	while @j <= @std_count
--	begin
--		select @std_id = [Std ID] from (select [Std ID] from (select ROW_NUMBER() over (order by ([Std ID]))as sr, [Std ID] from @dt_child where [Term Rank] = @i group by [Std ID])A where sr = @j)B		
--		select @subject_count = COUNT(Subject) from @dt_child where [Term Rank] = @term_rank and [Std ID] = @std_id		
--		set @k = 1
--		while @k <= @subject_count 
--		begin
--			select @subject = Subject,@term_id = term_id from (select ROW_NUMBER() over (order by ([Subject]))as sr_sb, Subject,term_id from @dt_child where [Term Rank] = @term_rank and [Std ID] = @std_id)A where sr_sb = @k
			
--			set @count_previous_term_rank = 0
--			set @total_marks = '-'
--			set @obtain_marks = '-'
--			set @pass_marks = '-'
--			set @next_term_age = 0
--			set @final_term_age = 0
--			set @class_id = 0
			
--			if @next_term_calculated_actual = @actual
--			begin
--				select @count_previous_term_rank = COUNT(@total_marks) from @dt_child where [Std ID] = @std_id and Subject = @subject and [Term Rank] = @term_rank -1
				
--				if @count_previous_term_rank != 0
--				begin				
--					select @total_marks = ISNULL([Total Marks],'-'), @obtain_marks = ISNULL([Obtained Marks],'-'), @pass_marks = ISNULL([Pass Marks],'-'),@next_term_age = ISNULL([Next Term %age],0), 
--					@final_term_age = ISNULL([Final Term %age],0), @class_id = ISNULL([Class ID], 0) from @dt_child where [Std ID] = @std_id and Subject = @subject and [Term Rank] = @term_rank -1
--				end
--			end
--			else 
--			begin
--				select @count_previous_term_rank = COUNT(@total_marks) from @dt_child where [Std ID] = @std_id and Subject = @subject and [Term Rank] = @term_rank -1
--				if @count_previous_term_rank != 0
--				begin
--					select @total_marks = ISNULL([Total Marks],'-'), @obtain_marks = ISNULL([Obtained Marks],'-'), @pass_marks = ISNULL([Pass Marks],'-'),@next_term_age = ISNULL([Next Term age],0), 
--					@final_term_age = ISNULL([Final Term age],0), @class_id = ISNULL([Class ID], 0) from @dt_annual where [Std ID] = @std_id and Subject = @subject and [Term Rank] = @term_rank -1
--				end
--			end		
			
--			if @class_id = 0
--				select @class_id = [Class ID] from @dt_child where [Std ID] = @std_id
--				select top(1) @subject_id = SUB_ID from SUBJECT_INFO where SUB_NAME = @subject and SUB_STATUS = 'T' and SUB_BR_ID = (select top(1) CLASS_BR_ID from SCHOOL_PLANE where CLASS_ID = @class_id and CLASS_STATUS = 'T')

--delete from @tbl_test_marks

--insert into @tbl_test_marks 
--select * from dbo.[CALCULATE_EXAM_TEST_MARKS] (@class_id,@subject_id,@term_id,@std_id)

--select @test_total_marks = SUM(TotalMarks), @test_pass_marks = SUM(PassMarks), @test_obtain_marks = SUM(ObtainMarks),@test_percent = SUM(Perent) from @tbl_test_marks

--			insert into @dt_annual 
--			select [Std ID], Subject,
--			--CASE WHEN @next_term_age > 0 and (@total_marks LIKE '%[0-9]%' or [Total Marks] LIKE '%[0-9]%') THEN 
--			(CAST((
--			CAST(ISNULL((CASE WHEN @total_marks LIKE '%[0-9]%' THEN CAST((@total_marks) As float) * @next_term_age / 100 ELSE 0 END),0) as float) + @test_total_marks +
--			CAST(ISNULL((CASE WHEN [Total Marks] LIKE '%[0-9]%' THEN (100 - @next_term_age - @test_percent) * CAST(([Total Marks]) As float)/ 100 ELSE 0 END),0) as float)
--			) as nvarchar(50)))
--			--ELSE [Total Marks]END
--			 as [Total Marks],
			

--			--Commented Due to when not taken 
--			--CASE WHEN @next_term_age > 0 and ((@obtain_marks != 'Not Taken' and @obtain_marks != 'Not Entered' and @obtain_marks != 'Absent') or ([Obtained Marks] != 'Not Taken' and [Obtained Marks] != 'Not Entered' and [Obtained Marks] != 'Absent')) THEN 
--			--(CAST((CAST(ISNULL((CASE WHEN @obtain_marks LIKE '%[0-9]%' THEN CAST((@obtain_marks) As float)  ELSE dbo.get_SUBJECT_GRADE_ID (@obtain_marks,@std_id) END * @next_term_age / 100.00 ),0) as float) + 
--			--CAST(ISNULL(((CASE WHEN [Obtained Marks] LIKE '%[0-9]%' THEN CAST(([Obtained Marks]) As float) ELSE dbo.get_SUBJECT_GRADE_ID ([Obtained Marks],@std_id) END) * (100.00 - @next_term_age)/ 100.00 ),0) as float)
--			--) as nvarchar(50))) 
--			--ELSE [Obtained Marks] END
--			--as [Obtained Marks],

--			CAST(
--			((CASE WHEN @obtain_marks LIKE '%[0-9]%' THEN @obtain_marks ELSE 0 END) * (@next_term_age / 100.00 )) + 
--			@test_obtain_marks + 
--			((CASE WHEN [Obtained Marks] LIKE '%[0-9]%' THEN [Obtained Marks] ELSE 0 END) * ((100.00 - @next_term_age - @test_percent)/ 100.00 )) 
--			as nvarchar(50))

--			as [Obtained Marks]
--			,
			
--			CAST(
--			((CASE WHEN @pass_marks LIKE '%[0-9]%' THEN @pass_marks ELSE 0 END) * (@next_term_age / 100.00 )) + 
--			@test_pass_marks + 
--			((CASE WHEN [Pass Marks] LIKE '%[0-9]%' THEN [Pass Marks] ELSE 0 END) * ((100.00 - @next_term_age - @test_percent)/ 100.00 )) 
--			as nvarchar(50))

--			--CASE WHEN @next_term_age > 0 and (@pass_marks LIKE '%[0-9]%' or [Pass Marks] LIKE '%[0-9]%') THEN 
--			--(CAST((
--			--CAST(ISNULL((CASE WHEN @pass_marks LIKE '%[0-9]%' THEN CAST((@pass_marks) As float) * @next_term_age / 100 ELSE 0 END),0) as float) +
--			--CAST(ISNULL((CASE WHEN [Pass Marks] LIKE '%[0-9]%' THEN (100 - @next_term_age) * CAST(([Pass Marks]) As float)/ 100 ELSE 0 END),0) as float)
--			--) as nvarchar(50)))
--			--ELSE [Pass Marks]END
--			 as [Pass Marks],
			
--			term_id, [Term Rank], [Next Term %age],[Final Term %age],0,'', [Marks Type], @class_id,0,0,0,0,''
			
--			from @dt_child where [Term Rank] = @i and [Std ID] = @std_id and Subject = @subject

--			set @k = @k + 1
--		end
		
--		set @j = @j + 1
--	end
	
--	set @i = @i + 1
--end






--set @i = 1
--set @j = 1
--set @k = 1


--select @std_count = count([Std ID]) from (select [Std ID] from @dt_annual group by [Std ID])A


--While @i <= @std_count
--begin	
--	select @std_id = [Std ID] from (select [Std ID] from (select ROW_NUMBER() over (order by ([Std ID]))as sr, [Std ID] from @dt_annual group by [Std ID])A where sr = @i)B		
--	select @subject_count = COUNT(*) from( select [Subject]from  @dt_annual where [Std ID] = @std_id group by [Subject])A
--	set @j = 1
--	while @j <= @subject_count
--	begin
--		select @subject = Subject from (select ROW_NUMBER() over (order by ([Subject]))as sr_sb, [Subject] from(select Subject from @dt_annual where [Std ID] = @std_id group by [Subject])A)B where sr_sb = @j
--		select @term_rank_count = COUNT([Term Rank]) from @dt_annual where [Std ID] = @std_id and Subject = @subject		
--		set @k = 1
--		set @total_marks = '-'
--		set @obtain_marks = '-'
--		set @final_term_age = 0
--		set @annual_obtain_marks = 0
--		set @annual_total_marks = 0
--		set @annual_pass_marks = 0
--		set @grace_numbers = 0
--		set @fail_limit = 0
--		set @class_id = 0
--		while @k <= @term_rank_count
--		begin
--			select @term_rank = [Term Rank] from (select ROW_NUMBER() over (order by (select 0))as sr_rn, [Term Rank] from @dt_annual where [Std ID] = @std_id and Subject = @subject)A where sr_rn = @k
			
--			select @total_marks = ISNULL([Total Marks],'-'), @obtain_marks = ISNULL([Obtained Marks],'-'), @pass_marks = ISNULL([Pass Marks],'-'),@final_term_age = ISNULL([Final Term age],0), @marks_type = ISNULL([Marks Type],'Numbers'), @class_id = ISNULL([Class ID],0) from @dt_annual where [Std ID] = @std_id and Subject = @subject and [Term Rank] = @term_rank
			
--			if @total_marks LIKE '%[0-9]%' and @final_term_age > 0
--				begin
--					set @annual_total_marks +=  (dbo.CSTF(@total_marks) * @final_term_age / 100)
--				end
--			else
--				begin
--					set @annual_total_marks += 0
--				end
			
			
--			if @obtain_marks LIKE '%[0-9]%' and @final_term_age > 0
--				begin
--					set @annual_obtain_marks +=  (dbo.CSTF(@obtain_marks) * (@final_term_age / 100))
--				end
--			else
--				begin
--					if @obtain_marks != 'Not Taken' and @obtain_marks != 'Not Entered' and @obtain_marks != 'Absent' and @obtain_marks != '-'
--						begin
--							set @annual_obtain_marks += dbo.get_SUBJECT_GRADE_ID(@obtain_marks, @std_id) * (@final_term_age / 100)
--						end					
--					else
--						begin
--							set @annual_obtain_marks += 0
--						end
--				end			
			
--			if @pass_marks LIKE '%[0-9]%' and @final_term_age > 0
--				begin
--					set @annual_pass_marks +=  (dbo.CSTF(@pass_marks) * @final_term_age / 100)
--				end
--			else
--				begin
--					set @annual_pass_marks += 0
--				end
			
--			set @k = @k + 1
--		end
		
--		set @grace_numbers = 3
--		--pending grace numbers
--		--(select ed.EXAM_DEF_GRACE_NUMBERS from EXAM ex join EXAM_DEF ed on ed.EXAM_DEF_PID = ex.EXAM_ID
--		--where EXAM_CLASS_PLAN_ID = @class_id and ed.)
		

		
--		insert into @dt_annual 
--		select @std_id, @subject,  
--		CASE WHEN @marks_type = 'Grade' THEN '-' ELSE dbo.CFTS(@annual_total_marks) END,
--		CASE WHEN @marks_type = 'Grade' THEN dbo.get_SUBJECT_GRADE_NAME(dbo.CFTS(@annual_obtain_marks)) ELSE dbo.CFTS(@annual_obtain_marks) END,
--		CASE WHEN @marks_type = 'Grade' THEN '-' ELSE dbo.CFTS(@annual_pass_marks) END, 0, 0, 0,0,0,'',@marks_type, @class_id,@grace_numbers,0,0,0,''
		
--		set @j = @j + 1
--	end
	
--	set @i = @i + 1
--end







--update @dt_annual set 
--[Total Marks] = CAST(ROUND(CAST(([Total Marks]) as float), @decimal_places) AS float)
--where [Total Marks]  LIKE '%[0-9]%'

--update @dt_annual set 
--[Obtained Marks] = CAST(ROUND(CAST(([Obtained Marks]) as float), @decimal_places) AS float)
--where [Obtained Marks]  LIKE '%[0-9]%'

--update @dt_annual set 
--[Pass Marks] = CAST(ROUND(CAST(([Pass Marks]) as float), @decimal_places) AS float)
--where [Pass Marks]  LIKE '%[0-9]%'

--update @dt_annual set [Obtained Marks] = '-' where [Obtained Marks] = ''

--update @dt_annual set [Percent] = (CASE WHEN [Obtained Marks] LIKE '%[0-9]%' and [Total Marks] LIKE '%[0-9]%' and [Total Marks] != '0'
--THEN dbo.CFTS((ROUND(dbo.CSTF([Obtained Marks]) * 100 / dbo.CSTF([Total Marks]),2))) ELSE '-' END)
--where [Total Marks] LIKE '%[0-9]%' and [Obtained Marks] LIKE '%[0-9]%'


--update @dt_annual set Grade = dbo.get_GRADE_NAME([Class ID], 
--(CASE WHEN [Percent] LIKE '%[0-9]%' THEN dbo.CSTF([Percent]) ELSE 0 END))
--where [Total Marks] LIKE '%[0-9]%' and [Obtained Marks] LIKE '%[0-9]%'


--update @dt_annual set Grade = '-' where Grade = ''



----dt annual 
--update @dt_annual set Remarks = 'delete' where Term = 0


--insert into @dt_annual
--select *, MAX(Position) OVER (PARTITION BY [Class ID],Term,[Subject]) AS [Total Positions],
--MAX(CASE WHEN [Obtained Marks] LIKE '%[0-9]%' THEN dbo.CSTF([Obtained Marks]) ELSE 0 END) OVER (PARTITION BY [Class ID],Term,[Subject]) AS [Max Marks],
-- CASE WHEN [Obtained Marks] LIKE '%[0-9]%' and [Pass Marks] LIKE '%[0-9]%' THEN 
--(CASE WHEN dbo.CSTF([Obtained Marks]) + [Grace Numbers] >= dbo.CSTF([Pass Marks]) 
-- THEN (CASE WHEN dbo.CSTF([Obtained Marks]) >= dbo.CSTF([Pass Marks]) THEN 'Pass' ELSE '*Pass' END)
-- ELSE 'Fail' END
-- )
-- ELSE '-' END as Remarks
--from
--(
--select [Std ID], Subject,[Total Marks], [Obtained Marks],[Pass Marks], Term, [Term Rank], [Next Term age], [Final Term age],
--[Percent], Grade, [Marks Type], [Class ID], [Grace Numbers],
--dense_rank() over (PARTITION BY [Class ID],Term,[Subject] ORDER BY [Obtained Marks] DESC) as Position 
--from @dt_annual where Term = 0
--)B

----select [Std ID], from @dt_annual where Term = 0 group by [Class ID]


--delete from @dt_annual where Term = 0 and Remarks = 'delete'
--update @dt_annual set [Obtained Marks] = 'Ab', [Total Marks] = '-' where [Obtained Marks] = 'Absent'
--update @dt_annual set [Obtained Marks] = '-', [Total Marks] = '-' where [Obtained Marks] = 'Not Entered'
--select * from @dt_annual
----dt percent
--insert into @dt_percent 

--select [Std ID], Term, [Class ID], [Total Marks], [Obtained Marks], [Pass Marks],CASE WHEN [Total Marks] = '0' THEN 0 ELSE ROUND(dbo.CSTF([Obtained Marks]) * 100 / dbo.CSTF([Total Marks]),2) END as Percentage 
--from(

--select [Std ID], MAX(Term) as Term, [Class ID],dbo.CFTS(SUM(dbo.CSTF([Total Marks]))) as [Total Marks], dbo.CFTS(SUM(dbo.CSTF([Obtained Marks]))) as [Obtained Marks],
--dbo.CFTS(SUM(dbo.CSTF([Pass Marks]))) as [Pass Marks] from
--(
--select [Std ID], Subject,CASE WHEN [Total Marks] LIKE '%[0-9]%' THEN [Total Marks] ELSE '0' END as [Total Marks],
--CASE WHEN [Obtained Marks] LIKE '%[0-9]%' THEN [Obtained Marks] ELSE '0' END as [Obtained Marks],
--CASE WHEN [Pass Marks] LIKE '%[0-9]%' THEN [Pass Marks] ELSE '0' END as [Pass Marks],Term,[Class ID]
--from @dt_annual
--)H group by [Class ID], Term,[Std ID]
--)I

--select [Std ID], Term, TERM_RANK as [Term Rank],TERM_NAME as [Term Name],[Percent] from @dt_percent dtp join TERM_INFO t on t.TERM_ID = dtp.Term
--union 
--select [Std ID], Term, 0 as [Term Rank],'Annual Term' as [Term Name],[Percent] from @dt_percent dtp where Term = 0



----parent table information

--select Session, Class, Term, '' as [Term Duration], T.[Std ID], [Std Name], [Std Roll#],T.[Total Marks],
--[Obtained Marks] as [Grand Total], [Percent], [No of Std], Position, Grade, [Total Days], [Total Working Days],
--Present, Absent,Leave,Late,T.[Max Marks],0 as term_id, class_id,Section,Shift,T.[Pass Marks],T.Remarks,
--[Total Positions], [Parent ID], [HD ID], [BR ID], B.[Std Image]
----,  grace_count, fail_count,fail_limit,total_limit

--  from 
--(select *, MAX(Position) OVER (PARTITION BY [Class ID],Term) AS [Total Positions], 
--COUNT(*) OVER (PARTITION BY [Class ID],Term) AS [No of Std], MAX([Obtained Marks]) OVER (PARTITION BY [Class ID],Term) AS [Max Marks],
--CASE WHEN [Percent] > 0 THEN dbo.get_GRADE_NAME([Class ID], [Percent]) ELSE '-' END as Grade
-- from 
--(
--select [Std ID], Term,[Class ID],[Obtained Marks], [Total Marks] ,[Pass Marks],[Percent], grace_count, fail_count,fail_limit,total_limit,
--CASE WHEN grace_count + fail_count > total_limit and fail_count > fail_limit THEN dbo.set_GRACE_FAIL(grace_count, 'G') + dbo.set_GRACE_FAIL(fail_count, 'F') + 'Fail' ELSE dbo.set_GRACE_FAIL(grace_count, 'G') + dbo.set_GRACE_FAIL(fail_count, 'F')  + 'Pass' END as Remarks,

--dense_rank() over (PARTITION BY [Class ID],Term ORDER BY [Obtained Marks] DESC) as Position

-- from
--(
--select p.*, ISNULL(ex.EXAM_FAIL_LIMIT,0) as fail_limit, ISNULL(ex.EXAM_FAIL_AND_GRACE_LIMIT,0) as total_limit,
--CASE WHEN [Std ID] > 0 THEN (select COUNT(Remarks) from @dt_annual dta where dta.[Std ID] = p.[Std ID] and dta.Term = 0 and Remarks = 'Fail') ELSE 0 END as fail_count,
--CASE WHEN [Std ID] > 0 THEN (select COUNT(Remarks) from @dt_annual dta where dta.[Std ID] = p.[Std ID] and dta.Term = 0 and Remarks = '*Pass') ELSE 0 END as grace_count
--from @dt_percent p 
--join EXAM ex on ex.EXAM_CLASS_PLAN_ID = p.[Class ID]
--where Term = 0
--)W
--)R
--)T

--join 


--(select A.*, s.STDNT_IMG  as [Std Image] from 
--(select [Session], class_id, [Std ID],[Std Name], Class,[Std Roll#],Shift,Section, [Parent ID],[HD ID],[BR ID],
--SUM([Total Days]) as [Total Days], SUM([Total Working Days]) as [Total Working Days], SUM(Present) as Present,
--SUM([Absent]) as [Absent], SUM(Leave) as Leave, SUM(Late) as Late
--from @dt_parent 
--group by [Session], class_id, Class,[Std ID], [Std Name], [Std Roll#],Shift,Section, [Parent ID],[HD ID],[BR ID])A

--join STUDENT_INFO s on s.STDNT_ID = A.[Std ID])B on B.[Std ID] = T.[Std ID]