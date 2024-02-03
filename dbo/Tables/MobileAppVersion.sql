CREATE TABLE [dbo].[MobileAppVersion] (
    [Id]                NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [AppVersionAndroid] NVARCHAR (100)  NULL,
    [AppVersionIos]     NVARCHAR (100)  NULL,
    [Title]             NVARCHAR (50)   NULL,
    [Message]           NVARCHAR (1000) NULL,
    [UrlAndroid]        NVARCHAR (100)  NULL,
    [Urlios]            NVARCHAR (100)  NULL,
    [AppName]           NVARCHAR (100)  NULL,
    [CreatedDate]       DATETIME        NULL,
    [UpdatedDate]       DATETIME        NULL,
    CONSTRAINT [PK_MobileAppVersion] PRIMARY KEY CLUSTERED ([Id] ASC)
);

