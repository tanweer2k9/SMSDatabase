




CREATE PROC [dbo].[usp_MobileAppDashboardNotificationUpdation]


@UserIds nvarchar(MAX) ,
@SubDashboardMenu nvarchar(100)

AS

--declare @UserId nvarchar(MAX) = '',
--@SubDashboardMenu nvarchar(100) = 'ActivitiesUpdatesClassActivities'

declare @DashboardId numeric = 0

select top(1) @DashboardId = Id from MobileAppDashboardMenu where Code = @SubDashboardMenu





--Matched will be update otherwise insert
 MERGE INTO MobileAppDashboardNotificationCount AS Target
    USING (select cast(val as int) as UserId, @DashboardId DashboardId  from split(@UserIds, ',')) AS Source
    ON Target.DashboardId = Source.DashboardId and Target.UserId = Source.UserId 
    WHEN MATCHED THEN
        UPDATE SET Target.NotificationCount = Target.NotificationCount + 1
    WHEN NOT MATCHED THEN           
        INSERT (DashboardId,
            UserId,
           NotificationCount
            )
        VALUES (Source.DashboardId,
            Source.UserId,
            1
            );