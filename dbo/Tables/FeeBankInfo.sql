CREATE TABLE [dbo].[FeeBankInfo] (
    [Id]           NUMERIC (18)   NULL,
    [BrId]         NUMERIC (18)   NULL,
    [HdId]         NUMERIC (18)   NULL,
    [AccountTitle] NVARCHAR (100) NULL,
    [BankName]     NVARCHAR (100) NULL,
    [BranchName]   NVARCHAR (100) NULL,
    [AccountNo]    NVARCHAR (100) NULL,
    [CreatedDate]  DATETIME       NULL,
    [CreatedBy]    NUMERIC (18)   NULL,
    [UpdatedDate]  DATETIME       NULL,
    [UpdatedBy]    NUMERIC (18)   NULL
);

