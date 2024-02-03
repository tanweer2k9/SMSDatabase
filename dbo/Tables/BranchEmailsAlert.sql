CREATE TABLE [dbo].[BranchEmailsAlert] (
    [Id]        NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [HdId]      NUMERIC (18)  NULL,
    [BrId]      NUMERIC (18)  NULL,
    [Module]    NVARCHAR (50) NULL,
    [Email]     NVARCHAR (50) NULL,
    [IsDeleted] BIT           NULL,
    CONSTRAINT [PK_BranchEmailsAlert] PRIMARY KEY CLUSTERED ([Id] ASC)
);

