CREATE TABLE [dbo].[MoibleAppSubscribedUsers] (
    [Id]         NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [UserId]     NUMERIC (18)  NULL,
    [PlayerId]   NVARCHAR (50) NULL,
    [DeviceId]   NVARCHAR (50) NULL,
    [CreateDate] DATETIME      NULL,
    [UpdateDate] DATETIME      NULL,
    [IsLoggedIn] BIT           NULL,
    CONSTRAINT [PK_MoibleAppSubscribedUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

