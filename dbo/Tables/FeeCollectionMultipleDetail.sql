CREATE TABLE [dbo].[FeeCollectionMultipleDetail] (
    [Id]              NUMERIC (18) NULL,
    [FeeCollectionId] NUMERIC (18) NULL,
    [Amount]          FLOAT (53)   NULL,
    [MulitReceivedId] NUMERIC (18) NULL,
    [ChequeId]        NUMERIC (18) NULL,
    [IsAdvance]       BIT          NULL
);

