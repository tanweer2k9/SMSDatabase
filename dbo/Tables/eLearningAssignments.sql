CREATE TABLE [dbo].[eLearningAssignments] (
    [Id]            NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]          NUMERIC (18)   NULL,
    [ClassId]       NUMERIC (18)   NULL,
    [SubjectId]     NUMERIC (18)   NULL,
    [Type]          NVARCHAR (100) NULL,
    [Topic]         NVARCHAR (200) NULL,
    [Date]          DATE           NULL,
    [Instructions]  NVARCHAR (MAX) NULL,
    [DueDate]       DATE           NULL,
    [TotalMarks]    FLOAT (53)     NULL,
    [ObtainedMarks] FLOAT (53)     NULL,
    [FilePath]      NVARCHAR (200) NULL,
    [IsDeleted]     BIT            NULL,
    [CreateDate]    DATETIME       NULL,
    [CreateBy]      NUMERIC (18)   NULL,
    [UpdateDate]    DATETIME       NULL,
    [UpdateBy]      NUMERIC (18)   NULL,
    CONSTRAINT [PK_eLearningAssignments] PRIMARY KEY CLUSTERED ([Id] ASC)
);

