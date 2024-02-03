CREATE TABLE [dbo].[eLearningAssessmentOptions] (
    [Id]         NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [QuestionId] NUMERIC (18)    NULL,
    [OptionText] NVARCHAR (1000) NULL,
    [FilePath]   NVARCHAR (500)  NULL,
    [IsDeleted]  BIT             NULL,
    CONSTRAINT [PK_eLearningAssessmentOptions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

