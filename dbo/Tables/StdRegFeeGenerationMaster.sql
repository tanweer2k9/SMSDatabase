CREATE TABLE [dbo].[StdRegFeeGenerationMaster] (
    [Id]                    NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [BrId]                  NUMERIC (18)   NULL,
    [StudentRegistrationId] NUMERIC (18)   NULL,
    [ClassId]               NUMERIC (18)   NULL,
    [InstallmentName]       NVARCHAR (100) NULL,
    [FeeStatus]             NVARCHAR (100) NULL,
    [DueDate]               DATE           NULL,
    [StartDate]             DATE           NULL,
    [EndDate]               DATE           NULL,
    [NetTotal]              FLOAT (53)     NULL,
    [BillNo]                NVARCHAR (50)  NULL,
    [ChallanNo]             NVARCHAR (50)  NULL,
    [CreatedDate]           DATETIME       NULL,
    [CreatedBy]             NUMERIC (18)   NULL,
    [UpdatedDate]           DATETIME       NULL,
    [UpdatedBy]             NUMERIC (18)   NULL,
    CONSTRAINT [PK_StdRegFeeGenerationMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

