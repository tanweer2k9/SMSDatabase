CREATE TABLE [dbo].[ResourcesMaterialFolders] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (200) NULL,
    [ParentId]    BIGINT         NULL,
    [IsDeleted]   BIT            NULL,
    [FolderType]  INT            NULL,
    [CreatedDate] DATETIME       NULL,
    [CreatedBy]   NUMERIC (18)   NULL,
    [UpdatedDate] DATETIME       NULL,
    [UpdatedBy]   NUMERIC (18)   NULL,
    CONSTRAINT [PK_ResourcesMaterialFolders] PRIMARY KEY CLUSTERED ([Id] ASC)
);

