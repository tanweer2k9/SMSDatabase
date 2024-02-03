CREATE PROC rpt_FeePlanMonthlyTermFeeReport
@BR_ID numeric
AS


select s.STDNT_SCHOOL_ID [School ID], s.STDNT_FIRST_NAME [Student Name], sp.CLASS_ID [Class ID], fd.PLAN_FEE_DEF_FEE  Fee
--SUM(PLAN_FEE_DEF_FEE)
from STUDENT_INFO s
join PLAN_FEE_DEF fd on fd.PLAN_FEE_DEF_PLAN_ID = s.STDNT_CLASS_FEE_ID
join FEE_INFO f on f.FEE_ID = fd.PLAN_FEE_DEF_FEE_NAME
join SCHOOL_PLANE sp on sp.CLASS_ID = s.STDNT_CLASS_PLANE_ID


where f.FEE_NAME like '%Term%' and s.STDNT_BR_ID = @BR_ID and fd.PLAN_FEE_DEF_STATUS = 'T' and s.STDNT_STATUS = 'T' 
order by CLASS_BR_ID desc, CLASS_ORDER