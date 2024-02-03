


CREATE PROC [dbo].[rptRoyalitySummary]

 @BrId numeric,
 @FromDate date,
 @ToDate date,
 @Session nvarchar(50),
 @isAllFeeHeads bit

 AS
--declare @Session nvarchar(50) = '2018-2019'
--declare @BrId numeric = 4
--declare @FromDate date = '2019-01-01'
--declare @ToDate date = '2019-01-31'


--select fi.FEE_NAME FeeName, SUM(f.FEE_COLLECT_FEE) TotalFee,SUM(f.FEE_COLLECT_ARREARS) TotalArears,SUM(fd.FEE_COLLECT_DEF_FEE) Fee, AVG(fd.FEE_COLLECT_DEF_ROYALTY_PERCENT) [Percent],ROUND(SUM(f.FEE_COLLECT_ROYALTY_FEE),0) Royality, COUNT(*) TotalSudents from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--where s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and CLASS_BR_ID = @BrId and fd.FEE_COLLECT_DEF_ROYALTY > 0 and f.FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate

declare @TotalStudents int = 0
select @TotalStudents = COUNT(ClassId) from dbo.tf_StudentRoyalityCount(@Session,@BrId,@FromDate,@ToDate) 


declare @NewStudents int = 0
select @NewStudents = COUNT(*) from STUDENT_INFO where STDNT_BR_ID = @BrId and STDNT_CLASSES_START_DATE between @FromDate and @ToDate


--delete from RoyaltyDetailTemp

--insert into RoyaltyDetailTemp
--select * from dbo.tf_RoyalityAll (@Session,@BrId,@FromDate,@ToDate)

select FORMAT(DATEADD(DD,7,GETDATE()),'dddd, MMMMM dd, yyyy') DueDate,FeeName, SUM(IIF(Royality > 0, TotalFee,0)) TotalFee,SUM(TotalArears) TotalArears,SUM(IIF(Royality > 0, Fee,0)) Fee, AVG([Percent]) [Percent],ROUND(SUM(Royality),0) Royality,ROUND(SUM(ISNULL(RoyaltyArrears,0)),0) RoyaltyArrears, SUM(IIF(Royality > 0, 1,0)) RoyaltySudents , @TotalStudents TotalStudents,@NewStudents NewStudents, SUM(IIF(Royality > 0, 1,0)) NoOfRoyaltySudents
FROM RoyaltyDetailTemp where Fee > 0 and FromDate between @FromDate and @ToDate and BrId = @BrId

group by FeeName

--union

--select FORMAT(DATEADD(DD,7,GETDATE()),'dddd, MMMMM dd, yyyy') DueDate,fi.FEE_NAME,0,0,0,r.ROYALTY_PERCENTAGE,0,0,0, @TotalStudents TotalStudents,0 NewStudents, 0 RoyaltySudents from ROYALTY_FEE_SETTING r
--join FEE_INFO fi on fi.FEE_ID = r.ROYALTY_FEE_ID
--where r.ROYALTY_BR_ID = @BrId and r.ROYALTY_FEE_ID not in (select distinct FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ROYALTY > 0 and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate)) AND @isAllFeeHeads = 1