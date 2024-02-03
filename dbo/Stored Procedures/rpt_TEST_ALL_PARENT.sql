
CREATE PROC [dbo].[rpt_TEST_ALL_PARENT]


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
--@SESSION_START_DATE date,
--@SESSION_END_DATE date,
--@TEST_WISE_PK_ID numeric=537,
--@TEST_WISE_TEST_ID numeric=2,
--@TEST_WISE_CLASS_ID numeric=2,
--@TEST_WISE_TERM_ID numeric=2,
--@TEST_WISE_SUBJECT_ID numeric=2,
--@TEST_WISE_STUDENT_ID numeric=1,
--@TEST_WISE_HD_ID numeric=2,
--@TEST_WISE_BR_ID numeric=1



DECLARE @std_id nvarchar(50)='%',
@parent_id nvarchar(50)='%',
@teacher_id nvarchar(50)='%',
@user_type nvarchar(50)='',
@user_id numeric = 0,
@test_id nvarchar(30)='%',
@class_id nvarchar(30)='%',
@term_id nvarchar(30)='%',
@subject_id nvarchar(30)='%'



select @user_type=u.USER_TYPE,@user_id=cast(USER_CODE as nvarchar(50)) 
from USER_INFO u where u.USER_ID=@TEST_WISE_PK_ID


if @user_type='Teacher'
	begin
		set @teacher_id= CAST(@user_id as nvarchar(30))
	end
else if @user_type='Student'
	begin
		set @TEST_WISE_STUDENT_ID = @user_id

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
	set @test_id = CAST(@TEST_WISE_TEST_ID as nvarchar(30))
END

if @TEST_WISE_TERM_ID != 0 
BEGIN
	set @term_id = CAST(@TEST_WISE_TERM_ID as nvarchar(30))
END

if @TEST_WISE_SUBJECT_ID != 0 
BEGIN
	set @subject_id = CAST(@TEST_WISE_SUBJECT_ID as nvarchar(30))
END





	select distinct s.SUB_NAME as [Subject], s.SUB_ID [Subject ID],sp.CLASS_Name [Class Name], sp.CLASS_ID [Class ID],t.TERM_NAME Term,t.TERM_ID [Term ID], 
	cast (sp.CLASS_SESSION_START_DATE as nvarchar)+' to '+cast(sp.CLASS_SESSION_END_DATE as nvarchar) as [Session]

	from SCHOOL_PLANE sp
	join EXAM_TEST et on et.EXAM_TEST_CLASS_ID = sp.CLASS_ID
	join TERM_INFO t on t.TERM_ID = et.EXAM_TEST_TERM_ID
	join SUBJECT_INFO s on s.SUB_ID = et.EXAM_TEST_SUBJECT_ID
	inner join EXAM_ENTRY ee on et.EXAM_TEST_ID=ee.EXAM_ENTRY_PLAN_EXAM_ID
	inner join STUDENT_INFO si on ee.EXAM_ENTRY_STUDENT_ID=si.STDNT_ID
	inner join PARENT_INFO p on si.STDNT_PARANT_ID=p.PARNT_ID 
	inner join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID=et.EXAM_TEST_CLASS_ID

	where
	ee.EXAM_ENTRY_STUDENT_ID like @std_id and p.PARNT_ID like @parent_id and 
	si.STDNT_HD_ID=@TEST_WISE_HD_ID and si.STDNT_BR_ID=@TEST_WISE_BR_ID and spd.DEF_TEACHER like @teacher_id and
	 et.EXAM_TEST_CLASS_ID like @class_id and et.EXAM_TEST_TERM_ID like @term_id 
	and et.EXAM_TEST_SUBJECT_ID like @subject_id