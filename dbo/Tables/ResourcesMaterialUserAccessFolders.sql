CREATE TABLE [dbo].[ResourcesMaterialUserAccessFolders] (
    [Id]       BIGINT IDENTITY (1, 1) NOT NULL,
    [FolderId] BIGINT NULL,
    [UserId]   BIGINT NULL,
    CONSTRAINT [PK_ResourcesMaterialUserAccessFolders] PRIMARY KEY CLUSTERED ([Id] ASC)
);

