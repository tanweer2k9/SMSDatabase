CREATE TABLE [dbo].[FeeDiscountGovt] (
    [Id]                NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]              NUMERIC (18) NULL,
    [StdId]             NUMERIC (18) NULL,
    [DiscountAlready]   FLOAT (53)   NULL,
    [DiscountAvailable] FLOAT (53)   NULL,
    CONSTRAINT [PK_FeeDiscountGovt] PRIMARY KEY CLUSTERED ([Id] ASC)
);

