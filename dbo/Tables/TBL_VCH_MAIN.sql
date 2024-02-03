CREATE TABLE [dbo].[TBL_VCH_MAIN] (
    [CMP_ID]                  NVARCHAR (50) NULL,
    [BRC_ID]                  NVARCHAR (50) NULL,
    [VCH_MID]                 NVARCHAR (50) NULL,
    [VCH_ID]                  NVARCHAR (50) NULL,
    [VCH_prefix]              NVARCHAR (30) NOT NULL,
    [VCH_date]                DATETIME      NOT NULL,
    [VCH_chequeNo]            VARCHAR (50)  NULL,
    [VCH_paidTo]              VARCHAR (50)  NULL,
    [VCH_referenceNo]         NVARCHAR (50) NULL,
    [VCH_PO]                  NVARCHAR (50) NULL,
    [VCH_GRN]                 NVARCHAR (50) NULL,
    [VCH_isPosted]            BIT           NULL,
    [VCH_isFinancial]         BIT           NULL,
    [VCH_narration]           VARCHAR (50)  NULL,
    [VCH_isDeleted]           BIT           NULL,
    [VCH_chequeClearanceDate] DATE          NULL,
    [VCH_chequeBankName]      NVARCHAR (50) NULL
);

