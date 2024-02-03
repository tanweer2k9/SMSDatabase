
CREATE PROC [dbo].[usp_GetActivities]

@ClassId numeric,
@StdId numeric,
@UserType nvarchar(50),
@ActivityType nvarchar(50)
As

--declare @ClassId numeric = 30120
--declare @StdId numeric = 1

select  top (80) ROW_NUMBER() over(partition by FeedType order by CreateDate desc) as Sr, Id, Title, FeedType ActivityType, FeedDescription Description, IIF(ImageUrl is nULL OR ImageUrl = '','/Content/Images/AppDiary/default/default.jpg',ImageUrl) ImageUrl, FORMAT(CreateDate, 'ddddd, MMMM dd, yyyy hh:mm tt') DateTime  from DiaryFeed f


where IsDeleted = 0 and FeedType =  @ActivityType and (((@UserType = 'A' OR @UserType = 'Teacher') AND ClassId = @ClassId ) 
OR (@UserType = 'Parent' AND f.ClassId = @ClassId  AND StudentId IS NULL) OR (@UserType = 'Parent' AND f.ClassId = @ClassId and StudentId = @StdId )

)

--where (@StdId = 0 OR  ISNULL(ClassId,0) = @ClassId OR ISNULL(StudentId,0) = @StdId 