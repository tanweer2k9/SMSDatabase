﻿CREATE TABLE [dbo].[LANG_INFO] (
    [LANG_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [LANG_HD_ID]  NUMERIC (18)   NOT NULL,
    [LANG_BR_ID]  NUMERIC (18)   NULL,
    [LANG_NAME]   NVARCHAR (50)  NULL,
    [LANG_DESC]   NVARCHAR (500) NULL,
    [LANG_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_LANG] PRIMARY KEY CLUSTERED ([LANG_ID] ASC),
    CONSTRAINT [FK_LANG_INFO_BR_ADMIN] FOREIGN KEY ([LANG_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_LANG_INFO_MAIN_HD_INFO] FOREIGN KEY ([LANG_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

