CREATE PROC [dbo].[rpt_TEST_STUDENT_WISE_PARENT]




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
		set @teacher_id= CAST(@user_id as nvarchar(30))
	end
else if @user_type='Student'
	begin
		set @TEST_WISE_STUDENT_ID = CAST(@user_id as nvarchar(30))

	end
else if @user_type='Parent'
	begin
		set @parent_id = CAST(@user_id as nvarchar(30))
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


select distinct ent.EXAM_ENTRY_STUDENT_ID as [Student ID],st.STDNT_SCHOOL_ID as [School ID] , st.STDNT_FIRST_NAME as [Student Name], p.PARNT_FAMILY_CODE [Family Code],
sp.CLASS_Name as [Class Name], ti.TERM_NAME [Term Name], CAST(sp.CLASS_SESSION_START_DATE as nvarchar(50)) + ' To ' + CAST(sp.CLASS_SESSION_END_DATE as nvarchar(50)) as [Session],
s.SUB_NAME as [Subject], sp.CLASS_ID as[Class ID],ti.TERM_ID as [Term ID], s.SUB_ID as [Subject ID]
from EXAM_TEST et
join EXAM_ENTRY ent on ent.EXAM_ENTRY_PLAN_EXAM_ID = et.EXAM_TEST_ID
join SCHOOL_PLANE sp on sp.CLASS_ID = et.EXAM_TEST_CLASS_ID
join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID = sp.CLASS_ID
join STUDENT_INFO st on st.STDNT_ID = ent.EXAM_ENTRY_STUDENT_ID
join PARENT_INFO p on p.PARNT_ID = st.STDNT_PARANT_ID
join TERM_INFO ti on ti.TERM_ID = et.EXAM_TEST_TERM_ID
join SUBJECT_INFO s on s.SUB_ID = et.EXAM_TEST_SUBJECT_ID

where ent.EXAM_ENTRY_EXAM_TYPE = 'Test' and
sp.CLASS_SESSION_START_DATE = @SESSION_START_DATE and CLASS_SESSION_END_DATE = @SESSION_END_DATE
and st.STDNT_ID like @std_id and st.STDNT_PARANT_ID like @parent_id
and et.EXAM_TEST_CLASS_ID like @class_id and et.EXAM_TEST_TERM_ID like @term_id and et.EXAM_TEST_SUBJECT_ID like @subject_id
and et.EXAM_TEST_ID like @test_id and et.EXAM_TEST_HD_ID = @TEST_WISE_HD_ID and et.EXAM_TEST_BR_ID = @TEST_WISE_BR_ID
and p.PARNT_ID like @parent_id and st.STDNT_ID like @std_id and spd.DEF_TEACHER like @teacher_id
order by [Class ID]