CREATE TABLE [dbo].[eLearningAssignmentsFiles] (
    [Id]            NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [PId]           NUMERIC (18)   NULL,
    [FilePath]      NVARCHAR (500) NULL,
    [FileName]      NVARCHAR (200) NULL,
    [FileThumbnail] NVARCHAR (500) NULL,
    CONSTRAINT [PK_eLearningAssignmentsFiles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

