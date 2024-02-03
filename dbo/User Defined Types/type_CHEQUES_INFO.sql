CREATE TYPE [dbo].[type_CHEQUES_INFO] AS TABLE (
    [ID]             NUMERIC (18)   NULL,
    [Cheque No]      NVARCHAR (50)  NULL,
    [Amount]         FLOAT (53)     NULL,
    [Cheque Date]    DATE           NULL,
    [Bank Name]      NVARCHAR (50)  NULL,
    [Clearance Date] DATE           NULL,
    [COA Account]    NVARCHAR (50)  NULL,
    [Is Cleared]     BIT            NULL,
    [Is DisHonored]  BIT            NULL,
    [Remarks]        NVARCHAR (500) NULL);

