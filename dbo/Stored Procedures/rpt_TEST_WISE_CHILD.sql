CREATE PROC [dbo].[rpt_TEST_WISE_CHILD]





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

select  [Student ID],[Test ID],[School ID],[Family Code],[Student Name],[Test Marks],[Passing Marks],[Obtained Marks],
[%Age],[Grade],dense_rank() over (order by [%Age] DESC) as Position from
(
select distinct si.STDNT_ID as [Student ID],et.EXAM_TEST_ID as [Test ID],si.STDNT_SCHOOL_ID as [School ID],p.PARNT_FAMILY_CODE AS [Family Code],
si.STDNT_FIRST_NAME+' '+si.STDNT_LAST_NAME as [Student Name],et.EXAM_TEST_TOTAL_MARKS as [Test Marks],
(et.[EXAM_TEST_PASS_%AGE]*et.EXAM_TEST_TOTAL_MARKS)/100 as [Passing Marks],
ee.EXAM_ENTRY_OBTAIN_MARKS as[Obtained Marks],(ee.EXAM_ENTRY_OBTAIN_MARKS/et.EXAM_TEST_TOTAL_MARKS)*100 as [%Age],
dbo.get_GRADE_NAME(et.EXAM_TEST_CLASS_ID,(EXAM_ENTRY_OBTAIN_MARKS/et.EXAM_TEST_TOTAL_MARKS)*100 ) as [Grade]
 from EXAM_TEST et
inner join EXAM_ENTRY ee on et.EXAM_TEST_ID=ee.EXAM_ENTRY_PLAN_EXAM_ID
inner join STUDENT_INFO si on ee.EXAM_ENTRY_STUDENT_ID=si.STDNT_ID
inner join PARENT_INFO p on si.STDNT_PARANT_ID=p.PARNT_ID 
inner join SCHOOL_PLANE_DEFINITION spd on spd.DEF_CLASS_ID=et.EXAM_TEST_CLASS_ID
where ee.EXAM_ENTRY_EXAM_TYPE='Test' and ee.EXAM_ENTRY_STUDENT_ID like @std_id and p.PARNT_ID like @parent_id and 
si.STDNT_HD_ID=@TEST_WISE_HD_ID and si.STDNT_BR_ID=@TEST_WISE_BR_ID and spd.DEF_TEACHER like @teacher_id and
et.EXAM_TEST_ID like @test_id and et.EXAM_TEST_CLASS_ID like @class_id and et.EXAM_TEST_TERM_ID like @term_id 
and et.EXAM_TEST_SUBJECT_ID like @subject_id

)A order by Position