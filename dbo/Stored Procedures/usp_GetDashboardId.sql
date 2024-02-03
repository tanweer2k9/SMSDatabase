create PROC usp_GetDashboardId

@SubDashboardMenu nvarchar(100) = ''

AS


select top(1) Id, ParentId from MobileAppDashboardMenu where Code = @SubDashboardMenu