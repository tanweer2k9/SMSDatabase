CREATE TABLE [dbo].[BankCode] (
    [Id]       NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [BrId]     NUMERIC (18)  NULL,
    [BankName] NVARCHAR (50) NULL,
    [BankCode] NVARCHAR (50) NULL,
    CONSTRAINT [PK_BankCode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

