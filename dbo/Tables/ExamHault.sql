CREATE TABLE [dbo].[ExamHault] (
    [Id]                   NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]                 NUMERIC (18) NULL,
    [IsAssessmentExamShow] BIT          NULL,
    [IsRegularExamShow]    BIT          NULL,
    CONSTRAINT [PK_ExamHault] PRIMARY KEY CLUSTERED ([Id] ASC)
);

