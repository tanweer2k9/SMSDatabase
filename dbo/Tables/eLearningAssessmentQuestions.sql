CREATE TABLE [dbo].[eLearningAssessmentQuestions] (
    [Id]                  NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [AssesmentTestInfoId] NUMERIC (18)   NULL,
    [ParagraphId]         NUMERIC (18)   NULL,
    [QuestionTypeId]      NUMERIC (18)   NULL,
    [Question]            NVARCHAR (MAX) NULL,
    [Marks]               FLOAT (53)     NULL,
    [IsDeleted]           BIT            NULL,
    [CreatedDate]         DATETIME       NULL,
    [CreatedBy]           NUMERIC (18)   NULL,
    [UpdatedDate]         DATETIME       NULL,
    [UpdatedBy]           NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningAssessmentQuestions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

