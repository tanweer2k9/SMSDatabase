

CREATE PROC [dbo].[sp_EXAM_GRAND_MARKSHEET]
--@SESSION_START_DATE date,
--@SESSION_END_DATE date,
@CLASS_ID numeric ,
@TERM_ID numeric, 
@LOGIN_ID numeric,
@SessionId numeric 
AS 
BEGIN
declare @one int = 1

--declare @HD_ID numeric = 2
--declare @BR_ID numeric = 1
--declare @SESSION_START_DATE date = '2013-01-01'
--declare @SESSION_END_DATE date = '2014-04-01'
--declare @CLASS_ID numeric = 3
--declare @TERM_ID numeric = 3
--declare @LOGIN_ID numeric = 2

select * from VPARENT_INFO where [Status] = 'T'

--select ID, [Institute ID] as [HD ID], [Branch ID] as [BR ID],Name,Section,Shift from VSCHOOL_PLANE 

--where [Session Start Date] = @SESSION_START_DATE 
--and [Session End Date] = @SESSION_END_DATE and [Status] = 'T'


--if @SESSION_START_DATE = '1900-01-01'
--begin
--	set @SESSION_START_DATE = ( select top (1) BR_ADM_ACCT_START_DATE from BR_ADMIN) 
--	set @SESSION_END_DATE = ( select top (1) BR_ADM_ACCT_END_DATE from BR_ADMIN) 
--end

declare @user_type nvarchar(50)= ''
declare @user_id int = 0
select @user_id = USER_CODE, @user_type = USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID




if @user_type = 'Teacher'
begin
	if @CLASS_ID = 0
	begin
		set @CLASS_ID = (select top(1) CLASS_ID from SCHOOL_PLANE where CLASS_TEACHER = @user_id)
	end



	select ID, [Institute ID] as [HD ID], [Branch ID] as [BR ID],Name,Section,Shift,[Is Subject Attendance] from VSCHOOL_PLANE 
	join SCHOOL_PLANE on ID = CLASS_ID
	where [Session Id] = @SessionId and [Status] = 'T' 
	and CLASS_TEACHER = @user_id Order by [Order]
end
else if @user_type = 'Student'
begin

	set @CLASS_ID = (select top(@one) STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_ID = @user_id)

	set @SessionId = (select top(@one) CLASS_SESSION_ID from SCHOOL_PLANE where CLASS_ID = @CLASS_ID)

	select ID, [Institute ID] as [HD ID], [Branch ID] as [BR ID],Name,Section,Shift,[Is Subject Attendance] 
	from VSCHOOL_PLANE 
	join STUDENT_INFO on STDNT_CLASS_PLANE_ID = ID
	where  [Status] = 'T' 	
	and STDNT_ID = @user_id Order by [Order]
end
else if @user_type = 'Parent'
begin
	if @CLASS_ID = 0
	begin
		set @CLASS_ID = (select top(1) STDNT_CLASS_PLANE_ID from STUDENT_INFO where STDNT_PARANT_ID = @user_id)
	end

	set @SessionId = (select top(@one) CLASS_SESSION_ID from SCHOOL_PLANE where CLASS_ID = @CLASS_ID)

	select ID, [Institute ID] as [HD ID], [Branch ID] as [BR ID],Name,Section,Shift,[Is Subject Attendance] from VSCHOOL_PLANE 
	join STUDENT_INFO on ID = STDNT_CLASS_PLANE_ID
	where  [Status] = 'T' 
	and STDNT_PARANT_ID = @user_id Order by [Order]
end
else 
begin
	select ID, [Institute ID] as [HD ID], [Branch ID] as [BR ID],Name,Section,Shift,[Is Subject Attendance] from VSCHOOL_PLANE 
	where [Session Id] = @SessionId and [Status] = 'T' Order by [Order]
end


if @CLASS_ID = NULL
begin
	set @CLASS_ID = -1
end
if @CLASS_ID = 0
begin
	set @CLASS_ID = (select top(1) ID from VSCHOOL_PLANE where [Session Id] = @SessionId and [Status] = 'T')
end
select distinct ([Term ID]) as ID, Term as Name, TERM_RANK as [Rank], TERM_START_DATE [Start Date],  TERM_END_DATE [End Date] from VSCHOOL_PLANE_DEFINITION join TERM_INFO on [Term ID] = TERM_ID where [Class ID] = @CLASS_ID and Status = 'T' order by TERM_RANK



if @TERM_ID = 0
begin
	set @TERM_ID = (select top(1) ID from (select distinct ([Term ID]) as ID, Term as Name, TERM_RANK as [Rank] from VSCHOOL_PLANE_DEFINITION join TERM_INFO on [Term ID] = TERM_ID where [Class ID] = @CLASS_ID and Status = 'T')A order by A.[Rank])
end


--Max Marks is added instead of total Marks
--declare @total_marks float = (select SUM(ed.EXAM_DEF_TOTAL_MARKS) from EXAM_DEF ed 
--join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
--where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_STATUS = 'T')



declare @query varchar(max)= ''
declare @query2 nvarchar(max)= ''
declare @final_query varchar(max) = ''
declare @subject_names varchar(max) = ''
declare @subject_names_sum varchar(max) = ''
declare @subject_names_individual_sum varchar(max) = ''
declare @subject_names_isnull varchar(max) = ''

declare @t table([Subject] varchar(100), [Subject Name] varchar(100), [Subject Description] varchar(100),[Subject Type] varchar(100),[Total Marks] float, [Pass Marks] float, [Subject Parts] int, [Next Term %age] float,[Final Term %age] float,[Marks Type] nvarchar(50), [Grace Numbers] float)
create table #grand_exam_total (ID int,StdNo int,House nvarchar(1),Name nvarchar(100), [Subject] nvarchar(100), [Obtain Marks] float,Roll# int, [Parent ID] int,
[Institute ID] int, [Branch ID] int, [Minus Marks] int )
create table #grand_exam_minus (ID int, [Minus Marks] int )
create table #total_marks (ID int, [Max Marks] float)

insert into #total_marks
select EXAM_ENTRY_STUDENT_ID, SUM(EXAM_DEF_TOTAL_MARKS) from 
(
select EXAM_ENTRY_STUDENT_ID, case when EXAM_ENTRY_OBTAIN_MARKS = -2 then 0 else EXAM_DEF_TOTAL_MARKS END as EXAM_DEF_TOTAL_MARKS from 
(
select * from EXAM_DEF ed 
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join EXAM_ENTRY en on ed.EXAM_DEF_ID = en.EXAM_ENTRY_PLAN_EXAM_ID
where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_STATUS = 'T'
)A )B
group by EXAM_ENTRY_STUDENT_ID


-- insert into @t table
insert into @t 
select Subject,[Subject Name],[Subject Description] ,[Subject Type], [Total Marks], [Pass Marks],[Subject Parts], [Next Term %age] ,[Final Term %age], [Marks Type], [Grace Numbers] from 
(select (Subject + ' ' + [Subject Type])  as Subject, Subject as [Subject Name], [Subject Description],[Subject Type], [Total Marks], [Pass Marks], [Subject Parts], [Next Term %age] ,[Final Term %age], [Marks Type], [Grace Numbers] from 
(select sb.SUB_NAME as Subject,SUB_DESC [Subject Description], CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID = 0 THEN 'Whole' ELSE
        (SELECT SUBJECT_TYPE_NAME
      FROM SUBJECT_TYPE_INFO
      WHERE SUBJECT_TYPE_ID = EXAM_DEF_SUBJECT_TYPE_ID) 
    END AS [Subject Type], ed.EXAM_DEF_TOTAL_MARKS as [Total Marks], (ed.[EXAM_DEF_PASS_%AGE] * ed.EXAM_DEF_TOTAL_MARKS)/100 as [Pass Marks],
	1 as [Subject Parts], ed.[EXAM_DEF_NEXT_TERM_%AGE] as [Next Term %age],ed.[EXAM_DEF_FINAL_%AGE] as [Final Term %age], ed.EXAM_DEF_MARKS_TYPE as [Marks Type], ed.EXAM_DEF_GRACE_NUMBERS as [Grace Numbers]
from EXAM_DEF ed
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID =@CLASS_ID

union all
select Subject, [Subject Type], [Subject Description],SUM([Total Marks]) as [Total Marks], SUM([Pass Marks]) as [Pass Marks],[Subject Parts], MAX([Next Term %age]) as [Final Term %age],MAX([Final Term %age]) as [Final Term %age], [Marks Type],[Grace Numbers]  from 
(select sb.SUB_NAME as Subject,sb.SUB_DESC [Subject Description], CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 'Whole' ELSE 'some'
    END AS [Subject Type], CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 
     ed.EXAM_DEF_TOTAL_MARKS ELSE 0 END AS [Total Marks], (ed.[EXAM_DEF_PASS_%AGE] * ed.EXAM_DEF_TOTAL_MARKS)/100 as [Pass Marks],
     2 as [Subject Parts], ed.[EXAM_DEF_NEXT_TERM_%AGE] as [Next Term %age],ed.[EXAM_DEF_FINAL_%AGE] as [Final Term %age], ed.EXAM_DEF_MARKS_TYPE as [Marks Type],ed.EXAM_DEF_GRACE_NUMBERS as [Grace Numbers]

from EXAM_DEF ed
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID =@CLASS_ID)A 
where A.[Subject Type] = 'Whole' group by A.Subject, A.[Subject Description],A.[Subject Type],A.[Subject Parts],A.[Marks Type],A.[Grace Numbers]


union all 


select sb.SUB_NAME, sb.SUB_DESC [Subject Description],'Whole' as [Subject Type],0 as [Total MArks], 0 as [Pass Marks], 1 as [Subject Parts], 0 as [Next Term %age],0 as [Final Term %age], 'Numbers' as [Marks Type], 0 [Grace Numbers]
from SCHOOL_PLANE_DEFINITION pd
join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T'
and sb.SUB_ID not in (select distinct pd.DEF_SUBJECT 
from EXAM_DEF ed 
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM =  @TERM_ID ))R)P

select * from @t order by [Subject Name]


select @subject_names = STUFF((SELECT ',' + QUOTENAME(convert(varchar(50), [Subject], 120))  from @t
					FOR XML PATH(''), TYPE).value('.', 'VARCHAR(max)') ,1,1,'')


select @subject_names_sum = STUFF((SELECT '+' + 'CASE WHEN' + QUOTENAME(convert(varchar(50), [Subject], 120)) + '< 0 THEN 0 ELSE '+ QUOTENAME(convert(varchar(50), [Subject], 120)) + ' END '  from @t where [Subject Parts] != 2 and [Marks Type] != 'Grade' FOR XML PATH(''), TYPE).value('.', 'VARCHAR(max)') ,1,1,'')

--select @subject_names_sum = STUFF((SELECT '+' + QUOTENAME(convert(varchar(50), [Subject], 120)) from @t where [Subject Parts] != 2 and [Marks Type] != 'Grade'
--FOR XML PATH(''), TYPE).value('.', 'VARCHAR(1000)') ,1,1,'')


set @subject_names_sum = 'SUM(' + @subject_names_sum + ' ) as [Grand Total]'


select @subject_names_individual_sum = STUFF((SELECT ',SUM(' + QUOTENAME(convert(varchar(50), [Subject], 120)) + ') as ['+ [Subject] + ']' from @t
FOR XML PATH(''), TYPE).value('.', 'VARCHAR(max)') ,1,1,'')


select @subject_names_isnull = STUFF((SELECT ',ISNULL(' + QUOTENAME(convert(varchar(50), [Subject], 120)) + ',-2) [' + [Subject] + ']' from @t
FOR XML PATH(''), TYPE).value('.', 'VARCHAR(max)') ,1,1,'')



insert into #grand_exam_total
select ID,StdNo,House,Name,(Subject +  ' '+ [Subject Type]) as Subject, [Obtain Marks],Roll#, [Parent ID], [Institute ID], [Branch ID],
		case when [Obtain Marks] <= -1 then -1 * [Obtain Marks] else 0 END as [Minus Marks] from 
		(select et.EXAM_ENTRY_STUDENT_ID as ID, CAST(s.STDNT_SCHOOL_ID as int) as StdNo, SUBSTRING(h.HOUSES_NAME,1,1) House,s.STDNT_FIRST_NAME as Name, sb.SUB_NAME as Subject,

		CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID = 0 THEN 'Whole' ELSE
				(SELECT SUBJECT_TYPE_NAME
			  FROM SUBJECT_TYPE_INFO
			  WHERE SUBJECT_TYPE_ID = EXAM_DEF_SUBJECT_TYPE_ID) 
			END AS [Subject Type], et.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks],
			CASE when s.STDNT_ID < 0 then 0 else (select top(1) STUDENT_ROLL_NUM_ROLL_NO from 
			STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#,
			pr.PARNT_ID as [Parent ID], s.STDNT_HD_ID  as [Institute ID], s.STDNT_BR_ID as [Branch ID],
			0 as [Minus Marks]

		from EXAM_ENTRY et
		join EXAM_DEF ed on et.EXAM_ENTRY_PLAN_EXAM_ID = ed.EXAM_DEF_ID
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
		join STUDENT_INFO s on s.STDNT_ID = et.EXAM_ENTRY_STUDENT_ID
		join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
		join PARENT_INFO pr on pr.PARNT_ID = s.STDNT_PARANT_ID
		join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID

		where p.CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID 

		union all

		select ID,StdNo,House,Name,Subject,[Subject Type],  [Obtain Marks],Roll#,[Parent ID], [Institute ID], [Branch ID],[Minus Marks] from
		(select ID,StdNo,House,Name, Subject, [Subject Type], SUM([Obtain Marks]) + SUM([Minus Marks]) as [Obtain Marks],
		Roll#,[Parent ID], [Institute ID], [Branch ID],SUM([Minus Marks]) as [Minus Marks] from (
		select et.EXAM_ENTRY_STUDENT_ID as ID, CAST(s.STDNT_SCHOOL_ID as int) as StdNo,SUBSTRING(h.HOUSES_NAME,1,1) House,s.STDNT_FIRST_NAME as Name, sb.SUB_NAME as Subject,
		CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 'Whole' ELSE
				'some'
			END AS [Subject Type],  et.EXAM_ENTRY_OBTAIN_MARKS as [Obtain Marks],
		CASE when s.STDNT_ID < 0 then 0 else (select top(1) STUDENT_ROLL_NUM_ROLL_NO from 
			STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#,
			pr.PARNT_ID as [Parent ID], s.STDNT_HD_ID  as [Institute ID], s.STDNT_BR_ID as [Branch ID],
			case when et.EXAM_ENTRY_OBTAIN_MARKS = -1 then 1 else 0 END as [Minus Marks]
		from EXAM_ENTRY et
		join EXAM_DEF ed on et.EXAM_ENTRY_PLAN_EXAM_ID = ed.EXAM_DEF_ID
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
		join STUDENT_INFO s on s.STDNT_ID = et.EXAM_ENTRY_STUDENT_ID
		join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
		join PARENT_INFO pr on pr.PARNT_ID = s.STDNT_PARANT_ID
		join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
		where p.CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID 
		)A where A.[Subject Type] = 'Whole' group by ID, StdNo,House,Name, Roll#,Subject, [Subject Type],[Parent ID], [Institute ID], [Branch ID],[Minus Marks])B

		union all


		select ID, StdNo,House,Name,Subject,[Subject Type],[Obtain Marks], Roll#,[Parent ID], [Institute ID], [Branch ID],[Minus Marks] from
		(select s.STDNT_ID as ID, CAST(s.STDNT_SCHOOL_ID as int) as StdNo,SUBSTRING(h.HOUSES_NAME,1,1) House,s.STDNT_FIRST_NAME as Name, sb.SUB_NAME as Subject, 

		CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID = 0 THEN 'Whole' ELSE
				(SELECT SUBJECT_TYPE_NAME
			  FROM SUBJECT_TYPE_INFO
			  WHERE SUBJECT_TYPE_ID = EXAM_DEF_SUBJECT_TYPE_ID) 
			END AS [Subject Type], 
			-2 [Obtain Marks],  CASE when s.STDNT_ID < 0 then 0 else (select top(1) STUDENT_ROLL_NUM_ROLL_NO from 
			STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#,
			sb.SUB_ID as [Subject ID],pr.PARNT_ID as [Parent ID], s.STDNT_HD_ID  as [Institute ID], s.STDNT_BR_ID as [Branch ID],
			0 as [Minus Marks]

		from EXAM_DEF ed
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID

		join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = pd.DEF_CLASS_ID and s.STDNT_STATUS = 'T'
		join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
		join PARENT_INFO pr on pr.PARNT_ID = s.STDNT_PARANT_ID
		join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
		where p.CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T'

		union all

		select ID,StdNo,House,Name,Subject,[Subject Type], [Obtain Marks],Roll#,[Subject ID],[Parent ID], [Institute ID], [Branch ID],[Minus Marks] from
		(select ID, StdNo,House,Name, Subject, [Subject Type], SUM([Obtain Marks]) as [Obtain Marks], Roll#,[Subject ID],[Parent ID], [Institute ID], [Branch ID],[Minus Marks] from
		(select s.STDNT_ID as ID, CAST(s.STDNT_SCHOOL_ID as int) as StdNo,SUBSTRING(h.HOUSES_NAME,1,1) House,s.STDNT_FIRST_NAME as Name, sb.SUB_NAME as Subject, sb.SUB_ID as [Subject ID],

		CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 'Whole' ELSE 'some'
			END AS [Subject Type],
			-2 [Obtain Marks],  CASE when s.STDNT_ID < 0 then 0 else (select top(1) STUDENT_ROLL_NUM_ROLL_NO from 
			STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#,
			pr.PARNT_ID as [Parent ID], s.STDNT_HD_ID  as [Institute ID], s.STDNT_BR_ID as [Branch ID],0 as [Minus Marks]
		from EXAM_DEF ed
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID

		join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = pd.DEF_CLASS_ID and s.STDNT_STATUS = 'T'
		join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
		join PARENT_INFO pr on pr.PARNT_ID = s.STDNT_PARANT_ID
		join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
		where p.CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T')A
		where A.[Subject Type] = 'Whole' group by ID, StdNo,House,Name,Subject,[Subject ID], [Subject Type],Roll#,[Parent ID], [Institute ID], [Branch ID],[Minus Marks] )B)C 
		where C.[Subject ID] not in 
		(
		select distinct pd.DEF_SUBJECT 
		from EXAM_ENTRY et
		join EXAM_DEF ed on ed.EXAM_DEF_ID = et.EXAM_ENTRY_PLAN_EXAM_ID
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T')

		union all

		select s.STDNT_ID as ID, CAST(s.STDNT_SCHOOL_ID as int) as StdNo,SUBSTRING(h.HOUSES_NAME,1,1) House,s.STDNT_FIRST_NAME as Name, sb.SUB_NAME as Subject,

		'Whole' [Subject Type], -2 [Obtain Marks],  CASE when s.STDNT_ID < 0 then 0 else (select top(1) STUDENT_ROLL_NUM_ROLL_NO from 
			STUDENT_ROLL_NUM r where r.STUDENT_ROLL_NUM_STD_ID = s.STDNT_ID and r.STUDENT_ROLL_NUM_PLAN_ID = @CLASS_ID order by r.STUDENT_ROLL_NUM_ID DESC) END as Roll#,
			pr.PARNT_ID as [Parent ID], s.STDNT_HD_ID  as [Institute ID], s.STDNT_BR_ID as [Branch ID],0 as [Minus Marks]
		    

		from SCHOOL_PLANE_DEFINITION pd
		join SCHOOL_PLANE p on p.CLASS_ID = pd.DEF_CLASS_ID
		join STUDENT_INFO s on s.STDNT_CLASS_PLANE_ID = pd.DEF_CLASS_ID and s.STDNT_STATUS = 'T'
		join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
		join PARENT_INFO pr on pr.PARNT_ID = s.STDNT_PARANT_ID
		join HOUSES_INFO h on h.HOUSES_ID = s.STDNT_HOUSE_ID
		where p.CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T'
		and sb.SUB_ID not in (select distinct pd.DEF_SUBJECT 
		from EXAM_DEF ed 
		join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
		where pd.DEF_CLASS_ID =@CLASS_ID  and pd.DEF_TERM =  @TERM_ID and pd.DEF_STATUS = 'T')

		)A
				
		 insert into #grand_exam_minus  select ID,SUM([Minus Marks]) from #grand_exam_total group by ID
		set @query2 = ';with tbl as 
		(
			select t.ID, t.StdNo,t.House,t.Name, t.Subject, t.[Obtain Marks],t.Roll#, t.[Parent ID], t.[Institute ID],t.[Branch ID],m.[Minus Marks]
			from #grand_exam_total t
			join #grand_exam_minus m on m.ID = t.ID
		)
		,pivot_tbl as
		( select * from tbl

		pivot
		(
		MAX([Obtain Marks])	for [Subject] in(' + @subject_names + '))
		 as final_tbl)
		, full_tbl as 

		(select ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID], SUM([Minus Marks]) as [Minus Marks],' +  @subject_names_individual_sum + '
		 from pivot_tbl

		group by ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID]' + '
		)
		
		,isnull_values as		
		(
			select ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' +  @subject_names_isnull + ', ISNULL([Minus Marks],0) as [Minus Marks]
		 from full_tbl

		group by ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' + @subject_names +',[Minus Marks]
		)
		
		,grand_total_tbl as
		(
			select ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' +  @subject_names + ', ' + @subject_names_sum + '
		 from isnull_values

		group by ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' + @subject_names +'
		)
		,max_marks_tbl as 
		(
			select g.ID,g.StdNo,g.House,g.Name,g.Roll#,g.[Parent ID],g.[Institute ID],g.[Branch ID],' + @subject_names + ', t.[Max Marks],[Grand Total]
			from grand_total_tbl g
			join #total_marks t on t.ID = g.ID
		)
		
		, cent_tble as
		(
		select ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' + @subject_names + ', [Max Marks],[Grand Total], CASE WHEN [Max Marks] = 0 THEN 0 ELSE CONVERT(decimal(8,2), [Grand Total] * 100 / [Max Marks] ) END as [Percent]
		from max_marks_tbl
		group by ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' + @subject_names + ',[Max Marks],[Grand Total]
		) 
		,grade_tbl as
		(
		select ID as [Std ID],StdNo,House,Name as [Student Name],Roll#,[Parent ID], [Institute ID] as [HD ID], [Branch ID] as [BR ID],' + @subject_names + ',[Max Marks], [Grand Total], [Percent],
		case when [Percent] < 0 then ''F'' else dbo.get_GRADE_NAME(' + CONVERT(varchar(50),@CLASS_ID) + ', [Percent]) END as Grade
		from cent_tble
		group by ID,StdNo,House,Name,Roll#,[Parent ID], [Institute ID], [Branch ID],' + @subject_names + ',[Max Marks],[Grand Total], [Percent]
		)
		select ROW_NUMBER() over (order by [StdNo] ) as Sr#,*, dense_rank() over (order by [percent] DESC) as Position from grade_tbl  order by Sr#'

--select @query
--select @query2
--set @final_query = @query2
--select @final_query
exec (@query2)

if @query2 = ''
begin
	select 0
end

-- Subjects not entered the marks
select (Subject + ' ' + [Subject Type]) as Subject from 
(select sb.SUB_NAME as Subject, CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID = 0 THEN 'Whole' ELSE
        (SELECT SUBJECT_TYPE_NAME
      FROM SUBJECT_TYPE_INFO
      WHERE SUBJECT_TYPE_ID = EXAM_DEF_SUBJECT_TYPE_ID) 
    END AS [Subject Type], ed.EXAM_DEF_TOTAL_MARKS as [Total Marks], (ed.[EXAM_DEF_PASS_%AGE] * ed.EXAM_DEF_TOTAL_MARKS)/100 as [Pass Marks]

from EXAM_DEF ed
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID =@CLASS_ID and SUB_ID not in 
(select SUB_ID from EXAM_ENTRY et
join EXAM_DEF ed on ed.EXAM_DEF_ID = et.EXAM_ENTRY_PLAN_EXAM_ID
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID
)

union all

select Subject, [Subject Type], SUM([Total Marks]) as [Total Marks], SUM([Pass Marks]) as [Pass Marks] from 
(select sb.SUB_NAME as Subject, CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 'Whole' ELSE 'some'
    END AS [Subject Type], CASE WHEN ed.EXAM_DEF_SUBJECT_TYPE_ID != 0 THEN 
     ed.EXAM_DEF_TOTAL_MARKS ELSE 0 END AS [Total Marks], (ed.[EXAM_DEF_PASS_%AGE] * ed.EXAM_DEF_TOTAL_MARKS)/100 as [Pass Marks]

from EXAM_DEF ed
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_TERM = @TERM_ID and pd.DEF_CLASS_ID =@CLASS_ID
and SUB_ID not in 
(
select SUB_ID from EXAM_ENTRY et
join EXAM_DEF ed on ed.EXAM_DEF_ID = et.EXAM_ENTRY_PLAN_EXAM_ID
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID
)
)A 
where A.[Subject Type] = 'Whole' group by A.Subject, A.[Subject Type]

)B


--subject not define the total marks
select sb.SUB_NAME as [Subject]
from SCHOOL_PLANE_DEFINITION pd
join SUBJECT_INFO sb on pd.DEF_SUBJECT = sb.SUB_ID
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and pd.DEF_STATUS = 'T'
and sb.SUB_ID not in (select distinct pd.DEF_SUBJECT 
from EXAM_DEF ed 
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM =  @TERM_ID )


--Subject Grade Table
select ID, Name from VSUBJECT_GRADE_INFO

--fail limit
select * from VEXAM where [Class Plan ID] = @CLASS_ID

select * from #total_marks

drop table #grand_exam_total
drop table #grand_exam_minus
drop table #total_marks



END
--pivot table names [Pak Study Whole], [Islamic Study Whole],[Math Whole],[Chimistery Whole],[Urdu Written], [Urdu Oral],[Urdu Whole],[Art Whole]