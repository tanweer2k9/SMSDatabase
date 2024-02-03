﻿CREATE TABLE [dbo].[TERM_INFO] (
    [TERM_ID]                 NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [TERM_HD_ID]              NUMERIC (18)   NOT NULL,
    [TERM_BR_ID]              NUMERIC (18)   NULL,
    [TERM_NAME]               NVARCHAR (50)  NULL,
    [TERM_DESC]               NVARCHAR (MAX) NOT NULL,
    [TERM_STATUS]             CHAR (2)       NULL,
    [TERM_START_DATE]         DATE           NULL,
    [TERM_END_DATE]           DATE           NULL,
    [TERM_SESSION_START_DATE] DATE           NULL,
    [TERM_SESSION_END_DATE]   DATE           NULL,
    [TERM_RANK]               INT            NULL,
    [TERM_SESSION_ID]         NUMERIC (18)   NULL,
    CONSTRAINT [PK_TERM] PRIMARY KEY CLUSTERED ([TERM_ID] ASC),
    CONSTRAINT [FK_TERM_INFO_BR_ADMIN] FOREIGN KEY ([TERM_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_TERM_INFO_MAIN_HD_INFO] FOREIGN KEY ([TERM_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

