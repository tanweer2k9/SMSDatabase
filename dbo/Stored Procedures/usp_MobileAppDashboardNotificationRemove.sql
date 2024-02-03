

CREATE PROC [dbo].[usp_MobileAppDashboardNotificationRemove]


@UserId numeric ,
@DashboardId numeric

AS




update MobileAppDashboardNotificationCount set NotificationCount = 0 where UserId = @UserId and DashboardId = @DashboardId