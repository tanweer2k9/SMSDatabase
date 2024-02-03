CREATE TYPE [dbo].[type_Multiple_Cash] AS TABLE (
    [ID]          NUMERIC (18)    NULL,
    [Date]        DATE            NULL,
    [COA Account] NVARCHAR (50)   NULL,
    [Amount]      FLOAT (53)      NULL,
    [Comment]     NVARCHAR (1000) NULL,
    [Transfer To] NVARCHAR (100)  NULL);



