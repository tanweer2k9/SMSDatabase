CREATE TABLE [dbo].[RoyaltyStudentsArrears] (
    [Id]     NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [StdId]  NUMERIC (18) NULL,
    [Month]  DATE         NULL,
    [Amount] FLOAT (53)   NULL,
    CONSTRAINT [PK_RoyaltyStudentsArrears] PRIMARY KEY CLUSTERED ([Id] ASC)
);

