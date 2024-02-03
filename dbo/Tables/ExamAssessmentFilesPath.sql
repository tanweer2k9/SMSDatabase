CREATE TABLE [dbo].[ExamAssessmentFilesPath] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [ParentKeyId] NUMERIC (18)   NULL,
    [StdId]       NUMERIC (18)   NULL,
    [FilePath]    NVARCHAR (500) NULL,
    [IsDeleted]   BIT            NULL,
    CONSTRAINT [PK_ExamAssessmentFilesPath] PRIMARY KEY CLUSTERED ([Id] ASC)
);

