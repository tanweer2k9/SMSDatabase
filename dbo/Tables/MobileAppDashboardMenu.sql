CREATE TABLE [dbo].[MobileAppDashboardMenu] (
    [Id]             NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (100) NULL,
    [Code]           NVARCHAR (100) NULL,
    [Icon]           NVARCHAR (50)  NULL,
    [IconLibrary]    NVARCHAR (50)  NULL,
    [NavigationPath] NVARCHAR (100) NULL,
    [OrderRank]      INT            NULL,
    [ParentId]       NUMERIC (18)   NULL,
    [ClassLevel]     INT            NULL,
    [Status]         BIT            NULL,
    CONSTRAINT [PK_MobileAppDashboardMenu] PRIMARY KEY CLUSTERED ([Id] ASC)
);

