CREATE TABLE [dbo].[MobileAppPushNotificationHistory] (
    [Id]                 NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BrId]               NUMERIC (18)    NULL,
    [ClassId]            NVARCHAR (MAX)  NULL,
    [StudentIds]         NVARCHAR (MAX)  NULL,
    [NotificationScreen] NVARCHAR (50)   NULL,
    [AppId]              NVARCHAR (100)  NULL,
    [Message]            NVARCHAR (1000) NULL,
    [Header]             NVARCHAR (100)  NULL,
    [PlayerIds]          NVARCHAR (MAX)  NULL,
    [Response]           NVARCHAR (MAX)  NULL,
    [IsSuccess]          BIT             NULL,
    [DateTime]           DATETIME        NULL,
    CONSTRAINT [PK_MobileAppPushNotificationHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

