

CREATE PROC [dbo].[usp_MobileAppSubDashboardNotificationCount]

@UserId numeric,
@DashboardId numeric

AS

--declare @UserId numeric = 273066
--declare @DashboardId numeric = 3
declare @UserType nvarchar(50) = '', @BrId numeric = 0

select @UserType = USER_TYPE,@BrId = USER_BR_ID from USER_INFO where USER_ID = @UserId 

select distinct d.Id,IIF(d.Code = 'ActivitiesUpdatesPTM', IIF(@UserType = 'Teacher', 'TeacherPTM','ParentTeacherMeeting'),d.NavigationPath) NavigationPath,d.Code,d.Icon,d.IconLibrary,d.Name, ISNULL(A.TotalCount,0) TotalCount, d1.Name ParentDashboardName from
(select d.Id,Name, NotificationCount TotalCount from MobileAppDashboardMenu d
join MobileAppDashboardNotificationCount c on c.DashboardId = d.Id

where UserId = @UserId and d.ParentId = @DashboardId
)A

 right join MobileAppDashboardMenu d on d.Id = A.Id
 right join  MobileAppDashboardRights r on r.DashboardId = d.Id
 left join MobileAppDashboardMenu d1 on d.ParentId = d1.Id

 where d.ParentId = @DashboardId and 
 (
 (@UserType = 'A' AND IsAdmin = 1 )
OR (@UserType = 'Student' AND IsParent = 1 )
OR (@UserType = 'Teacher' AND IsTeacher = 1 )
 )

 and (CASE WHEN @BrId = 5 and @UserType = 'Student' and @DashboardId = 3 THEN 0 ELSE 1 END) = 1

 order by d.Id