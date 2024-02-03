CREATE PROC sp_GET_CALCULATE_GRADE_INFO

@CLASS_ID numeric 

AS


--declare @class_id numeric = 3


select pgd.*, gi.GRADE_NAME Grade from GRADE_INFO gi
join PLAN_GRADE_DEF pgd on pgd.DEF_GRADE_INFO_ID =gi.GRADE_ID and pgd.DEF_GRADE_STATUS = 'T'
join GRADE_MAPPING gm on gm.GRADE_MAP_GRADE_PLAN_ID = pgd.DEF_P_ID
where gm.GRADE_MAP_CLASS_ID = @CLASS_ID