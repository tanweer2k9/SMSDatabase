CREATE TYPE [dbo].[type_EXAM_PROGRESS_REPORT_CHILD_TABLE] AS TABLE (
    [Std ID]          INT            NULL,
    [Subject]         NVARCHAR (200) NULL,
    [Total Marks]     NVARCHAR (200) NULL,
    [Obtained Marks]  NVARCHAR (200) NULL,
    [Pass Marks]      NVARCHAR (200) NULL,
    [Percent]         NVARCHAR (200) NULL,
    [Grade]           NVARCHAR (200) NULL,
    [Position]        NVARCHAR (200) NULL,
    [Max Marks]       NVARCHAR (200) NULL,
    [No of Std]       NVARCHAR (200) NULL,
    [term_id]         INT            NULL,
    [Final Term %age] FLOAT (53)     NULL,
    [Reamrks]         NVARCHAR (200) NULL,
    [Next Term %age]  FLOAT (53)     NULL,
    [Term Rank]       INT            NULL,
    [Marks Type]      NVARCHAR (200) NULL,
    [Class ID]        INT            NULL);

