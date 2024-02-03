CREATE TABLE [dbo].[eLearningAssessmentStudentAnswerMarks] (
    [Id]          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PId]         NUMERIC (18) NULL,
    [QuestionId]  NUMERIC (18) NULL,
    [Marks]       FLOAT (53)   NULL,
    [IsDeleted]   BIT          NULL,
    [CreatedDate] DATETIME     NULL,
    [CreatedBy]   NUMERIC (18) NULL,
    CONSTRAINT [PK_eLearningAssessmentStudentAnswerMarks] PRIMARY KEY CLUSTERED ([Id] ASC)
);

