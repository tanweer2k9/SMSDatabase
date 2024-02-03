CREATE TABLE [dbo].[eLearningAssessmentStudentAnswerOrderTemp] (
    [Id]               NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [StudentId]        NUMERIC (18) NULL,
    [TestInfoId]       NUMERIC (18) NULL,
    [QuestionId]       NUMERIC (18) NULL,
    [Serial]           INT          NULL,
    [IsDone]           BIT          NULL,
    [RemainingTimeSec] INT          NULL,
    CONSTRAINT [PK_eLearningAssessmentStudentAnswerOrderTemp] PRIMARY KEY CLUSTERED ([Id] ASC)
);

