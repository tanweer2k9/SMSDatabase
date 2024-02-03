CREATE TABLE [dbo].[eLearningAssessmentFileImages] (
    [Id]                NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [FilePath]          NVARCHAR (500) NULL,
    [FileName]          NVARCHAR (500) NULL,
    [FilePathThumbnail] NVARCHAR (500) NULL,
    [QuestionId]        NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningAssessmentFileImages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

