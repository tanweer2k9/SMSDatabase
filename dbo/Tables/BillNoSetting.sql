CREATE TABLE [dbo].[BillNoSetting] (
    [Id]     NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]   NUMERIC (18) NULL,
    [BillNo] BIGINT       NULL,
    CONSTRAINT [PK_BillNoSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

