CREATE TABLE [dbo].[MobileAppDashboardNotificationCount] (
    [Id]                NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [DashboardId]       NUMERIC (18) NULL,
    [UserId]            NUMERIC (18) NULL,
    [NotificationCount] INT          NULL,
    CONSTRAINT [PK_MobileAppDashboardNotificationCount] PRIMARY KEY CLUSTERED ([Id] ASC)
);

