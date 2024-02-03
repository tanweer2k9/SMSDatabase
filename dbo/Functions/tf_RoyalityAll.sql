



CREATE FUNCTION [dbo].[tf_RoyalityAll](@Session nvarchar(50), @BrId numeric, @FromDate date, @ToDate date)


returns @tbl table (Name nvarchar(100), StudentNo nvarchar(100),ClassId numeric,Class  nvarchar(100),FeeType nvarchar(20),FeeName  nvarchar(100),TotalFee float,TotalArears float,Fee float,Royality float,RoyalityDiscountCovid float,[Percent] float,ClassOrder int, NoOfMonths int, DOA date,FromDate date, Remarks nvarchar(300), RoyaltyArrears float  )


AS BEGIN

--Royality Calculation each month if fees is of 2 month
--ROUND((fd.FEE_COLLECT_DEF_ROYALTY/(DATEDIFF(MONTH, FEE_COLLECT_FEE_FROM_DATE, FEE_COLLECT_FEE_TO_DATE) + 1)),0) Royality

--Include All Students if not fee genereate fee will be zero
insert into @tbl
select * from
(select  ISNULL(st.STDNT_FIRST_NAME,A.StudentName) Name,ISNULL(st.STDNT_SCHOOL_ID,A.StudentNo) StudentNo,ISNULL(c.CLASS_ID,A.ClassId) ClassId,ISNULL(c.CLASS_Name,A.Class) Class,ISNULL(fi.FEE_TYPE,B.FEE_TYPE) FeeType,ISNULL(fi.FEE_NAME,B.FEE_NAME) FeeName, ISNULL(f.FEE_COLLECT_FEE,0) TotalFee,ISNULL(f.FEE_COLLECT_ARREARS,0) TotalArears,
ISNULL(fd.FEE_COLLECT_DEF_FEE,0)   Fee, 
--ISNULL(fd.FEE_COLLECT_DEF_FEE,0) * IIF(rd.TotalDiscount > 0 ,0.8,1)  Fee, 
--ROUND( IIF(ISNULL(fd.FEE_COLLECT_DEF_FEE,0) = 10000, ISNULL(fd.FEE_COLLECT_DEF_FEE,0) * 0.6, ISNULL(fd.FEE_COLLECT_DEF_FEE,0) - ISNULL(rd.TotalDiscount,0)),0) Fee, --FOr Valencia May 2020
--dbo.sc_CalcualteRoyalty(FEE_COLLECT_FEE_FROM_DATE, @FromDate,@ToDate,rr.IsRoyalty,st.STDNT_DATE_OF_LEAVING,FEE_COLLECT_DEF_ROYALTY)
IIF(st.STDNT_DATE_OF_LEAVING < DATEADD(D,11,@FromDate), 0,dbo.sc_CalcualteRoyalty(FEE_COLLECT_FEE_FROM_DATE, @FromDate,@ToDate,rr.IsRoyalty,st.STDNT_DATE_OF_LEAVING,FEE_COLLECT_DEF_ROYALTY))
 --IIF(st.STDNT_DATE_OF_LEAVING is not null, 0,dbo.sc_CalcualteRoyalty(FEE_COLLECT_FEE_FROM_DATE, @FromDate,@ToDate,rr.IsRoyalty,st.STDNT_DATE_OF_LEAVING,FEE_COLLECT_DEF_ROYALTY))
--ROUND(IIF(FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate, IIF(ISNULL(rr.IsRoyalty,1) = 0,0,IIF( st.STDNT_DATE_OF_LEAVING is NULL OR ,fd.FEE_COLLECT_DEF_ROYALTY,0)),0),0)
 Royality, ISNULL(rd.TotalDiscount * 0.075,0) TotalDiscount
, ISNULL(fd.FEE_COLLECT_DEF_ROYALTY_PERCENT,B.ROYALTY_PERCENTAGE) [Percent], ISNULL(sp.CLASS_ORDER,A.ClassOrder) ClassOrder, ISNULL(DATEDIFF(MONTH, FEE_COLLECT_FEE_FROM_DATE, FEE_COLLECT_FEE_TO_DATE) + 1,0) as NoOfMonths, A.DOA,ISNULL(f.FEE_COLLECT_FEE_FROM_DATE,@FromDate)  FromDate, IIF(st.STDNT_DATE_OF_LEAVING is not null, 'Left on ' + FORMAT(st.STDNT_DATE_OF_LEAVING,'MMM dd, yyyy'),rr.Remarks) Remarks,
--IIF(rsa.Id is not null,ISNULL(fd.FEE_COLLECT_DEF_ARREARS * fd.FEE_COLLECT_DEF_ROYALTY_PERCENT * 0.01,0),0) RoyaltyArrears  
ISNULL(rsa.Amount,0) RoyaltyArrears
from FEE_COLLECT f with (nolock)
join SCHOOL_PLANE sp with (nolock) on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID and  sp.CLASS_BR_ID = @BrId and ((FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate) OR @ToDate between FEE_COLLECT_FEE_FROM_DATE and FEE_COLLECT_FEE_TO_DATE)
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
join FEE_COLLECT_DEF fd with (nolock) on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID


left join (select FEE_COLLECT_DEF_PID, SUM(FEE_COLLECT_DEF_FEE) TotalDiscount from FEE_COLLECT_DEF fd with (nolock)
join FEE_INFO  f with (nolock) on f.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
where FEE_COLLECT_DEF_OPERATION = '-' and FEE_COLLECT_DEF_FEE > 0
and FEE_BR_ID = @BrId
group by fd.FEE_COLLECT_DEF_PID)RD on Rd.FEE_COLLECT_DEF_PID = fd.FEE_COLLECT_DEF_PID


join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join STUDENT_INFO st with (nolock) on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
-- @ToDate between DATEFROMPARTS(YEAR(f.FEE_COLLECT_FEE_FROM_DATE),MONTH(f.FEE_COLLECT_FEE_FROM_DATE),1)  and DATEADD(DD,-1,DATEADD(MM,1,DATEFROMPARTS(YEAR(FEE_COLLECT_FEE_TO_DATE),MONTH(FEE_COLLECT_FEE_TO_DATE),1)))
and fi.FEE_TYPE != 'once'
join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS
right join (select * from  dbo.[tf_StudentRoyalityCount] (@Session,@BrId,@FromDate,@ToDate) )A on A.StudentId = f.FEE_COLLECT_STD_ID
cross join (select fi1.FEE_NAME,r1.ROYALTY_PERCENTAGE,fi1.FEE_TYPE from ROYALTY_FEE_SETTING r1
join FEE_INFO fi1 with (nolock) on fi1.FEE_ID = r1.ROYALTY_FEE_ID and fi1.FEE_BR_ID = @BrId and fi1.FEE_TYPE != 'Once')B 
left join RoyaltyRemarks rr on rr.StdId = A.StudentId
left join RoyaltyStudentsArrears rsa on rsa.StdId = f.FEE_COLLECT_STD_ID and rsa.Month between @FromDate and @ToDate

--Old One inlude only fee genereated students
--select  st.STDNT_FIRST_NAME Name,st.STDNT_SCHOOL_ID StudentNo,c.CLASS_ID ClassId,c.CLASS_Name Class,fi.FEE_NAME FeeName, (f.FEE_COLLECT_FEE) TotalFee,(f.FEE_COLLECT_ARREARS) TotalArears,(fd.FEE_COLLECT_DEF_FEE) Fee, ROUND(IIF(FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate, fd.FEE_COLLECT_DEF_ROYALTY,0),0) Royality, fd.FEE_COLLECT_DEF_ROYALTY_PERCENT [Percent], sp.CLASS_ORDER ClassOrder, DATEDIFF(MONTH, FEE_COLLECT_FEE_FROM_DATE, FEE_COLLECT_FEE_TO_DATE) + 1 as NoOfMonths from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--right join STUDENT_INFO st on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
--right join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS
--where 
----s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and 
--sp.CLASS_BR_ID = @BrId and ((FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate) OR @ToDate between FEE_COLLECT_FEE_FROM_DATE and FEE_COLLECT_FEE_TO_DATE)
---- @ToDate between DATEFROMPARTS(YEAR(f.FEE_COLLECT_FEE_FROM_DATE),MONTH(f.FEE_COLLECT_FEE_FROM_DATE),1)  and DATEADD(DD,-1,DATEADD(MM,1,DATEFROMPARTS(YEAR(FEE_COLLECT_FEE_TO_DATE),MONTH(FEE_COLLECT_FEE_TO_DATE),1)))
--and fi.FEE_TYPE != 'once'

union 
select Name,StudentNo,ClassId,Class,FEE_TYPE,FeeName,TotalFee,TotalArears, Fee, IIF(Fee > 0,Royality,0) Royality, 0 TotalDiscount,[Percent],ClassOrder,NoOfMonths, DOA,fromDate,Remarks,0 from 
(
select  ISNULL(st.STDNT_FIRST_NAME,A.STDNT_FIRST_NAME) Name,ISNULL(st.STDNT_SCHOOL_ID,A.STDNT_SCHOOL_ID) StudentNo,ISNULL(c.CLASS_ID,A.CLASS_ID) ClassId,ISNULL(c.CLASS_Name,A.CLASS_NAME) Class,ISNULL(fi.FEE_TYPE,A.FEE_TYPE) FEE_TYPE,ISNULL(fi.FEE_NAME,A.FEE_NAME) FeeName, ISNULL(f.FEE_COLLECT_FEE,0) TotalFee,ISNULL(f.FEE_COLLECT_ARREARS,0) TotalArears,
IIF(f.FEE_COLLECT_FEE_FROM_DATE between @FromDate AND @ToDate,FEE_COLLECT_DEF_FEE,0)  Fee, 
dbo.sc_CalcualteRoyalty(FEE_COLLECT_FEE_FROM_DATE, @FromDate,@ToDate,rr.IsRoyalty,st.STDNT_DATE_OF_LEAVING,FEE_COLLECT_DEF_ROYALTY)
--IIF(rr.Id is not null,fd.FEE_COLLECT_DEF_ROYALTY,0) 
Royality,
ISNULL(fd.FEE_COLLECT_DEF_ROYALTY_PERCENT,A.ROYALTY_PERCENTAGE) [Percent], ISNULL(sp.CLASS_ORDER,A.CLASS_ORDER) ClassOrder, ISNULL(DATEDIFF(MONTH, FEE_COLLECT_FEE_FROM_DATE, FEE_COLLECT_FEE_TO_DATE) + 1,0) as NoOfMonths, ISNULL(st.STDNT_CLASSES_START_DATE,A.STDNT_CLASSES_START_DATE) DOA,ISNULL(f.FEE_COLLECT_FEE_FROM_DATE,@FromDate)  FromDate, rr.Remarks   from FEE_COLLECT f with (nolock)
join SCHOOL_PLANE sp with (nolock) on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
join FEE_COLLECT_DEF fd with (nolock) on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join FEE_INFO fi with (nolock) on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
join STUDENT_INFO st with (nolock)on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS and sp.CLASS_BR_ID = @BrId and  FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate and fi.FEE_TYPE = 'once' and fd.FEE_COLLECT_DEF_FEE > 0
full outer join (select s2.STDNT_FIRST_NAME,s2.STDNT_SCHOOL_ID,c1.CLASS_ID,c1.CLASS_NAME,C.FEE_TYPE, c.FEE_NAME,sp.CLASS_ORDER, ROYALTY_PERCENTAGE,s2.STDNT_CLASSES_START_DATE,FEE_COLLECT_STD_ID from(select f.FEE_COLLECT_STD_ID from FEE_COLLECT f with (nolock)
join FEE_COLLECT_DEF fd with (nolock)on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
join FEE_INFO fi with (nolock) on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME



where FEE_COLLECT_BR_ID = @BrId and FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate and fi.FEE_TYPE = 'once' and FEE_COLLECT_DEF_ROYALTY > 0
union
select s1.STDNT_ID from STUDENT_INFO s1 with (nolock)where  s1.STDNT_BR_ID = @BrId and s1.STDNT_CLASSES_START_DATE between @FromDate and @ToDate)B 
join STUDENT_INFO s2 with (nolock)on s2.STDNT_ID = B.FEE_COLLECT_STD_ID
join SCHOOL_PLANE sp with (nolock) on sp.CLASS_ID = s2.STDNT_CLASS_PLANE_ID
join CLASS_INFO c1 on c1.CLASS_ID = sp.CLASS_CLASS
join RoyalityClassesAllowed r on r.ClassId = s2.STDNT_CLASS_PLANE_ID
cross join (select fi1.FEE_NAME,r1.ROYALTY_PERCENTAGE,fi1.FEE_TYPE from ROYALTY_FEE_SETTING r1
join FEE_INFO fi1 with (nolock) on fi1.FEE_ID = r1.ROYALTY_FEE_ID and fi1.FEE_BR_ID = @BrId and fi1.FEE_TYPE = 'Once')C 

)A on A.FEE_COLLECT_STD_ID = st.STDNT_ID and A.FEE_NAME = fi.FEE_NAME
left join RoyaltyRemarks rr on rr.StdId = st.STDNT_ID
)A

union
select st.StudentName, st.RegistrationNo, c.CLASS_ID, c.CLASS_NAME, f.FEE_TYPE, f.FEE_NAME, m.NetTotal, 0, ISNULL(d.Fee,0),ISNULL(d.Fee,0) * (ISNULL(rf.ROYALTY_PERCENTAGE ,0)/ 100),0,rf.ROYALTY_PERCENTAGE, sp.CLASS_ORDER,1,ISNULL(st.DateOfRegistration, CAST(st.CreatedDate as date)), @FromDate, 'Registration Student',0  from StudentRegistration st
join StdRegFeeGenerationMaster m on m.StudentRegistrationId = st.Id
join StdRegFeeGenerationDetail d on d.PId = m.Id
join FEE_INFO f on f.FEE_ID =d.FeeId
join SCHOOL_PLANE sp on sp.CLASS_ID = st.ClassId
join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS

join RoyalityClassesAllowed ca on ca.ClassId = sp.CLASS_ID 
join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = d.FeeId

where m.StartDate between @FromDate and @ToDate and d.Fee > 0 and st.Brid = @BrId


)T 
--where 1 = (IIF (FeeName = 'Registration Fee' and StudentNo in ('220020','220012','220008','220029','220013','220019','220038','220009','220001','220002','220030','220005','220006','220004','220014','220010','220017','220018','220022','220024','220028','220026','220027','220015'),0,1) )

--and 1 = (IIF (FeeName = 'Admission Fee' and StudentNo in ('220001','220002','220003','220004','220005','220006','220007','220008','220009','220010','220011','220012','220013','220014','220015','220016','220017','220018','220019','220020','220022','220024','220026','220027'),0,1) )

--select Name,StudentNo,ClassId,Class,FEE_TYPE,FeeName,TotalFee,TotalArears, Fee, IIF(Fee > 0,Royality,0) Royality, [Percent],ClassOrder,NoOfMonths,RegDate from 
--(select  st.STDNT_FIRST_NAME Name,st.STDNT_SCHOOL_ID StudentNo,c.CLASS_ID ClassId,c.CLASS_Name Class,ISNULL(fi.FEE_TYPE,'') FEE_TYPE,fi.FEE_NAME FeeName, (f.FEE_COLLECT_FEE) TotalFee,(f.FEE_COLLECT_ARREARS) TotalArears,IIF(f.FEE_COLLECT_FEE_FROM_DATE between @FromDate AND @ToDate,FEE_COLLECT_DEF_FEE,0)  Fee, FEE_COLLECT_DEF_ROYALTY Royality, fd.FEE_COLLECT_DEF_ROYALTY_PERCENT [Percent], sp.CLASS_ORDER ClassOrder, DATEDIFF(MONTH, FEE_COLLECT_FEE_FROM_DATE, FEE_COLLECT_FEE_TO_DATE) + 1 as NoOfMonths,'1900-01-01' RegDate   from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
----join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join ROYALTY_FEE_SETTING rf on rf.ROYALTY_FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--right join STUDENT_INFO st on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
--join CLASS_INFO c on c.CLASS_ID = sp.CLASS_CLASS
--where 
----s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and 
--sp.CLASS_BR_ID = @BrId and  fd.FEE_COLLECT_DEF_ROYALTY > 0 and FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate and fi.FEE_TYPE = 'once'
--)A --where Fee > 0
--select  st.STDNT_FIRST_NAME Name,st.STDNT_SCHOOL_ID StudentNo,f.FEE_COLLECT_PLAN_ID ClassId,sp.CLASS_Name Class,fi.FEE_NAME FeeName, (f.FEE_COLLECT_FEE) TotalFee,(f.FEE_COLLECT_ARREARS) TotalArears,(fd.FEE_COLLECT_DEF_FEE) Fee, ROUND((f.FEE_COLLECT_ROYALTY_FEE),0) Royality, fd.FEE_COLLECT_DEF_ROYALTY_PERCENT [Percent], sp.CLASS_ORDER ClassOrder from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--join STUDENT_INFO st on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
--where s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and CLASS_BR_ID = @BrId and fd.FEE_COLLECT_DEF_ROYALTY > 0 and f.FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate 




return

END