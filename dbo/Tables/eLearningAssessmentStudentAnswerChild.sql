CREATE TABLE [dbo].[eLearningAssessmentStudentAnswerChild] (
    [Id]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [PId]         NUMERIC (18)   NULL,
    [QuestionId]  NUMERIC (18)   NULL,
    [OptionId]    NUMERIC (18)   NULL,
    [Answer]      NVARCHAR (MAX) NULL,
    [CreatedDate] DATETIME       NULL,
    CONSTRAINT [PK_eLearningAssessmentStudentAnswer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

