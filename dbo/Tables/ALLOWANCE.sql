﻿CREATE TABLE [dbo].[ALLOWANCE] (
    [ALLOWANCE_ID]          NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [ALLOWANCE_HD_ID]       NUMERIC (18)   NULL,
    [ALLOWANCE_BR_ID]       NUMERIC (18)   NULL,
    [ALLOWANCE_NAME]        NVARCHAR (200) NULL,
    [ALLOWANCE_DESCRIPTION] NVARCHAR (50)  NULL,
    [ALLOWANCE_DATE]        DATE           NULL,
    [ALLOWANCE_STATUS]      CHAR (2)       NULL,
    CONSTRAINT [PK_ALLOWANCE] PRIMARY KEY CLUSTERED ([ALLOWANCE_ID] ASC),
    CONSTRAINT [FK_ALLOWANCE_BR_ADMIN] FOREIGN KEY ([ALLOWANCE_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_ALLOWANCE_MAIN_HD_INFO] FOREIGN KEY ([ALLOWANCE_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
