CREATE TABLE [dbo].[FeeChallanBankDetail] (
    [Id]                     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HdId]                   NUMERIC (18)   NULL,
    [BrId]                   NUMERIC (18)   NULL,
    [BankDetail1]            NVARCHAR (MAX) NULL,
    [BankDetail2]            NVARCHAR (MAX) NULL,
    [CareOfTitle]            NVARCHAR (500) NULL,
    [SchoolCopyInstruction]  NVARCHAR (MAX) NULL,
    [ParentCopyInstruction]  NVARCHAR (MAX) NULL,
    [BankCopyInstruction]    NVARCHAR (MAX) NULL,
    [IsTotalFeeOnFeeChallan] BIT            NULL,
    [CreatedDate]            DATETIME       NULL,
    [CreatedBy]              NUMERIC (18)   NULL,
    [UpdatedDate]            DATETIME       NULL,
    [UpdatedBy]              NUMERIC (18)   NULL,
    CONSTRAINT [PK_FeeChallanBankDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);



