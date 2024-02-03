CREATE TABLE [dbo].[eLearningAssessmentStudentAnswerParent] (
    [Id]                 NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [TestInfoId]         NUMERIC (18) NULL,
    [StudentId]          NUMERIC (18) NULL,
    [StartTime]          DATETIME     NULL,
    [ObtainMarks]        FLOAT (53)   NULL,
    [ReamingTimeSeconds] INT          NULL,
    [IsCompleted]        BIT          NULL,
    [CreatedDate]        DATETIME     NULL,
    [MarksUpdatedDate]   DATETIME     NULL,
    [MarksUpdatedBy]     NUMERIC (18) NULL,
    CONSTRAINT [PK_eLearningAssessmentStudentAnswerMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

