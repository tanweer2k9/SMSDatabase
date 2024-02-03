CREATE PROC dbo.usp_GetClassesAgainstSessionBranch

@BrId numeric,
@SessionId numeric,
@Level int



AS


if @SessionId = -1
BEGIN
	set @SessionId = (select BR_ADM_SESSION from BR_ADMIN where BR_ADM_ID = @BrId)
END


select ID,Name + ' ('+ CAST(  ISNULL((select COUNT(*) from EXAM_ASSESS_CATEGORY_INFO where EXAM_CAT_CLASS_ID = sp.ID),0) as nvarchar(10)) + ')' from VSCHOOL_PLANE sp

where [Session Id] = @SessionId and [Status] = 'T' and [Branch ID] = @BrId and (@level = 0  OR [Level] = @level) order by [Order]