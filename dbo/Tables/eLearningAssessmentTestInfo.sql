CREATE TABLE [dbo].[eLearningAssessmentTestInfo] (
    [Id]            NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]          NUMERIC (18)   NULL,
    [ClassId]       NUMERIC (18)   NULL,
    [SubjectId]     NUMERIC (18)   NULL,
    [Name]          NVARCHAR (200) NULL,
    [PublishDate]   DATE           NULL,
    [TotalMarks]    INT            NULL,
    [TotalQuestion] INT            NULL,
    [TotalTime]     INT            NULL,
    [DueDate]       DATE           NULL,
    [IsDeleted]     BIT            NULL,
    [CreatedDate]   DATETIME       NULL,
    [CreatedBy]     NUMERIC (18)   NULL,
    [UpdatedDate]   DATETIME       NULL,
    [UpdatedBy]     NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningAssessmnetTest] PRIMARY KEY CLUSTERED ([Id] ASC)
);

