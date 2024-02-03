
CREATE PROC [dbo].[rpt_AWARDS_LIST]

@CLASS_ID numeric,
@TERM_ID numeric

AS


--declare @CLASS_ID numeric = 7
--declare @TERM_ID numeric = 1
declare @table table ([Std Id] bigint, [Std No] numeric,Name nvarchar(100), Subject nvarchar(1000))

declare @one int = 1

declare @awards_marks float = 0

select top(@one) @awards_marks = P_GRADE_SUBJECT_AWRADS_MARKS from PLAN_GRADE pg
join GRADE_MAPPING gm on gm.GRADE_MAP_GRADE_PLAN_ID = pg.P_GRADE_ID
where GRADE_MAP_CLASS_ID = @CLASS_ID

insert into @table
select s.STDNT_ID,CAST(s.STDNT_SCHOOL_ID as bigint),(s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME) as Name,REPLACE(sb.SUB_NAME,'&','and**') SUB_NAME from
EXAM_ENTRY et
join EXAM_DEF ed on et.EXAM_ENTRY_PLAN_EXAM_ID = ed.EXAM_DEF_ID
join SCHOOL_PLANE_DEFINITION pd on pd.DEF_ID = ed.EXAM_DEF_CLASS_ID
join STUDENT_INFO s on s.STDNT_ID = et.EXAM_ENTRY_STUDENT_ID 
join SUBJECT_INFO sb on sb.SUB_ID = pd.DEF_SUBJECT
where pd.DEF_CLASS_ID = @CLASS_ID and pd.DEF_TERM = @TERM_ID and et.EXAM_ENTRY_OBTAIN_MARKS >= @awards_marks



select [Std No],Name, REPLACE(Awards,'and**','&') Awards from
(
select [Std No], Name,  
	STUFF((
        SELECT ', ' + CAST(Subject AS VARCHAR(255))
        FROM @table t1
		WHERE t1.[Std Id] = t2.[Std Id]
        FOR XML PATH ('')), 1, 2, '') AS Awards


from @table t2
group by [Std Id],[Std No],Name)A
order by [Std No]