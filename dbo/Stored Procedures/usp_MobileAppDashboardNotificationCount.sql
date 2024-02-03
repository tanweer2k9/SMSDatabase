


CREATE PROC [dbo].[usp_MobileAppDashboardNotificationCount]

@UserId numeric

AS

--declare @UserId numeric = 273066
declare @UserType nvarchar(50) = (select USER_TYPE from USER_INFO where USER_ID = @UserId) 

select d.Id,d.NavigationPath,d.Code,d.Icon,d.IconLibrary,d.Name, ISNULL(A.TotalCount,0) TotalCount from
(select MAX(d1.Id) Id,d1.Name, SUM(NotificationCount) TotalCount from MobileAppDashboardMenu d
join MobileAppDashboardMenu d1 on d1.Id = d.ParentId 
join MobileAppDashboardNotificationCount c on c.DashboardId = d.Id

where UserId = @UserId

group by d1.Name

)A 
 right join MobileAppDashboardMenu d on d.Id = A.Id
 right join  MobileAppDashboardRights r on r.DashboardId = d.Id

 where d.ParentId is null and 
 (
 (@UserType = 'A' AND IsAdmin = 1 )
OR (@UserType = 'Student' AND IsParent = 1 )
OR (@UserType = 'Teacher' AND IsTeacher = 1 )
 )

 order by d.OrderRank