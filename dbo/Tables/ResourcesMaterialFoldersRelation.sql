CREATE TABLE [dbo].[ResourcesMaterialFoldersRelation] (
    [Id]               BIGINT IDENTITY (1, 1) NOT NULL,
    [FolderId]         BIGINT NULL,
    [FolderRelationId] BIGINT NULL,
    CONSTRAINT [PK_ResourcesMaterialFoldersRelation] PRIMARY KEY CLUSTERED ([Id] ASC)
);

