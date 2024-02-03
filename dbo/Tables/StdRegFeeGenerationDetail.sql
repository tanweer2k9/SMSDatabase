CREATE TABLE [dbo].[StdRegFeeGenerationDetail] (
    [Id]    NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [PId]   NUMERIC (18) NULL,
    [FeeId] NUMERIC (18) NULL,
    [Fee]   FLOAT (53)   NULL,
    CONSTRAINT [PK_StdRegFeeGenerationDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);

