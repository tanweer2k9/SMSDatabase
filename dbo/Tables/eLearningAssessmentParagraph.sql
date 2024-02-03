CREATE TABLE [dbo].[eLearningAssessmentParagraph] (
    [Id]            NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [PaagrapghName] NVARCHAR (100) NULL,
    [ParagraphText] NVARCHAR (MAX) NULL,
    [TestInfoId]    NUMERIC (18)   NULL,
    [CreatedDate]   DATETIME       NULL,
    [CreatedBy]     NUMERIC (18)   NULL,
    [UpdatedDate]   DATETIME       NULL,
    [UpdatedBy]     NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningAssessmentParagraph] PRIMARY KEY CLUSTERED ([Id] ASC)
);

