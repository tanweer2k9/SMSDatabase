

CREATE PROC [dbo].[rptRoyalityClasswiseDetail]


 @BrId numeric,
 @FromDate date,
 @ToDate date,
 @Session nvarchar(50)

 AS
--declare @Session nvarchar(50) = '2018-2019'
--declare @BrId numeric = 4
--declare @FromDate date = '2019-01-01'
--declare @ToDate date = '2019-01-31'


select * from RoyaltyDetailTemp A where   FromDate = @FromDate and BrId = @BrId

--select  st.STDNT_FIRST_NAME Name,st.STDNT_SCHOOL_ID StudentNo,f.FEE_COLLECT_PLAN_ID ClassId,sp.CLASS_Name Class,fi.FEE_NAME FeeName, (f.FEE_COLLECT_FEE) TotalFee,(f.FEE_COLLECT_ARREARS) TotalArears,(fd.FEE_COLLECT_DEF_FEE) Fee, ROUND((f.FEE_COLLECT_ROYALTY_FEE),0) Royality from FEE_COLLECT f
--join SCHOOL_PLANE sp on sp.CLASS_ID = f.FEE_COLLECT_PLAN_ID
--join SESSION_INFO s on s.SESSION_ID = sp.CLASS_SESSION_ID
--join RoyalityClassesAllowed r on r.ClassId = sp.CLASS_ID
--join FEE_COLLECT_DEF fd on fd.FEE_COLLECT_DEF_PID = f.FEE_COLLECT_ID
--join FEE_INFO fi on fi.FEE_ID = fd.FEE_COLLECT_DEF_FEE_NAME
--join STUDENT_INFO st on st.STDNT_ID = f.FEE_COLLECT_STD_ID 
--where s.SESSION_DESC = @Session and s.SESSION_STATUS = 'T' and CLASS_BR_ID = @BrId and fd.FEE_COLLECT_DEF_ROYALTY > 0 and f.FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate 

order by CAST(StudentNo as int)
--group by fi.FEE_NAME

--union

--select fi.FEE_NAME,0,0,0,0,0 from ROYALTY_FEE_SETTING r
--join FEE_INFO fi on fi.FEE_ID = r.ROYALTY_FEE_ID
--where r.ROYALTY_BR_ID = @BrId and r.ROYALTY_FEE_ID not in (select distinct FEE_COLLECT_DEF_FEE_NAME from FEE_COLLECT_DEF where FEE_COLLECT_DEF_ROYALTY > 0 and FEE_COLLECT_DEF_PID in (select FEE_COLLECT_ID from FEE_COLLECT where FEE_COLLECT_FEE_FROM_DATE between @FromDate and @ToDate))