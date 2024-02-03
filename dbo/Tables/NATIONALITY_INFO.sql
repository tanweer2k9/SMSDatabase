﻿CREATE TABLE [dbo].[NATIONALITY_INFO] (
    [NATIONALITY_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [NATIONALITY_HD_ID]  NUMERIC (18)   NOT NULL,
    [NATIONALITY_BR_ID]  NUMERIC (18)   NULL,
    [NATIONALITY_NAME]   NVARCHAR (50)  NULL,
    [NATIONALITY_DESC]   NVARCHAR (500) NULL,
    [NATIONALITY_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_NATIONALITY] PRIMARY KEY CLUSTERED ([NATIONALITY_ID] ASC),
    CONSTRAINT [FK_NATIONALITY_INFO_BR_ADMIN] FOREIGN KEY ([NATIONALITY_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_NATIONALITY_INFO_MAIN_HD_INFO] FOREIGN KEY ([NATIONALITY_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);
