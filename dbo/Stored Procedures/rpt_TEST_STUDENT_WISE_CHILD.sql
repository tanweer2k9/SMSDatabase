CREATE PROC [dbo].[rpt_TEST_STUDENT_WISE_CHILD]

@SESSION_START_DATE date,
@SESSION_END_DATE date,
@TEST_WISE_PK_ID numeric,
@TEST_WISE_TEST_ID numeric,
@TEST_WISE_CLASS_ID numeric,
@TEST_WISE_TERM_ID numeric,
@TEST_WISE_SUBJECT_ID numeric,
@TEST_WISE_STUDENT_ID numeric,
@TEST_WISE_HD_ID numeric,
@TEST_WISE_BR_ID numeric


AS

-----

--declare
--@SESSION_START_DATE date = '2014-04-01',
--@SESSION_END_DATE date = '2015-04-01',
--@TEST_WISE_PK_ID numeric=1,
--@TEST_WISE_TEST_ID numeric=0,
--@TEST_WISE_CLASS_ID numeric=0,
--@TEST_WISE_TERM_ID numeric=0,
--@TEST_WISE_SUBJECT_ID numeric=0,
--@TEST_WISE_STUDENT_ID numeric=0,
--@TEST_WISE_HD_ID numeric=2,
--@TEST_WISE_BR_ID numeric=1




DECLARE @std_id nvarchar(50)='%',
@parent_id nvarchar(50)='%',
@teacher_id nvarchar(50)='%',
@user_type nvarchar(50)='',
@user_id numeric =0,
@test_id nvarchar(30)='%',
@class_id nvarchar(30)='%',
@term_id nvarchar(30)='%',
@subject_id nvarchar(30)='%'



select @user_type=u.USER_TYPE,@user_id=USER_CODE 
from USER_INFO u where u.USER_ID=@TEST_WISE_PK_ID


if @user_type='Teacher'
	begin
		set @teacher_id= cast(@user_id as nvarchar(50)) 
	end
else if @user_type='Student'
	begin
		set @TEST_WISE_STUDENT_ID = cast (@user_id as nvarchar(50))

	end
else if @user_type='Parent'
	begin
		set @parent_id = cast(@user_id as nvarchar(50)) 
		set @TEST_WISE_STUDENT_ID = 0
	end



if @TEST_WISE_STUDENT_ID != 0 
BEGIN
	set @std_id = CAST(@TEST_WISE_STUDENT_ID as nvarchar(30))
END


if @TEST_WISE_CLASS_ID != 0 
BEGIN
	set @class_id = CAST(@TEST_WISE_CLASS_ID as nvarchar(30))
END

if @TEST_WISE_TEST_ID != 0 
BEGIN
	set @std_id = CAST(@TEST_WISE_STUDENT_ID as nvarchar(30))
END

if @TEST_WISE_TERM_ID != 0 
BEGIN
	set @term_id = CAST(@TEST_WISE_TERM_ID as nvarchar(30))
END

if @TEST_WISE_SUBJECT_ID != 0 
BEGIN
	set @subject_id = CAST(@TEST_WISE_SUBJECT_ID as nvarchar(30))
END





select *, dense_rank() over ( partition by [Test ID] order by [%Age]  desc ) Position
from
(select et.EXAM_TEST_NAME [Test Name], et.EXAM_TEST_ID [Test ID],ent.EXAM_ENTRY_STUDENT_ID as [Student ID],et.EXAM_TEST_TERM_ID [Term ID],et.EXAM_TEST_CLASS_ID [Class ID],
et.EXAM_TEST_SUBJECT_ID [Subject ID],et.EXAM_TEST_TOTAL_MARKS [Total Marks], (et.[EXAM_TEST_PASS_%AGE] * et.EXAM_TEST_TOTAL_MARKS/100) as [Pass Marks],
ent.EXAM_ENTRY_OBTAIN_MARKS as [Obtained Marks], (ent.EXAM_ENTRY_OBTAIN_MARKS/et.EXAM_TEST_TOTAL_MARKS)*100 as [%Age],
dbo.get_GRADE_NAME(et.EXAM_TEST_CLASS_ID,(EXAM_ENTRY_OBTAIN_MARKS/et.EXAM_TEST_TOTAL_MARKS)*100 ) as [Grade]
from EXAM_ENTRY ent
join EXAM_TEST et on et.EXAM_TEST_ID =  ent.EXAM_ENTRY_PLAN_EXAM_ID
join STUDENT_INFO st on st.STDNT_ID = ent.EXAM_ENTRY_STUDENT_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = et.EXAM_TEST_CLASS_ID
join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID = sp.CLASS_ID
join TERM_INFO ti on ti.TERM_ID = et.EXAM_TEST_TERM_ID
join SUBJECT_INFO s on s.SUB_ID = et.EXAM_TEST_SUBJECT_ID


where ent.EXAM_ENTRY_EXAM_TYPE = 'Test'
and sp.CLASS_SESSION_START_DATE = @SESSION_START_DATE and CLASS_SESSION_END_DATE = @SESSION_END_DATE
and st.STDNT_ID like @std_id and st.STDNT_PARANT_ID like @parent_id and spd.DEF_TEACHER like @teacher_id
and et.EXAM_TEST_CLASS_ID like @class_id and et.EXAM_TEST_TERM_ID like @term_id and et.EXAM_TEST_SUBJECT_ID like @subject_id
and et.EXAM_TEST_ID like @test_id and et.EXAM_TEST_HD_ID = @TEST_WISE_HD_ID and et.EXAM_TEST_BR_ID = @TEST_WISE_BR_ID


)A 
-----