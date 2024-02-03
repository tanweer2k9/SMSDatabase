CREATE TYPE [dbo].[type_FEE_Collection_Simple_Multiple_Students] AS TABLE (
    [ID]              NUMERIC (18)   NULL,
    [Student ID]      NUMERIC (18)   NULL,
    [Current Fee]     FLOAT (53)     NULL,
    [Arrears]         FLOAT (53)     NULL,
    [Net Total]       FLOAT (53)     NULL,
    [Date]            DATE           NULL,
    [Status]          NVARCHAR (100) NULL,
    [Cash in Hand]    FLOAT (53)     NULL,
    [Cash at Bank]    FLOAT (53)     NULL,
    [Hand Code]       NVARCHAR (100) NULL,
    [Bank Code]       NVARCHAR (100) NULL,
    [Late fee Fine]   FLOAT (53)     NULL,
    [Received Amount] FLOAT (53)     NULL);

