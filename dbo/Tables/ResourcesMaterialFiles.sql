CREATE TABLE [dbo].[ResourcesMaterialFiles] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [BrId]           BIGINT         NULL,
    [FileName]       NVARCHAR (100) NULL,
    [FilePath]       NVARCHAR (500) NULL,
    [FileType]       NVARCHAR (50)  NULL,
    [FolderId]       BIGINT         NULL,
    [IsDownloadable] BIT            NULL,
    [IsViewable]     BIT            NULL,
    [PublishDate]    DATE           NULL,
    [ExpiryDate]     DATE           NULL,
    [CreatedDate]    DATETIME       NULL,
    [CreatedBy]      BIGINT         NULL,
    [UpdatedDate]    DATETIME       NULL,
    [UpdatedBy]      BIGINT         NULL,
    CONSTRAINT [PK_ResourcesMaterialFiles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

