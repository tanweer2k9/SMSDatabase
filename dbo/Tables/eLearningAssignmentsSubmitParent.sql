CREATE TABLE [dbo].[eLearningAssignmentsSubmitParent] (
    [Id]               NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [AssignmentId]     NUMERIC (18)    NULL,
    [StudentId]        NUMERIC (18)    NULL,
    [AssignmentStatus] NVARCHAR (50)   NULL,
    [Description]      NVARCHAR (1000) NULL,
    [Remarks]          NVARCHAR (1000) NULL,
    [ObtainMarks]      FLOAT (53)      NULL,
    [CreatedDate]      DATETIME        NULL,
    [CreatedBy]        NUMERIC (18)    NULL,
    [UpdatedDate]      DATETIME        NULL,
    [UpdateBy]         NUMERIC (18)    NULL,
    CONSTRAINT [PK_eLearningAssignmentsSubmitParent] PRIMARY KEY CLUSTERED ([Id] ASC)
);

