CREATE TABLE [dbo].[FeeChallanFilesPath] (
    [Id]        NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [InvoiceId] NUMERIC (18)   NULL,
    [Path]      NVARCHAR (200) NULL,
    CONSTRAINT [PK_FeeChallanFilesPath] PRIMARY KEY CLUSTERED ([Id] ASC)
);

