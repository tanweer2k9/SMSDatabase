CREATE TABLE [dbo].[SMSHistory] (
    [Id]         NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HdId]       NUMERIC (18)   NULL,
    [BrId]       NUMERIC (18)   NULL,
    [MobileNo]   NVARCHAR (15)  NULL,
    [Mask]       NVARCHAR (15)  NULL,
    [Message]    NVARCHAR (700) NULL,
    [Characters] INT            NULL,
    [MsgCount]   INT            NULL,
    [Screen]     NVARCHAR (200) NULL,
    [UserId]     NUMERIC (18)   NULL,
    [DateTime]   DATETIME       NULL,
    [Status]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_SMSHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

