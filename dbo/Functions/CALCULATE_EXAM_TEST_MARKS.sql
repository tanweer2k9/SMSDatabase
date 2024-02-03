
CREATE FUNCTION [dbo].[CALCULATE_EXAM_TEST_MARKS] (@CLASS_ID numeric, @SUBJECT_ID numeric ,  @TERM_ID numeric,@STD_ID numeric)
returns @t table ([TotalMarks] float, [ObtainMarks] float, [PassMarks] float, Perent float, [Type] nvarchar(50))

AS

BEGIN

--declare @CLASS_ID numeric = 6
--declare @SUBJECT_ID numeric = 23
--declare @TERM_ID numeric = 1
--declare @STD_ID numeric = 0
declare @SESSION_START_DATE date = ''
declare @BR_ID numeric = 0

declare @BEST_TEST int =0
declare @TERM_RANKS_Test nvarchar(50) = ''
declare @PERCENT_Test float = 0
declare @TERM_RANKS_Assignment nvarchar(50) = ''
declare @PERCENT_Assignment float = 0
declare @TERM_RANKS_Presentation nvarchar(50) = ''
declare @PERCENT_Presentation float = 0
declare @TERM_RANKS_Quiz nvarchar(50) = ''
declare @PERCENT_Quiz float = 0

select @SESSION_START_DATE =  e.EXAM_SESSION_START_DATE,@BR_ID = e.EXAM_BR_ID,@BEST_TEST = ed.EXAM_DEF_TERM_BEST_TESTS, @TERM_RANKS_Test =  ed.EXAM_DEF_TERM_RANKS_TEST, @PERCENT_Test = ed.EXAM_DEF_TERM_RANKS_TEST_PERCENTAGE, @TERM_RANKS_Assignment =  ed.EXAM_DEF_TERM_RANKS_ASSIGNMENTS, @PERCENT_Assignment =  ed.EXAM_DEF_TERM_RANKS_ASSIGNMENTS_PERCENTAGE, @TERM_RANKS_Presentation =  ed.EXAM_DEF_TERM_RANKS_PRESENTATIONS, @PERCENT_Presentation =  ed.EXAM_DEF_TERM_RANKS_PRESENTATIONS_PERCENTAGE, @TERM_RANKS_Quiz = ed.EXAM_DEF_TERM_RANKS_QUIZ, @PERCENT_Quiz = ed.EXAM_DEF_TERM_RANKS_QUIZ_PERCENTAGE from exam e
join EXAM_DEF ed on ed.EXAM_DEF_PID = e.EXAM_ID
join SCHOOL_PLANE_DEFINITION spd on spd.DEF_ID = ed.EXAM_DEF_CLASS_ID
where spd.DEF_CLASS_ID = @CLASS_ID and spd.DEF_TERM = @TERM_ID and spd.DEF_SUBJECT = @SUBJECT_ID





declare @Test nvarchar(20) = 'Test'
declare @Presentation nvarchar(20) = 'Presentation'
declare @Assignment nvarchar(20) = 'Assignment'
declare @Quiz nvarchar(20) = 'Quiz'


declare @count_test int = 0

set @count_test = (select COUNT(*) from EXAM_TEST where EXAM_TEST_BR_ID = @BR_ID and EXAM_TEST_CLASS_ID = @CLASS_ID and EXAM_TEST_TERM_ID = @TERM_ID and EXAM_TEST_SUBJECT_ID = @SUBJECT_ID and EXAM_TEST_STATUS = 'T') 


if @count_test > 0
BEGIN
insert into @t
select ISNULL(SUM(EXAM_TEST_TOTAL_MARKS) * (@PERCENT_Test/100),0) [TotalMarks],ISNULL(SUM(EXAM_ENTRY_OBTAIN_MARKS)*(@PERCENT_Test/100),0) [ObtainMarks],ISNULL(SUM(EXAM_TEST_TOTAL_MARKS * ([EXAM_TEST_PASS_%AGE] / 100)) *(@PERCENT_Test/100),0) [PassMarks],@PERCENT_Test Perent, @Test [Type] from
(select ROW_NUMBER() over (order by exam_entry_obtain_marks desc) as sr, * from EXAM_ENTRY e
join EXAM_TEST et on et.EXAM_TEST_ID = e.EXAM_ENTRY_PLAN_EXAM_ID
where e.EXAM_ENTRY_EXAM_TYPE = @Test and et.EXAM_TEST_CLASS_ID = @CLASS_ID and et.EXAM_TEST_SUBJECT_ID = @SUBJECT_ID and et.EXAM_TEST_TERM_ID in (select TERM_ID from TERM_INFO where TERM_BR_ID = @BR_ID and TERM_SESSION_START_DATE = @SESSION_START_DATE and  TERM_RANK in(select val from dbo.split(@TERM_RANKS_Test,','))) and e.EXAM_ENTRY_STUDENT_ID = @STD_ID
)A where A.sr <= @BEST_TEST

union

select ISNULL(SUM(EXAM_TEST_TOTAL_MARKS) * (@PERCENT_Assignment/100),0) [TotalMarks],ISNULL(SUM(EXAM_ENTRY_OBTAIN_MARKS)*(@PERCENT_Assignment/100),0) [ObtainMarks],ISNULL(SUM(EXAM_TEST_TOTAL_MARKS * ([EXAM_TEST_PASS_%AGE] / 100)) *(@PERCENT_Assignment/100),0) [PassMarks],@PERCENT_Assignment Perent, @Assignment [Type] from
(select ROW_NUMBER() over (order by exam_entry_obtain_marks desc) as sr, * from EXAM_ENTRY e
join EXAM_TEST et on et.EXAM_TEST_ID = e.EXAM_ENTRY_PLAN_EXAM_ID
where e.EXAM_ENTRY_EXAM_TYPE = @Assignment and et.EXAM_TEST_CLASS_ID = @CLASS_ID and et.EXAM_TEST_SUBJECT_ID = @SUBJECT_ID and et.EXAM_TEST_TERM_ID in (select TERM_ID from TERM_INFO where TERM_BR_ID = @BR_ID and TERM_SESSION_START_DATE = @SESSION_START_DATE and  TERM_RANK in(select val from dbo.split(@TERM_RANKS_Assignment,','))) and e.EXAM_ENTRY_STUDENT_ID = @STD_ID
)A where A.sr <= @BEST_TEST

union

select ISNULL(SUM(EXAM_TEST_TOTAL_MARKS) * (@PERCENT_Presentation/100),0) [TotalMarks],ISNULL(SUM(EXAM_ENTRY_OBTAIN_MARKS)*(@PERCENT_Presentation/100),0) [ObtainMarks],ISNULL(SUM(EXAM_TEST_TOTAL_MARKS * ([EXAM_TEST_PASS_%AGE] / 100)) *(@PERCENT_Presentation/100),0) [PassMarks],@PERCENT_Presentation Perent, @Presentation [Type] from
(select ROW_NUMBER() over (order by exam_entry_obtain_marks desc) as sr, * from EXAM_ENTRY e
join EXAM_TEST et on et.EXAM_TEST_ID = e.EXAM_ENTRY_PLAN_EXAM_ID
where e.EXAM_ENTRY_EXAM_TYPE = @Presentation and et.EXAM_TEST_CLASS_ID = @CLASS_ID and et.EXAM_TEST_SUBJECT_ID = @SUBJECT_ID and et.EXAM_TEST_TERM_ID in (select TERM_ID from TERM_INFO where TERM_BR_ID = @BR_ID and TERM_SESSION_START_DATE = @SESSION_START_DATE and  TERM_RANK in(select val from dbo.split(@TERM_RANKS_Presentation,','))) and e.EXAM_ENTRY_STUDENT_ID = @STD_ID
)A where A.sr <= @BEST_TEST


union

select ISNULL(SUM(EXAM_TEST_TOTAL_MARKS) * (@PERCENT_Quiz/100),0) [TotalMarks],ISNULL(SUM(EXAM_ENTRY_OBTAIN_MARKS)*(@PERCENT_Quiz/100),0) [ObtainMarks],ISNULL(SUM(EXAM_TEST_TOTAL_MARKS * ([EXAM_TEST_PASS_%AGE] / 100)) *(@PERCENT_Quiz/100),0) [PassMarks],@PERCENT_Quiz Perent, @Quiz [Type] from
(select ROW_NUMBER() over (order by exam_entry_obtain_marks desc) as sr, * from EXAM_ENTRY e
join EXAM_TEST et on et.EXAM_TEST_ID = e.EXAM_ENTRY_PLAN_EXAM_ID
where e.EXAM_ENTRY_EXAM_TYPE = @Quiz and et.EXAM_TEST_CLASS_ID = @CLASS_ID and et.EXAM_TEST_SUBJECT_ID = @SUBJECT_ID and et.EXAM_TEST_TERM_ID in (select TERM_ID from TERM_INFO where TERM_BR_ID = @BR_ID and TERM_SESSION_START_DATE = @SESSION_START_DATE and  TERM_RANK in(select val from dbo.split(@TERM_RANKS_Quiz,','))) and e.EXAM_ENTRY_STUDENT_ID = @STD_ID
)A where A.sr <= @BEST_TEST
END
ELSE
BEGIN
	insert into @t
	select 0,0,0,0,@Assignment
	union
	select 0,0,0,0,@Presentation
	union
	select 0,0,0,0,@Quiz
	union
	select 0,0,0,0,@Test
	
END




return
END