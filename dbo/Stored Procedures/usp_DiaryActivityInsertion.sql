CREATE PROC [dbo].[usp_DiaryActivityInsertion]

@Title nvarchar(100),
@FeedType nvarchar(50),
@FeedDescription nvarchar(1000),
@ImageUrl nvarchar(200),
@ClassId nvarchar(1000),
@StudentId nvarchar(MAX),
@UserId numeric
AS


if @ClassId = ''
BEGIN
	insert into DiaryFeed
	select st.STDNT_HD_ID, st.STDNT_BR_ID, @Title,@FeedType,@FeedDescription,@ImageUrl, st.STDNT_CLASS_PLANE_ID, st.STDNT_ID,CAST(1 as bit),CAST(0 as bit), GETDATE(), @UserId,NULL,NULL from dbo.split(@StudentId, ',') s
	join STUDENT_INFO st on st.STDNT_ID = CAST(s.val as numeric)

END
ELSE
BEGIN
	insert into DiaryFeed
	select sp.CLASS_HD_ID, sp.CLASS_BR_ID, @Title,@FeedType,@FeedDescription,@ImageUrl, sp.CLASS_ID, NULL,CAST(1 as bit),CAST(0 as bit), GETDATE(), @UserId,NULL,NULL from dbo.split(@ClassId, ',') s
	join SCHOOL_PLANE sp on sp.CLASS_ID = CAST(s.val as numeric)
END