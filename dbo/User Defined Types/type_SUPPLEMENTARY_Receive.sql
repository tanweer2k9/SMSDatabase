CREATE TYPE [dbo].[type_SUPPLEMENTARY_Receive] AS TABLE (
    [ID]                INT           NULL,
    [Fee Received]      FLOAT (53)    NULL,
    [Discount]          FLOAT (53)    NULL,
    [Late Fee Fine]     FLOAT (53)    NULL,
    [Arrears Received]  FLOAT (53)    NULL,
    [Is Fully Received] NVARCHAR (50) NULL);

