CREATE TABLE [dbo].[FeeChallanStudentsUploadPaymentMaster] (
    [Id]            NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [InvoiceId]     NUMERIC (18)  NULL,
    [StdId]         NUMERIC (18)  NULL,
    [FeeMonth]      DATE          NULL,
    [IsDeleted]     BIT           NULL,
    [PaymentStatus] NVARCHAR (50) NULL,
    [CreatedDate]   DATETIME      NULL,
    [CreatedBy]     NUMERIC (18)  NULL,
    [UpdatedDate]   DATETIME      NULL,
    [UpdatedBy]     NUMERIC (18)  NULL,
    CONSTRAINT [PK_FeeChallanStudentsUploadPaymentMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

