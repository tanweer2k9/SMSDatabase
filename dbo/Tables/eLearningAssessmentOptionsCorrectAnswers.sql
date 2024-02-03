CREATE TABLE [dbo].[eLearningAssessmentOptionsCorrectAnswers] (
    [Id]         NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [OptionId]   NUMERIC (18) NULL,
    [QuestionId] NUMERIC (18) NULL,
    CONSTRAINT [PK_eLearningAssessmentOptionsCorrectAnswers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

