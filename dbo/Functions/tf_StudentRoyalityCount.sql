
CREATE FUNCTION [dbo].[tf_StudentRoyalityCount] (@Session nvarchar(50), @BrId numeric, @FromDate date, @ToDate date)

returns @tbl table (ClassId numeric,StudentId int,StudentName nvarchar(100), StudentNo nvarchar(20), Class nvarchar(50), ClassOrder int, DOA date, FromDate date )


AS BEGIN

insert into @tbl

--RIght Join is if new student fee is genereated in the previous month and reg date is of next month
select c.CLASS_ID, s.STDNT_ID, s.STDNT_FIRST_NAME, s.STDNT_SCHOOL_ID, c.CLASS_NAME,sp.CLASS_ORDER,s.STDNT_CLASSES_START_DATE,@FromDate
from STUDENT_INFO s

join tblStudentClassPlan sc on sc.StudentId = s.STDNT_ID
join RoyalityClassesAllowed r on r.ClassId = sc.ClassId
join SCHOOL_PLANE sp on sp.CLASS_ID = sc.ClassId
join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS

join SESSION_INFO si on si.SESSION_ID = sc.SessionId and STDNT_BR_ID = @BrId and si.SESSION_DESC = @Session
 --and  @ToDate between DATEFROMPARTS(YEAR(f.FEE_COLLECT_FEE_FROM_DATE),MONTH(f.FEE_COLLECT_FEE_FROM_DATE),1)  and DATEADD(DD,-1,DATEADD(MM,1,DATEFROMPARTS(YEAR(FEE_COLLECT_FEE_TO_DATE),MONTH(FEE_COLLECT_FEE_TO_DATE),1)))
 --and si.SESSION_BR_ID = @BrId and si.SESSION_DESC = @Session and sc.SessionId = si.SESSION_ID

and ((STDNT_DATE_OF_LEAVING is NULL AND STDNT_CLASSES_START_DATE <= @ToDate ) OR (  @FromDate between STDNT_CLASSES_START_DATE and STDNT_DATE_OF_LEAVING)) 

--right join (select f.FEE_COLLECT_STD_ID,c1.CLASS_ID,st1.STDNT_FIRST_NAME, st1.STDNT_SCHOOL_ID,st1.STDNT_REG_DATE, c1.CLASS_NAME,sp1.CLASS_ORDER from FEE_COLLECT f join RoyalityClassesAllowed r1 on r1.ClassId = f.FEE_COLLECT_PLAN_ID
--join SCHOOL_PLANE sp1 on sp1.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join CLASS_INFO c1 on c1.CLASS_ID = sp1.CLASS_CLASS
--join STUDENT_INFO st1 on st1.STDNT_ID = f.FEE_COLLECT_STD_ID
-- where FEE_COLLECT_BR_ID = @BrId and FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate)A on A.FEE_COLLECT_STD_ID = s.STDNT_ID

-- where 


insert into @tbl 
select c1.CLASS_ID,f.FEE_COLLECT_STD_ID,st1.STDNT_FIRST_NAME, st1.STDNT_SCHOOL_ID, c1.CLASS_NAME,sp1.CLASS_ORDER,st1.STDNT_CLASSES_START_DATE,ISNULL(f.FEE_COLLECT_FEE_FROM_DATE,@FromDate)  FromDate from FEE_COLLECT f join RoyalityClassesAllowed r1 on r1.ClassId = f.FEE_COLLECT_PLAN_ID
join SCHOOL_PLANE sp1 on sp1.CLASS_ID = f.FEE_COLLECT_PLAN_ID
join CLASS_INFO c1 on c1.CLASS_ID = sp1.CLASS_CLASS
join STUDENT_INFO st1 on st1.STDNT_ID = f.FEE_COLLECT_STD_ID
 where FEE_COLLECT_BR_ID = @BrId and FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate and f.FEE_COLLECT_STD_ID not in (select StudentId from @tbl)

return

END