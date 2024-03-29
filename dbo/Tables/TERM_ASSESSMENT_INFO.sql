﻿CREATE TABLE [dbo].[TERM_ASSESSMENT_INFO] (
    [TERM_ASSESS_ID]                 NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [TERM_ASSESS_HD_ID]              NUMERIC (18)   NOT NULL,
    [TERM_ASSESS_BR_ID]              NUMERIC (18)   NULL,
    [TERM_ASSESS_NAME]               NVARCHAR (50)  NULL,
    [TERM_ASSESS_DESC]               NVARCHAR (MAX) NOT NULL,
    [TERM_ASSESS_STATUS]             CHAR (2)       NULL,
    [TERM_ASSESS_START_DATE]         DATE           NULL,
    [TERM_ASSESS_END_DATE]           DATE           NULL,
    [TERM_ASSESS_SESSION_START_DATE] DATE           NULL,
    [TERM_ASSESS_SESSION_END_DATE]   DATE           NULL,
    [TERM_ASSESS_RANK]               INT            NULL,
    CONSTRAINT [PK_TERM_ASSESS] PRIMARY KEY CLUSTERED ([TERM_ASSESS_ID] ASC),
    CONSTRAINT [FK_TERM_ASSESSMENT_INFO_BR_ADMIN] FOREIGN KEY ([TERM_ASSESS_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_TERM_ASSESSMENT_INFO_MAIN_HD_INFO] FOREIGN KEY ([TERM_ASSESS_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

