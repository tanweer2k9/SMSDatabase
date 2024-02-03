CREATE PROC [dbo].[sp_EXAM_TEST_REPORT_selection]

 @HD_ID numeric,
@BR_ID numeric,
@SESSION_START_DATE nvarchar(50),
@SESSION_END_DATE nvarchar(50),
@SUBJECT_ID numeric,
@TERM_ID numeric,
@TEST_ID numeric,
@CLASS_ID numeric,
@PK_ID numeric

AS

--declare @HD_ID numeric = 2,
--@BR_ID numeric = 1,
--@SESSION_START_DATE nvarchar(50)='2014-04-01',
--@SESSION_END_DATE nvarchar(50)='2015-04-01',
--@SUBJECT_ID numeric = 0,
--@TERM_ID numeric = 0,
----@TEST_ID numeric = 0,
--@CLASS_ID numeric = 0,
--@STUDENT_ID numeric = 0


DECLARE @std_id nvarchar(50)='%',
@parent_id nvarchar(50)='%',
@teacher_id nvarchar(50)='%',
@user_type nvarchar(50)='',
@user_id numeric =0,
@TEST nvarchar(30)='%',
@CLASS nvarchar(30)='%',
@TERM nvarchar(30)='%',
@SUBJECT nvarchar(30)='%'



select @user_type=u.USER_TYPE,@user_id=USER_CODE 
from USER_INFO u where u.USER_ID=@PK_ID


if @user_type='Teacher'
	begin
		set @teacher_id= CAST(@user_id as nvarchar(30))
	end
else if @user_type='Student'
	begin
		set @std_id = CAST(@user_id as nvarchar(30))

	end
else if @user_type='Parent'
	begin
		set @parent_id = CAST(@user_id as nvarchar(30))		
	end




if @CLASS_ID != 0
BEGIN
	set @CLASS = CAST(@CLASS_ID as nvarchar(50))
END 


if @TEST_ID != 0
BEGIN
	set @TEST = CAST(@TEST_ID as nvarchar(50))
END 

if @TERM_ID != 0
BEGIN
	set @TERM = CAST(@TERM_ID as nvarchar(50))
END 

if @SUBJECT_ID != 0
BEGIN
	set @SUBJECT = CAST(@SUBJECT_ID as nvarchar(50))
END 


declare @tbl table (test int, class int, term int,[subject] int, std int )


--select sp.CLASS_ID as [Class ID],SP.CLASS_Name as [Class Name] from SCHOOL_PLANE sp 
--where sp.CLASS_SESSION_START_DATE =@startdate and sp.CLASS_SESSION_END_DATE=@enddate 
--and sp.CLASS_BR_ID like @brid and sp.CLASS_HD_ID like @hdid

--Class, Term, Subject, Test


insert into @tbl

select distinct et.EXAM_TEST_ID, et.EXAM_TEST_CLASS_ID as [Class ID], et.EXAM_TEST_TERM_ID [Term ID],et.EXAM_TEST_SUBJECT_ID [Sub ID], ee.EXAM_ENTRY_STUDENT_ID

--sp.CLASS_Name as [Class Name], ti.TERM_NAME [Term Name],

 from EXAM_TEST et
inner join SCHOOL_PLANE sp on sp.CLASS_ID=et.EXAM_TEST_CLASS_ID 
join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID = et.EXAM_TEST_CLASS_ID
join EXAM_ENTRY ee on ee.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
join STUDENT_INFO s on s.STDNT_ID = ee.EXAM_ENTRY_STUDENT_ID
join PARENT_INFO p on p.PARNT_ID = s.STDNT_PARANT_ID
join TERM_INFO ti on ti.TERM_ID = et.EXAM_TEST_TERM_ID
join SUBJECT_INFO sb on sb.SUB_ID = et.EXAM_TEST_SUBJECT_ID
where ee.EXAM_ENTRY_EXAM_TYPE = 'Test' and sp.CLASS_SESSION_START_DATE =@SESSION_START_DATE and sp.CLASS_SESSION_END_DATE=@SESSION_END_DATE 
and sp.CLASS_BR_ID = @BR_ID and sp.CLASS_HD_ID = @HD_ID and spd.DEF_TEACHER like @teacher_id and p.PARNT_ID like @parent_id
and ee.EXAM_ENTRY_STUDENT_ID like @std_id


select distinct s.CLASS_ID, s.CLASS_Name from 
@tbl t
join SCHOOL_PLANE s on s.CLASS_ID = t.class



select distinct s.SUB_ID, s.SUB_NAME from 
@tbl t
join SUBJECT_INFO s on s.SUB_ID = t.[subject]
where t.class like @CLASS and t.term like @TERM

--select distinct et.EXAM_TEST_SUBJECT_ID as [Subject ID],sbi.SUB_NAME as [Subject Name] from EXAM_TEST et
--inner join SUBJECT_INFO sbi on sbi.SUB_ID = et.EXAM_TEST_SUBJECT_ID
--where et.EXAM_TEST_HD_ID = @HD_ID and et.EXAM_TEST_BR_ID = @BR_ID  
--and et.EXAM_TEST_CLASS_ID like @CLASS and et.EXAM_TEST_TERM_ID like @TERM  


select distinct ID, [Student School ID] as [Sch ID], [First Name], [Last Name], [Family Code], [Parent Name]  from 
@tbl t
join VSTUDENT_INFO s on s.ID = t.std
where t.class like @CLASS and t.term like @TERM and t.subject like @SUBJECT and t.test like @TEST


--select distinct ID as [Std ID], [Student School ID] as [Sch ID], [First Name], [Last Name], [Family Code], [Parent Name] from VSTUDENT_INFO si
--join EXAM_ENTRY ee on ee.EXAM_ENTRY_STUDENT_ID = ee.EXAM_ENTRY_STUDENT_ID
--join  EXAM_TEST et on et.EXAM_TEST_ID = ee.EXAM_ENTRY_PLAN_EXAM_ID
--join SCHOOL_PLANE sp on sp.CLASS_ID = et.EXAM_TEST_CLASS_ID
--where ee.EXAM_ENTRY_EXAM_TYPE = 'Test' and et.EXAM_TEST_HD_ID = @HD_ID  and et.EXAM_TEST_HD_ID = @BR_ID
--and et.EXAM_TEST_CLASS_ID like @CLASS and et.EXAM_TEST_TERM_ID like @TERM 
--and et.EXAM_TEST_SUBJECT_ID like @SUBJECT and et.EXAM_TEST_ID like @TEST
--and sp.CLASS_SESSION_START_DATE = @SESSION_START_DATE and sp.CLASS_SESSION_END_DATE = @SESSION_END_DATE

select distinct s.TERM_ID, s.TERM_NAME from 
@tbl t
join TERM_INFO s on s.TERM_ID = t.term
where t.class like @CLASS


--select distinct et.EXAM_TEST_TERM_ID as [Term ID],ti.TERM_NAME from EXAM_TEST et
--inner join TERM_INFO ti on ti.TERM_ID=et.EXAM_TEST_TERM_ID 
--where ti.TERM_HD_ID = @HD_ID  and ti.TERM_BR_ID = @BR_ID  and et.EXAM_TEST_CLASS_ID like @CLASS


select distinct s.EXAM_TEST_ID, s.EXAM_TEST_NAME  from 
@tbl t
join EXAM_TEST s on s.EXAM_TEST_ID = t.test
where t.class like @CLASS and t.term like @TERM and t.subject like @SUBJECT

--select et.EXAM_TEST_ID as [Test ID],et.EXAM_TEST_NAME as [Test Name] from EXAM_TEST et
--where et.EXAM_TEST_HD_ID = @HD_ID  and et.EXAM_TEST_BR_ID = @BR_ID 
--and et.EXAM_TEST_CLASS_ID like @CLASS and et.EXAM_TEST_TERM_ID like @TERM 
--and et.EXAM_TEST_SUBJECT_ID like @SUBJECT and et.EXAM_TEST_ID like @TEST

select distinct ID, Name, [Institute ID] from V_BRANCH_INFO
select distinct ID, [Institute Name] from VMAIN_HD_INFO