CREATE TABLE [dbo].[DeviceInfo] (
    [Id]                NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [ClientType]        NVARCHAR (100)  NULL,
    [BrowserName]       NVARCHAR (100)  NULL,
    [BroswerVersion]    NVARCHAR (100)  NULL,
    [BrowserEngine]     NVARCHAR (100)  NULL,
    [OsName]            NVARCHAR (100)  NULL,
    [OSVersion]         NVARCHAR (100)  NULL,
    [OSPlatForm]        NVARCHAR (100)  NULL,
    [DeviceType]        NVARCHAR (100)  NULL,
    [DeviceBrand]       NVARCHAR (100)  NULL,
    [DeviceModel]       NVARCHAR (100)  NULL,
    [UserAgent]         NVARCHAR (1000) NULL,
    [UserAgentInfoJson] NVARCHAR (1000) NULL,
    [CreatedDate]       DATETIME        NULL,
    CONSTRAINT [PK_DeviceInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

