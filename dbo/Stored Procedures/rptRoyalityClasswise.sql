
CREATE PROC [dbo].[rptRoyalityClasswise]


 @BrId numeric,
 @FromDate date,
 @ToDate date,
 @Session nvarchar(50)

 AS
--declare @Session nvarchar(50) = '2018-2019'
--declare @BrId numeric = 4
--declare @FromDate date = '2019-01-01'
--declare @ToDate date = '2019-01-31'


select * FROM
(select A.ClassId, FeeName,FeeType, MAX(Class) Class,SUM(IIF(Royality > 0, TotalFee,0)) TotalFee,SUM(TotalArears) TotalArears,SUM(IIF(Royality > 0, Fee,0)) Fee, AVG([Percent]) [Percent],ROUND(SUM(Royality),0) Royality,ROUND(SUM(ISNULL(RoyaltyArrears,0)),0) RoyaltyArrears, SUM(IIF(Fee > 0, 1,0)) RoyalitySudents, COUNT(*) StudentCount, max(ClassOrder) ClassOrder
FROM RoyaltyDetailTemp A
full outer join (select ClassId, COUNT(ClassId) StudentCount from dbo.tf_StudentRoyalityCount(@Session,@BrId,@FromDate,@ToDate) group by ClassId)B on B.ClassId = A.ClassId
where  FromDate = @FromDate and BrId = @BrId
--where Fee > 0
group by A.ClassId, FeeName,FeeType
)A
order by FeeName, Classorder
--select * FROM
--(select A.ClassId, FeeName,FeeType, MAX(Class) Class,SUM(TotalFee) TotalFee,SUM(TotalArears) TotalArears,SUM(Fee) Fee, AVG([Percent]) [Percent],ROUND(SUM(Royality),0) Royality, COUNT(*) RoyalitySudents, MAX(B.StudentCount) StudentCount, max(ClassOrder) ClassOrder
--FROM dbo.tf_RoyalityAll (@Session,@BrId,@FromDate,@ToDate)A
--join (select ClassId, COUNT(ClassId) StudentCount from dbo.tf_StudentRoyalityCount(@Session,@BrId,@FromDate,@ToDate) group by ClassId)B on B.ClassId = A.ClassId
--where Fee > 0
--group by A.ClassId, FeeName,FeeType
--)A
--order by Classorder


--select  distinct sp.CLASS_ID ClassId,sp.CLASS_Name Class,fi.FEE_NAME FeeHead from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--join STUDENT_INFO st on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
--where s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and CLASS_BR_ID = @BrId and fd.FEE_COLLECT_DEF_ROYALTY > 0 and f.FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate 
--group by fi.FEE_NAME

--union

--select fi.FEE_NAME,0,0,0,0,0 from ROYALTY_FEE_SETTING r
--join FEE_INFO fi on fi.FEE_ID = r.ROYALTY_FEE_ID
--where r.ROYALTY_BR_ID = @BrId and r.ROYALTY_FEE_ID not in (select distinct FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ROYALTY > 0 and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate))