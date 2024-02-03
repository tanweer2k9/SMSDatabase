CREATE TABLE [dbo].[eLearningAssignmentsSubmit] (
    [Id]           NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [FilePath]     NVARCHAR (300)  NULL,
    [Description]  NVARCHAR (1000) NULL,
    [StudentId]    NUMERIC (18)    NULL,
    [AssignmentId] NUMERIC (18)    NULL,
    [CreatedDate]  DATETIME        NULL,
    [CreatedBy]    NUMERIC (18)    NULL,
    [UpdatedDate]  DATETIME        NULL,
    [UpdateBy]     NUMERIC (18)    NULL,
    CONSTRAINT [PK_eLearningAssignmentsSubmit] PRIMARY KEY CLUSTERED ([Id] ASC)
);

