﻿CREATE TABLE [dbo].[WORKING_HOURS_PACKAGES] (
    [HOURS_PACK_ID]     NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [HOURS_PACK_HD_ID]  NUMERIC (18)   NULL,
    [HOURS_PACK_BR_ID]  NUMERIC (18)   NULL,
    [HOURS_PACK_NAME]   NVARCHAR (100) NULL,
    [HOURS_PACK_STATUS] CHAR (2)       NULL,
    CONSTRAINT [PK_WORKING_HOURS_PACKAGES] PRIMARY KEY CLUSTERED ([HOURS_PACK_ID] ASC),
    CONSTRAINT [FK_WORKING_HOURS_PACKAGES_BR_ADMIN] FOREIGN KEY ([HOURS_PACK_BR_ID]) REFERENCES [dbo].[BR_ADMIN] ([BR_ADM_ID]),
    CONSTRAINT [FK_WORKING_HOURS_PACKAGES_MAIN_HD_INFO] FOREIGN KEY ([HOURS_PACK_HD_ID]) REFERENCES [dbo].[MAIN_HD_INFO] ([MAIN_INFO_ID])
);

