CREATE TABLE [dbo].[MobileAppDashboardRights] (
    [Id]          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [DashboardId] NUMERIC (18) NULL,
    [IsAdmin]     BIT          NULL,
    [IsTeacher]   BIT          NULL,
    [IsParent]    BIT          NULL,
    CONSTRAINT [PK_MobileAppDashboardRights] PRIMARY KEY CLUSTERED ([Id] ASC)
);

