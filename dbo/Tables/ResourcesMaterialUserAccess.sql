CREATE TABLE [dbo].[ResourcesMaterialUserAccess] (
    [Id]     BIGINT IDENTITY (1, 1) NOT NULL,
    [FileId] BIGINT NULL,
    [UserId] BIGINT NULL,
    CONSTRAINT [PK_ResourcesMaterialUserAccess] PRIMARY KEY CLUSTERED ([Id] ASC)
);

