CREATE TABLE [dbo].[TBL_KEY] (
    [CMP_ID]             NVARCHAR (50) NULL,
    [BRC_ID]             NVARCHAR (50) NULL,
    [GEN_FORM_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [GEN_FORM_key]       NVARCHAR (50) NOT NULL,
    [GEN_FORM_value]     NVARCHAR (50) NULL,
    [GEN_FORM_Prefix]    NVARCHAR (50) NULL,
    [GEN_FORM_isDeleted] BIT           NULL,
    CONSTRAINT [PK_TBL_KEY] PRIMARY KEY CLUSTERED ([GEN_FORM_key] ASC)
);

