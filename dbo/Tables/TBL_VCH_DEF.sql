CREATE TABLE [dbo].[TBL_VCH_DEF] (
    [CMP_ID]                       NVARCHAR (50)  NULL,
    [BRC_ID]                       NVARCHAR (50)  NULL,
    [VCH_DEF_countID]              NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [VCH_DEF_ID]                   NVARCHAR (37)  NOT NULL,
    [VCH_MAIN_ID]                  NVARCHAR (37)  NOT NULL,
    [VCH_DEF_COA]                  NVARCHAR (30)  NOT NULL,
    [VCH_DEF_debit]                FLOAT (53)     NULL,
    [VCH_DEF_credit]               FLOAT (53)     NULL,
    [VCH_DEF_debit1]               FLOAT (53)     NULL,
    [VCH_DEF_credit1]              FLOAT (53)     NULL,
    [VCH_DEF_referenceNo]          VARCHAR (50)   NULL,
    [VCH_DEF_remarks]              VARCHAR (100)  NULL,
    [VCH_DEF_GRDNo]                NVARCHAR (50)  NULL,
    [VCH_DEF_date]                 DATETIME       NULL,
    [VCH_DEF_ItemCOA]              NVARCHAR (50)  NULL,
    [VCH_DEF_narration]            NVARCHAR (MAX) NULL,
    [VCH_DEF_prefix]               NVARCHAR (50)  NULL,
    [VCH_DEF_isDeleted]            BIT            NULL,
    [VCH_DEF_isEffectOnProfitLoss] BIT            NULL,
    [VCH_DEF_accRefNo]             NVARCHAR (50)  NULL,
    CONSTRAINT [PK_TBL_VCH_DEF] PRIMARY KEY CLUSTERED ([VCH_DEF_countID] ASC)
);

