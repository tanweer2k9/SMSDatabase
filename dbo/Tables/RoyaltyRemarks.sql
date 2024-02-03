CREATE TABLE [dbo].[RoyaltyRemarks] (
    [Id]        NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [StdId]     NUMERIC (18)   NULL,
    [Date]      DATE           NULL,
    [Remarks]   NVARCHAR (300) NULL,
    [IsRoyalty] BIT            NULL,
    CONSTRAINT [PK_RoyaltyRemarks] PRIMARY KEY CLUSTERED ([Id] ASC)
);

