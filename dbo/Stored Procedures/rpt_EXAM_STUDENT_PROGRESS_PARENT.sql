

CREATE PROC [dbo].[rpt_EXAM_STUDENT_PROGRESS_PARENT]
@dt_parent dbo.[type_EXAM_PROGRESS_REPORT_PARENT_TABLE] readonly,
@status char(1),
@STUDENT_ID numeric,
@LOGIN_ID numeric,
@LAST_TERM_ID numeric,
@hd_id nvarchar(50),
@br_id nvarchar(50)
AS
--select 0

--declare @hd_id nvarchar(50) = '%'
--declare @br_id nvarchar(50) = '%'
declare @parent_id nvarchar(50) = '%'

declare @std_id nvarchar(50)
declare @user_type nvarchar(50)= ''
declare @user_id int = 0
select @user_id = USER_CODE, @user_type = USER_TYPE from USER_INFO where USER_ID = @LOGIN_ID

if @user_type = 'IT'
begin
	set @hd_id = '%'
	set @br_id = '%'
end
else if @user_type = 'SA'
begin
	set @br_id = '%'
end
else if @user_type = 'Parent'
begin
	set @parent_id = CAST((@user_id) as nvarchar(50))
end
else if @user_type = 'Student'
begin
	set @STUDENT_ID = CAST((@user_id) as nvarchar(50))
end
else if @user_type = 'OS'
begin
	set @hd_id = '-1'
end

	if @STUDENT_ID = 0
		set @std_id = '%'
	else
		set @std_id = CONVERT(nvarchar(50), @STUDENT_ID)

declare @tbl table (class_id numeric)


--add
--select * from @dt_parent

insert into @tbl 
select distinct class_id from @dt_parent

	select dt.*,(p.PARNT_FIRST_NAME + ' ' + p.PARNT_LAST_NAME) as [Parent Name], p.PARNT_PERM_ADDR [Parent Address],a.AREA_NAME [Parent Area],c.CITY_NAME [Parent City], p.PARNT_CELL_NO [Parent Mobile No],B.EXAM_STD_COM_COMMENTS Comments,s.STDNT_SCHOOL_ID [School ID], CASE WHEN sp.CLASS_IS_SUBJECT_ATTENDANCE =1 THEN '' ELSE attendnce.Attendance END Attendance from @dt_parent dt
	join STUDENT_INFO s on s.STDNT_ID = dt.[Std ID]
	left join PARENT_INFO p on p.PARNT_ID = dt.[Parent ID]
	left join AREA_INFO a on a.AREA_ID = p.PARNT_AREA
	left join CITY_INFO c on c.CITY_ID = p.PARNT_CITY
	left join SCHOOL_PLANE sp on sp.CLASS_ID = dt.class_id
	left join (select * from(select ROW_NUMBER() over (partition by e.EXAM_STD_COM_CLASS_ID,e.EXAM_STD_COM_STD_ID order by EXAM_STD_COM_IS_RETEST DESC,TERM_RANK DESC) as sr, e.EXAM_STD_COM_STD_ID,e.EXAM_STD_COM_CLASS_ID,e.EXAM_STD_COM_COMMENTS from EXAM_STD_COMMENTS e
left join TERM_INFO t on t.TERM_ID = e.EXAM_STD_COM_TERM_ID 

 where e.EXAM_STD_COM_CLASS_ID in (select tb.class_id from @tbl tb) )A where sr = 1)B on B.EXAM_STD_COM_STD_ID = dt.[Std ID] 

  left join (select EXAM_STD_ATT_STD_ID [Student ID], (CAST(ISNULL(SUM(EXAM_STD_ATT_PRESENT_DAYS),'') as nvarchar(10)) + '/'  + CAST(ISNULL(SUM(EXAM_STD_ATT_TOTAL_DAYS),'') as nvarchar(10))) as Attendance   from EXAM_STD_ATTENDANCE_INFO where EXAM_STD_ATT_TERM_ID = @LAST_TERM_ID and EXAM_STD_ATT_SUB_ID = 0
group by EXAM_STD_ATT_CLASS_ID,EXAM_STD_ATT_STD_ID) attendnce on attendnce.[Student ID] = dt.[Std ID]
	 	where [Std ID] like @std_id and 
		s.STDNT_STATUS = 'T' and
	[Parent ID] like @parent_id and
	[HD ID] like @hd_id and
	[BR ID] like @br_id
	order by class_id, CAST(s.STDNT_SCHOOL_ID as int) 


--if @status = 'T'
--	select * from @dt_parent 	where [Std ID] like @std_id and 
--	[Parent ID] like @parent_id and
--	[HD ID] like @hd_id and
--	[BR ID] like @br_id
--	order by class_id, [Std ID] 
--else if @status = 'A'
--	declare @t table ( plan_id int, max_marks float, no_of_std int)
	
--	--declare @total_positions int = 0
--	--set @total_positions = (select MAX(Position) from @dt_parent)
--	--declare @tbl_position table (t_position int)
--	--insert into @tbl_position values(@total_positions)


--	insert into @t
--	select class_id, MAX([Max Marks]) as [Max Marks], COUNT([Std ID]) as no_of_std from ( 
--	select [Std ID], class_id, SUM([Grand Total]) as [Max Marks] from @dt_parent group by [Std ID], class_id)A 
--	group by A.class_id

--	 --select class_id as plan_id, MAX([Grand Total]) as [Max Marks] from @dt_parent group by class_id



--	;with tbl as
--	(select Session, Class, 'Annaul Term' as Term, Session as [Term Duration], [Std ID], [Std Name], 
--	[Std Roll#],  SUM([Total Marks]) as [Total Marks], SUM([Grand Total]) as [Grand Total], SUM([Total Pass Marks]) as [Total Pass Marks],
--	case when [Std ID] > 0 then (select no_of_std from @t where plan_id = class_id) else 0 END as [No of Std],
--	SUM([Total Days]) as [Total Days], SUM([Total Working Days]) as [Total Working Days], SUM(Present) as Present,
--	SUM(Absent) as Absent, SUM(Leave) as Leave, SUM(Late) as Late, 0 as term_id, class_id, Remarks,Section,Shift, [Total Positions],
--	[Parent ID], [HD ID], [BR ID]
--	from @dt_parent group by [Std ID],Session, Class, [Std Name], [Std Roll#],class_id,Remarks,Section,Shift,[Total Positions],[Parent ID], [HD ID], [BR ID]
--	)



--	,cent_tbl as
--	(select Session, Class, Term, [Term Duration], [Std ID], [Std Name], [Std Roll#], [Total Marks], [Grand Total], (([Grand Total] * 100) / [Total Marks]) as [Percent],
--	 [No of Std],[Total Days], [Total Working Days], Present, Absent, Leave, Late, term_id, class_id, Remarks,Section,Shift,[Total Pass Marks], [Total Positions],[Parent ID], [HD ID], [BR ID]
--	 from tbl)



--	,grade_tbl as
--	(
--	select Session, Class, Term, [Term Duration], [Std ID], [Std Name], [Std Roll#], [Total Marks], [Grand Total], [Percent],
--	[No of Std], case when [Percent] < 0 then 'F' else dbo.get_GRADE_NAME(class_id, [Percent]) END as Grade,
--	[Total Days], [Total Working Days], Present, Absent, Leave, Late, term_id,class_id, Remarks,Section,Shift, [Total Pass Marks], 
--	[Total Positions],[Parent ID], [HD ID], [BR ID] from cent_tbl 
--	)
--	,overall_table as
--	(
--	select distinct [Std ID],Session, Class, Term, [Term Duration],  [Std Name], [Std Roll#], [Total Marks], [Grand Total], 
--	[Percent],[No of Std], dense_rank() over (order by [percent] DESC) as Position, Grade, [Total Days], [Total Working Days], 
--	Present, Absent, Leave, Late, case when [Std ID] > 0 then  (select max_marks from @t where plan_id = class_id) 
--	else 0 END as [Max Marks],term_id, class_id, Remarks,Section,Shift , [Total Pass Marks],[Total Positions],[Parent ID], [HD ID], [BR ID]	
--	from grade_tbl 
--	)
--	select * from overall_table
	
--	where [Std ID] like @std_id and 
--	[Parent ID] like @parent_id and
--	[HD ID] like @hd_id and
--	[BR ID] like @br_id
--	order by class_id, [Std ID]