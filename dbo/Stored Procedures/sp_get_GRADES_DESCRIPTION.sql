
CREATE PROC [dbo].[sp_get_GRADES_DESCRIPTION]

@CLASS_ID numeric

AS

--declare @CLASS_ID numeric = 0


declare @class nvarchar(20) = '%'

if @CLASS_ID != 0
BEGIN
	set @class = CAST(@CLASS_ID as nvarchar(50))
END


select gd.*,m.GRADE_MAP_CLASS_ID, g.GRADE_NAME,gd.DEF_GRADE_DESCRIPTION, pg.P_GRADE_SUBJECT_AWRADS_MARKS SubjectAwardsMarks
from GRADE_MAPPING m
join PLAN_GRADE_DEF gd on gd.DEF_P_ID = m.GRADE_MAP_GRADE_PLAN_ID
join GRADE_INFO g on g.GRADE_ID = gd.DEF_GRADE_INFO_ID
join PLAN_GRADE pg on pg.P_GRADE_ID = gd.DEF_P_ID
join BR_ADMIN b on b.BR_ADM_ID = pg.P_GRADE_BR_ID
join SESSION_INFO s on s.SESSION_ID = b.BR_ADM_SESSION 
where m.GRADE_MAP_CLASS_ID like @class and gd.DEF_GRADE_STATUS = 'T'  and s.SESSION_START_DATE = pg.P_GRADE_SESSION_START_DATE