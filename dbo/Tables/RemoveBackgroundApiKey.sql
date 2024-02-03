CREATE TABLE [dbo].[RemoveBackgroundApiKey] (
    [Id]        NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [Email]     NVARCHAR (50) NULL,
    [Password]  NVARCHAR (50) NULL,
    [ApiKey]    NVARCHAR (50) NULL,
    [Count]     INT           NULL,
    [RenewDate] DATE          NULL,
    CONSTRAINT [PK_RemoveBackgroundApiKey] PRIMARY KEY CLUSTERED ([Id] ASC)
);

