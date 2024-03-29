﻿CREATE TABLE [dbo].[SUBJECT_INFO] (
    [SUB_ID]           NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [SUB_HD_ID]        NUMERIC (18)   NOT NULL,
    [SUB_BR_ID]        NUMERIC (18)   NULL,
    [SUB_NAME]         NVARCHAR (50)  NULL,
    [SUB_DESC]         NVARCHAR (500) NULL,
    [SUB_STATUS]       CHAR (2)       NULL,
    [SUB_CODE]         NVARCHAR (50)  NULL,
    [SUB_CREDIT_HOURS] INT            NULL,
    CONSTRAINT [PK_SUBJECT] PRIMARY KEY CLUSTERED ([SUB_ID] ASC),
    CONSTRAINT [FK_SUBJECT_INFO_BR_ADMIN] FOREIGN KEY ([SUB_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_SUBJECT_INFO_MAIN_HD_INFO] FOREIGN KEY ([SUB_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

