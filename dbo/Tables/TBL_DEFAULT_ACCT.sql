CREATE TABLE [dbo].[TBL_DEFAULT_ACCT] (
    [CMP_ID]                 NVARCHAR (50) NULL,
    [BRC_ID]                 NVARCHAR (50) NULL,
    [DEFAULT_ACCT_ID]        NVARCHAR (50) NULL,
    [DEFAULT_ACCT_KEY]       NVARCHAR (50) NULL,
    [DEFAULT_ACCT_CODE]      NVARCHAR (50) NULL,
    [DEFAULT_ACCT_MATCH]     NVARCHAR (50) NULL,
    [DEFAULT_ACCT_isParent]  BIT           NULL,
    [DEFAULT_ACCT_isDeleted] BIT           NULL,
    [DEFAULT_ACCT_Length]    NVARCHAR (10) NULL
);

