﻿CREATE TABLE [dbo].[ACADMY_PLAN] (
    [SUBJCT_ID]              NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [SUBJCT_HD_ID]           NUMERIC (18)  NOT NULL,
    [SUBJCT_DEGREE]          NVARCHAR (50) NULL,
    [SUBJCT_CLASS]           NVARCHAR (50) NULL,
    [SUBJCT_SHIFT]           NVARCHAR (50) NULL,
    [SUBJCT_SECTION]         NVARCHAR (50) NULL,
    [SUBJCT_DPRTMNT]         NVARCHAR (50) NULL,
    [SUBJCT_SEQ_NO]          NVARCHAR (50) NULL,
    [SUBJCT_PRICE]           FLOAT (53)    NULL,
    [SUBJCT_VARIATION_PRCNT] FLOAT (53)    NULL,
    [SUBJCT_STATUS]          CHAR (2)      NULL,
    CONSTRAINT [PK_SUBJECT_PLAN] PRIMARY KEY CLUSTERED ([SUBJCT_ID] ASC),
    CONSTRAINT [FK_ACADMY_PLAN_MAIN_HD_INFO] FOREIGN KEY ([SUBJCT_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

