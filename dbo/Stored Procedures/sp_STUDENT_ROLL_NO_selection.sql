CREATE procedure  [dbo].[sp_STUDENT_ROLL_NO_selection] 


@STUDENT_ROLL_NO_HD_ID numeric,
@STUDENT_ROLL_NO_BR_ID numeric,
@STUDENT_ROLL_NO_PLAN_ID numeric,
@STATUS char(2)
AS
BEGIN

--declare @STUDENT_ROLL_NO_HD_ID numeric = 1
--declare @STUDENT_ROLL_NO_BR_ID numeric = 1
--declare @STUDENT_ROLL_NO_PLAN_ID numeric = 9
--declare @STATUS char(2) = 'R'

if @STATUS = 'L'
begin
SELECT CLASS_ID as ID, CLASS_Name as Name, CLASS_TEACHER as Incharge FROM SCHOOL_PLANE    
WHERE CLASS_HD_ID = @STUDENT_ROLL_NO_HD_ID
   and  CLASS_BR_ID = @STUDENT_ROLL_NO_BR_ID
   and  CLASS_STATUS = 'T'
end
else if @STATUS = 'R' -- Roll number
begin
select s.STDNT_ID as [Student ID], s.STDNT_FIRST_NAME + ' ' + s.STDNT_LAST_NAME as [Student Name], p.PARNT_FULL_NAME as [Parent Name] ,r.STUDENT_ROLL_NUM_ROLL_NO as [Student Roll #]
from STUDENT_INFO s
join PARENT_INFO p
on p.PARNT_ID = s.STDNT_PARANT_ID
join STUDENT_ROLL_NUM r
on s.STDNT_ID = r.STUDENT_ROLL_NUM_STD_ID

where 
STUDENT_ROLL_NUM_HD_ID = @STUDENT_ROLL_NO_HD_ID and
STUDENT_ROLL_NUM_BR_ID = @STUDENT_ROLL_NO_BR_ID and
STUDENT_ROLL_NUM_PLAN_ID = @STUDENT_ROLL_NO_PLAN_ID and
STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and
STUDENT_ROLL_NUM_STATUS = 'T' and 
STDNT_STATUS = 'T'
order by [Student Roll #]

--STUDENT_ROLL_NUM_HD_ID = 1 and
--STUDENT_ROLL_NUM_BR_ID = 1 and
--STUDENT_ROLL_NUM_PLAN_ID = 9 and
--STUDENT_ROLL_NUM_ACTIVE_STATUS in ('new', 'old') and
--STUDENT_ROLL_NUM_STATUS = 'T' and 
--STDNT_STATUS = 'T'

end

END