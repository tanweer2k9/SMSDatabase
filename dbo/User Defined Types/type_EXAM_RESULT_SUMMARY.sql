CREATE TYPE [dbo].[type_EXAM_RESULT_SUMMARY] AS TABLE (
    [ID]         INT            NOT NULL,
    [Subject]    NVARCHAR (100) NULL,
    [T Std]      INT            NULL,
    [Appear]     INT            NULL,
    [Pass]       NVARCHAR (100) NULL,
    [Fail]       NVARCHAR (100) NULL,
    [first std]  NVARCHAR (MAX) NULL,
    [second std] NVARCHAR (MAX) NULL,
    [third std]  NVARCHAR (MAX) NULL,
    [%age]       NVARCHAR (100) NULL,
    [Grade]      NVARCHAR (100) NULL);

