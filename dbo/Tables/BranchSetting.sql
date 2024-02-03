CREATE TABLE [dbo].[BranchSetting] (
    [Id]                 NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [BrId]               NUMERIC (18) NULL,
    [IsSmsEnabled]       BIT          NULL,
    [IsEmailEnabled]     BIT          NULL,
    [IsMobileAppEnabled] BIT          NULL,
    [Status]             BIT          NULL,
    CONSTRAINT [PK_BranchSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

