CREATE TABLE [dbo].[eLearningAssessmentQuestionType] (
    [Id]   NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (50) NULL,
    [Code] NVARCHAR (50) NULL,
    CONSTRAINT [PK_eLearningAssessmentQuestionType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

