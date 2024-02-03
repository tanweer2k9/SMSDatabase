CREATE TABLE [dbo].[FeeChallanStudentsUploadPaymentDetail] (
    [Id]                    NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [PId]                   NUMERIC (18)   NULL,
    [FilePath]              NVARCHAR (500) NULL,
    [CommentsUser]          NVARCHAR (500) NULL,
    [AdminCommentsRejected] NVARCHAR (500) NULL,
    [IsDeleted]             BIT            NULL,
    [CreaedDate]            DATETIME       NULL,
    CONSTRAINT [PK_FeeChallanStudentsUploadPaymentDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);

